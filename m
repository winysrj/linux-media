Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:40074 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbeERPsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:48:21 -0400
Received: by mail-yb0-f193.google.com with SMTP id o80-v6so2844000ybc.7
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:48:21 -0700 (PDT)
Date: Fri, 18 May 2018 11:48:19 -0400
From: Sean Paul <seanpaul@chromium.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] media: cec-notifier: Get notifier by device and
 connector name
Message-ID: <20180518154819.GL3373@art_vandelay>
References: <1526648704-16873-1-git-send-email-narmstrong@baylibre.com>
 <1526648704-16873-2-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526648704-16873-2-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 03:05:00PM +0200, Neil Armstrong wrote:
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

Hi Neil,
Thanks for posting these!

> ---
>  drivers/media/cec/cec-notifier.c | 11 ++++++++---
>  include/media/cec-notifier.h     | 27 ++++++++++++++++++++++++---
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
> index 16dffa0..dd2078b 100644
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
> @@ -30,13 +31,14 @@ struct cec_notifier {
>  static LIST_HEAD(cec_notifiers);
>  static DEFINE_MUTEX(cec_notifiers_lock);
>  
> -struct cec_notifier *cec_notifier_get(struct device *dev)
> +struct cec_notifier *cec_notifier_get_conn(struct device *dev, const char *conn)
>  {
>  	struct cec_notifier *n;
>  
>  	mutex_lock(&cec_notifiers_lock);
>  	list_for_each_entry(n, &cec_notifiers, head) {
> -		if (n->dev == dev) {
> +		if (n->dev == dev &&
> +		    (!conn || !strcmp(n->conn, conn))) {
>  			kref_get(&n->kref);
>  			mutex_unlock(&cec_notifiers_lock);
>  			return n;
> @@ -46,6 +48,8 @@ struct cec_notifier *cec_notifier_get(struct device *dev)
>  	if (!n)
>  		goto unlock;
>  	n->dev = dev;
> +	if (conn)
> +		n->conn = kstrdup(conn, GFP_KERNEL);
>  	n->phys_addr = CEC_PHYS_ADDR_INVALID;
>  	mutex_init(&n->lock);
>  	kref_init(&n->kref);
> @@ -54,7 +58,7 @@ struct cec_notifier *cec_notifier_get(struct device *dev)
>  	mutex_unlock(&cec_notifiers_lock);
>  	return n;
>  }
> -EXPORT_SYMBOL_GPL(cec_notifier_get);
> +EXPORT_SYMBOL_GPL(cec_notifier_get_conn);
>  
>  static void cec_notifier_release(struct kref *kref)
>  {
> @@ -62,6 +66,7 @@ static void cec_notifier_release(struct kref *kref)
>  		container_of(kref, struct cec_notifier, kref);
>  
>  	list_del(&n->head);
> +	kfree(n->conn);
>  	kfree(n);
>  }
>  
> diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
> index cf0add7..814eeef 100644
> --- a/include/media/cec-notifier.h
> +++ b/include/media/cec-notifier.h
> @@ -20,8 +20,10 @@ struct cec_notifier;
>  #if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
>  
>  /**
> - * cec_notifier_get - find or create a new cec_notifier for the given device.
> + * cec_notifier_get_conn - find or create a new cec_notifier for the given
> + * device and connector tuple.
>   * @dev: device that sends the events.
> + * @conn: the connector name from which the event occurs

Probably best to use "name" instead of connector, since it doesn't necessarily
_have_ to be a connector name. So, cec_notifier_get_by_name(dev, name)

>   *
>   * If a notifier for device @dev already exists, then increase the refcount
>   * and return that notifier.
> @@ -31,7 +33,8 @@ struct cec_notifier;
>   *
>   * Return NULL if the memory could not be allocated.
>   */
> -struct cec_notifier *cec_notifier_get(struct device *dev);
> +struct cec_notifier *cec_notifier_get_conn(struct device *dev,
> +					   const char *conn);
>  
>  /**
>   * cec_notifier_put - decrease refcount and delete when the refcount reaches 0.
> @@ -85,7 +88,8 @@ void cec_register_cec_notifier(struct cec_adapter *adap,
>  			       struct cec_notifier *notifier);
>  
>  #else
> -static inline struct cec_notifier *cec_notifier_get(struct device *dev)
> +static inline struct cec_notifier *cec_notifier_get_conn(struct device *dev,
> +							 const char *conn)
>  {
>  	/* A non-NULL pointer is expected on success */
>  	return (struct cec_notifier *)0xdeadfeed;
> @@ -121,6 +125,23 @@ static inline void cec_register_cec_notifier(struct cec_adapter *adap,
>  #endif
>  
>  /**
> + * cec_notifier_get - find or create a new cec_notifier for the given device.
> + * @dev: device that sends the events.
> + *
> + * If a notifier for device @dev already exists, then increase the refcount
> + * and return that notifier.
> + *
> + * If it doesn't exist, then allocate a new notifier struct and return a
> + * pointer to that new struct.

You might also want to cover the case where you have multiple named notifiers
for the same device. It looks like it just grabs the first one?

Sean

> + *
> + * Return NULL if the memory could not be allocated.
> + */
> +static inline struct cec_notifier *cec_notifier_get(struct device *dev)
> +{
> +	return cec_notifier_get_conn(dev, NULL);
> +}
> +
> +/**
>   * cec_notifier_phys_addr_invalidate() - set the physical address to INVALID
>   *
>   * @n: the CEC notifier
> -- 
> 2.7.4
> 

-- 
Sean Paul, Software Engineer, Google / Chromium OS
