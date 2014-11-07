Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35048 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaKGUeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 15:34:17 -0500
Received: by mail-oi0-f42.google.com with SMTP id a3so2956131oib.29
        for <linux-media@vger.kernel.org>; Fri, 07 Nov 2014 12:34:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415363697-32583-4-git-send-email-hverkuil@xs4all.nl>
References: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl> <1415363697-32583-4-git-send-email-hverkuil@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Fri, 7 Nov 2014 21:34:01 +0100
Message-ID: <CAL8zT=h_=1A=0KGy50oKXrB8PWNVr5rfhbZWqJD4VD1wLDgp=A@mail.gmail.com>
Subject: Re: [PATCH 3/3] adv7604: Correct G/S_EDID behaviour
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2014-11-07 13:34 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> In order to have v4l2-compliance tool pass the G/S_EDID some modifications
> where needed in the driver.
> In particular, the edid.reserved zone must be blanked.
>
> Based on a patch from Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
> but reworked it a bit. It should use edid.present instead of edid.blocks as the
> check whether edid data is present.

I may have missed it, but you did not implement it using edid.present
in the code below... ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/adv7604.c | 37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 47795ff..d64fbd9 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1997,19 +1997,7 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>         struct adv7604_state *state = to_state(sd);
>         u8 *data = NULL;
>
> -       if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
> -               return -EINVAL;
> -       if (edid->blocks == 0)
> -               return -EINVAL;
> -       if (edid->blocks > 2)
> -               return -EINVAL;
> -       if (edid->start_block > 1)
> -               return -EINVAL;
> -       if (edid->start_block == 1)
> -               edid->blocks = 1;
> -
> -       if (edid->blocks > state->edid.blocks)
> -               edid->blocks = state->edid.blocks;
> +       memset(edid->reserved, 0, sizeof(edid->reserved));
>
>         switch (edid->pad) {
>         case ADV7604_PAD_HDMI_PORT_A:
> @@ -2021,14 +2009,24 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>                 break;
>         default:
>                 return -EINVAL;
> -               break;
>         }
> -       if (!data)
> +
> +       if (edid->start_block == 0 && edid->blocks == 0) {
> +               edid->blocks = state->edid.blocks;
> +               return 0;
> +       }
> +
> +       if (data == NULL)
>                 return -ENODATA;
>
> -       memcpy(edid->edid,
> -              data + edid->start_block * 128,
> -              edid->blocks * 128);
> +       if (edid->start_block >= state->edid.blocks)
> +               return -EINVAL;
> +
> +       if (edid->start_block + edid->blocks > state->edid.blocks)
> +               edid->blocks = state->edid.blocks - edid->start_block;
> +
> +       memcpy(edid->edid, data + edid->start_block * 128, edid->blocks * 128);
> +
>         return 0;
>  }
>
> @@ -2068,6 +2066,8 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>         int err;
>         int i;
>
> +       memset(edid->reserved, 0, sizeof(edid->reserved));
> +
>         if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
>                 return -EINVAL;
>         if (edid->start_block != 0)
> @@ -2164,7 +2164,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>                 return -EIO;
>         }
>
> -
>         /* enable hotplug after 100 ms */
>         queue_delayed_work(state->work_queues,
>                         &state->delayed_work_enable_hotplug, HZ / 10);
> --
> 2.1.1
>
