Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab3BXMWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 07:22:44 -0500
Date: Sun, 24 Feb 2013 09:22:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joseph Yasi <joe.yasi@gmail.com>, linux-media@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	"Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>,
	"Sri Deevi" <Srinivasa.Deevi@conexant.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
Message-ID: <20130224092216.3627110f@redhat.com>
In-Reply-To: <1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
	<1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Feb 2013 03:16:35 +0000
Ben Hutchings <ben@decadent.org.uk> escreveu:

> On Fri, 2013-02-22 at 19:30 -0500, Joseph Yasi wrote:
> > Hi,
> > 
> > I'm not sure the appropriate list to email for this, but the
> > v4l-cx23885-enc.fw file in the linux-firmware.git tree is incorrect.
> > It is the wrong size and just a duplicate of the
> > v4l-cx23885-avcore-01.fw. The correct file can be extracted from the
> > HVR1800 drivers here: http://steventoth.net/linux/hvr1800/.
> 
> This was previously requested
> <http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/57816> but unfortunately it's not clear that it would be legal to redistribute firmware extracted from that driver (or the driver itself).

(c/c Conexant developers, Andy and Hans)

Let's see if we can once for all fix this issue. So, let me do a summary
of the firmware situation here.

Basically, the firmwares at linux-kernel are the ones that Conexant
gave us license to re-distribute.

According with Conexant, there's one firmware that it is the same
for two different chips. On their words:

	"The Merlin firmware are the same for 418 and 416/7."

The envolved Conexant firmwares are the ones used by cx23885-417.c,
cx231xx-417.c and cx25850.c:

$ git grep v4l-cx23885-enc.fw drivers/media
drivers/media/pci/cx23885/cx23885-417.c:#define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
drivers/media/usb/cx231xx/cx231xx-417.c:#define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"

$ grep "define.*FIRM" drivers/media/i2c/cx25840/cx25840-firmware.c
#define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
#define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
#define CX25840_FIRMWARE "v4l-cx25840.fw"

Those are the Conexant firmware files that we currently have at 
linux-firmware:

-rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx231xx-avcore-01.fw
-rw-rw-r-- 1 v4l v4l 141200 Ago 10  2012 v4l-cx23418-apu.fw
-rw-rw-r-- 1 v4l v4l 158332 Ago 10  2012 v4l-cx23418-cpu.fw
-rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23418-dig.fw
-rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-avcore-01.fw
-rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-enc.fw
-rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx25840.fw

And those are their corresponding md5sum:

7d3bb956dc9df0eafded2b56ba57cc42  v4l-cx231xx-avcore-01.fw
588f081b562f5c653a3db1ad8f65939a  v4l-cx23418-apu.fw
b6c7ed64bc44b1a6e0840adaeac39d79  v4l-cx23418-cpu.fw
95bc688d3e7599fd5800161e9971cc55  v4l-cx23418-dig.fw
a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-avcore-01.fw
a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-enc.fw
dadb79e9904fc8af96e8111d9cb59320  v4l-cx25840.fw

So, yes, v4l-cx23885-avcore-01.fw and v4l-cx23885-enc.fw files are
identical on the official released firmwares, and both have 16K.

Now, Hauppauge is using different firmwares for v4l-cx23885-enc.fw
and v4l-cx23885-avcore-01.fw. After extracting the firmware from their
zip file, we have:

-r--r--r--   1 v4l v4l  376836 Fev 24 08:47 v4l-cx23885-enc.fw
-r--r--r--   1 v4l v4l   16382 Fev 24 08:47 v4l-cx23885-avcore-01.fw

With different checksums:

b3704908fd058485f3ef136941b2e513  v4l-cx23885-avcore-01.fw
1cb3c48a6684126f5e503a434f2d636b  v4l-cx23885-enc.fw

So:
1) With regards to the encoder firmware for cx23885-417, both Conexant and
   Hauppauge, provided a firmware with 16KB. Although they're different.
   Not sure if they are just different versions, or if Hauppauge customized
   it on their driver.

2) With regards to the decoder firmware for cx25840 (actually, the
   equivalent IP block inside cx23885), while Conexant provided us with
   a 16KB firmware, and both decoder and encoder using the very same
   firmware, Hauppauge's driver is shipped with a 372KB firmware.

What's more intriguing is that the firmware size is so different
between those two versions. Also, having the encoder and the 
decoder using the same firmware looks weird.

In any case, it is clear, from the reports, that the cx25840 driver
doesn't work with the 16KB v4l-cx23885-enc.fw firmware provided by
Conexant.

It should also be noticed that the other firmwares used by cx25840 driver
also has only 16 KB.

So, I can see two possible situations here:

1) Conexant shipped us a wrong v4l-cx23885-enc.fw;

2) Hauppauge uses a completely different version for it, perhaps
developed by them, and the driver was written to take that special
version into account. So, the driver is not currently prepared to
use the Conexant firmware for cx23885.

As I didn't work on the development of this driver, nor I worked with
HVR1800 development, I can't tell what of the above is the case.

There are two possible solutions to solve the issue it:

1) Conexant could help us to make the cx23885 driver to work with
   their firmware, or release us the right firmware, (if this was simply a
   mistake when they sent us the firmwares). The driver could be smart
   enough to work with either firmware (it should be easy to distinguish
   between them, due to the huge difference on its size);

2) Hauppauge should re-license their v4l-cx23885-enc.fw firmware to
   allow it to be shipped together with linux-firmware;

> For now, I think we should delete the current version.

That seems to be the only approach left, if neither Conexant or Hauppauge
could help solving this dilema.

Regards,
Mauro
