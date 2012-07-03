Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm10-vm0.bullet.mail.ird.yahoo.com ([77.238.189.90]:26032 "HELO
	nm10-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756866Ab2GCQuP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jul 2012 12:50:15 -0400
Message-ID: <1341334213.13038.YahooMailClassic@web29405.mail.ird.yahoo.com>
Date: Tue, 3 Jul 2012 17:50:13 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <4FF31CEB.3070707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Tue, 3/7/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

<snipped>
> > That is USB radio based si470x chipset.
> 
> Well, I don't have any si470x device here.
> 
> It should be noticed that radio applications in general
> don't open the
> alsa devices to get audio, as old devices used to have a
> cable to wire
> at the audio adapter.
> 
> I bet that this device uses snd-usb-audio module for audio.
> So, you may
> need to use aplayer/arecord in order to listen, with a
> syntax similar to:
> 
>     arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE
> | aplay -
> 
> The -r 32000 is for 32 kHz. 

Quite possibly - shouldn't /proc/bus/usb/devices (or one of the /proc...usb...devices ) gives some clues about what kind of interface/device-class it is? lsusb probably also... 

> > Jul  3 00:12:18 localhost kernel: [27988.288783]
> usb 5-2: New USB device found, idVendor=10c5,
> idProduct=819a
> > Jul  3 00:12:18 localhost kernel: [27988.288787]
> usb 5-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> > Jul  3 00:12:18 localhost kernel: [27988.288789]
> usb 5-2: Manufacturer: www.rding.cn

The vendor's web site has some sort of linux driver for something else. They might be willing to talk.

> > Jul  3 00:12:18 localhost udevd[409]: specified
> group 'plugdev' unknown
> > Jul  3 00:12:18 localhost kernel: [27988.310751]
> radio-si470x 5-2:1.2: DeviceID=0x1242 ChipID=0x060c
> > Jul  3 00:12:18 localhost kernel: [27988.310754]
> radio-si470x 5-2:1.2: This driver is known to work with
> firmware version 15,
> > Jul  3 00:12:18 localhost kernel: [27988.310756]
> radio-si470x 5-2:1.2: but the device has firmware version
> 12.
> > Jul  3 00:12:18 localhost kernel: [27988.312750]
> radio-si470x 5-2:1.2: software version 1, hardware version
> 7
> > Jul  3 00:12:18 localhost kernel: [27988.312753]
> radio-si470x 5-2:1.2: This driver is known to work with
> software version 7,
> > Jul  3 00:12:18 localhost kernel: [27988.312755]
> radio-si470x 5-2:1.2: but the device has software version
> 1.

The two-stage (I assume) firmware message is a bit confusing... can this be improved?

