Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:32994 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZCIGhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 02:37:08 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1797878wfa.4
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2009 23:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0903082150200.6607@caramujo.chehab.org>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
	 <20090308140304.3cf9370a@caramujo.chehab.org>
	 <a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>
	 <20090308155125.5f8afe07@caramujo.chehab.org>
	 <a3ef07920903081654l39b98c2du57350109d7381fb@mail.gmail.com>
	 <alpine.LRH.2.00.0903082150200.6607@caramujo.chehab.org>
Date: Sun, 8 Mar 2009 23:37:06 -0700
Message-ID: <a3ef07920903082337q63363bd8v851b3aaa61b2889c@mail.gmail.com>
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
	building
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Baartz <baartzy@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 8, 2009 at 6:07 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> It won't mark they with M, if you keep enabling DVB_FE_CUSTOMISE, since this
> Kconfig var allows manual override over the frontend modules.

Ok, tried again and it's as you said.  I assumed the behavior of
DVB_FE_CUSTOMISE hadn't changed but it appears it has.  Although, I
think the previous behavior is still better having the required
modules as locked -M-.  At least then the user has some kind of
control over what modules are built without risk of disabling
something he needs.  What was the logic behind making this change?

That's one thing I don't understand... Why an os that prides itself on
user-customization seems to always be introducing ways to limit the
user.

Anyways, here's what I get:

$ grep "^CONFIG" .config
CONFIG_INPUT=y
CONFIG_USB=y
CONFIG_SND=y
CONFIG_I2C_ALGOBIT=y
CONFIG_INET=y
CONFIG_CRC32=y
CONFIG_SYSFS=y
CONFIG_PCI=y
CONFIG_VIRT_TO_BUS=y
CONFIG_NET=y
CONFIG_I2C=y
CONFIG_STANDALONE=y
CONFIG_MODULES=y
CONFIG_HAS_IOMEM=y
CONFIG_PROC_FS=y
CONFIG_HAS_DMA=y
CONFIG_SND_PCM=y
CONFIG_EXPERIMENTAL=y
CONFIG_IEEE1394=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
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
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_L64781=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_LNBP21=m
