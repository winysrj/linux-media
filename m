Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1H3WFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 18:05:03 -0400
Received: by iabu26 with SMTP id u26so64803iab.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 15:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108302331200.20921@axis700.grange>
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange>
	<201108302139.23337.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1108302208310.20675@axis700.grange>
	<CAOcJUbwfxdmyC2gLcV3t6AFz_u3h0-KCp_yokpQeYDMU+38W-w@mail.gmail.com>
	<Pine.LNX.4.64.1108302331200.20921@axis700.grange>
Date: Tue, 30 Aug 2011 18:05:02 -0400
Message-ID: <CAOcJUbx6G9GEtPv9SOg9P_9h7eD9AxoHTS0h3aWpMdn7WLui7A@mail.gmail.com>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
From: Michael Krufky <mkrufky@linuxtv.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 5:47 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 30 Aug 2011, Michael Krufky wrote:
>
>> On Tue, Aug 30, 2011 at 4:12 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > On Tue, 30 Aug 2011, Hans Verkuil wrote:
>> >
>> >> On Tuesday, August 30, 2011 19:22:00 Guennadi Liakhovetski wrote:
>> >> > None of the media drivers are compulsory, let users select which drivers
>> >> > they want to build, instead of having to unselect them one by one.
>> >>
>> >> I disagree with this: while this is fine for SoCs, for a generic kernel I
>> >> think it is better to build it all. Even expert users can have a hard time
>> >> figuring out what chip is in a particular device.
>> >
>> > Then could someone, please, explain to me, why I don't find this
>> > "convenience" in any other kernel driver class? Wireless, ALSA, USB, I2C -
>> > you name them. Is there something special about media, that I'm missing,
>> > or are all others just user-unfriendly? Why are distro-kernels,
>> > allmodconfig, allyesconfig not enough for media and we think it's
>> > necessary to build everything "just in case?"
>>
>>
>> This isn't a matter of "building all drivers by default" -- it is a
>> matter of building component dependency drivers that are needed by the
>> bridge drivers, and allowing users to not build drivers that they
>> don't need.
>
> I would understand, if in the beginning all was empty (all drivers
> disabled), then the user goes to his or her card entry, enables it. And
> since that card has a 100 of variations, and we don't know exactly which
> of them the user has, we enable all components, possibly present on this
> card. This would make sense. Howevre, this is not what we currently have.
>
>> The customization options are there to allow you to
>> disable the "helper chips" / "tuners" etc from all being built if that
>> is your choice.  If you disable the customization options, then
>> Kconfig automatically selects the dependencies of the bridge drivers
>> that you've selected and does NOT build those that are irrelevant to
>> you.
>
> Hm, that's not what I see. I just tried the following: made a default
> x86_64 .config, it had media disabled. Then I enabled media and alreay a
> bunch of IR remotes has been enabled. Then I enabled V4L, and all tuners
> got enabled. Switching on "customize" allowed me to kill them selectively.
> So, I don't see what you described above: how those tuners only get to
> build, if I enable respective bridges. Or have I misunderstood you?

You understood me correctly -- your experience described above reveals
to us that the dependency system somehow got broken and now we're
building too much by default.

Maybe we should make the VIDEO_TUNER symbol as well as VIDEO_IR etc
visible options so that those only looking to build webcams can turn
them off all at once.

I'd like to hear Mauro's comments on this.

-Mike

>> At first, users were forced to build everything without being
>> able to disable these modules.  We added this mechanism to allow such
>> modules to be disabled from a build, but we enable them by default
>> because anything else would become a user-support nightmare, as I
>> stated earlier.  If you refer to the mailing list archives from about
>> four or five years ago, you'll may find that this was discussed at
>> length on the video4linux and linux-dvb mailing lists.  In the end I
>> believe this is the solution that satisfied everybody the best.
>>
>> -Mike Krufky
>> >
>> > Thanks
>> > Guennadi
>> >
>> >>
>> >> Regards,
>> >>
>> >>       Hans
>> >>
>> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >> > ---
>> >> >  drivers/media/common/tuners/Kconfig |   23 +----------------------
>> >> >  drivers/media/radio/Kconfig         |    1 -
>> >> >  drivers/media/rc/Kconfig            |   16 +---------------
>> >> >  drivers/media/rc/keymaps/Kconfig    |    1 -
>> >> >  drivers/media/video/Kconfig         |    7 ++-----
>> >> >  5 files changed, 4 insertions(+), 44 deletions(-)
>> >> >
>> >> > diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
>> >> > index 996302a..1e53057 100644
>> >> > --- a/drivers/media/common/tuners/Kconfig
>> >> > +++ b/drivers/media/common/tuners/Kconfig
>> >> > @@ -33,7 +33,7 @@ config MEDIA_TUNER
>> >> >     select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE
>> >> >
>> >> >  config MEDIA_TUNER_CUSTOMISE
>> >> > -   bool "Customize analog and hybrid tuner modules to build"
>> >> > +   bool "Select analog and hybrid tuner modules to build"
>> >> >     depends on MEDIA_TUNER
>> >> >     default y if EXPERT
>> >> >     help
>> >> > @@ -52,7 +52,6 @@ config MEDIA_TUNER_SIMPLE
>> >> >     tristate "Simple tuner support"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> >     select MEDIA_TUNER_TDA9887
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for various simple tuners.
>> >> >
>> >> > @@ -61,28 +60,24 @@ config MEDIA_TUNER_TDA8290
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> >     select MEDIA_TUNER_TDA827X
>> >> >     select MEDIA_TUNER_TDA18271
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for Philips TDA8290+8275(a) tuner.
>> >> >
>> >> >  config MEDIA_TUNER_TDA827X
>> >> >     tristate "Philips TDA827X silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A DVB-T silicon tuner module. Say Y when you want to support this tuner.
>> >> >
>> >> >  config MEDIA_TUNER_TDA18271
>> >> >     tristate "NXP TDA18271 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A silicon tuner module. Say Y when you want to support this tuner.
>> >> >
>> >> >  config MEDIA_TUNER_TDA9887
>> >> >     tristate "TDA 9885/6/7 analog IF demodulator"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for Philips TDA9885/6/7
>> >> >       analog IF demodulator.
>> >> > @@ -91,63 +86,54 @@ config MEDIA_TUNER_TEA5761
>> >> >     tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> >     depends on EXPERIMENTAL
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for the Philips TEA5761 radio tuner.
>> >> >
>> >> >  config MEDIA_TUNER_TEA5767
>> >> >     tristate "TEA 5767 radio tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for the Philips TEA5767 radio tuner.
>> >> >
>> >> >  config MEDIA_TUNER_MT20XX
>> >> >     tristate "Microtune 2032 / 2050 tuners"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for the MT2032 / MT2050 tuner.
>> >> >
>> >> >  config MEDIA_TUNER_MT2060
>> >> >     tristate "Microtune MT2060 silicon IF tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon IF tuner MT2060 from Microtune.
>> >> >
>> >> >  config MEDIA_TUNER_MT2266
>> >> >     tristate "Microtune MT2266 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon baseband tuner MT2266 from Microtune.
>> >> >
>> >> >  config MEDIA_TUNER_MT2131
>> >> >     tristate "Microtune MT2131 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon baseband tuner MT2131 from Microtune.
>> >> >
>> >> >  config MEDIA_TUNER_QT1010
>> >> >     tristate "Quantek QT1010 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner QT1010 from Quantek.
>> >> >
>> >> >  config MEDIA_TUNER_XC2028
>> >> >     tristate "XCeive xc2028/xc3028 tuners"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to include support for the xc2028/xc3028 tuners.
>> >> >
>> >> >  config MEDIA_TUNER_XC5000
>> >> >     tristate "Xceive XC5000 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner XC5000 from Xceive.
>> >> >       This device is only used inside a SiP called together with a
>> >> > @@ -156,7 +142,6 @@ config MEDIA_TUNER_XC5000
>> >> >  config MEDIA_TUNER_XC4000
>> >> >     tristate "Xceive XC4000 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner XC4000 from Xceive.
>> >> >       This device is only used inside a SiP called together with a
>> >> > @@ -165,42 +150,36 @@ config MEDIA_TUNER_XC4000
>> >> >  config MEDIA_TUNER_MXL5005S
>> >> >     tristate "MaxLinear MSL5005S silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner MXL5005S from MaxLinear.
>> >> >
>> >> >  config MEDIA_TUNER_MXL5007T
>> >> >     tristate "MaxLinear MxL5007T silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner MxL5007T from MaxLinear.
>> >> >
>> >> >  config MEDIA_TUNER_MC44S803
>> >> >     tristate "Freescale MC44S803 Low Power CMOS Broadband tuners"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       Say Y here to support the Freescale MC44S803 based tuners
>> >> >
>> >> >  config MEDIA_TUNER_MAX2165
>> >> >     tristate "Maxim MAX2165 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       A driver for the silicon tuner MAX2165 from Maxim.
>> >> >
>> >> >  config MEDIA_TUNER_TDA18218
>> >> >     tristate "NXP TDA18218 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       NXP TDA18218 silicon tuner driver.
>> >> >
>> >> >  config MEDIA_TUNER_TDA18212
>> >> >     tristate "NXP TDA18212 silicon tuner"
>> >> >     depends on VIDEO_MEDIA && I2C
>> >> > -   default m if MEDIA_TUNER_CUSTOMISE
>> >> >     help
>> >> >       NXP TDA18212 silicon tuner driver.
>> >> >
>> >> > diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
>> >> > index 52798a1..0195335 100644
>> >> > --- a/drivers/media/radio/Kconfig
>> >> > +++ b/drivers/media/radio/Kconfig
>> >> > @@ -5,7 +5,6 @@
>> >> >  menuconfig RADIO_ADAPTERS
>> >> >     bool "Radio Adapters"
>> >> >     depends on VIDEO_V4L2
>> >> > -   default y
>> >> >     ---help---
>> >> >       Say Y here to enable selecting AM/FM radio adapters.
>> >> >
>> >> > diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> >> > index 899f783..2a4f829 100644
>> >> > --- a/drivers/media/rc/Kconfig
>> >> > +++ b/drivers/media/rc/Kconfig
>> >> > @@ -1,7 +1,6 @@
>> >> >  menuconfig RC_CORE
>> >> >     tristate "Remote Controller adapters"
>> >> >     depends on INPUT
>> >> > -   default INPUT
>> >> >     ---help---
>> >> >       Enable support for Remote Controllers on Linux. This is
>> >> >       needed in order to support several video capture adapters.
>> >> > @@ -11,12 +10,9 @@ menuconfig RC_CORE
>> >> >       if you don't need IR, as otherwise, you may not be able to
>> >> >       compile the driver for your adapter.
>> >> >
>> >> > -if RC_CORE
>> >> > -
>> >> >  config LIRC
>> >> >     tristate
>> >> > -   default y
>> >> > -
>> >> > +   depends on RC_CORE
>> >> >     ---help---
>> >> >        Enable this option to build the Linux Infrared Remote
>> >> >        Control (LIRC) core device interface driver. The LIRC
>> >> > @@ -30,7 +26,6 @@ config IR_NEC_DECODER
>> >> >     tristate "Enable IR raw decoder for the NEC protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have IR with NEC protocol, and
>> >> > @@ -40,7 +35,6 @@ config IR_RC5_DECODER
>> >> >     tristate "Enable IR raw decoder for the RC-5 protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have IR with RC-5 protocol, and
>> >> > @@ -50,7 +44,6 @@ config IR_RC6_DECODER
>> >> >     tristate "Enable IR raw decoder for the RC6 protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have an infrared remote control which
>> >> > @@ -60,7 +53,6 @@ config IR_JVC_DECODER
>> >> >     tristate "Enable IR raw decoder for the JVC protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have an infrared remote control which
>> >> > @@ -69,7 +61,6 @@ config IR_JVC_DECODER
>> >> >  config IR_SONY_DECODER
>> >> >     tristate "Enable IR raw decoder for the Sony protocol"
>> >> >     depends on RC_CORE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have an infrared remote control which
>> >> > @@ -79,7 +70,6 @@ config IR_RC5_SZ_DECODER
>> >> >     tristate "Enable IR raw decoder for the RC-5 (streamzap) protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have IR with RC-5 (streamzap) protocol,
>> >> > @@ -91,7 +81,6 @@ config IR_MCE_KBD_DECODER
>> >> >     tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
>> >> >     depends on RC_CORE
>> >> >     select BITREVERSE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option if you have a Microsoft Remote Keyboard for
>> >> > @@ -102,7 +91,6 @@ config IR_LIRC_CODEC
>> >> >     tristate "Enable IR to LIRC bridge"
>> >> >     depends on RC_CORE
>> >> >     depends on LIRC
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        Enable this option to pass raw IR to and from userspace via
>> >> > @@ -236,5 +224,3 @@ config RC_LOOPBACK
>> >> >
>> >> >        To compile this driver as a module, choose M here: the module will
>> >> >        be called rc_loopback.
>> >> > -
>> >> > -endif #RC_CORE
>> >> > diff --git a/drivers/media/rc/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
>> >> > index 8e615fd..dbaacf1 100644
>> >> > --- a/drivers/media/rc/keymaps/Kconfig
>> >> > +++ b/drivers/media/rc/keymaps/Kconfig
>> >> > @@ -1,7 +1,6 @@
>> >> >  config RC_MAP
>> >> >     tristate "Compile Remote Controller keymap modules"
>> >> >     depends on RC_CORE
>> >> > -   default y
>> >> >
>> >> >     ---help---
>> >> >        This option enables the compilation of lots of Remote
>> >> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> >> > index f574dc0..d26443d 100644
>> >> > --- a/drivers/media/video/Kconfig
>> >> > +++ b/drivers/media/video/Kconfig
>> >> > @@ -73,7 +73,6 @@ config VIDEOBUF2_DMA_SG
>> >> >  menuconfig VIDEO_CAPTURE_DRIVERS
>> >> >     bool "Video capture adapters"
>> >> >     depends on VIDEO_V4L2
>> >> > -   default y
>> >> >     ---help---
>> >> >       Say Y here to enable selecting the video adapters for
>> >> >       webcams, analog TV, and hybrid analog/digital TV.
>> >> > @@ -113,8 +112,8 @@ config VIDEO_HELPER_CHIPS_AUTO
>> >> >
>> >> >  config VIDEO_IR_I2C
>> >> >     tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
>> >> > -   depends on I2C && RC_CORE
>> >> > -   default y
>> >> > +   depends on I2C
>> >> > +   select RC_CORE
>> >> >     ---help---
>> >> >       Most boards have an IR chip directly connected via GPIO. However,
>> >> >       some video boards have the IR connected via I2C bus.
>> >> > @@ -556,7 +555,6 @@ config VIDEO_VIU
>> >> >     tristate "Freescale VIU Video Driver"
>> >> >     depends on VIDEO_V4L2 && PPC_MPC512x
>> >> >     select VIDEOBUF_DMA_CONTIG
>> >> > -   default y
>> >> >     ---help---
>> >> >       Support for Freescale VIU video driver. This device captures
>> >> >       video data, or overlays video on DIU frame buffer.
>> >> > @@ -986,7 +984,6 @@ source "drivers/media/video/s5p-tv/Kconfig"
>> >> >  menuconfig V4L_USB_DRIVERS
>> >> >     bool "V4L USB devices"
>> >> >     depends on USB
>> >> > -   default y
>> >> >
>> >> >  if V4L_USB_DRIVERS && USB
>> >> >
>> >> >
>> >>
>> >
>> > ---
>> > Guennadi Liakhovetski, Ph.D.
>> > Freelance Open-Source Software Developer
>> > http://www.open-technology.de/
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
