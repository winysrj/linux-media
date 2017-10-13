Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57415 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbdJMMeK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 08:34:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 06/17] media: v4l2-dv-timings.h: convert comment into kernel-doc markup
Date: Fri, 13 Oct 2017 15:34:23 +0300
Message-ID: <24723271.VJA3iU1YEF@avalon>
In-Reply-To: <bfe081e9560af67cd499c1f5ae458bfb57d557ea.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <bfe081e9560af67cd499c1f5ae458bfb57d557ea.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:49 EEST Mauro Carvalho Chehab wrote:
> The can_reduce_fps() is already documented, but it is not
> using the kernel-doc markup. Convert it, in order to generate
> documentation from it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-dv-timings.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-dv-timings.h
> b/include/media/v4l2-dv-timings.h index 61a18893e004..c0855887ad87 100644
> --- a/include/media/v4l2-dv-timings.h
> +++ b/include/media/v4l2-dv-timings.h
> @@ -203,13 +203,15 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8
> hor_landscape, u8 vert_portrait); */
>  struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings
> *t);
> 
> -/*
> - * reduce_fps - check if conditions for reduced fps are true.
> - * bt - v4l2 timing structure
> +/**
> + * can_reduce_fps - check if conditions for reduced fps are true.
> + * @bt: v4l2 timing structure
> + *
>   * For different timings reduced fps is allowed if following conditions

While at it, s/following conditions/the following conditions/

> - * are met -
> - * For CVT timings: if reduced blanking v2 (vsync == 8) is true.
> - * For CEA861 timings: if V4L2_DV_FL_CAN_REDUCE_FPS flag is true.
> + * are met:
> + *
> + *   - For CVT timings: if reduced blanking v2 (vsync == 8) is true.
> + *   - For CEA861 timings: if %V4L2_DV_FL_CAN_REDUCE_FPS flag is true.
>   */
>  static inline  bool can_reduce_fps(struct v4l2_bt_timings *bt)
>  {

-- 
Regards,

Laurent Pinchart
