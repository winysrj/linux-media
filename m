Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:42203 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0A2Q4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 11:56:23 -0500
Received: by pxi12 with SMTP id 12so1707931pxi.33
        for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 08:56:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B632187.9070403@utanet.at>
References: <4B632187.9070403@utanet.at>
Date: Fri, 29 Jan 2010 11:56:23 -0500
Message-ID: <34539a481001290856s151fc1f5icc62b5d4d3ca937f@mail.gmail.com>
Subject: Re: [Fwd: [Mjpeg-users] [PATCH] zoran: match parameter signedness of
	g_input_status]
From: "Ronald S. Bultje" <rsbultje@gmail.com>
To: linux-media@vger.kernel.org,
	Bernhard Praschinger <shadowlord@utanet.at>,
	=?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bernhard (& Marton),

patch is OK with me, you can forward this to LKML, or better yet, to
the V4L maintainers (this is try#2 to CC them).

Cheers,
Ronald

2010/1/29 Bernhard Praschinger <shadowlord@utanet.at>:
> Hallo
>
> I hope that you got the mail to the mailinglist to. Can you please check it
> and approve it or do something else with it ;)
>
>
>
> auf hoffentlich bald,
>
> Berni the Chaos of Woodquarter
>
> Email: shadowlord@utanet.at
> www: http://www.lysator.liu.se/~gz/bernhard
>
> From: Márton Németh <nm127@freemail.hu>
>
> The second parameter of g_input_status operation in <media/v4l2-subdev.h>
> is unsigned so also call it with unsigned paramter.
>
> This will remove the following sparse warning (see "make C=1"):
>  * incorrect type in argument 2 (different signedness)
>       expected unsigned int [usertype] *status
>       got int *<noident>
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r 2a50a0a1c951 linux/drivers/media/video/zoran/zoran_device.c
> --- a/linux/drivers/media/video/zoran/zoran_device.c    Sat Jan 23 00:14:32
> 2010 -0200
> +++ b/linux/drivers/media/video/zoran/zoran_device.c    Sat Jan 23 07:57:09
> 2010 +0100
> @@ -1197,7 +1197,8 @@
>  static void zoran_restart(struct zoran *zr)
>  {
>        /* Now the stat_comm buffer is ready for restart */
> -       int status = 0, mode;
> +       unsigned int status = 0;
> +       int mode;
>
>        if (zr->codec_mode == BUZ_MODE_MOTION_COMPRESS) {
>                decoder_call(zr, video, g_input_status, &status);
> diff -r 2a50a0a1c951 linux/drivers/media/video/zoran/zoran_driver.c
> --- a/linux/drivers/media/video/zoran/zoran_driver.c    Sat Jan 23 00:14:32
> 2010 -0200
> +++ b/linux/drivers/media/video/zoran/zoran_driver.c    Sat Jan 23 07:57:09
> 2010 +0100
> @@ -1452,7 +1452,7 @@
>        }
>
>        if (norm == V4L2_STD_ALL) {
> -               int status = 0;
> +               unsigned int status = 0;
>                v4l2_std_id std = 0;
>
>                decoder_call(zr, video, querystd, &std);
>
>
> ------------------------------------------------------------------------------
> Throughout its 18-year history, RSA Conference consistently attracts the
> world's best and brightest in the field, creating opportunities for
> Conference
> attendees to learn about information security's most important issues
> through
> interactions with peers, luminaries and emerging and established companies.
> http://p.sf.net/sfu/rsaconf-dev2dev
> _______________________________________________
> Mjpeg-users mailing list
> Mjpeg-users@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/mjpeg-users
>
>
