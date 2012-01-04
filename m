Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2ADWos (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 17:44:48 -0500
Message-ID: <4F04D657.7050402@infradead.org>
Date: Wed, 04 Jan 2012 20:44:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PULL] git://git.kernellabs.com/stoth/cx23885-hvr1850.git media-master
 branch
References: <CALzAhNUHJiwv5PmDPZyaxofA+1vBUw7WBV2EoT4VQNZZn--6fg@mail.gmail.com>
In-Reply-To: <CALzAhNUHJiwv5PmDPZyaxofA+1vBUw7WBV2EoT4VQNZZn--6fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04-01-2012 13:28, Steven Toth wrote:
> Mauro,
> 
> I've been adding support to the CX23885 and CX25840 drivers for the
> Hauppauge HVR1850
> card. These patches enable the use of raw video, audio and/or the mpeg
> encoder, via all
> video and audio inputs. Support for the HVR1850 is now in pretty good shape.
> 
> The card uses the CX23888 PCIe bridge which brings its own complexities and
> additional code to the CX25840. I've tested these patches against the
> HVR1700, HVR1800
> and HVR1850, everything appears to be working correctly.
> 
> These also fix a small regression in the HVR1800 driver related to the
> work done during
> October 2010 on the subdev conversion. Given that nobody has noticed
> in the last 12
> months it's not too important.
> 
> Tree is at git://git.kernellabs.com/stoth/cx23885-hvr1850.git
> media-master branch.

Steve,

Please, always use git request-pull to generate pull requests, otherwise
patchwork won't catch and I may miss it.

Thanks,
Mauro

> 
> Patch series viewable at:
> 
> http://git.kernellabs.com/?p=stoth/cx23885-hvr1850.git;a=shortlog;h=refs/heads/media-master
> 
>     [media] cx25840: Added g_std support to the video decoder driver
>     [media] cx25840: Hauppauge HVR1850 Analog driver support (patch#4)
>     [media] cx25840: Add a flag to enable the CX23888 DIF to be enabled or not.
>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#3)
>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#2)
>     [media] cx23885: Hauppauge HVR1850 Analog driver support (patch#1)
>     [media] cx23885: Bugfix /sys/class/video4linux/videoX/name truncation
>     [media] cx23885: Control cleanup on the MPEG Encoder
>     [media] cx23885: Configure the MPEG encoder early to avoid jerky video
>     [media] cx23885: Ensure the MPEG encoder height is configured from the norm
>     [media] cx23885: Cleanup MPEG encoder GPIO handling
>     [media] cx25840 / cx23885: Fixing audio/volume regression
> 
>  b/drivers/media/video/cx23885/cx23885-417.c   |    4
>  b/drivers/media/video/cx23885/cx23885-cards.c |   28
>  b/drivers/media/video/cx23885/cx23885-core.c  |   24
>  b/drivers/media/video/cx23885/cx23885-dvb.c   |   14
>  b/drivers/media/video/cx23885/cx23885-video.c |  153 +
>  b/drivers/media/video/cx23885/cx23885.h       |   12
>  b/drivers/media/video/cx25840/cx25840-audio.c |   10
>  b/drivers/media/video/cx25840/cx25840-core.c  |   36
>  b/include/media/cx25840.h                     |    1
>  drivers/media/video/cx23885/cx23885-417.c     |  137 -
>  drivers/media/video/cx23885/cx23885-video.c   |   10
>  drivers/media/video/cx25840/cx25840-core.c    | 3188 +++++++++++++++++++++++++-
>  12 files changed, 3487 insertions(+), 130 deletions(-)
> 
> Thanks,
> 

