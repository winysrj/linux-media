Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52552 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752239AbdJ0KGN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 06:06:13 -0400
Date: Fri, 27 Oct 2017 13:06:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v16 19/32] v4l: async: Ensure only unique fwnodes are
 registered to notifiers
Message-ID: <20171027100609.zvww6o5bacfvkfsv@valkosipuli.retiisi.org.uk>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-20-sakari.ailus@linux.intel.com>
 <20171027095227.GA8854@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171027095227.GA8854@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Oct 27, 2017 at 11:52:27AM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your patch.
> 
> On 2017-10-26 10:53:29 +0300, Sakari Ailus wrote:
> > While registering a notifier, check that each newly added fwnode is
> > unique, and return an error if it is not. Also check that a newly added
> > notifier does not have the same fwnodes twice.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-async.c | 82 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 77 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> > index ed539c4fd5dc..b4e88eef195f 100644
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
> > @@ -327,19 +392,25 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
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
> 
> You store the error code in ret before the jump, but in the out_unlock 
> path ret is not considered and 0 is always returned.
> 
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
> 
> Same here.

Good catch! How about this change on top of the patch? It makes return
value checks a little bit safer, too.

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index b4e88eef195f..a33a68e5417b 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -412,12 +412,13 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	}
 
 	ret = v4l2_async_notifier_try_all_subdevs(notifier);
-	if (ret)
+	if (ret < 0)
 		goto err_unbind;
 
 	ret = v4l2_async_notifier_try_complete(notifier);
-	if (ret)
+	if (ret < 0)
 		goto err_unbind;
+	ret = 0;
 
 	/* Keep also completed notifiers on the list */
 	list_add(&notifier->list, &notifier_list);
@@ -425,7 +426,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 out_unlock:
 	mutex_unlock(&list_lock);
 
-	return 0;
+	return ret;
 
 err_unbind:
 	/*

> 
> >  		}
> >  		list_add_tail(&asd->list, &notifier->waiting);
> >  	}
> >  
> > -	mutex_lock(&list_lock);
> > -
> >  	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> >  	if (ret)
> >  		goto err_unbind;
> > @@ -351,6 +422,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> >  	/* Keep also completed notifiers on the list */
> >  	list_add(&notifier->list, &notifier_list);
> >  
> > +out_unlock:
> >  	mutex_unlock(&list_lock);
> >  
> >  	return 0;

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
