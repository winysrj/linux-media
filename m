Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37190 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaCXX5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 19:57:11 -0400
Date: Tue, 25 Mar 2014 00:51:46 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
Message-ID: <20140324235146.GA25627@hardeman.nu>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com>
 <1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393629426-31341-2-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 28, 2014 at 11:17:02PM +0000, James Hogan wrote:
>Add generic scancode filtering of RC input events, and fall back to
>permitting any RC_FILTER_NORMAL scancode filter to be set if no s_filter
>callback exists. This allows raw IR decoder events to be filtered, and
>potentially allows hardware decoders to set looser filters and rely on
>generic code to filter out the corner cases.

Hi James,

What's the purpose of providing the sw scancode filtering in the case where
there's no hardware filtering support at all?

(sorry that I'm replying so late...busy schedule :))

>
>Signed-off-by: James Hogan <james.hogan@imgtec.com>
>Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>Cc: Antti Seppälä <a.seppala@gmail.com>
>Cc: linux-media@vger.kernel.org
>---
> drivers/media/rc/rc-main.c | 20 +++++++++++++-------
> 1 file changed, 13 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>index 6448128..0a4f680 100644
>--- a/drivers/media/rc/rc-main.c
>+++ b/drivers/media/rc/rc-main.c
>@@ -633,6 +633,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
> static void ir_do_keydown(struct rc_dev *dev, int scancode,
> 			  u32 keycode, u8 toggle)
> {
>+	struct rc_scancode_filter *filter;
> 	bool new_event = !dev->keypressed ||
> 			 dev->last_scancode != scancode ||
> 			 dev->last_toggle != toggle;
>@@ -640,6 +641,11 @@ static void ir_do_keydown(struct rc_dev *dev, int scancode,
> 	if (new_event && dev->keypressed)
> 		ir_do_keyup(dev, false);
> 
>+	/* Generic scancode filtering */
>+	filter = &dev->scancode_filters[RC_FILTER_NORMAL];
>+	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
>+		return;
>+
> 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
> 
> 	if (new_event && keycode != KEY_RESERVED) {
>@@ -1019,9 +1025,7 @@ static ssize_t show_filter(struct device *device,
> 		return -EINVAL;
> 
> 	mutex_lock(&dev->lock);
>-	if (!dev->s_filter)
>-		val = 0;
>-	else if (fattr->mask)
>+	if (fattr->mask)
> 		val = dev->scancode_filters[fattr->type].mask;
> 	else
> 		val = dev->scancode_filters[fattr->type].data;
>@@ -1069,7 +1073,7 @@ static ssize_t store_filter(struct device *device,
> 		return ret;
> 
> 	/* Scancode filter not supported (but still accept 0) */
>-	if (!dev->s_filter)
>+	if (!dev->s_filter && fattr->type != RC_FILTER_NORMAL)
> 		return val ? -EINVAL : count;
> 
> 	mutex_lock(&dev->lock);
>@@ -1081,9 +1085,11 @@ static ssize_t store_filter(struct device *device,
> 		local_filter.mask = val;
> 	else
> 		local_filter.data = val;
>-	ret = dev->s_filter(dev, fattr->type, &local_filter);
>-	if (ret < 0)
>-		goto unlock;
>+	if (dev->s_filter) {
>+		ret = dev->s_filter(dev, fattr->type, &local_filter);
>+		if (ret < 0)
>+			goto unlock;
>+	}
> 
> 	/* Success, commit the new filter */
> 	*filter = local_filter;
>-- 
>1.8.3.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
David Härdeman
