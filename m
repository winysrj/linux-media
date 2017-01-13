Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56717 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752004AbdAMPgf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 10:36:35 -0500
Message-ID: <1484321788.31475.98.camel@pengutronix.de>
Subject: Re: [PATCH 1/4] video: add HDMI state notifier support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Date: Fri, 13 Jan 2017 16:36:28 +0100
In-Reply-To: <20161213150813.37966-2-hverkuil@xs4all.nl>
References: <20161213150813.37966-1-hverkuil@xs4all.nl>
         <20161213150813.37966-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 13.12.2016, 16:08 +0100 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for HDMI hotplug and EDID notifiers, which is used to convey
> information from HDMI drivers to their CEC and audio counterparts.
> 
> Based on an earlier version from Russell King:
> 
> https://patchwork.kernel.org/patch/9277043/
> 
> The hdmi_notifier is a reference counted object containing the HDMI state
> of an HDMI device.
> 
> When a new notifier is registered the current state will be reported to
> that notifier at registration time.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  drivers/video/Kconfig         |   3 +
>  drivers/video/Makefile        |   1 +
>  drivers/video/hdmi-notifier.c | 134 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hdmi-notifier.h | 109 ++++++++++++++++++++++++++++++++++
>  4 files changed, 247 insertions(+)
>  create mode 100644 drivers/video/hdmi-notifier.c
>  create mode 100644 include/linux/hdmi-notifier.h
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 3c20af9..1ee7b9f 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -36,6 +36,9 @@ config VIDEOMODE_HELPERS
>  config HDMI
>  	bool
>  
> +config HDMI_NOTIFIERS
> +	bool
> +
>  if VT
>  	source "drivers/video/console/Kconfig"
>  endif
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 9ad3c17..65f5649 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_VGASTATE)            += vgastate.o
>  obj-$(CONFIG_HDMI)                += hdmi.o
> +obj-$(CONFIG_HDMI_NOTIFIERS)      += hdmi-notifier.o
>  
>  obj-$(CONFIG_VT)		  += console/
>  obj-$(CONFIG_LOGO)		  += logo/
> diff --git a/drivers/video/hdmi-notifier.c b/drivers/video/hdmi-notifier.c
> new file mode 100644
> index 0000000..29e4225
> --- /dev/null
> +++ b/drivers/video/hdmi-notifier.c
> @@ -0,0 +1,134 @@
> +#include <linux/export.h>
> +#include <linux/hdmi-notifier.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +
> +static LIST_HEAD(hdmi_notifiers);
> +static DEFINE_MUTEX(hdmi_notifiers_lock);
> +
> +struct hdmi_notifier *hdmi_notifier_get(struct device *dev)
> +{
> +	struct hdmi_notifier *n;
> +
> +	mutex_lock(&hdmi_notifiers_lock);
> +	list_for_each_entry(n, &hdmi_notifiers, head) {
> +		if (n->dev == dev) {
> +			mutex_unlock(&hdmi_notifiers_lock);
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
> +	list_add_tail(&n->head, &hdmi_notifiers);
> +unlock:
> +	mutex_unlock(&hdmi_notifiers_lock);
> +	return n;
> +}
> +EXPORT_SYMBOL_GPL(hdmi_notifier_get);
> +
> +static void hdmi_notifier_release(struct kref *kref)
> +{
> +	struct hdmi_notifier *n =
> +		container_of(kref, struct hdmi_notifier, kref);
> +
> +	mutex_lock(&hdmi_notifiers_lock);
> +	list_del(&n->head);
> +	mutex_unlock(&hdmi_notifiers_lock);
> +	kfree(n->edid);
> +	kfree(n);
> +}
> +
> +void hdmi_notifier_put(struct hdmi_notifier *n)
> +{
> +	kref_put(&n->kref, hdmi_notifier_release);
> +}
> +EXPORT_SYMBOL_GPL(hdmi_notifier_put);
> +
> +int hdmi_notifier_register(struct hdmi_notifier *n, struct notifier_block *nb)
> +{
> +	int ret = blocking_notifier_chain_register(&n->notifiers, nb);
> +
> +	if (ret)
> +		return ret;
> +	kref_get(&n->kref);
> +	mutex_lock(&n->lock);
> +	if (n->connected) {
> +		blocking_notifier_call_chain(&n->notifiers, HDMI_CONNECTED, n);
> +		if (n->edid_size)
> +			blocking_notifier_call_chain(&n->notifiers, HDMI_NEW_EDID, n);
> +		if (n->has_eld)
> +			blocking_notifier_call_chain(&n->notifiers, HDMI_NEW_ELD, n);
> +	}
> +	mutex_unlock(&n->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hdmi_notifier_register);
> +
> +int hdmi_notifier_unregister(struct hdmi_notifier *n, struct notifier_block *nb)
> +{
> +	int ret = blocking_notifier_chain_unregister(&n->notifiers, nb);
> +
> +	if (ret == 0)
> +		hdmi_notifier_put(n);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hdmi_notifier_unregister);
> +
> +void hdmi_event_connect(struct hdmi_notifier *n)
> +{
> +	mutex_lock(&n->lock);
> +	n->connected = true;
> +	blocking_notifier_call_chain(&n->notifiers, HDMI_CONNECTED, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hdmi_event_connect);
> +
> +void hdmi_event_disconnect(struct hdmi_notifier *n)
> +{
> +	mutex_lock(&n->lock);
> +	n->connected = false;
> +	n->has_eld = false;
> +	n->edid_size = 0;
> +	blocking_notifier_call_chain(&n->notifiers, HDMI_DISCONNECTED, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hdmi_event_disconnect);
> +
> +int hdmi_event_new_edid(struct hdmi_notifier *n, const void *edid, size_t size)
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
> +	blocking_notifier_call_chain(&n->notifiers, HDMI_NEW_EDID, n);
> +	mutex_unlock(&n->lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hdmi_event_new_edid);
> +
> +void hdmi_event_new_eld(struct hdmi_notifier *n, const u8 eld[128])
> +{
> +	mutex_lock(&n->lock);
> +	memcpy(n->eld, eld, sizeof(n->eld));
> +	n->has_eld = true;
> +	blocking_notifier_call_chain(&n->notifiers, HDMI_NEW_ELD, n);
> +	mutex_unlock(&n->lock);
> +}
> +EXPORT_SYMBOL_GPL(hdmi_event_new_eld);
> diff --git a/include/linux/hdmi-notifier.h b/include/linux/hdmi-notifier.h
> new file mode 100644
> index 0000000..1d88db0
> --- /dev/null
> +++ b/include/linux/hdmi-notifier.h
> @@ -0,0 +1,109 @@
> +/*
> + * hdmi-notifier.h - notify interested parties of (dis)connect and EDID
> + * events
> + *
> + * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
> + * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + */
> +
> +#ifndef LINUX_HDMI_NOTIFIER_H
> +#define LINUX_HDMI_NOTIFIER_H
> +
> +#include <linux/types.h>
> +#include <linux/notifier.h>
> +#include <linux/kref.h>
> +
> +enum {
> +	HDMI_CONNECTED,
> +	HDMI_DISCONNECTED,
> +	HDMI_NEW_EDID,
> +	HDMI_NEW_ELD,
> +};
> +
> +struct device;
> +
> +struct hdmi_notifier {
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
> + * hdmi_notifier_get - find or create a new hdmi_notifier for the given device.
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
> +struct hdmi_notifier *hdmi_notifier_get(struct device *dev);
> +
> +/**
> + * hdmi_notifier_put - decrease refcount and delete when the refcount reaches 0.
> + * @n: notifier
> + */
> +void hdmi_notifier_put(struct hdmi_notifier *n);
> +
> +/**
> + * hdmi_notifier_register - register the notifier with the notifier_block.
> + * @n: the HDMI notifier
> + * @nb: the notifier_block
> + */
> +int hdmi_notifier_register(struct hdmi_notifier *n, struct notifier_block *nb);
> +
> +/**
> + * hdmi_notifier_unregister - unregister the notifier with the notifier_block.
> + * @n: the HDMI notifier
> + * @nb: the notifier_block
> + */
> +int hdmi_notifier_unregister(struct hdmi_notifier *n, struct notifier_block *nb);
> +
> +/**
> + * hdmi_event_connect - send a connect event.
> + * @n: the HDMI notifier
> + *
> + * Send an HDMI_CONNECTED event to any registered parties.
> + */
> +void hdmi_event_connect(struct hdmi_notifier *n);
> +
> +/**
> + * hdmi_event_disconnect - send a disconnect event.
> + * @n: the HDMI notifier
> + *
> + * Send an HDMI_DISCONNECTED event to any registered parties.
> + */
> +void hdmi_event_disconnect(struct hdmi_notifier *n);
> +
> +/**
> + * hdmi_event_new_edid - send a new EDID event.
> + * @n: the HDMI notifier
> + *
> + * Send an HDMI_NEW_EDID event to any registered parties.
> + * This function will make a copy the EDID so it can return -ENOMEM if
> + * no memory could be allocated.
> + */
> +int hdmi_event_new_edid(struct hdmi_notifier *n, const void *edid, size_t size);
> +
> +/**
> + * hdmi_event_new_eld - send a new ELD event.
> + * @n: the HDMI notifier
> + *
> + * Send an HDMI_NEW_ELD event to any registered parties.
> + */
> +void hdmi_event_new_eld(struct hdmi_notifier *n, const u8 eld[128]);
> +
> +#endif


