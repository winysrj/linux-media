Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1906 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZGYOPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 10:15:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv10 8/8] FMTx: si4713: Add document file
Date: Sat, 25 Jul 2009 16:15:06 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <20090725131705.GC10561@esdhcp037198.research.nokia.com> <20090725134858.GF10561@esdhcp037198.research.nokia.com>
In-Reply-To: <20090725134858.GF10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907251615.06269.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 15:48:58 Eduardo Valentin wrote:
> On Sat, Jul 25, 2009 at 03:17:05PM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> > On Sat, Jul 25, 2009 at 03:25:25PM +0200, ext Hans Verkuil wrote:
> > > On Friday 24 July 2009 18:37:28 Eduardo Valentin wrote:
> > > > This patch adds a document file for si4713 device driver.
> > > > It describes the driver interfaces and organization.
> > > > 
> > > > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > > ---
> > > >  linux/Documentation/video4linux/si4713.txt |  175 ++++++++++++++++++++++++++++
> > > >  1 files changed, 175 insertions(+), 0 deletions(-)
> > > >  create mode 100644 linux/Documentation/video4linux/si4713.txt
> > > > 
> > > > diff --git a/linux/Documentation/video4linux/si4713.txt b/linux/Documentation/video4linux/si4713.txt
> > > > new file mode 100644
> > > > index 0000000..3843af5
> > > > --- /dev/null
> > > > +++ b/linux/Documentation/video4linux/si4713.txt
> > > > @@ -0,0 +1,175 @@
> > > > +Driver for I2C radios for the Silicon Labs Si4713 FM Radio Transmitters
> > > > +
> > > > +Copyright (c) 2009 Nokia Corporation
> > > > +Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > > +
> > > > +
> > > > +Information about the Device
> > > > +============================
> > > > +This chip is a Silicon Labs product. It is a I2C device, currently on 0Ã—63 address.
> > > > +Basically, it has transmission and signal noise level measurement features.
> > > > +
> > > > +The Si4713 integrates transmit functions for FM broadcast stereo transmission.
> > > > +The chip also allows integrated receive power scanning to identify low signal
> > > > +power FM channels.
> > > > +
> > > > +The chip is programmed using commands and responses. There are also several
> > > > +properties which can change the behavior of this chip.
> > > > +
> > > > +Users must comply with local regulations on radio frequency (RF) transmission.
> > > > +
> > > > +Device driver description
> > > > +=========================
> > > > +There are two modules to handle this device. One is a I2C device driver
> > > > +and the other is a platform driver.
> > > > +
> > > > +The I2C device driver exports a v4l2-subdev interface to the kernel.
> > > > +All properties can also be accessed by v4l2 extended controls interface, by
> > > > +using the v4l2-subdev calls (g_ext_ctrls, s_ext_ctrls).
> > > > +
> > > > +The platform device driver exports a v4l2 radio device interface to user land.
> > > > +So, it uses the I2C device driver as a sub device in order to send the user
> > > > +commands to the actual device. Basically it is a wrapper to the I2C device driver.
> > > > +
> > > > +Applications can use v4l2 radio API to specify frequency of operation, mute state,
> > > > +etc. But mostly of its properties will be present in the extended controls.
> > > > +
> > > > +When the v4l2 mute property is set to 1 (true), the driver will turn the chip off.
> > > > +
> > > > +Properties description
> > > > +======================
> > > > +
> > > > +The properties can be accessed using v4l2 extended controls.
> > > > +Here is an output from v4l2-ctl util:
> > > > +
> > > > +# v4l2-ctl -d /dev/radio0 --all -l
> > > > +Driver Info:
> > > > +        Driver name   : radio-si4713
> > > > +        Card type     : Silicon Labs Si4713 Modulator
> > > > +        Bus info      : 
> > > > +        Driver version: 0
> > > > +        Capabilities  : 0x00080800
> > > > +                RDS Output
> > > > +                Modulator
> > > > +Audio output: 0 (FM Modulator Audio Out)
> > > > +Frequency: 1545600 (96.600000 MHz)
> > > > +Video Standard = 0x00000000
> > > > +Modulator:
> > > > +        Name                 : FM Modulator
> > > > +        Capabilities         : 62.5 Hz stereo rds 
> > > > +        Frequency range      : 76.0 MHz - 108.0 MHz
> > > > +        Available subchannels: mono rds 
> > > > +
> > > > +User Controls
> > > > +
> > > > +                           mute (bool) : default=1 value=0
> > > > +
> > > > +FM Radio Modulator Controls
> > > > +
> > > > +                 rds_program_id (int)  : min=0 max=65535 step=1 default=0 value=0
> > > > +               rds_program_type (int)  : min=0 max=31 step=1 default=0 value=0
> > > > +                    rds_ps_name (str)  : value='Si4713  ' len=1024
> > > > +' len=1024       rds_radio_text (str)  : value='Si4713  
> > > 
> > > This doesn't look right. I think this output is from an old v4l2-ctl version.
> > > I'd like to see this output anyway using the latest v4l2-ctl version as I
> > > haven't been able to test it myself.
> > 
> > Yeah. My bad, forgot to update here. This is the output from the older version.
> 
> 
> I've just checked that now v4l2-ctl does not report rds subchannel for txsubchannel.
> Just to confirm this is something which is missing right?

Yes, that was missing. I've just added it to my tree. Thanks for the report.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
