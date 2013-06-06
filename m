Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49459 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754501Ab3FFALt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 20:11:49 -0400
Date: Thu, 6 Jun 2013 03:11:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hj210.choi@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com
Subject: Re: [REVIEW PATCH v2 10/11] media: Change media device link_notify
 behaviour
Message-ID: <20130606001114.GA3103@valkosipuli.retiisi.org.uk>
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com>
 <1370011047-11488-11-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370011047-11488-11-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch!

On Fri, May 31, 2013 at 04:37:26PM +0200, Sylwester Nawrocki wrote:
...
> @@ -547,25 +547,17 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
>  
>  	mdev = source->parent;
>  
> -	if ((flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify) {
> -		ret = mdev->link_notify(link->source, link->sink,
> -					MEDIA_LNK_FL_ENABLED);
> +	if (mdev->link_notify) {
> +		ret = mdev->link_notify(link, flags,
> +					MEDIA_DEV_NOTIFY_PRE_LINK_CH);
>  		if (ret < 0)
>  			return ret;
>  	}
>  
>  	ret = __media_entity_setup_link_notify(link, flags);
> -	if (ret < 0)
> -		goto err;
>  
> -	if (!(flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify)
> -		mdev->link_notify(link->source, link->sink, 0);
> -
> -	return 0;
> -
> -err:
> -	if ((flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify)
> -		mdev->link_notify(link->source, link->sink, 0);
> +	if (mdev->link_notify)
> +		mdev->link_notify(link, flags, MEDIA_DEV_NOTIFY_POST_LINK_CH);

This changes the behaviour of link_notify() so that the flags will be the
same independently of whether there was an error. I wonder if that's
intentional.

I'd think that in the case of error the flags wouldn't change from what they
were, i.e. the flags argument would be "link->flags" instead of "flags".

>  	return ret;
>  }

...

> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index eaade98..353c4ee 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -45,6 +45,7 @@ struct device;
>   * @entities:	List of registered entities
>   * @lock:	Entities list lock
>   * @graph_mutex: Entities graph operation lock
> + * @link_notify: Link state change notification callback
>   *
>   * This structure represents an abstract high-level media device. It allows easy
>   * access to entities and provides basic media device-level support. The
> @@ -75,10 +76,14 @@ struct media_device {
>  	/* Serializes graph operations. */
>  	struct mutex graph_mutex;
>  
> -	int (*link_notify)(struct media_pad *source,
> -			   struct media_pad *sink, u32 flags);
> +	int (*link_notify)(struct media_link *link, unsigned int flags,
> +			   unsigned int notification);

media_link->flags is unsigned long. The patch doesn't break anything, but it
switches from u32/unsigned long to unsigned int/unsigned long for the field.

How about making media_link->flags unsigned int (or unsigned long) at the
same time, or not changing it? This could be fixed in a separate patch as
well (which I'm not necessarily expect from you now). There are probably a
number of places that would need to be changed.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
