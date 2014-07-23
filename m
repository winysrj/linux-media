Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44851 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWRNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 13:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <53CA9A77.6060409@hauke-m.de>
References: <53CA9A77.6060409@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 23 Jul 2014 10:13:28 -0700
Message-ID: <CAB=NE6WvY1ZnwogYR0YLuiMUOeRvqeEjhhnLHUpeJjteSTwfGA@mail.gmail.com>
Subject: Re: Removal of regulator framework
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 19, 2014 at 9:19 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Maintaining the regulator drivers in backports costs some time and I do
> not need them. Is anybody using the regulator drivers from backports? I
> would like to remove them.

That came simply from collateral of backporting media drivers,
eventually I started running into device drivers that used the
regulator framework. Since we have tons of media drivers perhaps the
more sensible thing to do is to white list a set of media divers that
people actually care and then we just nuke both regulator and media
drivers that no one cares for. For that though I'd like to ask media
folks.

Here's a list of media drivers I know SUSE does support, in case that
helps. Right now backports carries all of drivers/media though.

                drivers/media/common/btcx-risc                  # some
code shared by bttv and cx88xx drivers
                drivers/media/common/cx2341x
                drivers/media/common/saa7146/saa7146
                drivers/media/common/saa7146/saa7146_vv
                drivers/media/common/tveeprom
                drivers/media/i2c/adv7170                       #
Analog Devices ADV7170 video encoder driver
                drivers/media/i2c/adv7175                       #
Analog Devices ADV7175 video encoder driver
                drivers/media/i2c/bt819                         #
Brooktree-819 video decoder driver
                drivers/media/i2c/bt856                         #
Brooktree-856A video encoder driver
                drivers/media/i2c/cs5345
                drivers/media/i2c/cs53l32a                      #
cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver
                drivers/media/i2c/cx25840/cx25840               #
Conexant CX25840 audio/video decoder driver
                drivers/media/i2c/ir-kbd-i2c                    #
input driver for i2c IR remote controls
                drivers/media/i2c/ks0127
                drivers/media/i2c/m52790
                drivers/media/i2c/msp3400                       #
device driver for msp34xx TV sound processor
                drivers/media/i2c/saa6588                       #
Philips SAA6588 RDS decoder
                drivers/media/i2c/saa7110                       #
Philips SAA7110 video decoder driver
                drivers/media/i2c/saa7115                       #
Philips SAA7111/13/14/15/18 video decoder driver
                drivers/media/i2c/saa7127                       #
Philips SAA7127/SAA7129 video encoder driver
                drivers/media/i2c/saa717x
                drivers/media/i2c/saa7185                       #
Philips SAA7185 video encoder driver
                drivers/media/i2c/tda7432                       # bttv
driver for the tda7432 audio processor chip
                drivers/media/i2c/tda9840
                drivers/media/i2c/tea6415c
                drivers/media/i2c/tea6420
                drivers/media/i2c/tvaudio                       #
device driver for various i2c TV sound decoder / audiomux chips
                drivers/media/i2c/tvp5150                       #
Texas Instruments TVP5150A(M) video decoder driver
                drivers/media/i2c/upd64031a
                drivers/media/i2c/upd64083
                drivers/media/i2c/vp27smpx
                drivers/media/i2c/vpx3220                       #
vpx3220a/vpx3216b/vpx3214c video encoder driver
                drivers/media/i2c/wm8739
                drivers/media/i2c/wm8775
                drivers/media/pci/bt8xx/bttv
                drivers/media/pci/cx88/cx88-alsa
                drivers/media/pci/cx88/cx88-blackbird
                drivers/media/pci/cx88/cx8800
                drivers/media/pci/cx88/cx8802
                drivers/media/pci/cx88/cx88xx
                drivers/media/pci/ivtv/ivtv
                drivers/media/pci/ivtv/ivtvfb
                drivers/media/pci/meye/meye
                drivers/media/pci/saa7134/saa6752hs             #
device driver for saa6752hs MPEG2 encoder
                drivers/media/pci/saa7134/saa7134
                drivers/media/pci/saa7134/saa7134-alsa
                drivers/media/pci/saa7134/saa7134-empress
                drivers/media/pci/saa7146/hexium_gemini
                drivers/media/pci/saa7146/hexium_orion
                drivers/media/pci/saa7146/mxb                   #
video4linux-2 driver for the Siemens-Nixdorf 'Multimedia eXtension
board'
                drivers/media/pci/zoran/videocodec              #
Intermediate API module for video codecs
                drivers/media/pci/zoran/zr36016
                drivers/media/pci/zoran/zr36050
                drivers/media/pci/zoran/zr36060
                drivers/media/pci/zoran/zr36067
                drivers/media/platform/vivi
                drivers/media/radio/dsbr100
                drivers/media/radio/radio-maxiradio             #
Radio driver for the Guillemot Maxi Radio FM2000 radio.
                drivers/media/radio/si470x/radio-usb-si470x
                drivers/media/radio/tea575x
                drivers/media/rc/ati_remote
                drivers/media/rc/rc_core
                drivers/media/rc/winbond-cir
                drivers/media/tuners/mt2060
                drivers/media/tuners/mt20xx
                drivers/media/tuners/mt2131
                drivers/media/tuners/mt2266
                drivers/media/tuners/mxl5005s
                drivers/media/tuners/mxl5007t
                drivers/media/tuners/qt1010
                drivers/media/tuners/tda18271
                drivers/media/tuners/tda827x
                drivers/media/tuners/tda8290
                drivers/media/tuners/tda9887
                drivers/media/tuners/tea5761
                drivers/media/tuners/tea5767
                drivers/media/tuners/tuner-simple
                drivers/media/tuners/tuner-types
                drivers/media/tuners/tuner-xc2028
                drivers/media/tuners/xc5000
                drivers/media/usb/em28xx/em28xx                 #
driver for Empia EM2800/EM2820/2840 USB video capture device
                drivers/media/usb/em28xx/em28xx-alsa
                drivers/media/usb/usbvision/usbvision
                drivers/media/usb/uvc/uvcvideo
                drivers/media/v4l2-core/tuner                   #
device driver for various TV and TV+FM radio tuners
                drivers/media/v4l2-core/v4l2-common
                drivers/media/v4l2-core/videobuf-core
                drivers/media/v4l2-core/videobuf-dma-sg
                drivers/media/v4l2-core/videobuf-vmalloc
                drivers/media/v4l2-core/videobuf2_core
                drivers/media/v4l2-core/videobuf2_memops
                drivers/media/v4l2-core/videobuf2_vmalloc
                drivers/media/v4l2-core/videodev                #
Device registrar for Video4Linux drivers

 Luis
