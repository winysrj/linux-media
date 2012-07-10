Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:64992 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2GJL2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 07:28:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] [media] V4L: Use NULL pointer instead of plain integer in v4l2-ctrls.c file
Date: Tue, 10 Jul 2012 13:27:58 +0200
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	g.liakhovetski@gmx.de, patches@linaro.org
References: <1341918886-7911-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1341918886-7911-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207101327.58621.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 10 July 2012 13:14:46 Sachin Kamat wrote:
> Fixes the following sparse warning:
> drivers/media/video/v4l2-ctrls.c:2123:43: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/v4l2-ctrls.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 9abd9ab..18101d6 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -2120,7 +2120,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  
>  	/* First zero the helper field in the master control references */
>  	for (i = 0; i < cs->count; i++)
> -		helpers[i].mref->helper = 0;
> +		helpers[i].mref->helper = NULL;
>  	for (i = 0, h = helpers; i < cs->count; i++, h++) {
>  		struct v4l2_ctrl_ref *mref = h->mref;
>  
> 
