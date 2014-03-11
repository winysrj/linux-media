Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:56149 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKHZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:25:13 -0400
Received: by mail-ve0-f178.google.com with SMTP id jw12so8059709veb.37
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:25:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-7-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-7-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:54:52 +0530
Message-ID: <CA+V-a8vdPwUsqTz6VCKdCe1s6b7nsXLUfMkW8MbZ8h13FfSBvA@mail.gmail.com>
Subject: Re: [PATCH v2 06/48] v4l: Add pad-level DV timings subdev operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  include/media/v4l2-subdev.h    |  4 ++++
>  include/uapi/linux/videodev2.h | 10 ++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1752530..2b5ec32 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -509,6 +509,10 @@ struct v4l2_subdev_pad_ops {
>                              struct v4l2_subdev_selection *sel);
>         int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
>         int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
> +       int (*dv_timings_cap)(struct v4l2_subdev *sd,
> +                             struct v4l2_dv_timings_cap *cap);
> +       int (*enum_dv_timings)(struct v4l2_subdev *sd,
> +                              struct v4l2_enum_dv_timings *timings);
>  #ifdef CONFIG_MEDIA_CONTROLLER
>         int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
>                              struct v4l2_subdev_format *source_fmt,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 17acba8..72fbbd4 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1103,12 +1103,15 @@ struct v4l2_dv_timings {
>
>  /** struct v4l2_enum_dv_timings - DV timings enumeration
>   * @index:     enumeration index
> + * @pad:       the pad number for which to enumerate timings (used with
> + *             v4l-subdev nodes only)
>   * @reserved:  must be zeroed
>   * @timings:   the timings for the given index
>   */
>  struct v4l2_enum_dv_timings {
>         __u32 index;
> -       __u32 reserved[3];
> +       __u32 pad;
> +       __u32 reserved[2];
>         struct v4l2_dv_timings timings;
>  };
>
> @@ -1146,11 +1149,14 @@ struct v4l2_bt_timings_cap {
>
>  /** struct v4l2_dv_timings_cap - DV timings capabilities
>   * @type:      the type of the timings (same as in struct v4l2_dv_timings)
> + * @pad:       the pad number for which to query capabilities (used with
> + *             v4l-subdev nodes only)
>   * @bt:                the BT656/1120 timings capabilities
>   */
>  struct v4l2_dv_timings_cap {
>         __u32 type;
> -       __u32 reserved[3];
> +       __u32 pad;
> +       __u32 reserved[2];
>         union {
>                 struct v4l2_bt_timings_cap bt;
>                 __u32 raw_data[32];
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
