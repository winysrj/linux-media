Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:37421 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbbA2UXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:23:36 -0500
Received: by mail-oi0-f53.google.com with SMTP id i138so30707244oig.12
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 12:23:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422548388-28861-5-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <1422548388-28861-5-git-send-email-william.towle@codethink.co.uk>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 29 Jan 2015 21:23:20 +0100
Message-ID: <CAL8zT=gQF+OeRqTU0X+eeKA1UmyNNyAfmyr5cmj6h6ALHuSF1A@mail.gmail.com>
Subject: Re: [PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
To: William Towle <william.towle@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First of all, this subject puzzles me... What means WmT ??

2015-01-29 17:19 GMT+01:00 William Towle <william.towle@codethink.co.uk>:
> ---
>  drivers/media/i2c/adv7604.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Again, it it passing checkpatch without signed-off-by ? And a little
description does not hurt :).

> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 30bbd9d..6ed9303 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1976,7 +1976,11 @@ static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>         if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>                 struct v4l2_mbus_framefmt *fmt;
>
> -               fmt = v4l2_subdev_get_try_format(fh, format->pad);
> +               fmt = (fh == NULL) ? NULL
> +                       : v4l2_subdev_get_try_format(fh, format->pad);
> +               if (fmt == NULL)
> +                       return EINVAL;
> +

Mmmh, Hans probably has an explanation on this, I just don't get a use
case where fh can be NULL... So can't see the point of this patch ?

>                 format->format.code = fmt->code;
>         } else {
>                 format->format.code = state->format->code;
> @@ -2008,7 +2012,11 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>         if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>                 struct v4l2_mbus_framefmt *fmt;
>
> -               fmt = v4l2_subdev_get_try_format(fh, format->pad);
> +               fmt = (fh == NULL) ? NULL
> +                       : v4l2_subdev_get_try_format(fh, format->pad);
> +               if (fmt == NULL)
> +                       return -EINVAL;
> +
>                 fmt->code = format->format.code;
>         } else {
>                 state->format = info;

Same comment as above.
Thanks,
JM
