Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44175 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0GGVdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 17:33:06 -0400
Received: by gxk23 with SMTP id 23so61686gxk.19
        for <linux-media@vger.kernel.org>; Wed, 07 Jul 2010 14:33:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100707110613.18be4215@tele>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele> <AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele>
From: Kyle Baker <kyleabaker@gmail.com>
Date: Wed, 7 Jul 2010 17:32:43 -0400
Message-ID: <AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 7, 2010 at 5:06 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
>
> The video and audio don't work at the same time because the video is
> opened before the audio and it takes all the USB bandwidth.
>
> The problem is in the main gspca.c, not in sonixj.c. It may fixed using
> a lower alternate setting. To check it, you may add the following lines:
>
>        if (dev->config->desc.bNumInterfaces != 1)
>                gspca_dev->nbalt -= 1;
> after
>        gspca_dev->nbalt = intf->num_altsetting;
> in the function gspca_dev_probe() of gspca.c.
>
> If it still does not work, change "-= 1" to "-= 2" or "-= 3" (there are
> 8 alternate settings in your webcam).

I've edited the gspca.c file with your suggestion to begin testing,
but I'm unable to get the new drivers to compile with and Error 2.

> For a correct fix, the exact video bandwidth shall be calculated and I
> could not find yet time enough to do the job and people to test it...

If you find time to start progress on this, I will be ready to test
your changes. In the meantime, I will continue trying to compile and
test these changes. If I understood more of how everything works then
I'd start the bandwidth calculation progress myself. Unfortunately I
don't, but I may be able to get a patch working if this will ever
compile.

Thanks.

--
Kyle Baker
