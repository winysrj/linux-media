Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34880 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdB0QIq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 11:08:46 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so14127568wmu.2
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2017 08:08:45 -0800 (PST)
Date: Mon, 27 Feb 2017 17:08:41 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv4 1/9] video: add hotplug detect notifier support
Message-ID: <20170227160841.3pgmpqwtidvjbnzn@phenom.ffwll.local>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
 <20170206102951.12623-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170206102951.12623-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 06, 2017 at 11:29:43AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for video hotplug detect and EDID/ELD notifiers, which is used
> to convey information from video drivers to their CEC and audio counterparts.
> 
> Based on an earlier version from Russell King:
> 
> https://patchwork.kernel.org/patch/9277043/
> 
> The hpd_notifier is a reference counted object containing the HPD/EDID/ELD state
> of a video device.
> 
> When a new notifier is registered the current state will be reported to
> that notifier at registration time.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

So I'm super late to the party because I kinda ignored all things CEC thus
far. Ḯ'm not sure this is a great design, with two main concerns:

- notifiers have a tendency to make locking utter painful. By design
  notifiers use their own lock to make sure any callbacks don't disappear
  unduly, but then on the other hand the locking order at
  register/unregister time is inverted. Or anything where you need to go
  the other way. For simple things it works, but my experience is that
  sooner or later things stop being simple, and then you're in complete
  pain. Viz fbdev notifier. I much more prefer if we have a direct
  interface, where we can define the lifetime rules and locking rules
  seperately, and if needed separately for each interface. Especially for
  something which is meant to connect different drivers from different
  subsystems so widely.
  
  You could object that this is the only interaction, and therefore there
  can't be loops, but we have dma-buf, reservation_obj and dma_fence
  sharing going on between lots of drivers already, and lots more will
  follow, so there's plenty of other cross-subsystem interactions going on
  to help complete the loop.

- The other concern I have is that we already have interfaces for ELD and
  hotplug notification. Atm their only restricted for use between gfx and
  snd, and e.g. i915 rolls 2 different kinds of its own, but there is a
  semi-standard one:

  include/sound/hdmi-codec.h

  That also deals with ELD and stuff, would be great if we don't force
  drivers to signal ELD changes in multiple different ways. Also, CEC
  should only exist with a HDMI output, so same thing.

- Afaiui we'll always should have a 1:1 mapping between drm HDMI connector
  and a given CEC pin. Notifiers are for n:m, how is this supposed to work
  if you have multiple HDMI ports around? I see that you look up by struct
  device, but it's a bit unclear what kind of device is supposed to be
  used as the key. If we extend the hdmi-codec stuff from sound and make
  it a notch more generic, then we'd already have the arbiter object to
  ties things together.

Just some thoughts on this. And again my apologies for being late with my
input.

Thanks, Daniel

> ---
>  drivers/video/Kconfig        |   3 +
>  drivers/video/Makefile       |   1 +
>  drivers/video/hpd-notifier.c | 134 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hpd-notifier.h | 109 +++++++++++++++++++++++++++++++++++
>  4 files changed, 247 insertions(+)
>  create mode 100644 drivers/video/hpd-notifier.c
>  create mode 100644 include/linux/hpd-notifier.h
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 3c20af999893..a3a58d8481e9 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -36,6 +36,9 @@ config VIDEOMODE_HELPERS
>  config HDMI
>  	bool
>  
> +config HPD_NOTIFIER
> +	bool
> +
>  if VT
>  	source "drivers/video/console/Kconfig"
>  endif
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 9ad3c17d6456..2697ae5c4166 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_VGASTATE)            += vgastate.o
>  obj-$(CONFIG_HDMI)                += hdmi.o
> +obj-$(CONFIG_HPD_NOTIFIER)        += hpd-notifier.o
>  
>  obj-$(CONFIG_VT)		  += console/
>  obj-$(CONFIG_LOGO)		  += logo/
> diff --git a/drivers/video/hpd-notifier.c b/drivers/video/hpd-notifier.c
> new file mode 100644
> index 000000000000..971e823ead00
> --- /dev/null
> +++ b/drivers/video/hpd-notifier.c
> @@ -0,0 +1,134 @@
> +#include <linux/export.h>
> +#include <linux/hpd-notifier.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +
> +static LIST_HEAD(hpd_notifiers);
> +static DEFINE_MUTEX(hpd_notifiers_lock);
> +
> +struct hpd_notifier *hpd_notifier_get(struct device *dev)
> +{
> +	struct hpd_notifier *n;
> +
> +	mutex_lock(&hpd_notifiers_lock);
> +	list_for_each_entry(n, &hpd_notifiers, head) {
> +		if (n->dev == dev) {
> +			mutex_unlock(&hpd_notifiers_lock);
> +			kref_get(&n->kref);
> +			return n;
> +		}
> +	}
> +	n = kzalloc(sizeof(*n), GFP_KERNEL);
> +	if (!n)
> +		goto unlock;
> +	n->dev = dev;
> +	mutex_init(&n->lock);
> +	BLOCKING_INIT_NOTIFIER_HEAD(&n->notifiers);
> +	kref_init(&n->kref);
> +	list_add_tail(&n->head, &hpd_notifiers);
> +unlock:
> +	mutex_unlock(&hpd_notifiers_lock);
> +	return n;
> +}
> +EXPORT_SYMBOL_GPL(hpd_notifier_get);
> +
> +static void hpd_notifier_release(struct kref *kref)
> +{
> +	struct hpd_notifier *n =
> +		container_of(kref, struct hpd_notifier, kref);
> +
> +	list_del(&n->head);
> +	kfree(n->edid);
> +	kfree(n);
> +}
> +
> +void hpd_notifier_put(struct hpd_notifier *n)
> +{
> +	mutex_lock(&hpd_notifiers_lock);
> +	kref_put(&n->kref, hpd_notifier_release);
> +	mutex_unlock(&hpd_notifiers_lock);
> +}
> +EXPORT_SYMBOL_GPL(hpd_notifier_put);
> +
> +int hpd_notifier_register(struct hpd_notifier *n, struct notifier_block *nb)
> +{
> +	int ret = blocking_notifier_chain_register(&n->notifiers, nb);
> +
> +	if (ret)
> +		return ret;
> +	kref_get(&n->kref);
> +	mutex_lock(&n->lock);
> +	if (n->connected) {
> +		blocking_notifier_call_chain(&n->notifiers, HPD_CONNECTED, n);
> +		if (n->edid_size)
> +			blocking_notifier_call_chain(&n->notifiers, HPD_NEW_EDID, n);
> +		if (n->has_eld)
> +			blocking_notifier_call_chain(&n->notifiers, HPD_NEW_ELD, n);
> +	}
> +	mutex_unlock(&n->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hpd_notifier_register);
> +
> +int hpd_notifier_unregister(struct hpd_notifier *n, struct notifier_block *nb)
> +{
> +	int ret = blocking_notifier_chain_unregister(&n->notifiers, nb);
> +
> +	if (ret == 0)
> +		hpd_notifier_put(n);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hpd_notifier_unregister);
> +
> +void hpd_event_connect(struct hpd_notifier *n)
> +{
> +	mutex_lock(&n->lock);
> +	n->connected = true;
> +	blocking_notifier_call_chain(&n->notifiers, HPD_CONNECTED, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hpd_event_connect);
> +
> +void hpd_event_disconnect(struct hpd_notifier *n)
> +{
> +	mutex_lock(&n->lock);
> +	n->connected = false;
> +	n->has_eld = false;
> +	n->edid_size = 0;
> +	blocking_notifier_call_chain(&n->notifiers, HPD_DISCONNECTED, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hpd_event_disconnect);
> +
> +int hpd_event_new_edid(struct hpd_notifier *n, const void *edid, size_t size)
> +{
> +	mutex_lock(&n->lock);
> +	if (n->edid_allocated_size < size) {
> +		void *p = kmalloc(size, GFP_KERNEL);
> +
> +		if (p == NULL) {
> +			mutex_unlock(&n->lock);
> +			return -ENOMEM;
> +		}
> +		kfree(n->edid);
> +		n->edid = p;
> +		n->edid_allocated_size = size;
> +	}
> +	memcpy(n->edid, edid, size);
> +	n->edid_size = size;
> +	blocking_notifier_call_chain(&n->notifiers, HPD_NEW_EDID, n);
> +	mutex_unlock(&n->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hpd_event_new_edid);
> +
> +void hpd_event_new_eld(struct hpd_notifier *n, const u8 eld[128])
> +{
> +	mutex_lock(&n->lock);
> +	memcpy(n->eld, eld, sizeof(n->eld));
> +	n->has_eld = true;
> +	blocking_notifier_call_chain(&n->notifiers, HPD_NEW_ELD, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hpd_event_new_eld);
> diff --git a/include/linux/hpd-notifier.h b/include/linux/hpd-notifier.h
> new file mode 100644
> index 000000000000..4dcb4515d2b2
> --- /dev/null
> +++ b/include/linux/hpd-notifier.h
> @@ -0,0 +1,109 @@
> +/*
> + * hpd-notifier.h - notify interested parties of (dis)connect and EDID
> + * events
> + *
> + * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
> + * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + */
> +
> +#ifndef LINUX_HPD_NOTIFIER_H
> +#define LINUX_HPD_NOTIFIER_H
> +
> +#include <linux/types.h>
> +#include <linux/notifier.h>
> +#include <linux/kref.h>
> +
> +enum {
> +	HPD_CONNECTED,
> +	HPD_DISCONNECTED,
> +	HPD_NEW_EDID,
> +	HPD_NEW_ELD,
> +};
> +
> +struct device;
> +
> +struct hpd_notifier {
> +	struct mutex lock;
> +	struct list_head head;
> +	struct kref kref;
> +	struct blocking_notifier_head notifiers;
> +	struct device *dev;
> +
> +	/* Current state */
> +	bool connected;
> +	bool has_eld;
> +	unsigned char eld[128];
> +	void *edid;
> +	size_t edid_size;
> +	size_t edid_allocated_size;
> +};
> +
> +/**
> + * hpd_notifier_get - find or create a new hpd_notifier for the given device.
> + * @dev: device that sends the events.
> + *
> + * If a notifier for device @dev already exists, then increase the refcount
> + * and return that notifier.
> + *
> + * If it doesn't exist, then allocate a new notifier struct and return a
> + * pointer to that new struct.
> + *
> + * Return NULL if the memory could not be allocated.
> + */
> +struct hpd_notifier *hpd_notifier_get(struct device *dev);
> +
> +/**
> + * hpd_notifier_put - decrease refcount and delete when the refcount reaches 0.
> + * @n: notifier
> + */
> +void hpd_notifier_put(struct hpd_notifier *n);
> +
> +/**
> + * hpd_notifier_register - register the notifier with the notifier_block.
> + * @n: the HPD notifier
> + * @nb: the notifier_block
> + */
> +int hpd_notifier_register(struct hpd_notifier *n, struct notifier_block *nb);
> +
> +/**
> + * hpd_notifier_unregister - unregister the notifier with the notifier_block.
> + * @n: the HPD notifier
> + * @nb: the notifier_block
> + */
> +int hpd_notifier_unregister(struct hpd_notifier *n, struct notifier_block *nb);
> +
> +/**
> + * hpd_event_connect - send a connect event.
> + * @n: the HPD notifier
> + *
> + * Send an HPD_CONNECTED event to any registered parties.
> + */
> +void hpd_event_connect(struct hpd_notifier *n);
> +
> +/**
> + * hpd_event_disconnect - send a disconnect event.
> + * @n: the HPD notifier
> + *
> + * Send an HPD_DISCONNECTED event to any registered parties.
> + */
> +void hpd_event_disconnect(struct hpd_notifier *n);
> +
> +/**
> + * hpd_event_new_edid - send a new EDID event.
> + * @n: the HPD notifier
> + *
> + * Send an HPD_NEW_EDID event to any registered parties.
> + * This function will make a copy the EDID so it can return -ENOMEM if
> + * no memory could be allocated.
> + */
> +int hpd_event_new_edid(struct hpd_notifier *n, const void *edid, size_t size);
> +
> +/**
> + * hpd_event_new_eld - send a new ELD event.
> + * @n: the HPD notifier
> + *
> + * Send an HPD_NEW_ELD event to any registered parties.
> + */
> +void hpd_event_new_eld(struct hpd_notifier *n, const u8 eld[128]);
> +
> +#endif
> -- 
> 2.11.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
