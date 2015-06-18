Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39016 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbbFRUBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 16:01:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: vsp1: Change pixel count at scale-up setting
Date: Thu, 18 Jun 2015 23:01:58 +0300
Message-ID: <65213967.H6cJcZz00U@avalon>
In-Reply-To: <1434302954-31273-1-git-send-email-ykaneko0929@gmail.com>
References: <1434302954-31273-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

Thank you for the patch.

On Monday 15 June 2015 02:29:14 Yoshihiro Kaneko wrote:
> From: Atsushi Akatsuka <atsushi.akatsuka.vb@hitachi.com>
> 
> This commit sets AMD bit of VI6_UDSn_CTRL register,
> and modifies scaling formula to fit AMD bit.

What's the rationale for that ? What are the side effects of setting the AMD 
bit ? Will it change anything beside the scaling factor computation formula ?

> Signed-off-by: Atsushi Akatsuka <atsushi.akatsuka.vb@hitachi.com>
> Signed-off-by: Hiroki Negishi <hiroki.negishi.zr@hitachi-solutions.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> This patch is based on the master branch of linuxtv.org/media_tree.git.
> 
>  drivers/media/platform/vsp1/vsp1_uds.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index ccc8243..e7a046d 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -64,10 +64,10 @@ static unsigned int uds_output_size(unsigned int input,
> unsigned int ratio) mp = ratio / 4096;
>  		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
> 
> -		return (input - 1) / mp * mp * 4096 / ratio + 1;
> +		return input / mp * mp * 4096 / ratio;

According to the datasheet I have access to the AMD bit only influences the 
scale-up case.

>  	} else {
>  		/* Up-scaling */
> -		return (input - 1) * 4096 / ratio + 1;
> +		return input * 4096 / ratio;
>  	}
>  }
> 
> @@ -145,7 +145,8 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int
> enable)
> 
>  	vsp1_uds_write(uds, VI6_UDS_CTRL,
>  		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
> -		       (multitap ? VI6_UDS_CTRL_BC : 0));
> +		       (multitap ? VI6_UDS_CTRL_BC : 0) |
> +		       VI6_UDS_CTRL_AMD);
> 
>  	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
>  		       (uds_passband_width(hscale)

-- 
Regards,

Laurent Pinchart

