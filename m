Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34246 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbcELG7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 02:59:17 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so13904936wmn.1
        for <linux-media@vger.kernel.org>; Wed, 11 May 2016 23:59:16 -0700 (PDT)
Message-ID: <1463036352.5484.26.camel@gmail.com>
Subject: Re: [PATCH] Revert "[media] videobuf2-v4l2: Verify planes array in
 buffer dequeueing"
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, stable@vgar.kernel.org
Date: Thu, 12 May 2016 09:59:12 +0300
In-Reply-To: <575aa5711a62f79c5f973011b415403fd3d3b7c7.1462984023.git.mchehab@osg.samsung.com>
References: <575aa5711a62f79c5f973011b415403fd3d3b7c7.1462984023.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 11 mai 2016 à 13:27 -0300, Mauro Carvalho Chehab a écrit :
> This patch causes a Kernel panic when called on a DVB driver.
> 
> This reverts commit 2c1f6951a8a82e6de0d82b1158b5e493fc6c54ab.

Seems rather tricky, since this commit fixed a possible (user induced)
buffer overflow according to Sakari comment. Would be nice to fix and
resubmit.

> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vgar.kernel.org
> Fixes: 2c1f6951a8a8 ("[media] videobuf2-v4l2: Verify planes array in
> buffer dequeueing")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c
> b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 7f366f1b0377..0b1b8c7b6ce5 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -74,11 +74,6 @@ static int __verify_planes_array(struct vb2_buffer
> *vb, const struct v4l2_buffer
>  	return 0;
>  }
>  
> -static int __verify_planes_array_core(struct vb2_buffer *vb, const
> void *pb)
> -{
> -	return __verify_planes_array(vb, pb);
> -}
> -
>  /**
>   * __verify_length() - Verify that the bytesused value for each
> plane fits in
>   * the plane length and that the data offset doesn't exceed the
> bytesused value.
> @@ -442,7 +437,6 @@ static int __fill_vb2_buffer(struct vb2_buffer
> *vb,
>  }
>  
>  static const struct vb2_buf_ops v4l2_buf_ops = {
> -	.verify_planes_array	= __verify_planes_array_core,
>  	.fill_user_buffer	= __fill_v4l2_buffer,
>  	.fill_vb2_buffer	= __fill_vb2_buffer,
>  	.copy_timestamp		= __copy_timestamp,
