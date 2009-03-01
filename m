Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:56717 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZCAHhG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Mar 2009 02:37:06 -0500
Date: Sun, 1 Mar 2009 08:26:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Thomas Champagne <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Thomas Kaiser <v4l@kaiser-linux.li>
Subject: Re: Topro 6800 driver
Message-ID: <20090301082635.0905afea@free.fr>
In-Reply-To: <49A95428.1090306@control.lth.se>
References: <49A8661A.4090907@control.lth.se>
	<20090228113135.4bbbc294@free.fr>
	<49A95428.1090306@control.lth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Feb 2009 16:11:36 +0100
Anders Blomdell <anders.blomdell@control.lth.se> wrote:

> Jean-Francois Moine wrote:
> > Thomas Champagne (See To:) was also writing a driver for this
> > webcam. Maybe you may merge your codes...
> Thomas, if you have DQT/Huffman tables for this camera, please drop
> me a note.
> 
> > About the JPEG images, the Huffman table is always the same 
> Does this mean that it's the same for all JPEG images or only for one 
> camera?
> 
> If it's the same for all images, it should mean that I have a way to 
> determine how much I have to chop off after the 0xfffe tag (no
> illegal huffman codes -> possibly chop at the correct position).
> 
> Comments anyone?

I already explained it:

- when a packet starts with '55 ff d8', it is the first part of the
  image. This one should start at the offset 8 of the packet.
                                      ~~~~~~~~

>  > and the
> > quantization tables depend on the compression quality.
> > 
> > From the USB trace I had from Thomas, I saw that:
> > 
> > - when a packet starts with '55 ff d8', it is the first part of the
> >   image. This one should start at the offset 8 of the packet.
> > 
> > - when a packet starts with 'cc', it is the next part of the image.
> This is even in the docs, and is implemented in the driver.
> 
> > In the function pkt_scan, when finding the image start, you must add
> > the JPEG header: 'ff d8', DQT, huffman table, SOF0 and SOS.
> OK, will see if I can find the DQT (and possibly the Huffman table)
> in the windows driver (as suggested by Thomas Kaiser).

See below.

> > As we don't know the quality used by the webcam, in my test
> > repository, I added a control for that: the JPEG header is created
> > at streamon time, and the quantization tables may be modified by
> > the control on the fly (have a look at stk014.c for an example).
> > 
> > This solution is not the right one: the JPEG quality must be set by
> > the VIDIOC_S_JPEGCOMP ioctl instead of VIDIOC_S_CTRL. I think I
> > will update the concerned subdrivers next week.
> I'll look into that monday.

In gspca, the file "jpeg.h" contains all the material to build a
complete JPEG header. With the new mechanism of my test repository, you
must:

- at streamon time (function sd_start):
	- allocate a buffer for the JPEG header,
	- set the resolution and number of samplesY (0x22 or 0x21) by
		the function jpeg_define,
	- set the quantization tables by the function jpeg_set_qual,
	  the quality being in percent (15..95).

- when getting the start of a new image in sd_pkt_scan, add the JPEG
  header as the first packet.

- at streamoff time (function sd_stop0), free the JPEG header.

- on VIDIOC_S_JPEGCOMP (function sd_set_jcomp which you must create),
  redefine the quantization tables by jpeg_set_qual.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
