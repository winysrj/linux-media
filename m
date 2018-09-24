Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbeIXXJg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 19:09:36 -0400
Date: Mon, 24 Sep 2018 14:06:04 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?UTF-8?B?U8O2ZGVy?= =?UTF-8?B?bHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v6 02/17] media: v4l2: async: Allow searching for asd of
 any type
Message-ID: <20180924140604.23e2b56f@coco.lan>
In-Reply-To: <1531175957-1973-3-git-send-email-steve_longerbeam@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
        <1531175957-1973-3-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Jul 2018 15:39:02 -0700
Steve Longerbeam <slongerbeam@gmail.com> escreveu:

> Generalize v4l2_async_notifier_fwnode_has_async_subdev() to allow
> searching for any type of async subdev, not just fwnodes. Rename to
> v4l2_async_notifier_has_async_subdev() and pass it an asd pointer.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v5:
> - none
> Changes since v4:
> - none
> Changes since v3:
> - removed TODO to support asd compare with CUSTOM match type in
>   asd_equal().
> Changes since v2:
> - code optimization in asd_equal(), and remove unneeded braces,
>   suggested by Sakari Ailus.
> Changes since v1:
> - none
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 73 +++++++++++++++++++++---------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 2b08d03..0e7e529 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -124,6 +124,31 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  	return NULL;
>  }
>  
> +/* Compare two asd's for equivalence */

Please, on comments, instead of "asd" prefer to use what this 3 random
letters mean, e. g.:
	asd -> asynchronous subdevice

> +static bool asd_equal(struct v4l2_async_subdev *asd_x,
> +		      struct v4l2_async_subdev *asd_y)
> +{
> +	if (asd_x->match_type != asd_y->match_type)
> +		return false;
> +
> +	switch (asd_x->match_type) {
> +	case V4L2_ASYNC_MATCH_DEVNAME:
> +		return strcmp(asd_x->match.device_name,
> +			      asd_y->match.device_name) == 0;
> +	case V4L2_ASYNC_MATCH_I2C:
> +		return asd_x->match.i2c.adapter_id ==
> +			asd_y->match.i2c.adapter_id &&
> +			asd_x->match.i2c.address ==
> +			asd_y->match.i2c.address;
> +	case V4L2_ASYNC_MATCH_FWNODE:
> +		return asd_x->match.fwnode == asd_y->match.fwnode;
> +	default:
> +		break;
> +	}
> +
> +	return false;
> +}
> +
>  /* Find the sub-device notifier registered by a sub-device driver. */
>  static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
>  	struct v4l2_subdev *sd)
> @@ -308,29 +333,22 @@ static void v4l2_async_notifier_unbind_all_subdevs(
>  	notifier->parent = NULL;
>  }
>  
> -/* See if an fwnode can be found in a notifier's lists. */
> -static bool __v4l2_async_notifier_fwnode_has_async_subdev(
> -	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
> +/* See if an async sub-device can be found in a notifier's lists. */
> +static bool __v4l2_async_notifier_has_async_subdev(
> +	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd)

This is a minor issue, but checkpatch complains (with reason)
(with --strict) about the above:

	CHECK: Lines should not end with a '('
	#63: FILE: drivers/media/v4l2-core/v4l2-async.c:337:
	+static bool __v4l2_async_notifier_has_async_subdev(

Better to declare it, instead, as:

static bool 
__v4l2_async_notifier_has_async_subdev(struct v4l2_async_notifier *notifier,
				       struct v4l2_async_subdev *asd)

Similar warnings appear on other places:
CHECK: Lines should not end with a '('
#102: FILE: drivers/media/v4l2-core/v4l2-async.c:362:
+static bool v4l2_async_notifier_has_async_subdev(

CHECK: Lines should not end with a '('
#141: FILE: drivers/media/v4l2-core/v4l2-async.c:410:
+			if (v4l2_async_notifier_has_async_subdev(

Btw, Checkpatch also complains that the author's email is different
than the SOB's one:

WARNING: Missing Signed-off-by: line by nominal patch author 'Steve Longerbeam <slongerbeam@gmail.com>'

(the some comes with Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>)

I suspect that other patches on this series will suffer from the same issue.


>  {
> -	struct v4l2_async_subdev *asd;
> +	struct v4l2_async_subdev *asd_y;
>  	struct v4l2_subdev *sd;
>  
> -	list_for_each_entry(asd, &notifier->waiting, list) {
> -		if (asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
> -			continue;
> -
> -		if (asd->match.fwnode == fwnode)
> +	list_for_each_entry(asd_y, &notifier->waiting, list)
> +		if (asd_equal(asd, asd_y))
>  			return true;
> -	}
>  
>  	list_for_each_entry(sd, &notifier->done, async_list) {
>  		if (WARN_ON(!sd->asd))
>  			continue;
>  
> -		if (sd->asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
> -			continue;
> -
> -		if (sd->asd->match.fwnode == fwnode)
> +		if (asd_equal(asd, sd->asd))
>  			return true;
>  	}
>  
> @@ -338,32 +356,28 @@ static bool __v4l2_async_notifier_fwnode_has_async_subdev(
>  }
>  
>  /*
> - * Find out whether an async sub-device was set up for an fwnode already or
> + * Find out whether an async sub-device was set up already or
>   * whether it exists in a given notifier before @this_index.
>   */
> -static bool v4l2_async_notifier_fwnode_has_async_subdev(
> -	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode,
> +static bool v4l2_async_notifier_has_async_subdev(
> +	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
>  	unsigned int this_index)
>  {
>  	unsigned int j;
>  
>  	lockdep_assert_held(&list_lock);
>  
> -	/* Check that an fwnode is not being added more than once. */
> +	/* Check that an asd is not being added more than once. */
>  	for (j = 0; j < this_index; j++) {
> -		struct v4l2_async_subdev *asd = notifier->subdevs[this_index];
> -		struct v4l2_async_subdev *other_asd = notifier->subdevs[j];
> +		struct v4l2_async_subdev *asd_y = notifier->subdevs[j];
>  
> -		if (other_asd->match_type == V4L2_ASYNC_MATCH_FWNODE &&
> -		    asd->match.fwnode ==
> -		    other_asd->match.fwnode)
> +		if (asd_equal(asd, asd_y))
>  			return true;
>  	}
>  
> -	/* Check than an fwnode did not exist in other notifiers. */
> +	/* Check that an asd does not exist in other notifiers. */
>  	list_for_each_entry(notifier, &notifier_list, list)
> -		if (__v4l2_async_notifier_fwnode_has_async_subdev(
> -			    notifier, fwnode))
> +		if (__v4l2_async_notifier_has_async_subdev(notifier, asd))
>  			return true;
>  
>  	return false;
> @@ -392,12 +406,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>  		case V4L2_ASYNC_MATCH_CUSTOM:
>  		case V4L2_ASYNC_MATCH_DEVNAME:
>  		case V4L2_ASYNC_MATCH_I2C:
> -			break;
>  		case V4L2_ASYNC_MATCH_FWNODE:
> -			if (v4l2_async_notifier_fwnode_has_async_subdev(
> -				    notifier, asd->match.fwnode, i)) {
> +			if (v4l2_async_notifier_has_async_subdev(
> +				    notifier, asd, i)) {
>  				dev_err(dev,
> -					"fwnode has already been registered or in notifier's subdev list\n");
> +					"asd has already been registered or in notifier's subdev list\n");

Please, never use "asd" on messages printed to the user. While someone
may understand it while reading the source code, for a poor use,
"asd" is just a random sequence of 3 characters.

>  				ret = -EEXIST;
>  				goto err_unlock;
>  			}



Thanks,
Mauro
