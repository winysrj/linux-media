Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39479 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0KMMQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 07:16:35 -0500
Received: by qyk4 with SMTP id 4so453451qyk.19
        for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 04:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101113104643.2b99e160@tele>
References: <20101113104643.2b99e160@tele>
Date: Sat, 13 Nov 2010 14:16:34 +0200
Message-ID: <AANLkTimX9E3Ww2NQf1GfHA6nuXzT=36wCPT0zG+W0Xu=@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Nov 13, 2010 at 11:46 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> The following changes since commit
> af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3:
>
>  [media] IR: add tv power scancode to rc6 mce keymap (2010-11-10 00:58:49 -0200)
>
> are available in the git repository at:
>  git://linuxtv.org/jfrancois/gspca.git for_2.6.38
>
> Jean-François Moine (16):
>      gspca - ov519: Handle the snapshot on capture stop when CONFIG_INPUT=m
>      gspca - ov519: Don't do USB exchanges after disconnection
>      gspca - ov519: Change types '__xx' to 'xx'
>      gspca - ov519: Reduce the size of some variables
>      gspca - ov519: Define the sensor types in an enum
>      gspca - ov519: Cleanup source
>      gspca - ov519: Set their numbers in the ov519 and ov7670 register names
>      gspca - ov519: Define the disabled controls in a table
>      gspca - ov519: Propagate errors to higher level
>      gspca - ov519: Clearer debug and error messages
>      gspca - ov519: Check the disabled controls at start time only
>      gspca - ov519: Simplify the LED control functions
>      gspca - ov519: Change the ov519 start and stop sequences
>      gspca - ov519: Initialize the ov519 snapshot register
>      gspca - ov519: Re-initialize the webcam at resume time
>      gspca - ov519: New sensor ov7660 with bridge ov530 (ov519)
>
> Nicolas Kaiser (1):
>      gspca - cpia1: Fix error check
>
>  drivers/media/video/gspca/cpia1.c   |    2 +-
>  drivers/media/video/gspca/ov519.c   | 1671 +++++++++++++++++++++--------------
>  drivers/media/video/gspca/w996Xcf.c |  325 +++----
>  3 files changed, 1131 insertions(+), 867 deletions(-)

Some conflicts against mainline:
diff --cc drivers/staging/cx25821/Kconfig
index 1d73334,9c2e259..0000000
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@@ -1,7 -1,6 +1,11 @@@
  config VIDEO_CX25821
  	tristate "Conexant cx25821 support"
++<<<<<<< HEAD
 +	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
 +	depends on BKL # please fix
++=======
+ 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
++>>>>>>> b49b143975141c461bfd11dd1c6632c1a1c7f8ff
  	select I2C_ALGOBIT
  	select VIDEO_BTCX
  	select VIDEO_TVEEPROM
diff --cc drivers/staging/go7007/Kconfig
index 3aecd30,75ddaad..0000000
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@@ -1,10 -1,9 +1,14 @@@
  config VIDEO_GO7007
  	tristate "WIS GO7007 MPEG encoder support"
++<<<<<<< HEAD
 +	depends on VIDEO_DEV && PCI && I2C && INPUT
 +	depends on BKL # please fix
++=======
+ 	depends on VIDEO_DEV && PCI && I2C
++>>>>>>> b49b143975141c461bfd11dd1c6632c1a1c7f8ff
  	depends on SND
  	select VIDEOBUF_DMA_SG
- 	depends on VIDEO_IR
+ 	depends on IR_CORE
  	select VIDEO_TUNER
  	select VIDEO_TVEEPROM
  	select SND_PCM

Running new kernel now, ov7660 works. Thank you.
