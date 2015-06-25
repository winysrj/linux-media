Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46869 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbbFYVw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 17:52:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/7] [media] omap3isp: remove unused var
Date: Fri, 26 Jun 2015 00:52:21 +0300
Message-ID: <2241247.FDDqeShdzl@avalon>
In-Reply-To: <7a9327cd8788da75b44d3bafb058bcfd6ae34319.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com> <7a9327cd8788da75b44d3bafb058bcfd6ae34319.1435142906.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 24 June 2015 07:49:09 Mauro Carvalho Chehab wrote:
> drivers/media/platform/omap3isp/isppreview.c:932:6: warning: variable
> ‘features’ set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On a side note, I'd appreciate if you could wait a couple of days for review 
before committing patches to the media_tree master branch.

Or maybe process pending pull requests for the same driver before fast-
tracking your own patches ;-)

> diff --git a/drivers/media/platform/omap3isp/isppreview.c
> b/drivers/media/platform/omap3isp/isppreview.c index
> 15cb254ccc39..13803270d104 100644
> --- a/drivers/media/platform/omap3isp/isppreview.c
> +++ b/drivers/media/platform/omap3isp/isppreview.c
> @@ -929,14 +929,10 @@ static void preview_setup_hw(struct isp_prev_device
> *prev, u32 update, u32 active)
>  {
>  	unsigned int i;
> -	u32 features;
> 
>  	if (update == 0)
>  		return;
> 
> -	features = (prev->params.params[0].features & active)
> -		 | (prev->params.params[1].features & ~active);
> -
>  	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
>  		const struct preview_update *attr = &update_attrs[i];
>  		struct prev_params *params;

-- 
Regards,

Laurent Pinchart

