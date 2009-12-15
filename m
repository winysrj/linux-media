Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:49505 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZLOHya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 02:54:30 -0500
Date: Tue, 15 Dec 2009 08:54:45 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Luis Maia <lmaia@royalhat.org>
Cc: linux-media@vger.kernel.org
Subject: Re: PATCH- gspca: added chipset revision sensor
Message-ID: <20091215085445.093ebfd8@tele>
In-Reply-To: <4B27063C.6020200@royalhat.org>
References: <4B27063C.6020200@royalhat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 Dec 2009 03:45:00 +0000
Luis Maia <lmaia@royalhat.org> wrote:

> Added extra chipset revision (sensor) to fix camera zc0301 with  ID: 
> 0ac8:301b .
> Since i own one of this cameras fixed and tested it.

> -------------
> 
> diff -uNr linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c 
> linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
> --- linux-2.6.32.1/drivers/media/video/gspca/zc3xx.c    2009-12-14 
> 17:47:25.000000000 +0000
> +++ linux-2.6.32.1-patch/drivers/media/video/gspca/zc3xx.c
> 2009-12-15 02:42:13.000000000 +0000
> @@ -6868,6 +6868,7 @@
>      {0x8001, 0x13},
>      {0x8000, 0x14},        /* CS2102K */
>      {0x8400, 0x15},        /* TAS5130K */
> +    {0xe400, 0x15},
>  };
>  
>  static int vga_3wr_probe(struct gspca_dev *gspca_dev)
> @@ -7634,7 +7635,7 @@
>      {USB_DEVICE(0x0698, 0x2003)},
>      {USB_DEVICE(0x0ac8, 0x0301), .driver_info = SENSOR_PAS106},
>      {USB_DEVICE(0x0ac8, 0x0302), .driver_info = SENSOR_PAS106},
> -    {USB_DEVICE(0x0ac8, 0x301b)},
> +    {USB_DEVICE(0x0ac8, 0x301b), .driver_info = SENSOR_PB0330},
>      {USB_DEVICE(0x0ac8, 0x303b)},
>      {USB_DEVICE(0x0ac8, 0x305b), .driver_info =
> SENSOR_TAS5130C_VF0250}, {USB_DEVICE(0x0ac8, 0x307b)},

Hello Luis,

I don't understand your patch:
1) you added 0xe400 in the chipset table giving the sensor tas5130c K
2) in the device table you say that the 0ac8:301b sensor is a pb0330
   (but this information is not used: the sensor type in .driver_info
   may be only pas106 for sif probe or mc501cb/tas5130_vf0250 for no
   probe.

What is exactly the sensor of your webcam?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
