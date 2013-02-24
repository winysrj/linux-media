Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46142 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab3BXViX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 16:38:23 -0500
Message-ID: <1361741900.1943.88.camel@palomino.walls.org>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Joseph Yasi <joe.yasi@gmail.com>, linux-media@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 24 Feb 2013 16:38:20 -0500
In-Reply-To: <20130224092216.3627110f@redhat.com>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
	 <1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
	 <20130224092216.3627110f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Instead of answering points in the email chain, I'm just going to
provide the best information I have.

I. Definitions:
- Thresher: broadcast video decoder
- Merlin:   broadcast audio system detection microcontroller and decoder
- Mako:     Thresher + Merlin

- CX2583[67]:   stand-alone Thresher
- CX2584[0123]: stand-alone Mako

- CX23415: PCI/Microcontroller host MPEG Encoder + MPEG Decoder, JHVM
- CX23416: PCI/Microcontroller host MPEG Encoder, JHVM
- CX23417: Microcontroller host MPEG Encoder, JHVM

- CX23418: PCI/Microcontroller host MPEG Encoder + Mako, ARM

- CX2388[578]: PCIe host Video capture + Mako
- CX2310[012]: USB host Video capture + Mako

II. Notes about the Mako core:
1. The Merlin in every Mako uses a 16 kB firmware image.  (Technically
it is 16382 bytes instead of 16384 bytes, IIRC.)

2. The Merlin implementations appear to vary from one another, but there
are at least two distinct groupings based on hardware register
implementation:
   a. Older: CX2584[0123] (v4l-cx25840.fw)
             CX23418      (v4l-cx23418-dig.fw)

   b. Newer: CX2388[578]  (v4l-cx23885-avcore-01.fw)
             CX231[012]   (v4l-cx231xx-avcore-01.fw)

The firmwares between the two groups are not interchangeable.  For
example, IIRC the older Merlin audio firmwares might manipulate video
U,V saturation registers on a CX23885.

3. There seem to be a large number of versions of Merlin firmware files,
upon examining Windows driver CD I have.  It is very possible that two
different Merlin firmware files, with different MD5 sums, are both
intended to work on the same chip, e.g. CX23885.

4. There appears to be no way to tell what chip for which a Merlin
firmware file is intended, without disassembling the Merlin firmware
file and painfully examining the assembly code.  A violation of most, if
not all, of the license agreements.

5. With the exception of the CX23418 chip and cx18 driver, all
Mako/Merlin stuff in Linux is handled by the cx25840 driver.  The cx18
driver has its own fork of cx25840-*.c in cx18-av-*.c


III. Notes on the MPEG Encoders:
1. The MPEG encoder firmware images are never 16 kB; they are around 10
times larger than that, or larger.

2. The CX2341[56] chips both use the same MPEG encoder firmware image.
(v4l-cx2341x-enc.fw)

3. It is very plausible that the CX23417 can use the same MPEG Encoder
firmware image as a CX23416, I just don't know for sure.

4. The CX23418 MPEG encoder firmware images (v4l-cx23418-cpu.fw, 
v4l-cx23418-apu.fw) and distinct from the firmware for the CX2341[567]
chips, as the underlying embedded processor has a different machine
architecture and instruction set.


IV. Known good firmware images

1. CX23418 MPEG encoder and CX23418 Merlin/Mako:
http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz
(Save as... adding an extra .gz at the end, since the webserver double
gzips the file.)
e8188c7542a82a8d7cdc2720ddfb3a3e CX23418 Firmware Video Firmware Release
Notes.pdf
6686a1673585585f5017c13ada343f98 LICENSE
588f081b562f5c653a3db1ad8f65939a v4l-cx23418-apu.fw
b6c7ed64bc44b1a6e0840adaeac39d79 v4l-cx23418-cpu.fw
b3704908fd058485f3ef136941b2e513 v4l-cx23418-dig.fw

Last I checked months ago, the CX23418 APU, CPU, and Merlin firmware
images all matched linuxtv.org's copies.

This CX23418 Merlin image does not match the CX23418 Merlin image that
Hauppauge is shipping with the HVR-1600 driver CD:
c529278bbceb51d68d3fc1993657c901  hcw18mlC.rom

So I now have doubts as to whether the CX23418 Merlin firmware file
being used under Linux is correct. :(


2. CX2341[56] MPEG decoder/encoder, CX2584[0123] Merlin, and PVRUSB
microcontroller
http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20080701.tar.gz
http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20070217.tar.gz
(Save as... adding an extra .gz at the end, since the webserver double
gzips the file.)

(The licenses in these files appear to be OK if the firmware is used
with Hauppauge products.  For any other use, consult your legal
council.)

The above archives are identical, except for the v4l-cx25840.fw Merlin
firmware file.

The 2007 archive has the "original" CX2584[0123] Merlin firmware,

The 2008 archive has the CX23418 Merlin firmware (which might be a bad
thing). I think the CX23418 Merlin firmware actually causes the
user-reported ivtv "tinny-audio" problem, when used with the
CX2584[0123] chips.

Please note: The ivtv driver was coded to a very specific version of the
v4l-cx2341x-enc.fw image, due the ivtv driver's use of firmware specific
memory locations to work around some chip and firmware bugs.  No other
version of this firmware image is recommended for the ivtv driver.


3. CX2388[578] MPEG encoder (aka. CX23417) firmware
Aside from Conextant, I don't know where to get a redistributable copy,
specifically intended for the CX23417.
The v4l-cx2341x-enc.fw file for the CX23416 might work, after being
renamed:
http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20080701.tar.gz
(Save as... adding an extra .gz at the end, since the webserver double
gzips the file.)

4. CX2388[578] Merlin firmware
Aside from Conexant, I don't know where to get a copy for
redistribution.

5. CX2310[012] Merlin firmware
Aside from Conexant, I don't know where to get a copy for
redistribution.


Regards,
Andy

On Sun, 2013-02-24 at 09:22 -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 24 Feb 2013 03:16:35 +0000
> Ben Hutchings <ben@decadent.org.uk> escreveu:
> 
> > On Fri, 2013-02-22 at 19:30 -0500, Joseph Yasi wrote:
> > > Hi,
> > > 
> > > I'm not sure the appropriate list to email for this, but the
> > > v4l-cx23885-enc.fw file in the linux-firmware.git tree is incorrect.
> > > It is the wrong size and just a duplicate of the
> > > v4l-cx23885-avcore-01.fw. The correct file can be extracted from the
> > > HVR1800 drivers here: http://steventoth.net/linux/hvr1800/.
> > 
> > This was previously requested
> > <http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/57816> but unfortunately it's not clear that it would be legal to redistribute firmware extracted from that driver (or the driver itself).
> 
> (c/c Conexant developers, Andy and Hans)
> 
> Let's see if we can once for all fix this issue. So, let me do a summary
> of the firmware situation here.
> 
> Basically, the firmwares at linux-kernel are the ones that Conexant
> gave us license to re-distribute.
> 
> According with Conexant, there's one firmware that it is the same
> for two different chips. On their words:
> 
> 	"The Merlin firmware are the same for 418 and 416/7."
> 
> The envolved Conexant firmwares are the ones used by cx23885-417.c,
> cx231xx-417.c and cx25850.c:
> 
> $ git grep v4l-cx23885-enc.fw drivers/media
> drivers/media/pci/cx23885/cx23885-417.c:#define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
> drivers/media/usb/cx231xx/cx231xx-417.c:#define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
> 
> $ grep "define.*FIRM" drivers/media/i2c/cx25840/cx25840-firmware.c
> #define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
> #define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
> #define CX25840_FIRMWARE "v4l-cx25840.fw"
> 
> Those are the Conexant firmware files that we currently have at 
> linux-firmware:
> 
> -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx231xx-avcore-01.fw
> -rw-rw-r-- 1 v4l v4l 141200 Ago 10  2012 v4l-cx23418-apu.fw
> -rw-rw-r-- 1 v4l v4l 158332 Ago 10  2012 v4l-cx23418-cpu.fw
> -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23418-dig.fw
> -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-avcore-01.fw
> -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-enc.fw
> -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx25840.fw
> 
> And those are their corresponding md5sum:
> 
> 7d3bb956dc9df0eafded2b56ba57cc42  v4l-cx231xx-avcore-01.fw
> 588f081b562f5c653a3db1ad8f65939a  v4l-cx23418-apu.fw
> b6c7ed64bc44b1a6e0840adaeac39d79  v4l-cx23418-cpu.fw
> 95bc688d3e7599fd5800161e9971cc55  v4l-cx23418-dig.fw
> a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-avcore-01.fw
> a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-enc.fw
> dadb79e9904fc8af96e8111d9cb59320  v4l-cx25840.fw
> 
> So, yes, v4l-cx23885-avcore-01.fw and v4l-cx23885-enc.fw files are
> identical on the official released firmwares, and both have 16K.
> 
> Now, Hauppauge is using different firmwares for v4l-cx23885-enc.fw
> and v4l-cx23885-avcore-01.fw. After extracting the firmware from their
> zip file, we have:
> 
> -r--r--r--   1 v4l v4l  376836 Fev 24 08:47 v4l-cx23885-enc.fw
> -r--r--r--   1 v4l v4l   16382 Fev 24 08:47 v4l-cx23885-avcore-01.fw
> 
> With different checksums:
> 
> b3704908fd058485f3ef136941b2e513  v4l-cx23885-avcore-01.fw
> 1cb3c48a6684126f5e503a434f2d636b  v4l-cx23885-enc.fw
> 
> So:
> 1) With regards to the encoder firmware for cx23885-417, both Conexant and
>    Hauppauge, provided a firmware with 16KB. Although they're different.
>    Not sure if they are just different versions, or if Hauppauge customized
>    it on their driver.
> 
> 2) With regards to the decoder firmware for cx25840 (actually, the
>    equivalent IP block inside cx23885), while Conexant provided us with
>    a 16KB firmware, and both decoder and encoder using the very same
>    firmware, Hauppauge's driver is shipped with a 372KB firmware.
> 
> What's more intriguing is that the firmware size is so different
> between those two versions. Also, having the encoder and the 
> decoder using the same firmware looks weird.
> 
> In any case, it is clear, from the reports, that the cx25840 driver
> doesn't work with the 16KB v4l-cx23885-enc.fw firmware provided by
> Conexant.
> 
> It should also be noticed that the other firmwares used by cx25840 driver
> also has only 16 KB.
> 
> So, I can see two possible situations here:
> 
> 1) Conexant shipped us a wrong v4l-cx23885-enc.fw;
> 
> 2) Hauppauge uses a completely different version for it, perhaps
> developed by them, and the driver was written to take that special
> version into account. So, the driver is not currently prepared to
> use the Conexant firmware for cx23885.
> 
> As I didn't work on the development of this driver, nor I worked with
> HVR1800 development, I can't tell what of the above is the case.
> 
> There are two possible solutions to solve the issue it:
> 
> 1) Conexant could help us to make the cx23885 driver to work with
>    their firmware, or release us the right firmware, (if this was simply a
>    mistake when they sent us the firmwares). The driver could be smart
>    enough to work with either firmware (it should be easy to distinguish
>    between them, due to the huge difference on its size);
> 
> 2) Hauppauge should re-license their v4l-cx23885-enc.fw firmware to
>    allow it to be shipped together with linux-firmware;
> 
> > For now, I think we should delete the current version.
> 
> That seems to be the only approach left, if neither Conexant or Hauppauge
> could help solving this dilema.
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


