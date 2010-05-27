Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40543 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0E0LST (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:18:19 -0400
Date: Thu, 27 May 2010 13:18:18 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9m111 swap_rgb_red_blue
Message-ID: <20100527111818.GD23664@pengutronix.de>
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr> <Pine.LNX.4.64.1005271112410.2293@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005271112410.2293@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 27, 2010 at 11:45:25AM +0200, Guennadi Liakhovetski wrote:
> On Wed, 26 May 2010, Robert Jarzmik wrote:
> 
> > Sascha Hauer <s.hauer@pengutronix.de> writes:
> > 
> > > Hi,
> > >
> > > The mt9m111 soc-camera driver has a swap_rgb_red_blue variable which is
> > > hardcoded to 1. This results in, well the name says it, red and blue being
> > > swapped in my picture.
> > > Is this value needed on some boards or is it just a leftover from
> > > development?
> > 
> > Hi Sascha,
> > 
> > It's not a development leftover, it's something that the sensor and the host
> > have to agree upon (ie. agree upon the output the sensor has to deliver to the
> > host).
> > 
> > By now, only the Marvell PXA27x CPU was used as the host of this sensor, and the
> > PXA expects the inverted Red/Blue order (ie. have BGR format).
> > 
> > Now, for the solution to your problem, we could :
> >  - enhance the mt9m111, and add the V4L2_MBUS_FMT_BGR565_2X8_LE format
> >    This format would have swap_rgb_red_blue = 1
> >  - fix the mt9m111, and add for the V4L2_MBUS_FMT_BGR565_2X8_LE format
> >    swap_rgb_red_blue = 0
> >  - fix the pxa_camera, and convert the RGB format asked for by userland into the
> >  V4L2_MBUS_FMT_BGR565_2X8_LE
> > 
> > What is your opinion here, Guennadi ?
> > 
> > --
> > Robert
> > 
> > PS: As for now, the RGB565 format is transfered as follows from the sensor, for
> > one pixel, over a 8 bit bus (D7-D0):
> > 
> >        D7 D6 D5 D4 D3 D2 D1 D0
> >        =======================
> > Byte1: G4 G3 G2 R7 R6 R5 R4 R3
> > Byte2: B7 B6 B5 B4 B3 G7 G6 G5
> > 
> > This is BGR565, with byte1 and byte2 inverted.
> 
> "inverted" has to be explained here, I think. So, an BGR565 is a 16-bit 
> word like (using your notation)
> 
> High byte                  | Low byte
> bit15                      |                      bit0
>    b7 b6 b5 b4 b3 g7 g6 g5 | g4 g3 g2 r7 r6 r5 r4 r3
> 
> on a LE machine this will be stored in RAM as
> 
> address 0 | address 1
> Low byte  | High byte
> 
> So, if we take a "natural pass-through" packing as
> 
> Byte1 -> address 0
> Byte2 -> address 1
> 
> Then your table above is a V4L2_MBUS_FMT_BGR565_2X8_LE format. Agree? So, 
> that's what you get with "swap_rgb_red_blue = 1." Now, this flag actually 
> swaps the colour components, not the bytes, right? With "swap_rgb_red_blue 
> = 0" you'd get V4L2_MBUS_FMT_BGR565_2X8_BE. So, yes, I agree, that 
> you have to extend the mt9m111 driver to support both these formats by 
> toggling that bit, and yes, you have to replace *RGB* formats with *BGR* 
> analogs in both mt9m111 and pxa drivers, because that's what we actually 
> have, right? And, while at it, we should extend mt9m111 to handle the 
> swap_rgb_red_blue flag to also provide *RGB* formats.

Ok then, I'll create patches for this.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
