Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58837 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0EKJdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 05:33:39 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 11 May 2010 15:03:34 +0530
Subject: RE: [PATCH 5/6] [RFC] tvp514x: remove obsolete fmt_list
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404BD8@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
 <fd7b8109f9b34c40670cc8a3072e4917bb409eb3.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <fd7b8109f9b34c40670cc8a3072e4917bb409eb3.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 5/6] [RFC] tvp514x: remove obsolete fmt_list
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/tvp514x.c |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 4e22621..1c3417b 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -198,21 +198,6 @@ static struct tvp514x_reg tvp514x_reg_list_default[] =
> {
>  };
> 
>  /**
> - * List of image formats supported by TVP5146/47 decoder
> - * Currently we are using 8 bit mode only, but can be
> - * extended to 10/20 bit mode.
> - */
> -static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
> -	{
> -	 .index = 0,
> -	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -	 .flags = 0,
> -	 .description = "8-bit UYVY 4:2:2 Format",
> -	 .pixelformat = V4L2_PIX_FMT_UYVY,
> -	},
> -};
> -
> -/**
[Hiremath, Vaibhav] This can be part of [PATCH 3/6] 

Subject: [RFC] tvp514x: there is only one supported format, so simplify the code

Irrespective of this, this is required so,

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav
>   * Supported standards -
>   *
>   * Currently supports two standards only, need to add support for rest of
> the
> --
> 1.6.4.2

