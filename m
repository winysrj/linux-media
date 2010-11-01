Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33147 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab0KAWIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Nov 2010 18:08:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: New media framework user space usage
Date: Mon, 1 Nov 2010 23:00:07 +0100
Cc: "Eino-Ville Talvala" <talvala@stanford.edu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com> <4CCDF6B7.1040708@stanford.edu> <AANLkTinowGqbs8p3iHQt25xb=5FxRoSX5KwXtkC_FBYG@mail.gmail.com>
In-Reply-To: <AANLkTinowGqbs8p3iHQt25xb=5FxRoSX5KwXtkC_FBYG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011012300.07592.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

On Monday 01 November 2010 12:10:55 Bastian Hecht wrote:
> > To clarify this: The number of pixels in an image sensor is typically
> > simply the number of independent photosites - so the 5-MP MT9P031 sensor
> > will give you a raw image with 5 million 12-bit values in it. (not 5x3
> > million, or 5x4 million, just 5 million)
> > 
> > Each photosite is covered by a single color filter, so each 12-bit raw
> > value represents a single color channel, and it is the only color
> > channel measured at that pixel.
> > 
> > Which color channel is recorded for each pixel depends on the arrangement
> > of the color filters. The most common arrangement is the Bayer pattern,
> > which you wrote:
> > G R G R G R G R
> > B G B G B G B G
> > G R G R G R G R
> > B G B G B G B G
> > So the top-left pixel in the sensor is covered by a green filter, the one
> > to the right of it is covered by a red filter, the one below it is a
> > blue filter. The pattern tiles across the whole sensor in this fashion.
> > (Note that which color is the top-leftmost does vary between sensors,
> > but the basic repeating tile is the same - two greens for each red and
> > blue, diagonally arranged)
> > 
> > To convert this 5-million-pixel raw image into a 5-million-pixel RGB
> > image, you have to demosaic the image - come up with the missing two
> > color values for each pixel. It suffices to say that there are lots of
> > ways to do this, of varying levels of complexity and quality.
> > 
> > The OMAP3 ISP preview pipe runs such a method in hardware, to give you a
> > 3-channel YUV 4:2:2 output from a raw sensor image, with 5 million Y
> > values, 2.5 million U, and 2.5 million V values.  There is a 3x3 color
> > conversion matrix inside the preview pipeline that converts from the
> > sensor's RGB space to a standard RGB space (at least if you set up the
> > matrix right), and then a second matrix to go from that RGB space to
> > YUV. The number of bits per channel also gets reduced from 10 to 8 using
> > a gamma lookup table.
> > 
> > So if you ask the ISP for raw data, you get 5 million 16-bit values (of
> > which only the lower 10 or 12 bits are valid) total. If you ask it for
> > YUV data, you'll get 10 million 8-bit values.
> > 
> > Hope that clarifies, and doesn't further confuse things.
> 
> OK, sure! Somehow I got stuck with the idea that you can get 1 pixel
> only from each quadruple, but as you said you can check the
> neighbourhood from each raw pixel with a kernel-matrix.
> Another step to a clearer understanding of the materia, thank you.
> 
> So, I followed the stuck ioctl in the code until I saw that the ISP
> simply waits for an image to complete. As the signals seem to come out
> right of the chip, I will double check my mux settings and investigate
> the ISP_IRQ0STATUS register to see if interrupts are generated at all.

Try to capture raw data first (at the CCDC output). If the ISP driver waits 
endlessly for the frame to arrive it probably means that the sensor outputs 
less columns/lines than the ISP expect.

> The reference manual states on page 1503 that this register is located
> at 0x480B C010 in physical memory. Instead of polluting the kernel
> code I tried to use inw() to read the register from userspace:
> unsigned int a;
> a = inw(0xC010480B); // and I tried a = inw(0x480BC010);
> 
> Both tries gave me segfaults. Any idea why that does not work?

You can't read physical memory like that. Userspace applications can only 
access their virtual memory space. You could mmap() /dev/mem but it's not 
worth the effort.

> Well now I put the debug message in the kernel code.

That's a better solution.

-- 
Regards,

Laurent Pinchart
