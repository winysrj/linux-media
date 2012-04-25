Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:47079 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2DYQI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 12:08:57 -0400
Date: Wed, 25 Apr 2012 18:09:49 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] tinyjpeg: Dynamic luminance quantization table for
 Pixart JPEG
Message-ID: <20120425180949.2243472b@tele>
In-Reply-To: <4F98080D.5040901@redhat.com>
References: <20120412122017.0c808009@tele>
	<4F95CACD.5010403@redhat.com>
	<20120424123412.3b63810d@tele>
	<4F98080D.5040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, 25 Apr 2012 16:19:57 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> > You say that the marker cannot be in the range 0..31 (index 0..7), but
> > I have never seen a value lower than 68 (index 17).  
> 
> If you change register 0x80 in bank/page 1 to > 42 on pac7311 or larger then
> circa 100 on pac7302, you will get markers with bit 8 set. When this happens
> you will initially get markers 0xa0 - 0xa4 ... 0xbc and the stream tends to
> stabilize on 0xbc. Likewise if you remove the artificial limiting of
> the pac7302 to 15 fps from the driver you will get markers 0x44 - 0x48 ...
> 0x7c.
> 
> The images look a lot better with bit 8 set, so I plan to run some tests
> wrt what framerates can safely handle that (it uses more bandwidth) and set
> bit 8 on lower framerates.

I carefully looked at the ms-windows pac7302 traces I have. The
register 1-80 stays always in the range 0d..11, except sometimes 19 at
start time. In these traces, the images with marker 44 (dec 68) look
really better with all 08's as the quantization table.

[snip]
> Yeah short of someone disassembling and reverse-engineering the windows driver
> we will probably never figure out the exact correct tables.

Well, I got the SPC230NC.SYS of the ms-windows pac7302 driver, but it
is not easy to disassemble because it has no symbol table. But, inside,
I found this tables just before the Huffman table:

- 0006C888
	10 10 10 10 10 10 20 20 20 20 20 20 20 20 20 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
- 0006C908
	10 10 10 10 10 10 20 20 20 20 20 20 20 20 20 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
- 0006C988
	08 08 08 08 08 08 10 10 10 10 10 10 10 10 10 10
	10 10 10 10 10 10 10 10 10 10 10 10 20 20 20 20
	20 20 20 20 20 20 20 20 20 20 20 40 40 40 40 40
	40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40
- 0006CA08
	08 08 08 08 08 08 08 08 08 08 08 08 08 08 08 08
	08 08 08 08 08 08 08 08 08 08 08 08 10 10 10 10
	10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
	10 10 10 10 10 10 20 20 20 20 20 20 20 20 20 20
- 0006CA88
	10 10 10 10 10 10 20 20 20 20 20 20 20 20 20 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
- 0006CB08
	08 0b 0b 0b 0b 0b 10 10 10 10 10 10 10 10 10 10
	10 10 10 10 10 20 20 20 20 20 20 20 40 40 40 40
	40 40 40 40 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
- 0006CB88
	11 12 12 18 15 18 2f 1a 1a 2f 63 42 38 42 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
	63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
- 0006CC08
	10 0b 0c 0e 0c 0b 10 0e 0d 0e 12 11 10 13 18 28
	1a 18 16 16 18 31 23 25 1d 28 3a 33 3d 3c 39 33
	38 37 40 48 5c 4e 40 44 57 45 37 38 50 6D 51 57
	5F 62 67 68 67 3E 4D 71 78 70 64 78 5C 65 67 63

Don't they look like quantization tables? (the table 0006CB08 is quite
the same the flat table you tried!)

BTW, I don't think the exposure and gain controls use the right
registers as they are coded in the actual gspca  pac7302 subdriver.
The ms-windows driver uses the registers (3-80 / 3-03), (3-05 / 3-04),
(3-12) and (1-80) for autogain/exposure. The gspca test tarball of my
web site includes a new AGC using these registers, but it does not work
well. Maybe you could tell me what is wrong with it...

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
