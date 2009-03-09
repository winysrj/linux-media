Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCIBHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 21:07:55 -0400
Date: Sun, 8 Mar 2009 22:07:28 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: VDR User <user.vdr@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Peter Baartz <baartzy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
 building
In-Reply-To: <a3ef07920903081654l39b98c2du57350109d7381fb@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0903082150200.6607@caramujo.chehab.org>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>  <20090308140304.3cf9370a@caramujo.chehab.org>  <a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>  <20090308155125.5f8afe07@caramujo.chehab.org>
 <a3ef07920903081654l39b98c2du57350109d7381fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-436904319-1236560872=:6607"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-436904319-1236560872=:6607
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 8 Mar 2009, VDR User wrote:

> On Sun, Mar 8, 2009 at 11:51 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>>> Yesterday I grabbed a fresh clone of v4l and compiled drivers for my
>>> nexus-s.  Only that none of the required frontend modules were enabled
>>> automatically as they should be when I selected AV7110.  I had to
>>> manually go enable them by hand.  Luckily I knew which ones were
>>> needed but I'm sure a ton of users have no clue.
>>
>> Hopefully, it should be fixed right now. I did a one-line change at the scripts
>> that does the .config initialization. At least, on my tests, everything seems
>> to be fine right now with -hg.
>
> I just grabbed a fresh clone (7cfb5386b66f tip) to see and it's still
> broken.  Everything was enabled in menuconfig by default but
> deselecting everything and then enabling AV7110 back still isn't
> -M-'ing the required frontends.

It won't mark they with M, if you keep enabling DVB_FE_CUSTOMISE, since 
this Kconfig var allows manual override over the frontend modules.

In order to just select what av7110 modules need, you should disable it. 
By disabling, the building system will auto-select the frontends that are 
needed by a full av7110 support.

This is what I get here if I disable all video devices but av7110:

$ cat linux/drivers/media/dvb/frontends/Makefile | perl -ne 'if 
(m/CONFIG_([A-Z_\d]+)/) { print "$1\n" }' >/tmp/fe; grep -f /tmp/fe 
v4l/.config
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_L64781=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_LNBP21=m

Cheers,
Mauro

---
As reference, this is the complete .config, where I've disabled all 
V4L/Radio/DVB adapters, keeping just av7110 and letting the building 
system to auto-select the tuners and the frontends:

#
# Automatically generated make config: don't edit
# Linux kernel version: 
# Sun Mar  8 22:04:08 2009
#
CONFIG_INPUT=y
CONFIG_USB=y
# CONFIG_SPARC64 is not set
# CONFIG_of is not set
# CONFIG_M is not set
# CONFIG_PLAT_M32700UT is not set
# CONFIG_GENERIC_GPIO is not set
# CONFIG_dependencies is not set
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_HAVE_CLK is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND=m
# CONFIG_ARCH_OMAP2 is not set
# CONFIG_SPARC32 is not set
CONFIG_I2C_ALGOBIT=m
# CONFIG_IR is not set
CONFIG_INET=y
CONFIG_CRC32=m
CONFIG_SYSFS=y
# CONFIG_ISA is not set
CONFIG_PCI=y
CONFIG_PARPORT_1284=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_PARPORT=m
# CONFIG_Avoids is not set
# CONFIG_due is not set
CONFIG_NET=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_SND_AC97_CODEC=m
# CONFIG_PXA27x is not set
# CONFIG_SGI_IP22 is not set
CONFIG_I2C=m
CONFIG_STANDALONE=y
# CONFIG_Y is not set
CONFIG_MODULES=y
CONFIG_HAS_IOMEM=y
CONFIG_SND_OPL3_LIB=m
CONFIG_PROC_FS=y
# CONFIG_to is not set
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_HAS_DMA=y
# CONFIG_pvrusb is not set
CONFIG_FB=y
# CONFIG_DVB is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_MX3_IPU is not set
CONFIG_SND_PCM=m
CONFIG_EXPERIMENTAL=y
# CONFIG_M32R is not set
# CONFIG_I2C_ALGO_SGI is not set
# CONFIG_IEEE1394 is not set
# CONFIG_VIDEO_KERNEL_VERSION is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_L64781=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_LNBP21=m
# CONFIG_DAB is not set

#
# Audio devices for multimedia
#

#
# ALSA sound
#
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
--8323328-436904319-1236560872=:6607--
