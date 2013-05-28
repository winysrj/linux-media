Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41153 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab3E1RjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 13:39:16 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNI00IZIRPCRP30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 18:39:14 +0100 (BST)
Message-id: <51A4EBC0.9090300@samsung.com>
Date: Tue, 28 May 2013 19:39:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, dh09.lee@samsung.com, a.hajda@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 09/13] media: Change media device link_notify behaviour
References: <1368113805-20233-1-git-send-email-s.nawrocki@samsung.com>
 <1368113805-20233-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368113805-20233-10-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

(replying to myself, probably a bad sign... ;))

On 05/09/2013 05:36 PM, Sylwester Nawrocki wrote:
> Currently the media device link_notify callback is invoked before the
> actual change of state of a link when the link is being enabled, and
> after the actual change of state when the link is being disabled.
> 
> This doesn't allow a media device driver to perform any operations
> on a full graph before a link is disabled, as well as performing
> any tasks on a modified graph right after a link's state is changed.
> 
> This patch modifies signature of the link_notify callback. This
> callback is now called always before and after a link's state change.
> To distinguish the notifications a 'notification' argument is added
> to the link_notify callback: MEDIA_DEV_NOTIFY_PRE_LINK_CH indicates
> notification before link's state change and
> MEDIA_DEV_NOTIFY_POST_LINK_CH corresponds to a notification after
> link flags change.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/media-entity.c                  |   18 +++--------
>  drivers/media/platform/exynos4-is/media-dev.c |   16 +++++-----
>  drivers/media/platform/omap3isp/isp.c         |   41 +++++++++++++++----------
>  include/media/media-device.h                  |    9 ++++--
>  4 files changed, 46 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 7c2b51c..0fcf4c0 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -547,25 +547,17 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
>  
>  	mdev = source->parent;
>  
> -	if ((flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify) {
> -		ret = mdev->link_notify(link->source, link->sink,
> -					MEDIA_LNK_FL_ENABLED);
> +	if (mdev->link_notify) {
> +		ret = mdev->link_notify(link, MEDIA_LNK_FL_ENABLED,
> +						MEDIA_DEV_NOTIFY_PRE_LINK_CH);

After some testing I found it really should have been

		ret = mdev->link_notify(link, flags,
					MEDIA_DEV_NOTIFY_PRE_LINK_CH);

Otherwise the pipeline never gets powered off upon link disconnection.

I will repost the whole series in the end of week, after some more testing.
Still, any further comments on this are appreciated.

Thanks,
Sylwester
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
>  
>  	return ret;
>  }

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
Samsung Electronics
