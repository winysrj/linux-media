Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42924 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754526AbdDGKjr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 06:39:47 -0400
Date: Fri, 7 Apr 2017 13:39:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/8] v4l: async: Add fwnode match support
Message-ID: <20170407103913.GE4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-4-git-send-email-sakari.ailus@linux.intel.com>
 <3722368.bfpMvP62Mi@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3722368.bfpMvP62Mi@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 12:49:02PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 06 Apr 2017 16:12:05 Sakari Ailus wrote:
> > Add fwnode matching to complement OF node matching. And fwnode may also be
> > an OF node.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 12 ++++++++++++
> >  include/media/v4l2-async.h           |  5 +++++
> >  include/media/v4l2-subdev.h          |  3 +++
> >  3 files changed, 20 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 96cc733..384ad5e 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -46,6 +46,11 @@ static bool match_of(struct v4l2_subdev *sd, struct
> > v4l2_async_subdev *asd) of_node_full_name(asd->match.of.node));
> >  }
> > 
> > +static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev
> > *asd)
> > +{
> > +	return sd->fwnode == asd->match.fwnode.fwn;
> > +}
> > +
> >  static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev
> > *asd) {
> >  	if (!asd->match.custom.match)
> > @@ -80,6 +85,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct
> > v4l2_async_notifier * case V4L2_ASYNC_MATCH_OF:
> >  			match = match_of;
> >  			break;
> > +		case V4L2_ASYNC_MATCH_FWNODE:
> > +			match = match_fwnode;
> > +			break;
> >  		default:
> >  			/* Cannot happen, unless someone breaks us */
> >  			WARN_ON(true);
> > @@ -158,6 +166,7 @@ int v4l2_async_notifier_register(struct v4l2_device
> > *v4l2_dev, case V4L2_ASYNC_MATCH_DEVNAME:
> >  		case V4L2_ASYNC_MATCH_I2C:
> >  		case V4L2_ASYNC_MATCH_OF:
> > +		case V4L2_ASYNC_MATCH_FWNODE:
> >  			break;
> >  		default:
> >  			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : 
> NULL,
> > @@ -282,6 +291,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  	 */
> >  	if (!sd->of_node && sd->dev)
> >  		sd->of_node = sd->dev->of_node;
> > +	if (!sd->fwnode && sd->dev)
> > +		sd->fwnode = sd->dev->of_node ?
> > +			&sd->dev->of_node->fwnode : sd->dev->fwnode;
> > 
> >  	mutex_lock(&list_lock);
> > 
> > diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> > index 8e2a236..8f552d2 100644
> > --- a/include/media/v4l2-async.h
> > +++ b/include/media/v4l2-async.h
> > @@ -32,6 +32,7 @@ struct v4l2_async_notifier;
> >   * @V4L2_ASYNC_MATCH_DEVNAME: Match will use the device name
> >   * @V4L2_ASYNC_MATCH_I2C: Match will check for I2C adapter ID and address
> >   * @V4L2_ASYNC_MATCH_OF: Match will use OF node
> > + * @V4L2_ASYNC_MATCH_FWNODE: Match will use firmware node
> >   *
> >   * This enum is used by the asyncrhronous sub-device logic to define the
> >   * algorithm that will be used to match an asynchronous device.
> > @@ -41,6 +42,7 @@ enum v4l2_async_match_type {
> >  	V4L2_ASYNC_MATCH_DEVNAME,
> >  	V4L2_ASYNC_MATCH_I2C,
> >  	V4L2_ASYNC_MATCH_OF,
> > +	V4L2_ASYNC_MATCH_FWNODE,
> >  };
> > 
> >  /**
> > @@ -58,6 +60,9 @@ struct v4l2_async_subdev {
> >  			const struct device_node *node;
> >  		} of;
> >  		struct {
> > +			struct fwnode_handle *fwn;
> 
> I'd name this "node". The rationale is that code should be as independent as 
> possible of whether we use device_node or fwnode_handle. Naming both variable 
> "node" helps in that regard, and is in my opinion easier to read. This applies 
> to the other patches in the series too.

What you're proposing doesn't really change that: you'll have to be aware of
which one you have anyway. Variables pointing to fwnode_handle are often
called fwn as well --- as node is used for struct device_node.

In other words, I prefer to keep it as it is.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > +		} fwnode;
> > +		struct {
> >  			const char *name;
> >  		} device_name;
> >  		struct {
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 0ab1c5d..5f1669c 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -788,6 +788,8 @@ struct v4l2_subdev_platform_data {
> >   * @devnode: subdev device node
> >   * @dev: pointer to the physical device, if any
> >   * @of_node: The device_node of the subdev, usually the same as
> > dev->of_node. + * @fwnode: The fwnode_handle of the subdev, usually the
> > same as
> > + *	    either dev->of_node->fwnode or dev->fwnode (whichever is non-
> NULL).
> >   * @async_list: Links this subdev to a global subdev_list or
> > @notifier->done *	list.
> >   * @asd: Pointer to respective &struct v4l2_async_subdev.
> > @@ -819,6 +821,7 @@ struct v4l2_subdev {
> >  	struct video_device *devnode;
> >  	struct device *dev;
> >  	struct device_node *of_node;
> > +	struct fwnode_handle *fwnode;
> >  	struct list_head async_list;
> >  	struct v4l2_async_subdev *asd;
> >  	struct v4l2_async_notifier *notifier;
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
