Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725762AbeIZEaz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 00:30:55 -0400
Date: Tue, 25 Sep 2018 19:20:45 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 02/17] media: v4l2: async: Allow searching for asd of
 any type
Message-ID: <20180925192045.59c83e3d@coco.lan>
In-Reply-To: <a8ea673c-a519-81e8-35b1-9d4a224dcbf5@mentor.com>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
        <1531175957-1973-3-git-send-email-steve_longerbeam@mentor.com>
        <20180924140604.23e2b56f@coco.lan>
        <a8ea673c-a519-81e8-35b1-9d4a224dcbf5@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Sep 2018 14:04:21 -0700
Steve Longerbeam <steve_longerbeam@mentor.com> escreveu:

> Hi Mauro,
> 
> 
> On 09/24/2018 10:06 AM, Mauro Carvalho Chehab wrote:
> > Em Mon,  9 Jul 2018 15:39:02 -0700
> > Steve Longerbeam <slongerbeam@gmail.com> escreveu:
> >  
> >> Generalize v4l2_async_notifier_fwnode_has_async_subdev() to allow
> >> searching for any type of async subdev, not just fwnodes. Rename to
> >> v4l2_async_notifier_has_async_subdev() and pass it an asd pointer.
> >>
> >> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> >> ---
> >> Changes since v5:
> >> - none
> >> Changes since v4:
> >> - none
> >> Changes since v3:
> >> - removed TODO to support asd compare with CUSTOM match type in
> >>    asd_equal().
> >> Changes since v2:
> >> - code optimization in asd_equal(), and remove unneeded braces,
> >>    suggested by Sakari Ailus.
> >> Changes since v1:
> >> - none
> >> ---
> >>   drivers/media/v4l2-core/v4l2-async.c | 73 +++++++++++++++++++++---------------
> >>   1 file changed, 43 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> >> index 2b08d03..0e7e529 100644
> >> --- a/drivers/media/v4l2-core/v4l2-async.c
> >> +++ b/drivers/media/v4l2-core/v4l2-async.c
> >> @@ -124,6 +124,31 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
> >>   	return NULL;
> >>   }
> >>   
> >> +/* Compare two asd's for equivalence */  
> > Please, on comments, instead of "asd" prefer to use what this 3 random
> > letters mean, e. g.:
> > 	asd -> asynchronous subdevice  
> 
> Ok, I will change the comment to read:
> 
> /* Compare two async subdevice descriptors for equivalence */

OK

> 
> >  
> >> +static bool asd_equal(struct v4l2_async_subdev *asd_x,
> >> +		      struct v4l2_async_subdev *asd_y)
> >> +{
> >> +	if (asd_x->match_type != asd_y->match_type)
> >> +		return false;
> >> +
> >> +	switch (asd_x->match_type) {
> >> +	case V4L2_ASYNC_MATCH_DEVNAME:
> >> +		return strcmp(asd_x->match.device_name,
> >> +			      asd_y->match.device_name) == 0;
> >> +	case V4L2_ASYNC_MATCH_I2C:
> >> +		return asd_x->match.i2c.adapter_id ==
> >> +			asd_y->match.i2c.adapter_id &&
> >> +			asd_x->match.i2c.address ==
> >> +			asd_y->match.i2c.address;
> >> +	case V4L2_ASYNC_MATCH_FWNODE:
> >> +		return asd_x->match.fwnode == asd_y->match.fwnode;
> >> +	default:
> >> +		break;
> >> +	}
> >> +
> >> +	return false;
> >> +}
> >> +
> >>   /* Find the sub-device notifier registered by a sub-device driver. */
> >>   static struct v4l2_async_notifier *v4l2_async_find_subdev_notifier(
> >>   	struct v4l2_subdev *sd)
> >> @@ -308,29 +333,22 @@ static void v4l2_async_notifier_unbind_all_subdevs(
> >>   	notifier->parent = NULL;
> >>   }
> >>   
> >> -/* See if an fwnode can be found in a notifier's lists. */
> >> -static bool __v4l2_async_notifier_fwnode_has_async_subdev(
> >> -	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
> >> +/* See if an async sub-device can be found in a notifier's lists. */
> >> +static bool __v4l2_async_notifier_has_async_subdev(
> >> +	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd)  
> > This is a minor issue, but checkpatch complains (with reason)
> > (with --strict) about the above:
> >
> > 	CHECK: Lines should not end with a '('
> > 	#63: FILE: drivers/media/v4l2-core/v4l2-async.c:337:
> > 	+static bool __v4l2_async_notifier_has_async_subdev(
> >
> > Better to declare it, instead, as:
> >
> > static bool
> > __v4l2_async_notifier_has_async_subdev(struct v4l2_async_notifier *notifier,
> > 				       struct v4l2_async_subdev *asd)
> >
> > Similar warnings appear on other places:
> > CHECK: Lines should not end with a '('
> > #102: FILE: drivers/media/v4l2-core/v4l2-async.c:362:
> > +static bool v4l2_async_notifier_has_async_subdev(
> >
> > CHECK: Lines should not end with a '('
> > #141: FILE: drivers/media/v4l2-core/v4l2-async.c:410:
> > +			if (v4l2_async_notifier_has_async_subdev(  
> 
> Will fix.
> 
> >
> > Btw, Checkpatch also complains that the author's email is different
> > than the SOB's one:
> >
> > WARNING: Missing Signed-off-by: line by nominal patch author 'Steve Longerbeam <slongerbeam@gmail.com>'
> >
> > (the some comes with Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>)
> >
> > I suspect that other patches on this series will suffer from the same issue.  
> 
> Will fix when submitting v7.
> 
> > <snip>
> >  
> >> @@ -392,12 +406,11 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >>   		case V4L2_ASYNC_MATCH_CUSTOM:
> >>   		case V4L2_ASYNC_MATCH_DEVNAME:
> >>   		case V4L2_ASYNC_MATCH_I2C:
> >> -			break;
> >>   		case V4L2_ASYNC_MATCH_FWNODE:
> >> -			if (v4l2_async_notifier_fwnode_has_async_subdev(
> >> -				    notifier, asd->match.fwnode, i)) {
> >> +			if (v4l2_async_notifier_has_async_subdev(
> >> +				    notifier, asd, i)) {
> >>   				dev_err(dev,
> >> -					"fwnode has already been registered or in notifier's subdev list\n");
> >> +					"asd has already been registered or in notifier's subdev list\n");  
> > Please, never use "asd" on messages printed to the user. While someone
> > may understand it while reading the source code, for a poor use,
> > "asd" is just a random sequence of 3 characters.  
> 
> I will change the message to read:
> 
> "subdev descriptor already listed in this or other notifiers".

Perfect!

Thanks!
Mauro
