Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:50637 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732219AbeHCRKm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 13:10:42 -0400
Date: Fri, 3 Aug 2018 17:13:46 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 03/17] media: v4l2: async: Add
 v4l2_async_notifier_add_subdev
Message-ID: <20180803151346.GG4528@w540>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-4-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="APlYHCtpeOhspHkB"
Content-Disposition: inline
In-Reply-To: <1531175957-1973-4-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--APlYHCtpeOhspHkB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Steven,
   I've a small remark, which is probably not only related to your
   patches but was there alreay... Anyway, please read below..


On Mon, Jul 09, 2018 at 03:39:03PM -0700, Steve Longerbeam wrote:
> v4l2_async_notifier_add_subdev() adds an asd to the notifier. It checks
> that no other equivalent asd's have already been added to this notifier's
> asd list, or to other registered notifier's waiting or done lists, and
> increments num_subdevs.
>
> v4l2_async_notifier_add_subdev() does not make use of the notifier subdevs
> array, otherwise it would have to re-allocate the array every time the
> function was called. In place of the subdevs array, the function adds
> the newly allocated asd to a new master asd_list. The function will
> return error with a WARN() if it is ever called with the subdevs array
> allocated.
>
> Drivers are now required to call a v4l2_async_notifier_init(), before the
> first call to v4l2_async_notifier_add_subdev(), in order to initialize
> the asd_list.
>
> In v4l2_async_notifier_has_async_subdev(), __v4l2_async_notifier_register(),
> and v4l2_async_notifier_cleanup(), maintain backward compatibility with
> the subdevs array, by alternatively operate on the subdevs array or a
> non-empty notifier->asd_list.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v5:
> - export v4l2_async_notifier_init() which must be called by drivers.
>   Suggested by Sakari Ailus.
> Changes since v4:
> - none
> Changes since v3:
> - init notifier lists after the sanity checks.
> Changes since v2:
> - add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
> Changes since v1:
> - none
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 189 +++++++++++++++++++++++++++--------
>  include/media/v4l2-async.h           |  34 ++++++-
>  2 files changed, 180 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index 0e7e529..8e52df2 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -363,16 +363,26 @@ static bool v4l2_async_notifier_has_async_subdev(
>  	struct v4l2_async_notifier *notifier, struct v4l2_async_subdev *asd,
>  	unsigned int this_index)
>  {
> +	struct v4l2_async_subdev *asd_y;
>  	unsigned int j;
>
>  	lockdep_assert_held(&list_lock);
>
>  	/* Check that an asd is not being added more than once. */
> -	for (j = 0; j < this_index; j++) {
> -		struct v4l2_async_subdev *asd_y = notifier->subdevs[j];
> -
> -		if (asd_equal(asd, asd_y))
> -			return true;
> +	if (notifier->subdevs) {
> +		for (j = 0; j < this_index; j++) {
> +			asd_y = notifier->subdevs[j];
> +			if (asd_equal(asd, asd_y))
> +				return true;
> +		}
> +	} else {
> +		j = 0;
> +		list_for_each_entry(asd_y, &notifier->asd_list, asd_list) {
> +			if (j++ >= this_index)
> +				break;
> +			if (asd_equal(asd, asd_y))
> +				return true;
> +		}
>  	}
>
>  	/* Check that an asd does not exist in other notifiers. */
> @@ -383,10 +393,46 @@ static bool v4l2_async_notifier_has_async_subdev(
>  	return false;
>  }
>
> -static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> +static int v4l2_async_notifier_asd_valid(struct v4l2_async_notifier *notifier,
> +					 struct v4l2_async_subdev *asd,
> +					 unsigned int this_index)
>  {
>  	struct device *dev =
>  		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
> +
> +	if (!asd)
> +		return -EINVAL;
> +
> +	switch (asd->match_type) {
> +	case V4L2_ASYNC_MATCH_CUSTOM:
> +	case V4L2_ASYNC_MATCH_DEVNAME:
> +	case V4L2_ASYNC_MATCH_I2C:
> +	case V4L2_ASYNC_MATCH_FWNODE:
> +		if (v4l2_async_notifier_has_async_subdev(notifier, asd,
> +							 this_index))
> +			return -EEXIST;
> +		break;
> +	default:
> +		dev_err(dev, "Invalid match type %u on %p\n",
> +			asd->match_type, asd);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +void v4l2_async_notifier_init(struct v4l2_async_notifier *notifier)
> +{
> +	mutex_lock(&list_lock);
> +
> +	INIT_LIST_HEAD(&notifier->asd_list);
> +
> +	mutex_unlock(&list_lock);
> +}
> +EXPORT_SYMBOL(v4l2_async_notifier_init);
> +
> +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> +{
>  	struct v4l2_async_subdev *asd;
>  	int ret;
>  	int i;
> @@ -399,29 +445,25 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>
>  	mutex_lock(&list_lock);
>
> -	for (i = 0; i < notifier->num_subdevs; i++) {
> -		asd = notifier->subdevs[i];
> +	if (notifier->subdevs) {
> +		for (i = 0; i < notifier->num_subdevs; i++) {
> +			asd = notifier->subdevs[i];
>
> -		switch (asd->match_type) {
> -		case V4L2_ASYNC_MATCH_CUSTOM:
> -		case V4L2_ASYNC_MATCH_DEVNAME:
> -		case V4L2_ASYNC_MATCH_I2C:
> -		case V4L2_ASYNC_MATCH_FWNODE:
> -			if (v4l2_async_notifier_has_async_subdev(
> -				    notifier, asd, i)) {
> -				dev_err(dev,
> -					"asd has already been registered or in notifier's subdev list\n");
> -				ret = -EEXIST;
> +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i);
> +			if (ret)
>  				goto err_unlock;
> -			}
> -			break;
> -		default:
> -			dev_err(dev, "Invalid match type %u on %p\n",
> -				asd->match_type, asd);
> -			ret = -EINVAL;
> -			goto err_unlock;
> +
> +			list_add_tail(&asd->list, &notifier->waiting);
> +		}
> +	} else {
> +		i = 0;
> +		list_for_each_entry(asd, &notifier->asd_list, asd_list) {
> +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);

Here the call stack looks like this, if I'm not mistaken:

list_for_each_entry(asd, notifier->asd_list, i) {
        v4l2_async_notifier_asd_valid(notifier, asd, i):
                v4l2_async_notifier_has_async_subdev(notifier, asd, i):
                        list_for_each_entry(asd_y, notifier->asd_list, j) {
                                if (j >= i) break;
                                if (asd == asd_y) return true;
                        }
}

Which is an optimization of O(n^2), but still bad.

This was there already there, it was:
for (i = 0; i < notifier->num_subdevs; i++) {
        v4l2_async_notifier_has_async_subdev(notifier, notifier->subdevs[i], i):
                for (j = 0; j < i; j++) {
                        if (notifier->subdevs[i] == notifier->subdevs[j])
                                return true;
                        }
                }
}

We're not talking high performances here, but I see no reason to go through
the list twice, as after switching to use your here introduced
v4l2_async_notifier_add_subdev() async subdevices are tested at endpoint
parsing time in v4l2_async_notifier_fwnode_parse_endpoint(), which
guarantees we can't have doubles later, at notifier registration time.

If I'm not wrong, this can be anyway optimized later.

Thanks
   j

> +			if (ret)
> +				goto err_unlock;
> +
> +			list_add_tail(&asd->list, &notifier->waiting);
>  		}
> -		list_add_tail(&asd->list, &notifier->waiting);
>  	}
>
>  	ret = v4l2_async_notifier_try_all_subdevs(notifier);
> @@ -511,36 +553,99 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  }
>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>
> -void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> +static void __v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
>  {
> +	struct v4l2_async_subdev *asd, *tmp;
>  	unsigned int i;
>
> -	if (!notifier || !notifier->max_subdevs)
> +	if (!notifier)
>  		return;
>
> -	for (i = 0; i < notifier->num_subdevs; i++) {
> -		struct v4l2_async_subdev *asd = notifier->subdevs[i];
> +	if (notifier->subdevs) {
> +		if (!notifier->max_subdevs)
> +			return;
>
> -		switch (asd->match_type) {
> -		case V4L2_ASYNC_MATCH_FWNODE:
> -			fwnode_handle_put(asd->match.fwnode);
> -			break;
> -		default:
> -			WARN_ON_ONCE(true);
> -			break;
> +		for (i = 0; i < notifier->num_subdevs; i++) {
> +			asd = notifier->subdevs[i];
> +
> +			switch (asd->match_type) {
> +			case V4L2_ASYNC_MATCH_FWNODE:
> +				fwnode_handle_put(asd->match.fwnode);
> +				break;
> +			default:
> +				break;
> +			}
> +
> +			kfree(asd);
>  		}
>
> -		kfree(asd);
> +		notifier->max_subdevs = 0;
> +		kvfree(notifier->subdevs);
> +		notifier->subdevs = NULL;
> +	} else {
> +		list_for_each_entry_safe(asd, tmp,
> +					 &notifier->asd_list, asd_list) {
> +			switch (asd->match_type) {
> +			case V4L2_ASYNC_MATCH_FWNODE:
> +				fwnode_handle_put(asd->match.fwnode);
> +				break;
> +			default:
> +				break;
> +			}
> +
> +			list_del(&asd->asd_list);
> +			kfree(asd);
> +		}
>  	}
>
> -	notifier->max_subdevs = 0;
>  	notifier->num_subdevs = 0;
> +}
> +
> +void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
> +{
> +	mutex_lock(&list_lock);
> +
> +	__v4l2_async_notifier_cleanup(notifier);
>
> -	kvfree(notifier->subdevs);
> -	notifier->subdevs = NULL;
> +	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_cleanup);
>
> +int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	int ret;
> +
> +	mutex_lock(&list_lock);
> +
> +	if (notifier->num_subdevs >= V4L2_MAX_SUBDEVS) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * If caller uses this function, it cannot also allocate and
> +	 * place asd's in the notifier->subdevs array.
> +	 */
> +	if (WARN_ON(notifier->subdevs)) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	ret = v4l2_async_notifier_asd_valid(notifier, asd,
> +					    notifier->num_subdevs);
> +	if (ret)
> +		goto unlock;
> +
> +	list_add_tail(&asd->asd_list, &notifier->asd_list);
> +	notifier->num_subdevs++;
> +
> +unlock:
> +	mutex_unlock(&list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_add_subdev);
> +
>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *subdev_notifier;
> @@ -614,7 +719,7 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
>  	mutex_lock(&list_lock);
>
>  	__v4l2_async_notifier_unregister(sd->subdev_notifier);
> -	v4l2_async_notifier_cleanup(sd->subdev_notifier);
> +	__v4l2_async_notifier_cleanup(sd->subdev_notifier);
>  	kfree(sd->subdev_notifier);
>  	sd->subdev_notifier = NULL;
>
> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
> index 1592d32..ab4d7ac 100644
> --- a/include/media/v4l2-async.h
> +++ b/include/media/v4l2-async.h
> @@ -73,6 +73,8 @@ enum v4l2_async_match_type {
>   * @match.custom.priv:
>   *		Driver-specific private struct with match parameters
>   *		to be used if %V4L2_ASYNC_MATCH_CUSTOM.
> + * @asd_list:	used to add struct v4l2_async_subdev objects to the
> + *		master notifier @asd_list
>   * @list:	used to link struct v4l2_async_subdev objects, waiting to be
>   *		probed, to a notifier->waiting list
>   *
> @@ -98,6 +100,7 @@ struct v4l2_async_subdev {
>
>  	/* v4l2-async core private: not to be used by drivers */
>  	struct list_head list;
> +	struct list_head asd_list;
>  };
>
>  /**
> @@ -127,6 +130,7 @@ struct v4l2_async_notifier_operations {
>   * @v4l2_dev:	v4l2_device of the root notifier, NULL otherwise
>   * @sd:		sub-device that registered the notifier, NULL otherwise
>   * @parent:	parent notifier
> + * @asd_list:	master list of struct v4l2_async_subdev, replaces @subdevs
>   * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
>   * @done:	list of struct v4l2_subdev, already probed
>   * @list:	member in a global list of notifiers
> @@ -139,12 +143,38 @@ struct v4l2_async_notifier {
>  	struct v4l2_device *v4l2_dev;
>  	struct v4l2_subdev *sd;
>  	struct v4l2_async_notifier *parent;
> +	struct list_head asd_list;
>  	struct list_head waiting;
>  	struct list_head done;
>  	struct list_head list;
>  };
>
>  /**
> + * v4l2_async_notifier_init - Initialize a notifier.
> + *
> + * @notifier: pointer to &struct v4l2_async_notifier
> + *
> + * This function initializes the notifier @asd_list. It must be called
> + * before the first call to @v4l2_async_notifier_add_subdev.
> + */
> +void v4l2_async_notifier_init(struct v4l2_async_notifier *notifier);
> +
> +/**
> + * v4l2_async_notifier_add_subdev - Add an async subdev to the
> + *				notifier's master asd list.
> + *
> + * @notifier: pointer to &struct v4l2_async_notifier
> + * @asd: pointer to &struct v4l2_async_subdev
> + *
> + * This can be used before registering a notifier to add an
> + * asd to the notifiers @asd_list. If the caller uses this
> + * method to compose an asd list, it must never allocate
> + * or place asd's in the @subdevs array.
> + */
> +int v4l2_async_notifier_add_subdev(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_async_subdev *asd);
> +
> +/**
>   * v4l2_async_notifier_register - registers a subdevice asynchronous notifier
>   *
>   * @v4l2_dev: pointer to &struct v4l2_device
> @@ -177,7 +207,9 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
>   * Release memory resources related to a notifier, including the async
>   * sub-devices allocated for the purposes of the notifier but not the notifier
>   * itself. The user is responsible for calling this function to clean up the
> - * notifier after calling @v4l2_async_notifier_parse_fwnode_endpoints or
> + * notifier after calling
> + * @v4l2_async_notifier_add_subdev,
> + * @v4l2_async_notifier_parse_fwnode_endpoints or
>   * @v4l2_fwnode_reference_parse_sensor_common.
>   *
>   * There is no harm from calling v4l2_async_notifier_cleanup in other
> --
> 2.7.4
>

--APlYHCtpeOhspHkB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbZHEqAAoJEHI0Bo8WoVY8lAYP/3i6mIobjOSl6q70kBDkwEVc
byUEOEqYIGvVP3Fzhzd7zjlawG3ZxUS/mCBycFqnrba04SEIHazj6ffakVohDklk
Uo04386DEkVWCKWRBnrF0eeiKm70G2mEJK2dc48TIHyFxhUXg9cu1B+oSySGJEoW
Y7F+80ogskzNR2StNGwpQ+13mPRMtGS6XKiyks6qrdjSGqwYolRxnaHpRwqO/2kS
LoPB1TVR2EzwyQPbpwXnQdFLas8v7ksk+sD/MTlkZ9wrpOiU63WUb4WmIex7OvKD
Fc2p916ctQWMYW1NA9jXTl2YEJKS/xZyqF9LxXgRp/kdnb9J7/3j5ttlX0ouZHRB
kMFsAOuVdDcDbxgX3UkM9zC/+bTbtO68KqA2OtpwBkYbxhYpJJwhEFlSE904frHD
xntAPfHgXFRDlc4daWgI+7NoGuqY9pBvePIwA2rNjdyR+O6w561/koDHdtkaw5Dl
1WS//XJNSmK/IZksP4jvdeSFACnUlVFSzVibnuwuCRT+S3qS8VmGHQGftxh99eQt
8SXjJVEE4hOAmFVCSnIfkkQyeaAxmB8AzDA8POVO5WM66pGjf3dYef+B7NxQN/7h
q0NG9glM8AB9803HhSzEvfnuRkmnRVmWB1lWgza/4hbOdpH/y7mHYZb7HnJ1i0a6
tsHC0yn7maV9ctyzvNv2
=45de
-----END PGP SIGNATURE-----

--APlYHCtpeOhspHkB--
