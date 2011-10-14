Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab1JNVTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 17:19:38 -0400
Received: by wwf22 with SMTP id 22so4042099wwf.1
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 14:19:36 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
Date: Sat, 15 Oct 2011 00:19:55 +0300
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	Abylai Ospan <aospan@netup.ru>
References: <201110101752.11536.liplianin@me.by> <4E989AA3.3010305@infradead.org>
In-Reply-To: <4E989AA3.3010305@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110150019.55734.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от 14 октября 2011 23:25:07 автор Mauro Carvalho Chehab написал:
> Em 10-10-2011 11:52, Igor M. Liplianin escreveu:
> > Hi Mauro and Steven,
> > 
> > It's been a long time since cx23885-alsa pull was requested.
> > To speed things up I created a git branch where I put the patches.
> > Some patches merged, like introduce then correct checkpatch compliance
> > or convert spinlock to mutex and back to spinlock, insert printk then
> > remove printk as well. Minor corrections from me was silently merged,
> > for major I created additional patches.
> > 
> > Hope it helps.
> > 
> > The following changes since commit 
e30528854797f057aa6ffb6dc9f890e923c467fd:
> >   [media] it913x-fe changes to power up and down of tuner (2011-10-08
> >   08:03:27 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/liplianin/media_tree.git cx23885-alsa-clean-2
> 
> Ok, all the other patches look sane. I just had to do another patchset
> reorder, moving patch 39 to happen before patch 29, and folding one of the
> Igor's fixes with a patch sent by Steven.
> 
> I'm assuming that all of you are ok with that. So, I'm pushing the
> changeset into my tree.
Great. Thank you Mauro.

> 
> > Igor M. Liplianin (2):
> >       cx23885: videobuf: Remove the videobuf_sg_dma_map/unmap functions
> >       cx25840-audio: fix missing state declaration
> > 
> > Mijhail Moreyra (6):
> >       cx23885: merge mijhail's header changes for alsa
> >       cx23885: ALSA support
> >       cx23885: core changes requireed for ALSA
> >       cx23885: add definitions for HVR1500 to support audio
> >       cx23885: correct the contrast, saturation and hue controls
> >       cx23885: hooks the alsa changes into the video subsystem
> > 
> > Steven Toth (31):
> >       cx23885: prepare the cx23885 makefile for alsa support
> >       cx23885: convert from snd_card_new() to snd_card_create()
> >       cx23885: convert call clients into subdevices
> >       cx23885: minor function renaming to ensure uniformity
> >       cx23885: setup the dma mapping for raw audio support
> >       cx23885: mute the audio during channel change
> >       cx23885: add two additional defines to simplify VBI register bitmap
> >       handling cx23885: initial support for VBI with the cx23885
> >       cx23885: initialize VBI support in the core, add IRQ support,
> >       register vbi device cx23885: minor printk cleanups and device
> >       registration
> >       cx25840: enable raw cc processing only for the cx23885 hardware
> >       cx23885: vbi line window adjustments
> >       cx23885: add vbi buffer formatting, window changes and video core
> >       changes cx23885: Ensure the VBI pixel format is established
> >       correctly. cx23885: ensure video is streaming before allowing vbi
> >       to stream cx23885: remove channel dump diagnostics when a vbi
> >       buffer times out. cx23885: Ensure VBI buffers timeout quickly -
> >       bugfix for vbi hangs during streaming. cx23885: Name an internal
> >       i2c part and declare a bitfield by name cx25840: Enable support
> >       for non-tuner LR1/LR2 audio inputs cx23885: Enable audio line in
> >       support from the back panel
> >       cx25840: Ensure AUDIO6 and AUDIO7 trigger line-in baseband use.
> >       cx23885: Initial support for the MPX-885 mini-card
> >       cx23885: fixes related to maximum number of inputs and range
> >       checking cx23885: add generic functions for dealing with audio
> >       input selection cx23885: hook the audio selection functions into
> >       the main driver cx23885: v4l2 api compliance, set the audioset
> >       field correctly cx23885: Removed a spurious function
> >       cx23885_set_scale().
> >       cx23885: Avoid stopping the risc engine during buffer timeout.
> >       cx23885: Avoid incorrect error handling and reporting
> >       cx23885: Stop the risc video fifo before reconfiguring it.
> >       cx23885: Allow the audio mux config to be specified on a per input
> >       basis.
> >  
> >  drivers/media/video/cx23885/Makefile        |    2 +-
> >  drivers/media/video/cx23885/cx23885-alsa.c  |  535
> >  +++++++++++++++++++++++++++ drivers/media/video/cx23885/cx23885-cards.c
> >  |   53 +++
> >  drivers/media/video/cx23885/cx23885-core.c  |   99 ++++-
> >  drivers/media/video/cx23885/cx23885-i2c.c   |    1 +
> >  drivers/media/video/cx23885/cx23885-reg.h   |    3 +
> >  drivers/media/video/cx23885/cx23885-vbi.c   |   72 +++-
> >  drivers/media/video/cx23885/cx23885-video.c |  373 ++++++++++++++++---
> >  drivers/media/video/cx23885/cx23885.h       |   56 +++
> >  drivers/media/video/cx25840/cx25840-audio.c |   10 +-
> >  drivers/media/video/cx25840/cx25840-core.c  |   19 +
> >  11 files changed, 1144 insertions(+), 79 deletions(-)
> >  create mode 100644 drivers/media/video/cx23885/cx23885-alsa.c
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
