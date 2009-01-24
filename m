Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:47877 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbZAXUhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 15:37:31 -0500
Date: Sat, 24 Jan 2009 15:37:26 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: linux-media@vger.kernel.org, killero_24@yahoo.com
Subject: Re: [linux-dvb] HVR-1800 Support
Message-ID: <20090124203726.GA9808@blorp.plorb.com>
References: <463244.61379.qm@web45416.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463244.61379.qm@web45416.mail.sp1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 20, 2009 at 10:08:51PM -0800, Killero SS wrote:
> i'm using ubuntu 8.10 2.6.27-9-generic
> and tried compiling latest modules with hg-clone but my analog capture got broken, firmware error...
> so i got back to original kernel modules
> however, some people claim they get audio with analog on /dev/video1
> this has never be my case, im using svideo signal so wondering if that may be it.
> i get analog video on video0 and video1, but some colors look pretty weird, red for example.

The driver in the kernel and hg does not set up the registers properly 
for the video or audio in S-Video mode.  I made some changes to get mine 
working.  I can probably make a patch for you if you can get your source 
build working.

You might be able to get everything working using the cx25840ctl utility 
from the ivtv-utils package.  With cx25840ctl you'll need to make sure 
the i2c-dev module is loaded, and figure out which i2c device is the 
cx25840 interface.  "cx25840ctl -l 3" will show the registers from i2c 
device 3.  "-s 3" sets the registers on i2c device 3.  You'll probably 
need to set the registers after you have the device open to get the 
audio working, otherwise the driver will reset some of them.  I haven't 
tested this since I put the settings in my driver.  (I still need to use 
part of this script to fix the brightness, contrast, saturation, and hue 
though.)

#!/bin/sh
modprobe i2c-dev
cx25840ctl -s 3 <<EOT
VGA_SEL_CH2=0
VGA_SEL_CH3=0
DROOP_COMP_CH3=1
DROOP_COMP_CH2=1
BRIGHT=0
CNTRST=128
USAT=128
VSAT=128
HUE=0
SOFT_RESET=1
START_MICROCNTL=0
PATH1_SEL_CTL=3
PATH1_AVC_STEREO=0
SOFT1_MUTE_EN=0
SRC1_MUTE_EN=0
SA_MUTE_EN=0
PAR_MUTE_EN=0
AC97_MUTE_EN=0
SOFT_RESET=0
EOT
# end

> another thing this card has fm radio, anyone knows how to set it up? i've been unable to find any info regarding this

I didn't notice any code for radio support while I was debugging the 
driver.

-- 
Jeff DeFouw <jeffd@i2k.com>
