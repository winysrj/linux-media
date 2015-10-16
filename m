Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52572 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbbJPPxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 11:53:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 57BE02A0080
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2015 17:51:37 +0200 (CEST)
Message-ID: <56211D09.1010903@xs4all.nl>
Date: Fri, 16 Oct 2015 17:51:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.4] Various fixes + SDR TX
References: <5620C167.9080801@xs4all.nl>
In-Reply-To: <5620C167.9080801@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2015 11:20 AM, Hans Verkuil wrote:
> This pull request fixes various bugs, but the main change is Antti's support
> for SDR transmitters.
> 
> BTW, I have v4l2-ctl and v4l2-compliance support ready for this feature as
> well. Available here:
> 
> http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=sdr
> 
> Note: this needs some cleanup as the patches are a bit messy.
> 
> Once this pull request is merged I'll cleanup my v4l-utils code and push it.

Note: please merged the vb2 split pull request first: https://patchwork.linuxtv.org/patch/31670/ 

There may be some fall-out from that that affects this pull request. I haven't tested that
(forgot about it).

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit efe98010b80ec4516b2779e1b4e4a8ce16bf89fe:
> 
>   [media] DocBook: Fix remaining issues with VB2 core documentation (2015-10-05 09:12:56 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.4e
> 
> for you to fetch changes up to eaae4b60943fa2ee07ca1d1600489ed9051ffc0f:
> 
>   DocBook media: update copyright/version numbers (2015-10-16 11:13:01 +0200)
> 
> ----------------------------------------------------------------
> Antonio Ospite (1):
>       media/v4l2-ctrls: fix setting autocluster to manual with VIDIOC_S_CTRL
> 
> Antti Palosaari (13):
>       v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
>       v4l2: add RF gain control
>       DocBook: document tuner RF gain control
>       v4l2: add support for SDR transmitter
>       DocBook: document SDR transmitter
>       v4l: add type field to v4l2_modulator struct
>       DocBook: add modulator type field
>       hackrf: add control for RF amplifier
>       hackrf: switch to single function which configures everything
>       hackrf: add support for transmitter
>       hackrf: do not set human readable name for formats
>       DocBook: add SDR specific info to G_TUNER / S_TUNER
>       DocBook: add SDR specific info to G_MODULATOR / S_MODULATOR
> 
> Hans Verkuil (1):
>       DocBook media: update copyright/version numbers
> 
> Jan Kara (1):
>       ivtv: Convert to get_user_pages_unlocked()
> 
> Jean-Michel Hautbois (1):
>       DocBook media: Fix a typo in encoder cmd
> 
> Salva Peiró (1):
>       media/vivid-osd: fix info leak in ioctl
> 
>  Documentation/DocBook/media/v4l/compat.xml             |   20 ++
>  Documentation/DocBook/media/v4l/controls.xml           |   14 +
>  Documentation/DocBook/media/v4l/dev-sdr.xml            |   32 +-
>  Documentation/DocBook/media/v4l/io.xml                 |   10 +-
>  Documentation/DocBook/media/v4l/pixfmt.xml             |    2 +-
>  Documentation/DocBook/media/v4l/v4l2.xml               |   13 +-
>  Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml       |    2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-modulator.xml |   14 +-
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml     |   16 +
>  Documentation/DocBook/media/v4l/vidioc-querycap.xml    |    6 +
>  Documentation/DocBook/media_api.tmpl                   |    2 +-
>  drivers/media/pci/ivtv/ivtv-yuv.c                      |   12 +-
>  drivers/media/platform/vivid/vivid-osd.c               |    1 +
>  drivers/media/usb/hackrf/hackrf.c                      | 1082 ++++++++++++++++++++++++++++++++++++++------------------
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c          |    2 +
>  drivers/media/v4l2-core/v4l2-ctrls.c                   |    4 +-
>  drivers/media/v4l2-core/v4l2-dev.c                     |   14 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c                   |   49 ++-
>  drivers/media/v4l2-core/videobuf-core.c                |    4 +-
>  include/media/v4l2-ioctl.h                             |    8 +
>  include/trace/events/v4l2.h                            |    1 +
>  include/uapi/linux/v4l2-controls.h                     |    1 +
>  include/uapi/linux/videodev2.h                         |   13 +-
>  24 files changed, 952 insertions(+), 372 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

