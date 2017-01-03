Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16759 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdACHvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 02:51:01 -0500
Subject: Re: [PATCHv2 1/4] video: add hotplug detect notifier support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <ddb0ba80-c2a4-1024-8e9c-4ba74882a282@samsung.com>
Date: Tue, 03 Jan 2017 08:50:54 +0100
MIME-version: 1.0
In-reply-to: <1483366747-34288-2-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
 <CGME20170102141939epcas2p4a53acf3b27264f0b95e60eac75133885@epcas2p4.samsung.com>
 <1483366747-34288-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 02.01.2017 15:19, Hans Verkuil wrote:
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
> index 3c20af9..cddc860 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -36,6 +36,9 @@ config VIDEOMODE_HELPERS
>  config HDMI
>  	bool
>  
> +config HPD_NOTIFIERS
> +	bool
> +
>  if VT
>  	source "drivers/video/console/Kconfig"
>  endif
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 9ad3c17..424698b 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_VGASTATE)            += vgastate.o
>  obj-$(CONFIG_HDMI)                += hdmi.o
> +obj-$(CONFIG_HPD_NOTIFIERS)       += hpd-notifier.o
>  
>  obj-$(CONFIG_VT)		  += console/
>  obj-$(CONFIG_LOGO)		  += logo/
> diff --git a/drivers/video/hpd-notifier.c b/drivers/video/hpd-notifier.c
> new file mode 100644
> index 0000000..54f7a6b
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

I think this place is racy, we have pointer to unprotected area
(n->kref), so if concurrent thread calls hpd_notifier_put in this moment
&n->kref could be freed and kref_get in the next line will operate on
dangling pointer. Am I right?

Regards
Andrzej

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
> +	mutex_lock(&hpd_notifiers_lock);
> +	list_del(&n->head);
> +	mutex_unlock(&hpd_notifiers_lock);
> +	kfree(n->edid);
> +	kfree(n);
> +}
> +
> +void hpd_notifier_put(struct hpd_notifier *n)
> +{
> +	kref_put(&n->kref, hpd_notifier_release);
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
(...)

