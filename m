Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37496 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbcDXVEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <1460682008-17168-2-git-send-email-javier@osg.samsung.com>
References: <1460682008-17168-1-git-send-email-javier@osg.samsung.com> <1460682008-17168-2-git-send-email-javier@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 24 Apr 2016 22:03:49 +0100
Message-ID: <CA+V-a8tpVgTudcMizZFJw228G7CVpzUXXxNDACA2y3AGtvwGyg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] tvp5150: propagate I2C write error in
 .s_register callback
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 15, 2016 at 2:00 AM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> The tvp5150_write() function can fail so don't return 0 unconditionally
> in tvp5150_s_register() but propagate what's returned by tvp5150_write().
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>
>  drivers/media/i2c/tvp5150.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 4a2e851b6a3b..7be456d1b071 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1161,8 +1161,7 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
>
>  static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
>  {
> -       tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
> -       return 0;
> +       return tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
>  }
>  #endif
>
> --
> 2.5.5
>
