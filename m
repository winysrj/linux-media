Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59963 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752408AbeEOG16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 02:27:58 -0400
Subject: Re: [RFC PATCH 2/5] media: cec-notifier: Get notifier by device and
 connector name
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
 <1526337639-3568-3-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <adbbccf9-d8af-c43a-3f10-bdd828e8c842@xs4all.nl>
Date: Tue, 15 May 2018 08:27:49 +0200
MIME-Version: 1.0
In-Reply-To: <1526337639-3568-3-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thanks for this patch series!

Some comments below:

On 05/15/2018 12:40 AM, Neil Armstrong wrote:
> In non device-tree world, we can need to get the notifier by the driver
> name directly and eventually defer probe if not yet created.
> 
> This patch adds a variant of the get function by using the device name
> instead and will not create a notifier if not yet created.
> 
> But the i915 driver exposes at least 2 HDMI connectors, this patch also
> adds the possibility to add a connector name tied to the notifier device
> to form a tuple and associate different CEC controllers for each HDMI
> connectors.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/media/cec/cec-notifier.c | 30 ++++++++++++++++++++++++---
>  include/media/cec-notifier.h     | 44 ++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 69 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
> index 16dffa0..716070a 100644
> --- a/drivers/media/cec/cec-notifier.c
> +++ b/drivers/media/cec/cec-notifier.c
> @@ -21,6 +21,7 @@ struct cec_notifier {
>  	struct list_head head;
>  	struct kref kref;
>  	struct device *dev;
> +	const char *conn;
>  	struct cec_adapter *cec_adap;
>  	void (*callback)(struct cec_adapter *adap, u16 pa);
>  
> @@ -30,13 +31,34 @@ struct cec_notifier {
>  static LIST_HEAD(cec_notifiers);
>  static DEFINE_MUTEX(cec_notifiers_lock);
>  
> -struct cec_notifier *cec_notifier_get(struct device *dev)
> +struct cec_notifier *cec_notifier_get_byname(const char *name,
> +					     const char *conn)
>  {
>  	struct cec_notifier *n;
>  
>  	mutex_lock(&cec_notifiers_lock);
>  	list_for_each_entry(n, &cec_notifiers, head) {
> -		if (n->dev == dev) {
> +		if (!strcmp(dev_name(n->dev), name) &&
> +		    (!conn || !strcmp(n->conn, conn))) {
> +			kref_get(&n->kref);
> +			mutex_unlock(&cec_notifiers_lock);
> +			return n;
> +		}
> +	}
> +	mutex_unlock(&cec_notifiers_lock);
> +
> +	return NULL;

This doesn't seem right. For one it doesn't act like the other cec_notifier_get*
functions in that it doesn't make a new notifier if it wasn't found yet in the
list.

For another, I think this function shouldn't be here at all. How about calling
bus_find_device_by_name(), then use cec_notifier_get_conn()?

> +}
> +EXPORT_SYMBOL_GPL(cec_notifier_get_byname);
> +
> +struct cec_notifier *cec_notifier_get_conn(struct device *dev, const char *conn)
> +{
> +	struct cec_notifier *n;
> +
> +	mutex_lock(&cec_notifiers_lock);
> +	list_for_each_entry(n, &cec_notifiers, head) {
> +		if (n->dev == dev &&
> +		    (!conn || !strcmp(n->conn, conn))) {
>  			kref_get(&n->kref);
>  			mutex_unlock(&cec_notifiers_lock);
>  			return n;
> @@ -46,6 +68,8 @@ struct cec_notifier *cec_notifier_get(struct device *dev)
>  	if (!n)
>  		goto unlock;
>  	n->dev = dev;
> +	if (conn)
> +		n->conn = devm_kstrdup(dev, conn, GFP_KERNEL);

The use of devm_kstrdup worries me. The problem is that when the 'dev' device
is removed, this memory is also automatically freed. But the notifier might
still have a reference through the CEC driver, so you end up with a n->conn
pointer that points to freed memory.

I think it is better to just use kstrdup and kfree it when the last notifier
reference is released.

>  	n->phys_addr = CEC_PHYS_ADDR_INVALID;
>  	mutex_init(&n->lock);
>  	kref_init(&n->kref);
> @@ -54,7 +78,7 @@ struct cec_notifier *cec_notifier_get(struct device *dev)
>  	mutex_unlock(&cec_notifiers_lock);
>  	return n;
>  }
> -EXPORT_SYMBOL_GPL(cec_notifier_get);
> +EXPORT_SYMBOL_GPL(cec_notifier_get_conn);
>  
>  static void cec_notifier_release(struct kref *kref)
>  {
> diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
> index cf0add7..70f2974 100644
> --- a/include/media/cec-notifier.h
> +++ b/include/media/cec-notifier.h
> @@ -20,6 +20,37 @@ struct cec_notifier;
>  #if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
>  
>  /**
> + * cec_notifier_get_byname - find a cec_notifier for the given device name
> + * and connector tuple.
> + * @name: device name that sends the events.
> + * @conn: the connector name from which the event occurs
> + *
> + * If a notifier for device @name exists, then increase the refcount and
> + * return that notifier.
> + *
> + * If it doesn't exist, return NULL
> + */
> +struct cec_notifier *cec_notifier_get_byname(const char *name,
> +					     const char *conn);
> +
> +/**
> + * cec_notifier_get_conn - find or create a new cec_notifier for the given
> + * device and connector tuple.
> + * @dev: device that sends the events.
> + * @conn: the connector name from which the event occurs
> + *
> + * If a notifier for device @dev already exists, then increase the refcount
> + * and return that notifier.
> + *
> + * If it doesn't exist, then allocate a new notifier struct and return a
> + * pointer to that new struct.
> + *
> + * Return NULL if the memory could not be allocated.
> + */
> +struct cec_notifier *cec_notifier_get_conn(struct device *dev,
> +					   const char *conn);
> +
> +/**
>   * cec_notifier_get - find or create a new cec_notifier for the given device.
>   * @dev: device that sends the events.
>   *
> @@ -31,7 +62,10 @@ struct cec_notifier;
>   *
>   * Return NULL if the memory could not be allocated.
>   */
> -struct cec_notifier *cec_notifier_get(struct device *dev);
> +static inline struct cec_notifier *cec_notifier_get(struct device *dev)
> +{
> +	return cec_notifier_get_conn(dev, NULL);
> +}
>  
>  /**
>   * cec_notifier_put - decrease refcount and delete when the refcount reaches 0.
> @@ -85,12 +119,18 @@ void cec_register_cec_notifier(struct cec_adapter *adap,
>  			       struct cec_notifier *notifier);
>  
>  #else
> -static inline struct cec_notifier *cec_notifier_get(struct device *dev)
> +static inline struct cec_notifier *cec_notifier_get_conn(struct device *dev,
> +							 const char *conn)
>  {
>  	/* A non-NULL pointer is expected on success */
>  	return (struct cec_notifier *)0xdeadfeed;
>  }
>  
> +static inline struct cec_notifier *cec_notifier_get(struct device *dev)
> +{
> +	return cec_notifier_get_conn(dev, NULL);
> +}
> +
>  static inline void cec_notifier_put(struct cec_notifier *n)
>  {
>  }
> 

Regards,

	Hans
