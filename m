Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53780 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751794AbdJ3NFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 09:05:31 -0400
Date: Mon, 30 Oct 2017 15:05:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v16.1 19/32] v4l: async: Ensure only unique fwnodes are
 registered to notifiers
Message-ID: <20171030130526.umhg57z4n26l6ewz@valkosipuli.retiisi.org.uk>
References: <20171026075342.5760-20-sakari.ailus@linux.intel.com>
 <20171027105309.8766-1-sakari.ailus@linux.intel.com>
 <20171029222555.obyxxq4w4wjyn4f2@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171029222555.obyxxq4w4wjyn4f2@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Sun, Oct 29, 2017 at 11:25:55PM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Oct 27, 2017 at 01:53:09PM +0300, Sakari Ailus wrote:
> > While registering a notifier, check that each newly added fwnode is
> > unique, and return an error if it is not. Also check that a newly added
> > notifier does not have the same fwnodes twice.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 89 ++++++++++++++++++++++++++++++++----
> >  1 file changed, 81 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index ed539c4fd5dc..a33a68e5417b 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> > @@ -308,8 +308,71 @@ static void v4l2_async_notifier_unbind_all_subdevs(
> >  	notifier->parent = NULL;
> >  }
> >  
> > +/* See if an fwnode can be found in a notifier's lists. */
> > +static bool __v4l2_async_notifier_fwnode_has_async_subdev(
> > +	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode)
> > +{
> > +	struct v4l2_async_subdev *asd;
> > +	struct v4l2_subdev *sd;
> > +
> > +	list_for_each_entry(asd, &notifier->waiting, list) {
> > +		if (asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
> > +			continue;
> > +
> > +		if (asd->match.fwnode.fwnode == fwnode)
> > +			return true;
> > +	}
> > +
> > +	list_for_each_entry(sd, &notifier->done, async_list) {
> > +		if (WARN_ON(!sd->asd))
> > +			continue;
> > +
> > +		if (sd->asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
> > +			continue;
> > +
> > +		if (sd->asd->match.fwnode.fwnode == fwnode)
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +/*
> > + * Find out whether an async sub-device was set up for an fwnode already or
> > + * whether it exists in a given notifier before @this_index.
> > + */
> > +static bool v4l2_async_notifier_fwnode_has_async_subdev(
> > +	struct v4l2_async_notifier *notifier, struct fwnode_handle *fwnode,
> > +	unsigned int this_index)
> > +{
> > +	unsigned int j;
> > +
> > +	lockdep_assert_held(&list_lock);
> > +
> > +	/* Check that an fwnode is not being added more than once. */
> > +	for (j = 0; j < this_index; j++) {
> > +		struct v4l2_async_subdev *asd = notifier->subdevs[this_index];
> > +		struct v4l2_async_subdev *other_asd = notifier->subdevs[j];
> > +
> > +		if (other_asd->match_type == V4L2_ASYNC_MATCH_FWNODE &&
> > +		    asd->match.fwnode.fwnode ==
> > +		    other_asd->match.fwnode.fwnode)
> > +			return true;
> > +	}
> > +
> > +	/* Check than an fwnode did not exist in other notifiers. */
> > +	list_for_each_entry(notifier, &notifier_list, list)
> > +		if (__v4l2_async_notifier_fwnode_has_async_subdev(
> > +			    notifier, fwnode))
> > +			return true;
> > +
> > +	return false;
> > +}
> > +
> >  static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  {
> > +	struct device *dev =
> > +		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
> >  	struct v4l2_async_subdev *asd;
> >  	int ret;
> >  	int i;
> > @@ -320,6 +383,8 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  	INIT_LIST_HEAD(&notifier->waiting);
> >  	INIT_LIST_HEAD(&notifier->done);
> >  
> > +	mutex_lock(&list_lock);
> > +
> >  	for (i = 0; i < notifier->num_subdevs; i++) {
> >  		asd = notifier->subdevs[i];
> >  
> > @@ -327,33 +392,41 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  		case V4L2_ASYNC_MATCH_CUSTOM:
> >  		case V4L2_ASYNC_MATCH_DEVNAME:
> >  		case V4L2_ASYNC_MATCH_I2C:
> > +			break;
> >  		case V4L2_ASYNC_MATCH_FWNODE:
> > +			if (v4l2_async_notifier_fwnode_has_async_subdev(
> > +				    notifier, asd->match.fwnode.fwnode, i)) {
> > +				dev_err(dev,
> > +					"fwnode has already been registered or in notifier's subdev list\n");
> > +				ret = -EEXIST;
> > +				goto out_unlock;
> > +			}
> >  			break;
> >  		default:
> > -			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
> > -				"Invalid match type %u on %p\n",
> > +			dev_err(dev, "Invalid match type %u on %p\n",
> >  				asd->match_type, asd);
> > -			return -EINVAL;
> > +			ret = -EINVAL;
> > +			goto out_unlock;
> >  		}
> >  		list_add_tail(&asd->list, &notifier->waiting);
> >  	}
> >  
> > -	mutex_lock(&list_lock);
> > -
> >  	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> > -	if (ret)
> > +	if (ret < 0)
> >  		goto err_unbind;
> 
> the error path does no unlock?

It does; however the two paths were introduced as the other always returned
zero. So the result is rather less clean after fixing the bug, let me clean
this up...

> 
> >  	ret = v4l2_async_notifier_try_complete(notifier);
> > -	if (ret)
> > +	if (ret < 0)
> >  		goto err_unbind;
> 
> dito
> 
> > +	ret = 0;
> >  
> >  	/* Keep also completed notifiers on the list */
> >  	list_add(&notifier->list, &notifier_list);
> >  
> > +out_unlock:
> >  	mutex_unlock(&list_lock);
> >  
> > -	return 0;
> > +	return ret;
> >  
> >  err_unbind:
> >  	/*
> 
> Otherwise:
> 
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
