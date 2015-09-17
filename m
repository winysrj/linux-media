Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36044 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbIQIa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 04:30:28 -0400
Received: by lanb10 with SMTP id b10so6529028lan.3
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2015 01:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F95CD9.80802@xs4all.nl>
References: <55F95CD9.80802@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 17 Sep 2015 10:30:06 +0200
Message-ID: <CAPybu_3ZMj_cLsH=GGQU=eqpX+-A1eRniO8M_fomXo8oA6YT5g@mail.gmail.com>
Subject: Re: [RFC PATCH] v4l2-ctrls: fix NEXT_COMPOUND support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

I tried this patch on my platform and v4l2compliance now works ok.

I would suggest to add this definition to the userland header for clarity

#define V4L2_CTRL_FLAG_NEXT_COMPOUND_OR_ARRAY V4L2_CTRL_FLAG_NEXT_COMPOUND


Thanks!

On Wed, Sep 16, 2015 at 2:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Ricardo reported a problem in v4l2-compliance if an integer control was used in
> an array. It turned out to be a problem in the implementation of NEXT_COMPOUND
> that didn't match arrays as being compound controls.
>
> I also did some DocBook updates. The final version of this patch will split off
> the docbook changes in a separate patch (or patches).
>
> Ricardo, can you test this?
>
> In order to be able to use integer controls in an array we also need a new field in
> the union in struct v4l2_ext_control: __s32 __user *p_s32.
>
> Ricardo, please test this thoroughly. I've never tested INTEGER arrays before, so
> I'm not sure if there are no hidden surprises somewhere.
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> index c5bdbfc..842536a 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> @@ -200,6 +200,13 @@ Valid if this control is of type <constant>V4L2_CTRL_TYPE_U16</constant>.</entry
>           </row>
>           <row>
>             <entry></entry>
> +           <entry>__u32 *</entry>
> +           <entry><structfield>p_u32</structfield></entry>
> +           <entry>A pointer to a matrix control of unsigned 32-bit values.
> +Valid if this control is of type <constant>V4L2_CTRL_TYPE_U32</constant>.</entry>
> +         </row>
> +         <row>
> +           <entry></entry>
>             <entry>void *</entry>
>             <entry><structfield>ptr</structfield></entry>
>             <entry>A pointer to a compound type which can be an N-dimensional array and/or a
> diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> index 6ec39c6..8246b30 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> @@ -101,8 +101,9 @@ prematurely end the enumeration).</para></footnote></para>
>  next supported non-compound control, or <errorcode>EINVAL</errorcode>
>  if there is none. In addition, the <constant>V4L2_CTRL_FLAG_NEXT_COMPOUND</constant>
>  flag can be specified to enumerate all compound controls (i.e. controls
> -with type &ge; <constant>V4L2_CTRL_COMPOUND_TYPES</constant>). Specify both
> -<constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> and
> +with type &ge; <constant>V4L2_CTRL_COMPOUND_TYPES</constant> and/or array
> +control, in other words controls that contain more than one value).i
> +Specify both <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> and
>  <constant>V4L2_CTRL_FLAG_NEXT_COMPOUND</constant> in order to enumerate
>  all controls, compound or not. Drivers which do not support these flags yet
>  always return <errorcode>EINVAL</errorcode>.</para>
> @@ -422,7 +423,7 @@ the array to zero.</entry>
>             <entry>any</entry>
>             <entry>An integer-valued control ranging from minimum to
>  maximum inclusive. The step value indicates the increment between
> -values which are actually different on the hardware.</entry>
> +values.</entry>
>           </row>
>           <row>
>             <entry><constant>V4L2_CTRL_TYPE_BOOLEAN</constant></entry>
> @@ -518,7 +519,7 @@ Older drivers which do not support this feature return an
>             <entry>any</entry>
>             <entry>An unsigned 8-bit valued control ranging from minimum to
>  maximum inclusive. The step value indicates the increment between
> -values which are actually different on the hardware.
> +values.
>  </entry>
>           </row>
>           <row>
> @@ -528,7 +529,17 @@ values which are actually different on the hardware.
>             <entry>any</entry>
>             <entry>An unsigned 16-bit valued control ranging from minimum to
>  maximum inclusive. The step value indicates the increment between
> -values which are actually different on the hardware.
> +values.
> +</entry>
> +         </row>
> +         <row>
> +           <entry><constant>V4L2_CTRL_TYPE_U32</constant></entry>
> +           <entry>any</entry>
> +           <entry>any</entry>
> +           <entry>any</entry>
> +           <entry>An unsigned 32-bit valued control ranging from minimum to
> +maximum inclusive. The step value indicates the increment between
> +values.
>  </entry>
>           </row>
>         </tbody>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6b7dcc..d5de70e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2498,7 +2498,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
>                         /* We found a control with the given ID, so just get
>                            the next valid one in the list. */
>                         list_for_each_entry_continue(ref, &hdl->ctrl_refs, node) {
> -                               is_compound =
> +                               is_compound = ref->ctrl->is_array ||
>                                         ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
>                                 if (id < ref->ctrl->id &&
>                                     (is_compound & mask) == match)
> @@ -2512,7 +2512,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
>                            is one, otherwise the first 'if' above would have
>                            been true. */
>                         list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> -                               is_compound =
> +                               is_compound = ref->ctrl->is_array ||
>                                         ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
>                                 if (id < ref->ctrl->id &&
>                                     (is_compound & mask) == match)



-- 
Ricardo Ribalda
