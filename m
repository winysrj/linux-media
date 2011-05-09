Return-path: <mchehab@gaivota>
Received: from mailout1.samsung.com ([203.254.224.24]:18437 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1EIGXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 02:23:30 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LKX001I90F2VJ90@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 May 2011 15:23:29 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LKX006GO0F5UT@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 May 2011 15:23:29 +0900 (KST)
Date: Mon, 09 May 2011 15:23:26 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: [PATCH 2/2] v4l: simulate old crop API using extended crop/compose
 API
In-reply-to: <1304588396-7557-3-git-send-email-t.stanislaws@samsung.com>
To: 'Tomasz Stanislawski' <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Message-id: <004d01cc0e11$9c715e10$d5541a30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <1304588396-7557-3-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hi Tomasz Stanislawski,

On Thursday, May 05, 2011 6:40 PM Tomasz Stanislawski wrote:
> This patch allows new drivers to work correctly with applications that use
> old-style crop API.
> The old crop ioctl is simulated by using selection ioctls.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   85
+++++++++++++++++++++++++++++++++----
>  1 files changed, 75 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-
> ioctl.c
> index aeef966..d0a4073 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1723,11 +1723,31 @@ static long __video_do_ioctl(struct file *file,
>  	{
>  		struct v4l2_crop *p = arg;
> 
> -		if (!ops->vidioc_g_crop)
> +		dbgarg(cmd, "type=%s\n", prt_names(p->type,
v4l2_type_names));
> +
> +		if (ops->vidioc_g_crop) {
> +			ret = ops->vidioc_g_crop(file, fh, p);
> +		} else
> +		if (ops->vidioc_g_selection) {
> +			/* simulate capture crop using selection api */
> +			struct v4l2_selection s = {
> +				.type = p->type,
> +				.target = V4L2_SEL_CROP_ACTIVE,
> +			};
> +
> +			/* crop means compose for output devices */
> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;
> +

If it also supports V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
how about using Macro like V4L2_TYPE_IS_OUTPUT(type) ?

[snip]

Best regards,
Jonghun Han


