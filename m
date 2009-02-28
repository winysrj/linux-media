Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:56590 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZB1Klo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 05:41:44 -0500
Date: Sat, 28 Feb 2009 11:31:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Anders Blomdell <anders.blomdell@control.lth.se>,
	"Thomas Champagne" <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Topro 6800 driver
Message-ID: <20090228113135.4bbbc294@free.fr>
In-Reply-To: <49A8661A.4090907@control.lth.se>
References: <49A8661A.4090907@control.lth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Feb 2009 23:15:54 +0100
Anders Blomdell <anders.blomdell@control.lth.se> wrote:

> Hi,
> 
> I'm trying to write a driver for a webcam based on Topro TP6801/CX0342
> (06a2:0003). My first attempt (needs gspca) can be found on:
> 
> http://www.control.lth.se/user/andersb/tp6800.c
> 
> Unfortunately the JPEG images (one example dump is in
> http://www.control.lth.se/user/andersb/topro_img_dump.txt), seems to
> be bogus, they start with (data is very similar to windows data):
> 
> 00000000: 0xff,0xd8,0xff,0xfe,0x28,0x3c,0x01,0xe8,...
> ...
> 0000c340: ...,0xf4,0xc0,0xff,0xd9
> 
> Anybody who has a good idea of how to find a DQT/Huffman table that
> works with this image data?

Hi Anders,

Thomas Champagne (See To:) was also writing a driver for this webcam.
Maybe you may merge your codes...

About the JPEG images, the Huffman table is always the same and the
quantization tables depend on the compression quality.

>From the USB trace I had from Thomas, I saw that:

- when a packet starts with '55 ff d8', it is the first part of the
  image. This one should start at the offset 8 of the packet.

- when a packet starts with 'cc', it is the next part of the image.

In the function pkt_scan, when finding the image start, you must add
the JPEG header: 'ff d8', DQT, huffman table, SOF0 and SOS.

As we don't know the quality used by the webcam, in my test repository,
I added a control for that: the JPEG header is created at streamon
time, and the quantization tables may be modified by the control on the
fly (have a look at stk014.c for an example).

This solution is not the right one: the JPEG quality must be set by the
VIDIOC_S_JPEGCOMP ioctl instead of VIDIOC_S_CTRL. I think I will update
the concerned subdrivers next week.

BTW, don't use the video4linux-list@redhat.com mailing-list anymore: all
the video discussions are now done in linux-media@vger.kernel.org.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
