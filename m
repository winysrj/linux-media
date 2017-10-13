Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:60380 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753468AbdJMPb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 11:31:57 -0400
Subject: Re: [PATCH v2 06/17] media: v4l2-dv-timings.h: convert comment into
 kernel-doc markup
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <bfe081e9560af67cd499c1f5ae458bfb57d557ea.1506548682.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <caaeec02-fb78-0759-a669-fac58127a049@xs4all.nl>
Date: Fri, 13 Oct 2017 17:31:52 +0200
MIME-Version: 1.0
In-Reply-To: <bfe081e9560af67cd499c1f5ae458bfb57d557ea.1506548682.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> The can_reduce_fps() is already documented, but it is not
> using the kernel-doc markup. Convert it, in order to generate
> documentation from it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/media/v4l2-dv-timings.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
> index 61a18893e004..c0855887ad87 100644
> --- a/include/media/v4l2-dv-timings.h
> +++ b/include/media/v4l2-dv-timings.h
> @@ -203,13 +203,15 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
>   */
>  struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t);
>  
> -/*
> - * reduce_fps - check if conditions for reduced fps are true.
> - * bt - v4l2 timing structure
> +/**
> + * can_reduce_fps - check if conditions for reduced fps are true.
> + * @bt: v4l2 timing structure
> + *
>   * For different timings reduced fps is allowed if following conditions
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
> 
