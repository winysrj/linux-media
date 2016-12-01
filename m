Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50548 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751503AbcLAKLD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 05:11:03 -0500
Subject: Re: [RFCv2 PATCH 1/5] video: add HDMI state notifier support
To: linux-media@vger.kernel.org
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
 <1479136968-24477-2-git-send-email-hverkuil@xs4all.nl>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a999cfd1-5888-440c-2cba-0d8906358d7a@xs4all.nl>
Date: Thu, 1 Dec 2016 11:09:35 +0100
MIME-Version: 1.0
In-Reply-To: <1479136968-24477-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/16 16:22, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Add support for HDMI hotplug and EDID notifiers, which is used to convey
> information from HDMI drivers to their CEC and audio counterparts.

I realized that the name 'HDMI notifier' isn't the best: the same mechanism
can be used with e.g. DisplayPort as well.

What would be a good alternative name?

"Video Notifier"?

Any objections to that? Or suggestions for a better name?

Regards,

	Hans

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
> ---
>  drivers/video/Kconfig         |   3 +
>  drivers/video/Makefile        |   1 +
>  drivers/video/hdmi-notifier.c | 136 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hdmi-notifier.h |  43 +++++++++++++
>  4 files changed, 183 insertions(+)
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
> index 0000000..c2a4f1b
> --- /dev/null
> +++ b/drivers/video/hdmi-notifier.c
> @@ -0,0 +1,136 @@
> +#include <linux/export.h>
> +#include <linux/hdmi-notifier.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +
> +struct hdmi_notifiers {
> +	struct list_head head;
> +	struct device *dev;
> +	struct hdmi_notifier *n;
> +};
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
> index 0000000..f7fc405
> --- /dev/null
> +++ b/include/linux/hdmi-notifier.h
> @@ -0,0 +1,43 @@
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
> +struct hdmi_notifier *hdmi_notifier_get(struct device *dev);
> +void hdmi_notifier_put(struct hdmi_notifier *n);
> +int hdmi_notifier_register(struct hdmi_notifier *n, struct notifier_block *nb);
> +int hdmi_notifier_unregister(struct hdmi_notifier *n, struct notifier_block *nb);
> +
> +void hdmi_event_connect(struct hdmi_notifier *n);
> +void hdmi_event_disconnect(struct hdmi_notifier *n);
> +int hdmi_event_new_edid(struct hdmi_notifier *n, const void *edid, size_t size);
> +void hdmi_event_new_eld(struct hdmi_notifier *n, const u8 eld[128]);
> +
> +#endif
>
