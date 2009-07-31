Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56289 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaQ5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 12:57:03 -0400
Received: by fxm17 with SMTP id 17so1483984fxm.37
        for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 09:57:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A731E8B.4030005@jusst.de>
References: <4A731E8B.4030005@jusst.de>
Date: Fri, 31 Jul 2009 12:57:02 -0400
Message-ID: <a728f9f90907310957r5bb95eep65a7f0125c34374e@mail.gmail.com>
Subject: Re: [PATCH] Fix lowband tuning with tda8261
From: Alex Deucher <alexdeucher@gmail.com>
To: Julian Scheel <julian@jusst.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 12:40 PM, Julian Scheel<julian@jusst.de> wrote:
> Attached is a patch which fixes tuning to low frequency channels with
> stb0899+tda8261 cards like the KNC TV-Station DVB-S2.
> The cause of the issue was a broken if construct, which should have been an
> if/else if, so that the setting for the lowest matching frequency is
> applied.
>
> Without this patch for example tuning to "arte" on Astra 19.2, 10744MHz
> SR22000 failed most times and when it failed the communication between
> driver and tda8261 was completely broken.
> This problem disappears with the attached patch.
>

Please replay with your Signed Off By.

Alex

> diff -r 6477aa1782d5 linux/drivers/media/dvb/frontends/tda8261.c
> --- a/linux/drivers/media/dvb/frontends/tda8261.c       Tue Jul 21 09:17:24
> 2009 -0300
> +++ b/linux/drivers/media/dvb/frontends/tda8261.c       Fri Jul 31 18:36:07
> 2009 +0200
> @@ -136,9 +136,9 @@
>
>                if (frequency < 1450000)
>                        buf[3] = 0x00;
> -               if (frequency < 2000000)
> +               else if (frequency < 2000000)
>                        buf[3] = 0x40;
> -               if (frequency < 2150000)
> +               else if (frequency < 2150000)
>                        buf[3] = 0x80;
>
>                /* Set params */
>
>
