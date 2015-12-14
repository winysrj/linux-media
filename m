Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40346 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbbLNSkn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 13:40:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH v2] Return proper error code if STREAMON fails
Date: Mon, 14 Dec 2015 20:40:55 +0200
Message-ID: <2309522.HN147kSG6f@avalon>
In-Reply-To: <1737708.1znbc4YfP6@ttoivone-desk1>
References: <207011196.fyjkdD1C8L@ttoivone-desk1> <181264909.M62ZDuucnX@ttoivone-desk1> <1737708.1znbc4YfP6@ttoivone-desk1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tuukka,

On Monday 14 December 2015 09:49:57 Tuukka Toivonen wrote:
> Return the error code if video_enable() and VIDIOC_STREAMON
> fails.
> 
> Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>

Applied to my tree and pushed, thank you for the patch.

> ---
>  yavta.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/yavta.c b/yavta.c
> index b627725..3d80d3c 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -1708,7 +1708,9 @@ static int video_do_capture(struct device *dev,
> unsigned int nframes, }
> 
>  	/* Stop streaming. */
> -	video_enable(dev, 0);
> +	ret = video_enable(dev, 0);
> +	if (ret < 0)
> +		return ret;
> 
>  	if (nframes == 0) {
>  		printf("No frames captured.\n");

-- 
Regards,

Laurent Pinchart

