Return-path: <linux-media-owner@vger.kernel.org>
Received: from ims-d13.mx.aol.com ([205.188.249.150]:47952 "EHLO
	ims-d13.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1JQRJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 13:09:24 -0400
Received: from oms-db04.r1000.mx.aol.com (oms-db04.r1000.mx.aol.com [205.188.58.4])
	by ims-d13.mx.aol.com (8.14.1/8.14.1) with ESMTP id p9HH965i014136
	for <linux-media@vger.kernel.org>; Mon, 17 Oct 2011 13:09:06 -0400
Received: from mtaout-db02.r1000.mx.aol.com (mtaout-db02.r1000.mx.aol.com [172.29.51.194])
	by oms-db04.r1000.mx.aol.com (AOL Outbound OMS Interface) with ESMTP id E1E661C000087
	for <linux-media@vger.kernel.org>; Mon, 17 Oct 2011 13:09:06 -0400 (EDT)
Received: from [192.168.1.34] (unknown [190.50.38.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-db02.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 161DBE0000E5
	for <linux-media@vger.kernel.org>; Mon, 17 Oct 2011 13:09:05 -0400 (EDT)
Message-ID: <4E9C3819.2000307@netscape.net>
Date: Mon, 17 Oct 2011 11:13:45 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
References: <201110101752.11536.liplianin@me.by>
In-Reply-To: <201110101752.11536.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 10/10/11 11:52, Igor M. Liplianin escribió:
> Hi Mauro and Steven,
>
> It's been a long time since cx23885-alsa pull was requested.
> To speed things up I created a git branch where I put the patches.
> Some patches merged, like introduce then correct checkpatch compliance
> or convert spinlock to mutex and back to spinlock, insert printk then remove printk as well.
> Minor corrections from me was silently merged, for major I created additional patches.
>
> Hope it helps.
>
> The following changes since commit e30528854797f057aa6ffb6dc9f890e923c467fd:
>
>    [media] it913x-fe changes to power up and down of tuner (2011-10-08 08:03:27 -0300)
>
> are available in the git repository at:
>    git://linuxtv.org/liplianin/media_tree.git cx23885-alsa-clean-2
>
> Igor M. Liplianin (2):
>        cx23885: videobuf: Remove the videobuf_sg_dma_map/unmap functions
>        cx25840-audio: fix missing state declaration
>
> Mijhail Moreyra (6):
>        cx23885: merge mijhail's header changes for alsa
>        cx23885: ALSA support
>        cx23885: core changes requireed for ALSA
>        cx23885: add definitions for HVR1500 to support audio
>        cx23885: correct the contrast, saturation and hue controls
>        cx23885: hooks the alsa changes into the video subsystem
>
> Steven Toth (31):
>        cx23885: prepare the cx23885 makefile for alsa support
>        cx23885: convert from snd_card_new() to snd_card_create()
>        cx23885: convert call clients into subdevices
>        cx23885: minor function renaming to ensure uniformity
>        cx23885: setup the dma mapping for raw audio support
>        cx23885: mute the audio during channel change
>        cx23885: add two additional defines to simplify VBI register bitmap handling
>        cx23885: initial support for VBI with the cx23885
>        cx23885: initialize VBI support in the core, add IRQ support, register vbi device
>        cx23885: minor printk cleanups and device registration
>        cx25840: enable raw cc processing only for the cx23885 hardware
>        cx23885: vbi line window adjustments
>        cx23885: add vbi buffer formatting, window changes and video core changes
>        cx23885: Ensure the VBI pixel format is established correctly.
>        cx23885: ensure video is streaming before allowing vbi to stream
>        cx23885: remove channel dump diagnostics when a vbi buffer times out.
>        cx23885: Ensure VBI buffers timeout quickly - bugfix for vbi hangs during streaming.
>        cx23885: Name an internal i2c part and declare a bitfield by name
>        cx25840: Enable support for non-tuner LR1/LR2 audio inputs
>        cx23885: Enable audio line in support from the back panel
>        cx25840: Ensure AUDIO6 and AUDIO7 trigger line-in baseband use.
>        cx23885: Initial support for the MPX-885 mini-card
>        cx23885: fixes related to maximum number of inputs and range checking
>        cx23885: add generic functions for dealing with audio input selection
>        cx23885: hook the audio selection functions into the main driver
>        cx23885: v4l2 api compliance, set the audioset field correctly
>        cx23885: Removed a spurious function cx23885_set_scale().
>        cx23885: Avoid stopping the risc engine during buffer timeout.
>        cx23885: Avoid incorrect error handling and reporting
>        cx23885: Stop the risc video fifo before reconfiguring it.
>        cx23885: Allow the audio mux config to be specified on a per input basis.
>
>   drivers/media/video/cx23885/Makefile        |    2 +-
>   drivers/media/video/cx23885/cx23885-alsa.c  |  535 +++++++++++++++++++++++++++
>   drivers/media/video/cx23885/cx23885-cards.c |   53 +++
>   drivers/media/video/cx23885/cx23885-core.c  |   99 ++++-
>   drivers/media/video/cx23885/cx23885-i2c.c   |    1 +
>   drivers/media/video/cx23885/cx23885-reg.h   |    3 +
>   drivers/media/video/cx23885/cx23885-vbi.c   |   72 +++-
>   drivers/media/video/cx23885/cx23885-video.c |  373 ++++++++++++++++---
>   drivers/media/video/cx23885/cx23885.h       |   56 +++
>   drivers/media/video/cx25840/cx25840-audio.c |   10 +-
>   drivers/media/video/cx25840/cx25840-core.c  |   19 +
>   11 files changed, 1144 insertions(+), 79 deletions(-)
>   create mode 100644 drivers/media/video/cx23885/cx23885-alsa.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
When compile, I get this error:

dhcppc1:/usr/src/linux # make SUBDIRS=drivers/media/video/cx23885 
modules -j2
   Building modules, stage 2.
   MODPOST 2 modules
WARNING: "cx23885_risc_databuffer" 
[drivers/media/video/cx23885/cx23885.ko] undefined!

dhcppc1:/usr/src/linux # modprobe cx23885 debug=3 v4l_debug=3 i2c_scan=3
FATAL: Error inserting cx23885 
(/lib/modules/3.0.6-2-desktop/kernel/drivers/media/video/cx23885/cx23885.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg:
....
[13447.629867] cx23885: Unknown symbol cx23885_risc_databuffer (err 0)


I use kernel 3.0.6 and OpenSuse 11.4


Thank

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es

