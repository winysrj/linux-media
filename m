Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:54074 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775AbZKXSCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 13:02:11 -0500
Date: Tue, 24 Nov 2009 19:02:09 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Gustavo =?ISO-8859-1?Q?Cha=EDn?= Dumit <g@0xff.cl>
Cc: linux-media@vger.kernel.org
Subject: Re: VFlip problem in gspca_pac7311
Message-ID: <20091124190209.67d6a2f7@tele>
In-Reply-To: <20091123141042.47feac9e@0xff.cl>
References: <20091123141042.47feac9e@0xff.cl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Nov 2009 14:10:42 -0300
Gustavo Chaín Dumit <g@0xff.cl> wrote:
> I'm testing a Pixart Imaging device (0x93a:0x2622)
> Everything works fine, but vertical orientation. Image looks rotated.
> So I wrote a little hack to prevent it.
> 
> diff --git a/drivers/media/video/gspca/pac7311.c
> b/drivers/media/video/gspca/pac 7311.c
> index 0527144..f7904ec 100644
> --- a/drivers/media/video/gspca/pac7311.c
> +++ b/drivers/media/video/gspca/pac7311.c
> @@ -690,27 +690,28 @@ static int sd_start(struct gspca_dev *gspca_dev)
>         }
>         setgain(gspca_dev);
>         setexposure(gspca_dev);
> -       sethvflip(gspca_dev);
> +       if (gspca_dev->dev->descriptor.idProduct != 0x2622)
> +               sethvflip(gspca_dev);
> 
> Any one has the same problem ?

Yes, other people have the same problem with this webcam. I was
changing the driver when I found a problem.

The vertical and horizontal flips are set in the register 0x21 of the
page 3. The function sethvflip() sets 0x08 for Hflip and 0x04 for
Vflip. By default, this register is set to 0x08 and when sethvflip() is
called, it sets back the value to 0 (no H nor V flip).

As your patch prevents sethvflip to be called, the value 0x08 should be
Vflip and not Hflip. May you confirm that changing Vflip by program
(v4l2ucp, v4l2-ctl...)  does mirroring?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
