Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35518 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KDSeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Nov 2010 14:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <4CD1E232.30406@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
Date: Thu, 4 Nov 2010 14:34:07 -0400
Message-ID: <AANLkTiksbQQsXDydmohz6TiR4u-QNSJkfZHnkLOKizF7@mail.gmail.com>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kyle@redhat.com, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Basically, we have things there like:
>
> config VIDEO_HELPER_CHIPS_AUTO
>        bool "Autoselect pertinent encoders/decoders and other helper chips"
>
> config VIDEO_IVTV
>        select VIDEO_WM8739 if VIDEO_HELPER_CHIPS_AUTO
>
> menu "Encoders/decoders and other helper chips"
>        depends on !VIDEO_HELPER_CHIPS_AUTO
>
> config VIDEO_WM8739
>        tristate "Wolfson Microelectronics WM8739 stereo audio ADC"
>
Where do you get that code from ? this particular one is not in 2.6.37-rc1:

% git describe
v2.6.37-rc1-27-gff8b16d

% head -20 drivers/media/video/ivtv/Kconfig
config VIDEO_IVTV
        tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
        depends on VIDEO_V4L2 && PCI && I2C
        depends on INPUT   # due to VIDEO_IR
        select I2C_ALGOBIT
        depends on VIDEO_IR
        select VIDEO_TUNER
        select VIDEO_TVEEPROM
        select VIDEO_CX2341X
        select VIDEO_CX25840
        select VIDEO_MSP3400
        select VIDEO_SAA711X
        select VIDEO_SAA717X
        select VIDEO_SAA7127
        select VIDEO_CS53L32A
        select VIDEO_M52790
        select VIDEO_WM8775
        select VIDEO_WM8739
        select VIDEO_VP27SMPX
        select VIDEO_UPD64031A

 - Arnaud
