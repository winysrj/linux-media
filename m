Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:41269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab0KDSnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Nov 2010 14:43:55 -0400
Message-ID: <4CD2FEDD.2050402@redhat.com>
Date: Thu, 04 Nov 2010 14:43:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kyle@redhat.com, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz>	<4CD1E232.30406@redhat.com> <AANLkTiksbQQsXDydmohz6TiR4u-QNSJkfZHnkLOKizF7@mail.gmail.com>
In-Reply-To: <AANLkTiksbQQsXDydmohz6TiR4u-QNSJkfZHnkLOKizF7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 04-11-2010 14:34, Arnaud Lacombe escreveu:
> Hi,
> 
> On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Basically, we have things there like:
>>
>> config VIDEO_HELPER_CHIPS_AUTO
>>        bool "Autoselect pertinent encoders/decoders and other helper chips"
>>
>> config VIDEO_IVTV
>>        select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO
>>
>> menu "Encoders/decoders and other helper chips"
>>        depends on !VIDEO_HELPER_CHIPS_AUTO
>>
>> config VIDEO_WM8739
>>        tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
>>
> Where do you get that code from ? this particular one is not in 2.6.37-rc1:

The I2C drivers can/are used by other drivers, so they are not at ivtv/Kconfig.
They are at drivers/media/video/Kconfig.

I'm using here just v2.6.37-rc1 (c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4):

$ grep VIDEO_WM8739 drivers/media/video/Kconfig -A2
config VIDEO_WM8739
	tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
	depends on VIDEO_V4L2 && I2C

$ grep VIDEO_HELPER_CHIPS_AUTO drivers/media/video/Kconfig -A2|head -3
config VIDEO_HELPER_CHIPS_AUTO
	bool "Autoselect pertinent encoders/decoders and other helper chips"
	default y if !EMBEDDED


> 
> % git describe
> v2.6.37-rc1-27-gff8b16d
> 
> % head -20 drivers/media/video/ivtv/Kconfig
> config VIDEO_IVTV
>         tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
>         depends on VIDEO_V4L2 && PCI && I2C
>         depends on INPUT   # due to VIDEO_IR
>         select I2C_ALGOBIT
>         depends on VIDEO_IR
>         select VIDEO_TUNER
>         select VIDEO_TVEEPROM
>         select VIDEO_CX2341X
>         select VIDEO_CX25840
>         select VIDEO_MSP3400
>         select VIDEO_SAA711X
>         select VIDEO_SAA717X
>         select VIDEO_SAA7127
>         select VIDEO_CS53L32A
>         select VIDEO_M52790
>         select VIDEO_WM8775
>         select VIDEO_WM8739
>         select VIDEO_VP27SMPX
>         select VIDEO_UPD64031A
> 
>  - Arnaud

