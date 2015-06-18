Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39038 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbFRUUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 16:20:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Simon Horman <horms@verge.net.au>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] v4l: vsp1: Align crop rectangle to even boundary for YUV formats
Date: Thu, 18 Jun 2015 23:21:08 +0300
Message-ID: <14792550.FyoUCuzjPK@avalon>
In-Reply-To: <1432817979-2929-1-git-send-email-ykaneko0929@gmail.com>
References: <1432817979-2929-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

Thank you for the patch.

On Thursday 28 May 2015 21:59:39 Yoshihiro Kaneko wrote:
> From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> 
> Make sure that there are valid values in the crop rectangle to ensure
> that the color plane doesn't get shifted when cropping.
> Since there is no distinction between 12bit and 16bit YUV formats in
> at the subdev level, use the more restrictive 12bit limits for all YUV
> formats.
> 
> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with a summary of the commit message added as a source 
code comment.

> ---
> 
> This patch is based on the master branch of linuxtv.org/media_tree.git.
> 
> v2 [Yoshihiro Kaneko]
> * As suggested by Laurent Pinchart
>   - remove the change to add a restriction to the left and top
>   - use round_down() to align the width and height
> * As suggested by Sergei Shtylyov
>   - use ALIGN() to align the left and top
>   - correct a misspelling of the commit message
> * Compile tested only
> 
>  drivers/media/platform/vsp1/vsp1_rwpf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c
> b/drivers/media/platform/vsp1/vsp1_rwpf.c index fa71f46..32687c7 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -197,6 +197,14 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
> */
>  	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SINK,
>  					    sel->which);
> +
> +	if (format->code == MEDIA_BUS_FMT_AYUV8_1X32) {
> +		sel->r.left = ALIGN(sel->r.left, 2);
> +		sel->r.top = ALIGN(sel->r.top, 2);
> +		sel->r.width = round_down(sel->r.width, 2);
> +		sel->r.height = round_down(sel->r.height, 2);
> +	}
> +
>  	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
>  	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);
>  	if (rwpf->entity.type == VSP1_ENTITY_WPF) {

-- 
Regards,

Laurent Pinchart

