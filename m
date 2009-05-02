Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:52988 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbZEBVSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 17:18:04 -0400
Received: by ewy24 with SMTP id 24so3012629ewy.37
        for <linux-media@vger.kernel.org>; Sat, 02 May 2009 14:18:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FCB2A4.2000609@gmail.com>
References: <49FCB2A4.2000609@gmail.com>
Date: Sun, 3 May 2009 01:18:03 +0400
Message-ID: <208cbae30905021418j613b3dddve5f2e45a36badc1a@mail.gmail.com>
Subject: Re: [PATCH] zoran: Fix &&/|| typo
From: Alexey Klimov <klimov.linux@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mjpeg-users@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Roel

On Sun, May 3, 2009 at 12:52 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> Fix &&/|| typo
>
> diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
> index ea6c577..ea9de8b 100644
> --- a/drivers/media/video/zoran/zoran_card.c
> +++ b/drivers/media/video/zoran/zoran_card.c
> @@ -1022,7 +1022,7 @@ zr36057_init (struct zoran *zr)
>        zr->vbuf_bytesperline = 0;
>
>        /* Avoid nonsense settings from user for default input/norm */
> -       if (default_norm < 0 && default_norm > 2)
> +       if (default_norm < 0 || default_norm > 2)
>                default_norm = 0;
>        if (default_norm == 0) {
>                zr->norm = V4L2_STD_PAL;

Please, remember that all patches that you send need 'Signed-off-by' field.
And i'm out of touch with events, but probably it's better to make
description more dilated/patulous (i'm not sure here).

-- 
Best regards, Klimov Alexey
