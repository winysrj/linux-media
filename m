Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3020 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3CHQNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:13:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.10] vb2 enhancement + solo6x10 driver overhaul
Date: Fri, 8 Mar 2013 17:12:43 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Federico Vaga <federico.vaga@gmail.com>
References: <201303081406.19637.hverkuil@xs4all.nl>
In-Reply-To: <201303081406.19637.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303081712.43999.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm canceling this pull request for now. Bluecherry have their own driver
which of course diverged from ours and I want to investigate how best to bring
the two together again.

I will make a new pull request with just the two vb2 patches.

Regards,

	Hans

On Fri March 8 2013 14:06:19 Hans Verkuil wrote:
> Hi Mauro,
> 
> This patch series adds the gfp_flags field to vb2 in order to be able to
> use GFP_DMA or __GFP_DMA32 for PCI drivers like the solo that can only do
> 32-bit DMA. This is a temporary fix, Marek is working on a better solution,
> but that won't happen during this kernel cycle. It's blocking work Federico
> and myself are doing though, so he is OK with this going in and he'll adapt
> it later. It's an internal API only and easy enough to change later.
> 
> The second vb2 patch silences some debug messages that the dma-sg allocator
> kept sending out every time a buffer was allocated or freed. Only do that
> if the debug option is set. Those messages really started to annoy me.
> 
> The remainder are the solo6x10 patches, overhauling that driver into a sane
> state. It is now actually usable, although there are still a few issues that
> need to be resolved before it can be moved out of staging.
> 
> It has been tested with my Bluecherry BC-04120A MPEG4 4 port video encoder/decoder
> card, generously provided by Bluecherry about two years ago.
> 
> The patch series in this pull request is almost unchanged from the version
> posted earlier:
> 
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/61275
> 
> Only the last patch is new. There I rename most of the sources to give them
> a proper solo6x10- prefix. That patch has no other changes.
> 
> Remaining open issues:
> 
> 1) Most importantly, the video from video0 is broken: it is supposed to be
>    either one of the four inputs or a 2x2 image of all four inputs, instead I
>    always get the first video line of the input repeated for the whole image.
> 
>    I have no idea why and it would be very nice if someone from Bluecherry
>    can look at this. I do not see anything wrong in the DMA code, so it is
>    a mystery to me. I'm beginning to wonder if you are actually supposed to
>    be able to DMA from video0!
> 
> 2) I couldn't get it to work on a big-endian system. I keep getting
>    SOLO_PCI_ERR_P2M_DESC errors, but I see nothing wrong with the DMA
>    descriptor. Perhaps if someone with a solo datasheet can tell me the
>    possible causes of that error interrupt I might be able to figure it
>    out. It's just the DMA setup that does something wrong, the rest seems
>    fine.
> 
> 3) What is the meaning of this snippet of code in v4l2-enc.c?
> 
>         if (pix->priv)
>                 solo_enc->type = SOLO_ENC_TYPE_EXT;
> 
>    I've commented it out since it is completely undocumented and no driver
>    should assume that priv is non-zero anymore, precisely because of issues
>    like this. Ismael, do you know what the difference is between SOLO_ENC_TYPE_STD
>    and SOLO_ENC_TYPE_EXT?
> 
>    Update: I now know what this is, but this will require some research to get
>    this to work. Basically you can get two encoded streams out of the box: each
>    with different encoder settings (e.g. high and low bitrates). With the priv
>    field you would select which you set up. But this probably should be implemented
>    with an extra video node.
> 
> 4) There is a custom extension for motion detection. I left that part unchanged
>    as it doesn't look too bad, but I am unable to test it properly. I've
>    ordered a suitable CCTV camera from dealextreme, but that will take a few
>    weeks before I have it (dx.com is cheap, but delivery is quite slow). I'd
>    like to experiment a bit with this.
> 
> 5) The tw28* 'drivers' should really be split off as subdevice drivers, but
>    unfortunately I don't have a datasheet for the tw2815 (I found one for the
>    tw2864 though). If I ever get hold of a datasheet, then creating subdev
>    drivers for this would be nice.
> 
>    Update: I have now have a tw2815 datasheet.
> 
> 6) The kernel threads really should be replaced by workqueues.
> 
> So there is still work to be done, but at least the driver is in a much better
> state.
> 
> Regards,
> 
> 	Hans
> 
> 
> 
> The following changes since commit 457ba4ce4f435d0b4dd82a0acc6c796e541a2ea7:
> 
>   [media] bttv: move fini_bttv_i2c() from bttv-input.c to bttv-i2c.c (2013-03-05 17:11:12 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git solo
> 
> for you to fetch changes up to a3998bd98e5e68e303ddaf560bd621241c232449:
> 
>   solo6x10: add a proper solo6x10- prefix to the sources. (2013-03-08 13:41:01 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (21):
>       videobuf2: add gfp_flags.
>       vb2-dma-sg: add debug module option.
>       solo6x10: fix querycap.
>       solo6x10: add v4l2_device.
>       solo6x10: add control framework.
>       solo6x10: fix scheduling while atomic error.
>       solo6x10: fix various format-related compliancy issues.
>       solo6x10: add support for prio and control event handling.
>       solo6x10: move global fields in solo_enc_fh to solo_enc_dev.
>       solo6x10: move global fields in solo_dev_fh to solo_dev.
>       solo6x10: add missing size-- to enc_write_sg.
>       solo6x10: rename the spinlock 'lock' to 'slock'.
>       solo6x10: convert encoder nodes to vb2.
>       solo6x10: convert the display node to vb2.
>       solo6x10: use monotonic timestamps.
>       solo6x10: drop video_type and add proper s_std support.
>       solo6x10: update buffer flags to fix clash with existing flags.
>       solo6x10: use correct __GFP_DMA32 flags.
>       solo6x10: small big-endian fix.
>       solo6x10: also stop DMA if the SOLO_PCI_ERR_P2M_DESC is raised.
>       solo6x10: add a proper solo6x10- prefix to the sources.
> 
>  drivers/media/v4l2-core/videobuf2-core.c                           |    2 +-
>  drivers/media/v4l2-core/videobuf2-dma-contig.c                     |    5 +-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c                         |   22 +-
>  drivers/media/v4l2-core/videobuf2-vmalloc.c                        |    4 +-
>  drivers/staging/media/solo6x10/Kconfig                             |    2 +-
>  drivers/staging/media/solo6x10/Makefile                            |    4 +-
>  drivers/staging/media/solo6x10/{core.c => solo6x10-core.c}         |   10 +-
>  drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c}         |   10 +-
>  drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c}           |    6 +-
>  drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c}         |    2 +-
>  drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c}         |    0
>  drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c}           |    0
>  drivers/staging/media/solo6x10/{offsets.h => solo6x10-offsets.h}   |    0
>  drivers/staging/media/solo6x10/{osd-font.h => solo6x10-osd-font.h} |    0
>  drivers/staging/media/solo6x10/{p2m.c => solo6x10-p2m.c}           |    8 +-
>  drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h}    |    2 +-
>  drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c}         |   14 +-
>  drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h}         |    1 +
>  drivers/staging/media/solo6x10/{v4l2-enc.c => solo6x10-v4l2-enc.c} | 1024 ++++++++++++++++--------------------------------
>  drivers/staging/media/solo6x10/{v4l2.c => solo6x10-v4l2.c}         |  583 +++++++++++----------------
>  drivers/staging/media/solo6x10/solo6x10.h                          |   52 ++-
>  include/media/videobuf2-core.h                                     |   10 +-
>  22 files changed, 664 insertions(+), 1097 deletions(-)
>  rename drivers/staging/media/solo6x10/{core.c => solo6x10-core.c} (96%)
>  rename drivers/staging/media/solo6x10/{disp.c => solo6x10-disp.c} (96%)
>  rename drivers/staging/media/solo6x10/{enc.c => solo6x10-enc.c} (97%)
>  rename drivers/staging/media/solo6x10/{g723.c => solo6x10-g723.c} (99%)
>  rename drivers/staging/media/solo6x10/{gpio.c => solo6x10-gpio.c} (100%)
>  rename drivers/staging/media/solo6x10/{i2c.c => solo6x10-i2c.c} (100%)
>  rename drivers/staging/media/solo6x10/{offsets.h => solo6x10-offsets.h} (100%)
>  rename drivers/staging/media/solo6x10/{osd-font.h => solo6x10-osd-font.h} (100%)
>  rename drivers/staging/media/solo6x10/{p2m.c => solo6x10-p2m.c} (96%)
>  rename drivers/staging/media/solo6x10/{registers.h => solo6x10-regs.h} (99%)
>  rename drivers/staging/media/solo6x10/{tw28.c => solo6x10-tw28.c} (99%)
>  rename drivers/staging/media/solo6x10/{tw28.h => solo6x10-tw28.h} (97%)
>  rename drivers/staging/media/solo6x10/{v4l2-enc.c => solo6x10-v4l2-enc.c} (63%)
>  rename drivers/staging/media/solo6x10/{v4l2.c => solo6x10-v4l2.c} (56%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
