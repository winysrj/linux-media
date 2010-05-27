Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57019 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0IEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 04:04:02 -0400
Date: Thu, 27 May 2010 10:04:00 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: mt9m111 swap_rgb_red_blue
Message-ID: <20100527080400.GA23664@pengutronix.de>
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpc2za9i.fsf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 26, 2010 at 10:19:21PM +0200, Robert Jarzmik wrote:
> Sascha Hauer <s.hauer@pengutronix.de> writes:
> 
> > Hi,
> >
> > The mt9m111 soc-camera driver has a swap_rgb_red_blue variable which is
> > hardcoded to 1. This results in, well the name says it, red and blue being
> > swapped in my picture.
> > Is this value needed on some boards or is it just a leftover from
> > development?
> 
> Hi Sascha,
> 
> It's not a development leftover, it's something that the sensor and the host
> have to agree upon (ie. agree upon the output the sensor has to deliver to the
> host).
> 
> By now, only the Marvell PXA27x CPU was used as the host of this sensor, and the
> PXA expects the inverted Red/Blue order (ie. have BGR format).
> 
> Now, for the solution to your problem, we could :
>  - enhance the mt9m111, and add the V4L2_MBUS_FMT_BGR565_2X8_LE format
>    This format would have swap_rgb_red_blue = 1
>  - fix the mt9m111, and add for the V4L2_MBUS_FMT_BGR565_2X8_LE format
>    swap_rgb_red_blue = 0

You mean V4L2_MBUS_FMT_RGB565_2X8_LE => swap_rgb_red_blue = 0 ?


>  - fix the pxa_camera, and convert the RGB format asked for by userland into the
>  V4L2_MBUS_FMT_BGR565_2X8_LE
> 
> What is your opinion here, Guennadi ?
> 
> --
> Robert
> 
> PS: As for now, the RGB565 format is transfered as follows from the sensor, for
> one pixel, over a 8 bit bus (D7-D0):
> 
>        D7 D6 D5 D4 D3 D2 D1 D0
>        =======================
> Byte1: G4 G3 G2 R7 R6 R5 R4 R3
> Byte2: B7 B6 B5 B4 B3 G7 G6 G5
> 
> This is BGR565, with byte1 and byte2 inverted.
> 
> 
> PPS: This is what Sascha is expecting, if I understood correctly:
> 
>        D7 D6 D5 D4 D3 D2 D1 D0
>        =======================
> Byte1: G4 G3 G2 B7 B6 B5 B4 B3
> Byte2: R7 R6 R5 R4 R3 G7 G6 G5
> 
> This is RGB565, with byte1 and byte2 inverted.

Yes, that's what I need

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
