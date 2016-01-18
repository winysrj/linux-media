Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36601 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbcARPVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 10:21:01 -0500
Received: by mail-wm0-f42.google.com with SMTP id l65so103702523wmf.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 07:21:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569CE27F.6090702@xs4all.nl>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
Date: Mon, 18 Jan 2016 12:20:59 -0300
Message-ID: <CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	=?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 18 January 2016 at 10:02, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ezequiel,
>
> Thanks for working on this! Do you know where I can get a board tw686x board?
> I always like to have hardware to test the driver, if at all possible.
>

No, I don't know. I have one to spare, and I could send it to you.

> See below for a review of this driver.
>
> On 12/27/2015 03:26 AM, Ezequiel Garcia wrote:
>> This commit introduces the support for the Techwell TW686x video
>> capture IC. This hardware supports a few DMA modes, including
>> scatter-gather and frame (contiguous).
>>
>> This commit supports only DMA frame (contiguous) mode.
>> DMA scatter-gather mode support may be added in the future.
>>
>> Currently supported chips:
>> - TW6864 (4 video channels),
>> - TW6865 (4 video channels, not tested, second generation chip),
>> - TW6868 (8 video channels but only 4 first channels using
>>            built-in video decoder are supported, not tested),
>> - TW6869 (8 video channels, second generation chip).
>>
>> Cc: Krzysztof Hałasa <khalasa@piap.pl>
>> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
>> ---
>> This patchset superseeds Krzysztof's original patch:
>> https://patchwork.linuxtv.org/patch/30448/
>>
>> Tested on a custom TW6869-based capture card.
>> Latest v4l2-compliance test pass:
>>
>> $ /usr/bin/v4l2-compliance -f -s
>> Driver Info:
>>       Driver name   : tw686x
>>       Card type     : tw6869
>>       Bus info      : PCI:0000:04:00.0
>>       Driver version: 4.4.0
>>       Capabilities  : 0x85200001
>>               Video Capture
>>               Read/Write
>>               Streaming
>>               Extended Pix Format
>>               Device Capabilities
>>       Device Caps   : 0x05200001
>>               Video Capture
>>               Read/Write
>>               Streaming
>>               Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> [..]
>> Test input 0:
>>
>> Streaming ioctls:
>>       test read/write: OK
>>       test MMAP: OK
>>       test USERPTR: OK (Not Supported)
>>       test DMABUF: Cannot test, specify --expbuf-device
>>
>> Stream using all formats:
>>       test MMAP for Format UYVY, Frame Size 360x240:
>>               Stride 720, Field Interlaced: OK
>>       test MMAP for Format UYVY, Frame Size 720x480:
>>               Stride 1440, Field Interlaced: OK
>>       test MMAP for Format RGBP, Frame Size 360x240:
>>               Stride 720, Field Interlaced: OK
>>       test MMAP for Format RGBP, Frame Size 720x480:
>>               Stride 1440, Field Interlaced: OK
>>       test MMAP for Format YUYV, Frame Size 360x240:
>>               Stride 720, Field Interlaced: OK
>>       test MMAP for Format YUYV, Frame Size 720x480:
>>               Stride 1440, Field Interlaced: OK
>>
>> Total: 114, Succeeded: 114, Failed: 0, Warnings: 0
>> ---
>>  MAINTAINERS                             |   8 +
>>  drivers/media/pci/Kconfig               |   1 +
>>  drivers/media/pci/Makefile              |   1 +
>>  drivers/media/pci/tw686x/Kconfig        |  18 +
>>  drivers/media/pci/tw686x/Makefile       |   3 +
>>  drivers/media/pci/tw686x/tw686x-audio.c | 379 +++++++++++++
>>  drivers/media/pci/tw686x/tw686x-core.c  | 356 ++++++++++++
>>  drivers/media/pci/tw686x/tw686x-regs.h  | 118 ++++
>>  drivers/media/pci/tw686x/tw686x-video.c | 953 ++++++++++++++++++++++++++++++++
>>  drivers/media/pci/tw686x/tw686x.h       | 189 +++++++
>>  10 files changed, 2026 insertions(+)
>>  create mode 100644 drivers/media/pci/tw686x/Kconfig
>>  create mode 100644 drivers/media/pci/tw686x/Makefile
>>  create mode 100644 drivers/media/pci/tw686x/tw686x-audio.c
>>  create mode 100644 drivers/media/pci/tw686x/tw686x-core.c
>>  create mode 100644 drivers/media/pci/tw686x/tw686x-regs.h
>>  create mode 100644 drivers/media/pci/tw686x/tw686x-video.c
>>  create mode 100644 drivers/media/pci/tw686x/tw686x.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 4635e1d14612..9308f8242cd3 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -10846,6 +10846,14 @@ W:   https://linuxtv.org
>>  S:   Odd Fixes
>>  F:   drivers/media/pci/tw68/
>>
>> +TW686X VIDEO4LINUX DRIVER
>> +M:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
>> +L:   linux-media@vger.kernel.org
>> +T:   git git://linuxtv.org/media_tree.git
>> +W:   http://linuxtv.org
>> +S:   Maintained
>> +F:   drivers/media/pci/tw686x/
>> +
>>  TPM DEVICE DRIVER
>>  M:   Peter Huewe <peterhuewe@gmx.de>
>>  M:   Marcel Selhorst <tpmdd@selhorst.net>
>> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
>> index 48a611bc3e18..4f6467fbaeb4 100644
>> --- a/drivers/media/pci/Kconfig
>> +++ b/drivers/media/pci/Kconfig
>> @@ -14,6 +14,7 @@ source "drivers/media/pci/meye/Kconfig"
>>  source "drivers/media/pci/solo6x10/Kconfig"
>>  source "drivers/media/pci/sta2x11/Kconfig"
>>  source "drivers/media/pci/tw68/Kconfig"
>> +source "drivers/media/pci/tw686x/Kconfig"
>>  source "drivers/media/pci/zoran/Kconfig"
>>  endif
>>
>> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
>> index 5f8aacb8b9b8..2e54c36441f7 100644
>> --- a/drivers/media/pci/Makefile
>> +++ b/drivers/media/pci/Makefile
>> @@ -25,6 +25,7 @@ obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>>  obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
>>  obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
>>  obj-$(CONFIG_VIDEO_TW68) += tw68/
>> +obj-$(CONFIG_VIDEO_TW686X) += tw686x/
>>  obj-$(CONFIG_VIDEO_DT3155) += dt3155/
>>  obj-$(CONFIG_VIDEO_MEYE) += meye/
>>  obj-$(CONFIG_STA2X11_VIP) += sta2x11/
>> diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
>> new file mode 100644
>> index 000000000000..bd73d3dd25b4
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/Kconfig
>> @@ -0,0 +1,18 @@
>> +config VIDEO_TW686X
>> +     tristate "Intersil/Techwell TW686x video capture cards"
>> +     depends on PCI && VIDEO_DEV && VIDEO_V4L2 && SND
>> +     depends on HAS_DMA
>> +     select VIDEOBUF2_DMA_CONTIG
>> +     select SND_PCM
>> +     help
>> +       Support for Intersil/Techwell TW686x-based frame grabber cards.
>> +
>> +       Currently supported chips:
>> +       - TW6864 (4 video channels),
>> +       - TW6865 (4 video channels, not tested, second generation chip),
>> +       - TW6868 (8 video channels but only 4 first channels using
>> +         built-in video decoder are supported, not tested),
>> +       - TW6869 (8 video channels, second generation chip).
>> +
>> +       To compile this driver as a module, choose M here: the module
>> +       will be named tw686x.
>> diff --git a/drivers/media/pci/tw686x/Makefile b/drivers/media/pci/tw686x/Makefile
>> new file mode 100644
>> index 000000000000..99819542b733
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/Makefile
>> @@ -0,0 +1,3 @@
>> +tw686x-objs := tw686x-core.o tw686x-video.o tw686x-audio.o
>> +
>> +obj-$(CONFIG_VIDEO_TW686X) += tw686x.o
>> diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
>> new file mode 100644
>> index 000000000000..2295d2d1a945
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/tw686x-audio.c
>> @@ -0,0 +1,379 @@
>> +/*
>> + * Copyright (C) 2015 VanguardiaSur - www.vanguardiasur.com.ar
>> + *
>> + * Based on the audio support from the tw6869 driver:
>> + * Copyright 2015 www.starterkit.ru <info@starterkit.ru>
>> + *
>> + * Based on:
>> + * Driver for Intersil|Techwell TW6869 based DVR cards
>> + * (c) 2011-12 liran <jli11@intersil.com> [Intersil|Techwell China]
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/kmod.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pci.h>
>> +#include <linux/delay.h>
>> +
>> +#include <sound/core.h>
>> +#include <sound/initval.h>
>> +#include <sound/pcm.h>
>> +#include <sound/control.h>
>> +#include "tw686x.h"
>> +#include "tw686x-regs.h"
>> +
>> +#define AUDIO_CHANNEL_OFFSET 8
>> +
>> +void tw686x_audio_irq(struct tw686x_dev *dev, unsigned long requests,
>> +                   unsigned int pb_status)
>> +{
>> +     unsigned long flags;
>> +     unsigned int ch, pb;
>> +
>> +     for_each_set_bit(ch, &requests, max_channels(dev)) {
>> +
>
> Remove this empty line.
>

Sure.

>> +             struct tw686x_audio_channel *ac = &dev->audio_channels[ch];
>> +             struct tw686x_audio_buf *done = NULL;
>> +             struct tw686x_audio_buf *next = NULL;
>> +             struct tw686x_dma_desc *desc;
>> +
>> +             pb = !!(pb_status & BIT(AUDIO_CHANNEL_OFFSET + ch));
>> +
>> +             spin_lock_irqsave(&ac->lock, flags);
>> +
>> +             /* Sanity check */
>> +             if (!ac->ss || !ac->curr_bufs[0] || !ac->curr_bufs[1]) {
>> +                     spin_unlock_irqrestore(&ac->lock, flags);
>> +                     continue;
>> +             }
>> +
>> +             if (!list_empty(&ac->buf_list)) {
>> +                     next = list_first_entry(&ac->buf_list,
>> +                                     struct tw686x_audio_buf, list);
>> +                     list_move_tail(&next->list, &ac->buf_list);
>> +                     done = ac->curr_bufs[!pb];
>> +                     ac->curr_bufs[pb] = next;
>> +             }
>> +             spin_unlock_irqrestore(&ac->lock, flags);
>> +
>> +             desc = &ac->dma_descs[pb];
>> +             if (done && next && desc->virt) {
>> +                     memcpy(done->virt, desc->virt, desc->size);
>> +                     ac->ptr = done->dma - ac->buf[0].dma;
>> +                     snd_pcm_period_elapsed(ac->ss);
>> +             }
>> +     }
>> +}
>> +
>> +static int tw686x_pcm_hw_params(struct snd_pcm_substream *ss,
>> +                             struct snd_pcm_hw_params *hw_params)
>> +{
>> +     return snd_pcm_lib_malloc_pages(ss, params_buffer_bytes(hw_params));
>> +}
>> +
>> +static int tw686x_pcm_hw_free(struct snd_pcm_substream *ss)
>> +{
>> +     return snd_pcm_lib_free_pages(ss);
>> +}
>> +
>> +static const struct snd_pcm_hardware tw686x_capture_hw = {
>> +     .info                   = (SNDRV_PCM_INFO_MMAP |
>> +                                SNDRV_PCM_INFO_INTERLEAVED |
>> +                                SNDRV_PCM_INFO_BLOCK_TRANSFER |
>> +                                SNDRV_PCM_INFO_MMAP_VALID),
>> +     .formats                = SNDRV_PCM_FMTBIT_S16_LE,
>> +     .rates                  = SNDRV_PCM_RATE_8000_48000,
>> +     .rate_min               = 8000,
>> +     .rate_max               = 48000,
>> +     .channels_min           = 1,
>> +     .channels_max           = 1,
>> +     .buffer_bytes_max       = TW686X_AUDIO_PAGE_MAX * TW686X_PAGE_SIZE,
>> +     .period_bytes_min       = TW686X_PAGE_SIZE,
>> +     .period_bytes_max       = TW686X_PAGE_SIZE,
>> +     .periods_min            = 2,
>> +     .periods_max            = TW686X_AUDIO_PAGE_MAX,
>> +};
>> +
>> +static int tw686x_pcm_open(struct snd_pcm_substream *ss)
>> +{
>> +     struct tw686x_dev *dev = snd_pcm_substream_chip(ss);
>> +     struct tw686x_audio_channel *ac = &dev->audio_channels[ss->number];
>> +     struct snd_pcm_runtime *rt = ss->runtime;
>> +     int err;
>> +
>> +     ac->ss = ss;
>> +     rt->hw = tw686x_capture_hw;
>> +
>> +     err = snd_pcm_hw_constraint_integer(rt, SNDRV_PCM_HW_PARAM_PERIODS);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     return 0;
>> +}
>> +
>> +static int tw686x_pcm_close(struct snd_pcm_substream *ss)
>> +{
>> +     struct tw686x_dev *dev = snd_pcm_substream_chip(ss);
>> +     struct tw686x_audio_channel *ac = &dev->audio_channels[ss->number];
>> +
>> +     ac->ss = NULL;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_pcm_prepare(struct snd_pcm_substream *ss)
>> +{
>> +     struct tw686x_dev *dev = snd_pcm_substream_chip(ss);
>> +     struct tw686x_audio_channel *ac = &dev->audio_channels[ss->number];
>> +     struct snd_pcm_runtime *rt = ss->runtime;
>> +     unsigned int period_size = snd_pcm_lib_period_bytes(ss);
>> +     struct tw686x_audio_buf *p_buf, *b_buf;
>> +     unsigned long flags;
>> +     int i;
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     tw686x_disable_channel(dev, AUDIO_CHANNEL_OFFSET + ac->ch);
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +     if (dev->audio_rate != rt->rate) {
>> +             u32 reg;
>> +
>> +             dev->audio_rate = rt->rate;
>> +             reg = ((125000000 / rt->rate) << 16) +
>> +                    ((125000000 % rt->rate) << 16) / rt->rate;
>> +
>> +             reg_write(dev, AUDIO_CONTROL2, reg);
>> +     }
>> +
>> +     if ((period_size != TW686X_PAGE_SIZE) ||
>> +         (rt->periods < 2) || (rt->periods > TW686X_AUDIO_PAGE_MAX)) {
>
> There is no need for the extra parenthesis around simple comparisons.
>

OK.

>> +             return -EINVAL;
>> +     }
>> +
>> +     spin_lock_irqsave(&ac->lock, flags);
>> +     INIT_LIST_HEAD(&ac->buf_list);
>> +
>> +     for (i = 0; i < rt->periods; i++) {
>> +             ac->buf[i].dma = rt->dma_addr + period_size * i;
>> +             ac->buf[i].virt = rt->dma_area + period_size * i;
>> +             INIT_LIST_HEAD(&ac->buf[i].list);
>> +             list_add_tail(&ac->buf[i].list, &ac->buf_list);
>> +     }
>> +
>> +     p_buf = list_first_entry(&ac->buf_list, struct tw686x_audio_buf, list);
>> +     list_move_tail(&p_buf->list, &ac->buf_list);
>> +
>> +     b_buf = list_first_entry(&ac->buf_list, struct tw686x_audio_buf, list);
>> +     list_move_tail(&b_buf->list, &ac->buf_list);
>> +
>> +     ac->curr_bufs[0] = p_buf;
>> +     ac->curr_bufs[1] = b_buf;
>> +     ac->ptr = 0;
>> +     spin_unlock_irqrestore(&ac->lock, flags);
>> +
>> +     return 0;
>> +}
>> +
>> +static int tw686x_pcm_trigger(struct snd_pcm_substream *ss, int cmd)
>> +{
>> +     struct tw686x_dev *dev = snd_pcm_substream_chip(ss);
>> +     struct tw686x_audio_channel *ac = &dev->audio_channels[ss->number];
>> +     unsigned long flags;
>> +     int err = 0;
>> +
>> +     switch (cmd) {
>> +     case SNDRV_PCM_TRIGGER_START:
>> +             if (ac->curr_bufs[0] && ac->curr_bufs[1]) {
>> +                     spin_lock_irqsave(&dev->lock, flags);
>> +                     tw686x_enable_channel(dev, AUDIO_CHANNEL_OFFSET + ac->ch);
>> +                     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +                     mod_timer(&dev->dma_delay_timer,
>> +                               jiffies + msecs_to_jiffies(100));
>> +             } else {
>> +                     err = -EIO;
>> +             }
>> +             break;
>> +     case SNDRV_PCM_TRIGGER_STOP:
>> +             spin_lock_irqsave(&dev->lock, flags);
>> +             tw686x_disable_channel(dev, AUDIO_CHANNEL_OFFSET + ac->ch);
>> +             spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +             spin_lock_irqsave(&ac->lock, flags);
>> +             ac->curr_bufs[0] = NULL;
>> +             ac->curr_bufs[1] = NULL;
>> +             spin_unlock_irqrestore(&ac->lock, flags);
>> +             break;
>> +     default:
>> +             err = -EINVAL;
>> +     }
>> +     return err;
>> +}
>> +
>> +static snd_pcm_uframes_t tw686x_pcm_pointer(struct snd_pcm_substream *ss)
>> +{
>> +     struct tw686x_dev *dev = snd_pcm_substream_chip(ss);
>> +     struct tw686x_audio_channel *ac = &dev->audio_channels[ss->number];
>> +
>> +     return bytes_to_frames(ss->runtime, ac->ptr);
>> +}
>> +
>> +static struct snd_pcm_ops tw686x_pcm_ops = {
>> +     .open = tw686x_pcm_open,
>> +     .close = tw686x_pcm_close,
>> +     .ioctl = snd_pcm_lib_ioctl,
>> +     .hw_params = tw686x_pcm_hw_params,
>> +     .hw_free = tw686x_pcm_hw_free,
>> +     .prepare = tw686x_pcm_prepare,
>> +     .trigger = tw686x_pcm_trigger,
>> +     .pointer = tw686x_pcm_pointer,
>> +};
>> +
>> +static int tw686x_snd_pcm_init(struct tw686x_dev *dev)
>> +{
>> +     struct snd_card *card = dev->snd_card;
>> +     struct snd_pcm *pcm;
>> +     struct snd_pcm_substream *ss;
>> +     unsigned int i;
>> +     int err;
>> +
>> +     err = snd_pcm_new(card, card->driver, 0, 0, max_channels(dev), &pcm);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &tw686x_pcm_ops);
>> +     snd_pcm_chip(pcm) = dev;
>> +     pcm->info_flags = 0;
>> +     strcpy(pcm->name, "tw686x PCM");
>
> strlcpy
>

OK.

>> +
>> +     for (i = 0, ss = pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream;
>> +          ss; ss = ss->next, i++)
>> +             sprintf(ss->name, "vch%u audio", i);
>
> snprintf
>

OK.

>> +
>> +     return snd_pcm_lib_preallocate_pages_for_all(pcm,
>> +                             SNDRV_DMA_TYPE_DEV,
>> +                             snd_dma_pci_data(dev->pci_dev),
>> +                             TW686X_AUDIO_PAGE_MAX * TW686X_PAGE_SIZE,
>> +                             TW686X_AUDIO_PAGE_MAX * TW686X_PAGE_SIZE);
>> +}
>> +
>> +static void tw686x_audio_dma_free(struct tw686x_dev *dev,
>> +                               struct tw686x_audio_channel *ac)
>> +{
>> +     int pb;
>> +
>> +     for (pb = 0; pb < 2; pb++) {
>> +             if (!ac->dma_descs[pb].virt)
>> +                     continue;
>> +             pci_free_consistent(dev->pci_dev, ac->dma_descs[pb].size,
>> +                                 ac->dma_descs[pb].virt,
>> +                                 ac->dma_descs[pb].phys);
>> +             ac->dma_descs[pb].virt = NULL;
>> +     }
>> +}
>> +
>> +static int tw686x_audio_dma_alloc(struct tw686x_dev *dev,
>> +                               struct tw686x_audio_channel *ac)
>> +{
>> +     int pb;
>> +
>> +     for (pb = 0; pb < 2; pb++) {
>> +             u32 reg = pb ? ADMA_B_ADDR[ac->ch] : ADMA_P_ADDR[ac->ch];
>> +             void *virt;
>> +
>> +             virt = pci_alloc_consistent(dev->pci_dev, TW686X_PAGE_SIZE,
>> +                                         &ac->dma_descs[pb].phys);
>> +             if (!virt) {
>> +                     dev_err(&dev->pci_dev->dev,
>> +                             "dma%d: unable to allocate audio DMA %s-buffer\n",
>> +                             ac->ch, pb ? "B" : "P");
>> +                     return -ENOMEM;
>> +             }
>> +             ac->dma_descs[pb].virt = virt;
>> +             ac->dma_descs[pb].size = TW686X_PAGE_SIZE;
>> +             reg_write(dev, reg, ac->dma_descs[pb].phys);
>> +     }
>> +     return 0;
>> +}
>> +
>> +void tw686x_audio_free(struct tw686x_dev *dev)
>> +{
>> +     unsigned long flags;
>> +     u32 dma_ch_mask;
>> +     u32 dma_cmd;
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     dma_cmd = reg_read(dev, DMA_CMD);
>> +     dma_ch_mask = reg_read(dev, DMA_CHANNEL_ENABLE);
>> +     reg_write(dev, DMA_CMD, dma_cmd & ~0xff00);
>> +     reg_write(dev, DMA_CHANNEL_ENABLE, dma_ch_mask & ~0xff00);
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +     if (!dev->snd_card)
>> +             return;
>> +     snd_card_free(dev->snd_card);
>> +     dev->snd_card = NULL;
>> +}
>> +
>> +int tw686x_audio_init(struct tw686x_dev *dev)
>> +{
>> +     struct pci_dev *pci_dev = dev->pci_dev;
>> +     struct snd_card *card;
>> +     int err, ch;
>> +
>> +     /*
>> +      * AUDIO_CONTROL1
>> +      * DMA byte length [31:19] = 4096 (i.e. ALSA period)
>> +      * External audio enable [0] = enabled
>> +      */
>> +     reg_write(dev, AUDIO_CONTROL1, 0x80000001);
>> +
>> +     err = snd_card_new(&pci_dev->dev, SNDRV_DEFAULT_IDX1,
>> +                        SNDRV_DEFAULT_STR1,
>> +                        THIS_MODULE, 0, &card);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     dev->snd_card = card;
>> +     strcpy(card->driver, "tw686x");
>> +     strcpy(card->shortname, "tw686x");
>> +     sprintf(card->longname, "%s", pci_name(pci_dev));
>
> Use strlcpy and snprintf.
>

OK.

>> +     snd_card_set_dev(card, &pci_dev->dev);
>> +
>> +     for (ch = 0; ch < max_channels(dev); ch++) {
>> +             struct tw686x_audio_channel *ac;
>> +
>> +             ac = &dev->audio_channels[ch];
>> +             spin_lock_init(&ac->lock);
>> +             ac->dev = dev;
>> +             ac->ch = ch;
>> +
>> +             err = tw686x_audio_dma_alloc(dev, ac);
>> +             if (err < 0)
>> +                     goto err_cleanup;
>> +     }
>> +
>> +     err = tw686x_snd_pcm_init(dev);
>> +     if (err < 0)
>> +             goto err_cleanup;
>> +
>> +     err = snd_card_register(card);
>> +     if (!err)
>> +             return 0;
>> +
>> +err_cleanup:
>> +     for (ch = 0; ch < max_channels(dev); ch++) {
>> +             if (!dev->audio_channels[ch].dev)
>> +                     continue;
>> +             tw686x_audio_dma_free(dev, &dev->audio_channels[ch]);
>> +     }
>> +     snd_card_free(card);
>> +     dev->snd_card = NULL;
>> +     return err;
>> +}
>> diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
>> new file mode 100644
>> index 000000000000..8774facb29d5
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/tw686x-core.c
>> @@ -0,0 +1,356 @@
>> +/*
>> + * Copyright (C) 2015 VanguardiaSur - www.vanguardiasur.com.ar
>> + *
>> + * Based on original driver by Krzysztof Hałasa:
>> + * Copyright (C) 2015 Industrial Research Institute for Automation
>> + * and Measurements PIAP
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/delay.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/pci_ids.h>
>> +#include <linux/slab.h>
>> +#include <linux/timer.h>
>> +
>> +#include "tw686x.h"
>> +#include "tw686x-regs.h"
>> +
>> +static u32 dma_interval = 0x00098968;
>> +module_param(dma_interval, int, 0444);
>> +MODULE_PARM_DESC(dma_interval, "Minimum time span for DMA interrupting host");
>> +
>> +/*
>> + * The purpose of this awful hack is to avoid
>> + * enabling the DMA channels "too fast" which seems
>> + * to make some TW686x devices _very_ angry and freeze the CPU.
>> + */
>> +static void tw686x_dma_delay(unsigned long data)
>> +{
>> +        struct tw686x_dev *dev = (struct tw686x_dev *) data;
>
> Weird indentation, spaces instead of tab. Remove space after cast.
>

Ouch, I'll fix it.

>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +
>> +     reg_write(dev, DMA_CHANNEL_ENABLE, dev->pending_dma_en);
>> +     reg_write(dev, DMA_CMD, dev->pending_dma_cmd);
>> +     dev->pending_dma_en = 0;
>> +     dev->pending_dma_cmd = 0;
>> +
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +}
>> +
>> +static void tw686x_reset_channels(struct tw686x_dev *dev, unsigned int ch_mask)
>> +{
>> +     u32 dma_en, dma_cmd;
>> +
>> +     dma_en = reg_read(dev, DMA_CHANNEL_ENABLE);
>> +     dma_cmd = reg_read(dev, DMA_CMD);
>> +
>> +     /*
>> +      * Save pending register status, the timer will
>> +      * restore them.
>> +      */
>> +     dev->pending_dma_en |= dma_en;
>> +     dev->pending_dma_cmd |= dma_cmd;
>> +
>> +     /* Disable the reset channels */
>> +     reg_write(dev, DMA_CHANNEL_ENABLE, dma_en & ~ch_mask);
>> +
>> +     if ((dma_en & ~ch_mask) == 0) {
>> +             dev_dbg(&dev->pci_dev->dev, "reset: stopping DMA\n");
>> +             dma_cmd &= ~BIT(31);
>> +     }
>> +     reg_write(dev, DMA_CMD, dma_cmd & ~ch_mask);
>> +}
>> +
>> +static irqreturn_t tw686x_irq(int irq, void *dev_id)
>> +{
>> +     struct tw686x_dev *dev = (struct tw686x_dev *)dev_id;
>> +     unsigned int video_requests, audio_requests, reset_ch;
>> +     u32 fifo_status, fifo_signal, fifo_ov, fifo_bad, fifo_errors;
>> +     u32 int_status, dma_en, video_en, pb_status;
>> +     unsigned long flags;
>> +
>> +     int_status = reg_read(dev, INT_STATUS); /* cleared on read */
>> +     fifo_status = reg_read(dev, VIDEO_FIFO_STATUS);
>> +
>> +     /* INT_STATUS does not include FIFO_STATUS errors! */
>> +     if (!int_status && !TW686X_FIFO_ERROR(fifo_status))
>> +             return IRQ_NONE;
>> +
>> +     if (int_status & BIT(17)) {
>
> Either use a define for BIT(17) or add a comment so I know what bit 17 is.
>

Sure, I'll define it.

>> +             dev_dbg(&dev->pci_dev->dev,
>> +                     "DMA timeout. Resetting DMA for all channels\n");
>> +             reset_ch = ~0;
>> +             goto reset_channels;
>> +     }
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     dma_en = reg_read(dev, DMA_CHANNEL_ENABLE);
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +     video_en = dma_en & 0xff;
>> +     fifo_signal = ~(fifo_status & 0xff) & video_en;
>> +     fifo_ov = fifo_status >> 24;
>> +     fifo_bad = fifo_status >> 16;
>> +
>> +     /* Mask of channels with signal and FIFO errors */
>> +     fifo_errors = fifo_signal & (fifo_ov | fifo_bad);
>> +
>> +     reset_ch = 0;
>> +     pb_status = reg_read(dev, PB_STATUS);
>> +
>> +     /* Coalesce video frame/error events */
>> +     video_requests = (int_status & video_en) | fifo_errors;
>> +     audio_requests = (int_status & dma_en) >> 8;
>> +
>> +     if (video_requests)
>> +             tw686x_video_irq(dev, video_requests, pb_status,
>> +                              fifo_status, &reset_ch);
>> +     if (audio_requests)
>> +             tw686x_audio_irq(dev, audio_requests, pb_status);
>> +
>> +reset_channels:
>> +     if (reset_ch) {
>> +             spin_lock_irqsave(&dev->lock, flags);
>> +             tw686x_reset_channels(dev, reset_ch);
>> +             spin_unlock_irqrestore(&dev->lock, flags);
>> +             mod_timer(&dev->dma_delay_timer,
>> +                       jiffies + msecs_to_jiffies(100));
>> +     }
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static void tw686x_dev_release(struct v4l2_device *v4l2_dev)
>> +{
>> +        struct tw686x_dev *dev = container_of(v4l2_dev, struct tw686x_dev,
>> +                                           v4l2_dev);
>> +     unsigned int ch;
>> +
>> +     for (ch = 0; ch < max_channels(dev); ch++)
>> +             v4l2_ctrl_handler_free(&dev->video_channels[ch].ctrl_handler);
>> +
>> +     v4l2_device_unregister(&dev->v4l2_dev);
>> +
>> +     kfree(dev->audio_channels);
>> +     kfree(dev->video_channels);
>> +     kfree(dev);
>> +}
>> +
>> +static int tw686x_probe(struct pci_dev *pci_dev,
>> +                     const struct pci_device_id *pci_id)
>> +{
>> +     struct tw686x_dev *dev;
>> +     int err;
>> +
>> +     dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>> +     if (!dev)
>> +             return -ENOMEM;
>> +     dev->type = pci_id->driver_data;
>> +     sprintf(dev->name, "tw%04X", pci_dev->device);
>> +
>> +     dev->video_channels = kcalloc(max_channels(dev),
>> +             sizeof(*dev->video_channels), GFP_KERNEL);
>> +     if (!dev->video_channels) {
>> +             err = -ENOMEM;
>> +             goto free_dev;
>> +     }
>> +
>> +     dev->audio_channels = kcalloc(max_channels(dev),
>> +             sizeof(*dev->audio_channels), GFP_KERNEL);
>> +     if (!dev->audio_channels) {
>> +             err = -ENOMEM;
>> +             goto free_video;
>> +     }
>> +
>> +     pr_info("%s: PCI %s, IRQ %d, MMIO 0x%lx\n", dev->name,
>> +             pci_name(pci_dev), pci_dev->irq,
>> +             (unsigned long)pci_resource_start(pci_dev, 0));
>> +
>> +     dev->pci_dev = pci_dev;
>> +     if (pci_enable_device(pci_dev)) {
>> +             err = -EIO;
>> +             goto free_audio;
>> +     }
>> +
>> +     pci_set_master(pci_dev);
>> +     err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
>> +     if (err) {
>> +             dev_err(&pci_dev->dev, "32-bit PCI DMA not supported\n");
>> +             err = -EIO;
>> +             goto disable_pci;
>> +     }
>> +
>> +     err = pci_request_regions(pci_dev, dev->name);
>> +     if (err) {
>> +             dev_err(&pci_dev->dev, "unable to request PCI region\n");
>> +             goto disable_pci;
>> +     }
>> +
>> +     dev->mmio = pci_ioremap_bar(pci_dev, 0);
>> +     if (!dev->mmio) {
>> +             dev_err(&pci_dev->dev, "unable to remap PCI region\n");
>> +             err = -ENOMEM;
>> +             goto free_region;
>> +     }
>> +
>> +     /* Reset all subsystems */
>> +     reg_write(dev, SYS_SOFT_RST, 0x0F);
>
> The codingstyle for the kernel is to use lower case hex values, so 0x0f.
>
> Please change this throughout the source code.
>

Sure.

>> +     mdelay(1);
>> +
>> +     reg_write(dev, SRST[0], 0x3F);
>> +     if (max_channels(dev) > 4)
>> +             reg_write(dev, SRST[1], 0x3F);
>> +
>> +     /* Disable the DMA engine */
>> +     reg_write(dev, DMA_CMD, 0);
>> +     reg_write(dev, DMA_CHANNEL_ENABLE, 0);
>> +
>> +     /* Enable DMA FIFO overflow and pointer check */
>> +     reg_write(dev, DMA_CONFIG, 0xFFFFFF04);
>> +     reg_write(dev, DMA_CHANNEL_TIMEOUT, 0x140C8584);
>> +     reg_write(dev, DMA_TIMER_INTERVAL, dma_interval);
>> +
>> +     spin_lock_init(&dev->lock);
>> +
>> +     err = request_irq(pci_dev->irq, tw686x_irq, IRQF_SHARED,
>> +                       dev->name, dev);
>> +     if (err < 0) {
>> +             dev_err(&pci_dev->dev, "unable to request interrupt\n");
>> +             goto iounmap;
>> +     }
>> +
>> +     setup_timer(&dev->dma_delay_timer,
>> +                 tw686x_dma_delay, (unsigned long) dev);
>> +
>> +     /*
>> +      * This must be set right before initializing v4l2_dev.
>> +      * It's used to release resources after the last handle
>> +      * held is released.
>> +      */
>> +     dev->v4l2_dev.release = tw686x_dev_release;
>> +     err = tw686x_video_init(dev);
>> +     if (err) {
>> +             dev_err(&pci_dev->dev, "can't register video\n");
>> +             goto free_irq;
>> +     }
>> +
>> +     err = tw686x_audio_init(dev);
>> +     if (err) {
>> +             dev_warn(&pci_dev->dev, "can't register audio\n");
>> +     }
>> +
>> +     pci_set_drvdata(pci_dev, dev);
>> +     return 0;
>> +
>> +free_irq:
>> +     free_irq(pci_dev->irq, dev);
>> +iounmap:
>> +     pci_iounmap(pci_dev, dev->mmio);
>> +free_region:
>> +     pci_release_regions(pci_dev);
>> +disable_pci:
>> +     pci_disable_device(pci_dev);
>> +free_audio:
>> +     kfree(dev->audio_channels);
>> +free_video:
>> +     kfree(dev->video_channels);
>> +free_dev:
>> +     kfree(dev);
>> +     return err;
>> +}
>> +
>> +static void tw686x_remove(struct pci_dev *pci_dev)
>> +{
>> +     struct tw686x_dev *dev = pci_get_drvdata(pci_dev);
>> +     unsigned long flags;
>> +
>> +     /* This guarantees the IRQ handler is no longer running,
>> +      * which means we can kiss good-bye some resources.
>> +      */
>> +     free_irq(pci_dev->irq, dev);
>> +
>> +     tw686x_video_free(dev);
>> +     tw686x_audio_free(dev);
>> +     del_timer_sync(&dev->dma_delay_timer);
>> +
>> +     pci_iounmap(pci_dev, dev->mmio);
>> +     pci_release_regions(pci_dev);
>> +     pci_disable_device(pci_dev);
>> +
>> +     /*
>> +      * This allows to detect device is not here,
>> +      * and will be used by vb2_ops. The lock is really
>> +      * important here.
>> +      */
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     dev->pci_dev = NULL;
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>
> As you sure this is needed? Normally you can only come here if the module
> is removed, which isn't possible as long as userspace is using it. And if
> the module is removed, then vb2 shouldn't be called at all.
>
> The only exception would be if this is a hot-pluggable device, which is
> quite unlikely for a PCI device. I don't believe any of the pci drivers
> support that.
>

A previous version of the driver didn't have that. However, under certain
stress testing it was observed that the PCIe link goes down. I still have the
traces for that:

[..]
[21833.389031] pciehp 0000:13:01.0:pcie24: pcie_isr: intr_loc 100
[21833.389035] pciehp 0000:13:01.0:pcie24: Data Link Layer State change
[21833.389038] pciehp 0000:13:01.0:pcie24: slot(1-5): Link Down event
[21833.389076] pciehp 0000:13:01.0:pcie24: Disabling
domain:bus:device=0000:14:00
[21833.389078] pciehp 0000:13:01.0:pcie24: pciehp_unconfigure_device:
domain:bus:dev = 0000:14:00
[21833.389103] TW686x 0000:14:00.0: removing
[21833.416557] TW686x 0000:14:00.0: removed
[..]

I have no idea why the link goes down (hardware issue?),
but it's better to handle it gracefully :)

> Dubious code.
>
>> +
>> +        /*
>> +         * This calls tw686x_dev_release if it's the last reference.
>> +         * therwise, release is posponed until there are no users left.
>
> Typo: Otherwise ... postponed
>

Right.

>> +         */
>> +        v4l2_device_put(&dev->v4l2_dev);
>
> Again, spaces instead of tabs.
>

Will fix.

>> +}
>> +
>> +/*
>> + * On TW6864 and TW6868, all channels share the pair of video DMA SG tables,
>> + * with 10-bit start_idx and end_idx determining start and end of frame buffer
>> + * for particular channel.
>> + * TW6868 with all its 8 channels would be problematic (only 127 SG entries per
>> + * channel) but we support only 4 channels on this chip anyway (the first
>> + * 4 channels are driven with internal video decoder, the other 4 would require
>> + * an external TW286x part).
>> + *
>> + * On TW6865 and TW6869, each channel has its own DMA SG table, with indexes
>> + * starting with 0. Both chips have complete sets of internal video decoders
>> + * (respectively 4 or 8-channel).
>> + *
>> + * All chips have separate SG tables for two video frames.
>> + */
>> +
>> +/* driver_data is number of A/V channels */
>> +static const struct pci_device_id tw686x_pci_tbl[] = {
>> +     {
>> +             PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, 0x6864),
>> +             .driver_data = 4
>> +     },
>> +     {
>> +             PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, 0x6865), /* not tested */
>> +             .driver_data = 4 | TYPE_SECOND_GEN
>> +     },
>> +     /*
>> +      * TW6868 supports 8 A/V channels with an external TW2865 chip;
>> +      * not supported by the driver.
>> +      */
>> +     {
>> +             PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, 0x6868), /* not tested */
>> +             .driver_data = 4
>> +     },
>> +     {
>> +             PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, 0x6869),
>> +             .driver_data = 8 | TYPE_SECOND_GEN},
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(pci, tw686x_pci_tbl);
>> +
>> +static struct pci_driver tw686x_pci_driver = {
>> +     .name = "tw686x",
>> +     .id_table = tw686x_pci_tbl,
>> +     .probe = tw686x_probe,
>> +     .remove = tw686x_remove,
>> +};
>> +module_pci_driver(tw686x_pci_driver);
>> +
>> +MODULE_DESCRIPTION("Driver for video frame grabber cards based on Intersil/Techwell TW686[4589]");
>> +MODULE_AUTHOR("Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/media/pci/tw686x/tw686x-regs.h b/drivers/media/pci/tw686x/tw686x-regs.h
>> new file mode 100644
>> index 000000000000..92c331ceb065
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/tw686x-regs.h
>> @@ -0,0 +1,118 @@
>> +/* DMA controller registers */
>> +#define REG8_1(a0) ((const u16[8]){a0, a0 + 1, a0 + 2, a0 + 3,               \
>> +                                a0 + 4, a0 + 5, a0 + 6, a0 + 7})
>> +#define REG8_2(a0) ((const u16[8]){a0, a0 + 2, a0 + 4, a0 + 6,               \
>> +                                a0 + 8, a0 + 0xA, a0 + 0xC, a0 + 0xE})
>> +#define REG8_8(a0) ((const u16[8]){a0, a0 + 8, a0 + 0x10, a0 + 0x18, \
>> +                                a0 + 0x20, a0 + 0x28, a0 + 0x30, a0 + 0x38})
>> +#define INT_STATUS           0x00
>> +#define PB_STATUS            0x01
>> +#define DMA_CMD                      0x02
>> +#define VIDEO_FIFO_STATUS    0x03
>> +#define VIDEO_CHANNEL_ID     0x04
>> +#define VIDEO_PARSER_STATUS  0x05
>> +#define SYS_SOFT_RST         0x06
>> +#define DMA_PAGE_TABLE0_ADDR ((const u16[8]){0x08, 0xD0, 0xD2, 0xD4, \
>> +                                             0xD6, 0xD8, 0xDA, 0xDC})
>> +#define DMA_PAGE_TABLE1_ADDR ((const u16[8]){0x09, 0xD1, 0xD3, 0xD5, \
>> +                                             0xD7, 0xD9, 0xDB, 0xDD})
>> +#define DMA_CHANNEL_ENABLE   0x0a
>> +#define DMA_CONFIG           0x0b
>> +#define DMA_TIMER_INTERVAL   0x0c
>> +#define DMA_CHANNEL_TIMEOUT  0x0d
>> +#define VDMA_CHANNEL_CONFIG  REG8_1(0x10)
>> +#define ADMA_P_ADDR          REG8_2(0x18)
>> +#define ADMA_B_ADDR          REG8_2(0x19)
>> +#define DMA10_P_ADDR         0x28 /* ??? */
>> +#define DMA10_B_ADDR         0x29
>> +#define VIDEO_CONTROL1               0x2A
>> +#define VIDEO_CONTROL2               0x2B
>> +#define AUDIO_CONTROL1               0x2C
>> +#define AUDIO_CONTROL2               0x2D
>> +#define PHASE_REF            0x2E
>> +#define GPIO_REG             0x2F
>> +#define INTL_HBAR_CTRL               REG8_1(0x30)
>> +#define AUDIO_CONTROL3               0x38
>> +#define VIDEO_FIELD_CTRL     REG8_1(0x39)
>> +#define HSCALER_CTRL         REG8_1(0x42)
>> +#define VIDEO_SIZE           REG8_1(0x4A)
>> +#define VIDEO_SIZE_F2                REG8_1(0x52)
>> +#define MD_CONF                      REG8_1(0x60)
>> +#define MD_INIT                      REG8_1(0x68)
>> +#define MD_MAP0                      REG8_1(0x70)
>> +#define VDMA_P_ADDR          REG8_8(0x80) /* not used in DMA SG mode */
>> +#define VDMA_WHP             REG8_8(0x81)
>> +#define VDMA_B_ADDR          REG8_8(0x82)
>> +#define VDMA_F2_P_ADDR               REG8_8(0x84)
>> +#define VDMA_F2_WHP          REG8_8(0x85)
>> +#define VDMA_F2_B_ADDR               REG8_8(0x86)
>> +#define EP_REG_ADDR          0xFE
>> +#define EP_REG_DATA          0xFF
>> +
>> +/* Video decoder registers */
>> +#define VDREG8(a0) ((const u16[8]){                  \
>> +     a0 + 0x000, a0 + 0x010, a0 + 0x020, a0 + 0x030, \
>> +     a0 + 0x100, a0 + 0x110, a0 + 0x120, a0 + 0x130})
>> +#define VIDSTAT                      VDREG8(0x100)
>> +#define BRIGHT                       VDREG8(0x101)
>> +#define CONTRAST             VDREG8(0x102)
>> +#define SHARPNESS            VDREG8(0x103)
>> +#define SAT_U                        VDREG8(0x104)
>> +#define SAT_V                        VDREG8(0x105)
>> +#define HUE                  VDREG8(0x106)
>> +#define CROP_HI                      VDREG8(0x107)
>> +#define VDELAY_LO            VDREG8(0x108)
>> +#define VACTIVE_LO           VDREG8(0x109)
>> +#define HDELAY_LO            VDREG8(0x10A)
>> +#define HACTIVE_LO           VDREG8(0x10B)
>> +#define MVSN                 VDREG8(0x10C)
>> +#define STATUS2                      VDREG8(0x10C)
>> +#define SDT                  VDREG8(0x10E)
>> +#define SDT_EN                       VDREG8(0x10F)
>> +
>> +#define VSCALE_LO            VDREG8(0x144)
>> +#define SCALE_HI             VDREG8(0x145)
>> +#define HSCALE_LO            VDREG8(0x146)
>> +#define F2CROP_HI            VDREG8(0x147)
>> +#define F2VDELAY_LO          VDREG8(0x148)
>> +#define F2VACTIVE_LO         VDREG8(0x149)
>> +#define F2HDELAY_LO          VDREG8(0x14A)
>> +#define F2HACTIVE_LO         VDREG8(0x14B)
>> +#define F2VSCALE_LO          VDREG8(0x14C)
>> +#define F2SCALE_HI           VDREG8(0x14D)
>> +#define F2HSCALE_LO          VDREG8(0x14E)
>> +#define F2CNT                        VDREG8(0x14F)
>> +
>> +#define VDREG2(a0) ((const u16[2]){a0, a0 + 0x100})
>> +#define SRST                 VDREG2(0x180)
>> +#define ACNTL                        VDREG2(0x181)
>> +#define ACNTL2                       VDREG2(0x182)
>> +#define CNTRL1                       VDREG2(0x183)
>> +#define CKHY                 VDREG2(0x184)
>> +#define SHCOR                        VDREG2(0x185)
>> +#define CORING                       VDREG2(0x186)
>> +#define CLMPG                        VDREG2(0x187)
>> +#define IAGC                 VDREG2(0x188)
>> +#define VCTRL1                       VDREG2(0x18F)
>> +#define MISC1                        VDREG2(0x194)
>> +#define LOOP                 VDREG2(0x195)
>> +#define MISC2                        VDREG2(0x196)
>> +
>> +#define CLMD                 VDREG2(0x197)
>> +#define ANPWRDOWN            VDREG2(0x1ce)
>> +#define AIGAIN                       ((const u16[8]){0x1D0, 0x1D1, 0x1D2, 0x1D3, \
>> +                                             0x2D0, 0x2D1, 0x2D2, 0x2D3})
>> +
>> +#define SYS_MODE_DMA_SHIFT   13
>> +#define TW686X_VIDSTAT_HLOCK BIT(6)
>> +#define TW686X_VIDSTAT_VDLOSS        BIT(7)
>> +
>> +#define TW686X_STD_NTSC_M    0
>> +#define TW686X_STD_PAL               1
>> +#define TW686X_STD_SECAM     2
>> +#define TW686X_STD_NTSC_443  3
>> +#define TW686X_STD_PAL_M     4
>> +#define TW686X_STD_PAL_CN    5
>> +#define TW686X_STD_PAL_60    6
>> +
>> +#define TW686X_FIFO_ERROR(x) (x & ~(0xFF))
>> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
>> new file mode 100644
>> index 000000000000..7287a9de7a1a
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/tw686x-video.c
>> @@ -0,0 +1,953 @@
>> +/*
>> + * Copyright (C) 2015 VanguardiaSur - www.vanguardiasur.com.ar
>> + *
>> + * Based on original driver by Krzysztof Hałasa:
>> + * Copyright (C) 2015 Industrial Research Institute for Automation
>> + * and Measurements PIAP
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +#include "tw686x.h"
>> +#include "tw686x-regs.h"
>> +
>> +#define TW686X_INPUTS_PER_CH         4
>> +#define TW686X_VIDEO_WIDTH           720
>> +#define TW686X_VIDEO_HEIGHT(id)              ((id & V4L2_STD_625_50) ? 576 : 480)
>> +
>> +static const struct tw686x_format formats[] = {
>> +     {
>> +             .name = "4:2:2 packed, UYVY",
>> +             .fourcc = V4L2_PIX_FMT_UYVY,
>> +             .mode = 0,
>> +             .depth = 16,
>> +     }, {
>> +             .name = "16 bpp RGB",
>> +             .fourcc = V4L2_PIX_FMT_RGB565,
>> +             .mode = 5,
>> +             .depth = 16,
>> +     }, {
>> +             .name = "4:2:2 packed, YUYV",
>
> Drop name: these days this is filled in by the v4l2 core to ensure
> consistent naming.
>

OK.

>> +             .fourcc = V4L2_PIX_FMT_YUYV,
>> +             .mode = 6,
>> +             .depth = 16,
>> +     }
>> +};
>> +
>> +static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
>> +{
>> +     unsigned int map[15] = {
>> +             0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
>> +             0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
>> +             0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
>> +     };
>> +
>> +     unsigned int std_625_50[26] = {
>> +             0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
>> +                8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
>> +     };
>> +
>> +     unsigned int std_525_60[31] = {
>> +             0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
>> +                8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
>> +     };
>
> This can all be static const.
>

OK.

>> +
>> +     unsigned int i =
>> +             (std & V4L2_STD_625_50) ? std_625_50[fps] : std_525_60[fps];
>> +
>> +     return map[i];
>> +}
>> +
>> +static void tw686x_set_framerate(struct tw686x_video_channel *vc,
>> +                              unsigned int fps)
>> +{
>> +     unsigned int map;
>> +
>> +     if (vc->fps == fps)
>> +             return;
>> +
>> +     map = tw686x_fields_map(vc->video_standard, fps) << 1;
>> +     map |= map << 1;
>> +     if (map > 0)
>> +             map |= BIT(31);
>> +     reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], map);
>> +     vc->fps = fps;
>> +}
>> +
>> +static const struct tw686x_format *format_by_fourcc(unsigned fourcc)
>> +{
>> +     unsigned cnt;
>> +
>> +     for (cnt = 0; cnt < ARRAY_SIZE(formats); cnt++)
>> +             if (formats[cnt].fourcc == fourcc)
>> +                     return &formats[cnt];
>> +     return NULL;
>> +}
>> +
>> +static int tw686x_queue_setup(struct vb2_queue *vq,
>> +                           unsigned int *nbuffers, unsigned int *nplanes,
>> +                           unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +     struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
>> +     unsigned int szimage =
>> +             (vc->width * vc->height * vc->format->depth) >> 3;
>> +
>> +     /*
>> +      * Let's request at least three buffers: two for the
>> +      * DMA engine and one for userspace.
>> +      */
>> +     if (vq->num_buffers + *nbuffers < 3)
>> +             *nbuffers = 3 - vq->num_buffers;
>> +
>> +     if (*nplanes) {
>> +             if (*nplanes != 1 || sizes[0] < szimage)
>> +                     return -EINVAL;
>> +             return 0;
>> +     }
>> +
>> +     sizes[0] = szimage;
>> +     *nplanes = 1;
>> +     return 0;
>> +}
>> +
>> +static void tw686x_buf_queue(struct vb2_buffer *vb)
>> +{
>> +     struct tw686x_video_channel *vc = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct tw686x_dev *dev = vc->dev;
>> +     struct pci_dev *pci_dev;
>> +     unsigned long flags;
>> +     struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +     struct tw686x_v4l2_buf *buf =
>> +             container_of(vbuf, struct tw686x_v4l2_buf, vb);
>> +
>> +     /* Check device presence */
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     pci_dev = dev->pci_dev;
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +     if (!pci_dev) {
>> +             vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +             return;
>> +     }
>> +
>> +     spin_lock_irqsave(&vc->qlock, flags);
>> +     list_add_tail(&buf->list, &vc->vidq_queued);
>> +     spin_unlock_irqrestore(&vc->qlock, flags);
>> +}
>> +
>> +/*
>> + * We can call this even when alloc_dma failed for the given channel
>> + */
>> +static void tw686x_free_dma(struct tw686x_video_channel *vc, unsigned int pb)
>> +{
>> +     struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
>> +     struct tw686x_dev *dev = vc->dev;
>> +     struct pci_dev *pci_dev;
>> +     unsigned long flags;
>> +
>> +     /* Check device presence. Shouldn't really happen! */
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     pci_dev = dev->pci_dev;
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +     if (!pci_dev) {
>> +             WARN(1, "trying to deallocate on missing device\n");
>> +             return;
>> +     }
>
> Dubious code, as mentioned earlier.
>
>> +
>> +     if (desc->virt) {
>> +             pci_free_consistent(dev->pci_dev, desc->size,
>> +                                 desc->virt, desc->phys);
>> +             desc->virt = NULL;
>> +     }
>> +}
>> +
>> +static int tw686x_alloc_dma(struct tw686x_video_channel *vc, unsigned int pb)
>> +{
>> +     struct tw686x_dev *dev = vc->dev;
>> +     u32 reg = pb ? VDMA_B_ADDR[vc->ch] : VDMA_P_ADDR[vc->ch];
>> +     unsigned int len;
>> +     void *virt;
>> +
>> +     WARN(vc->dma_descs[pb].virt,
>> +          "Allocating buffer but previous still here\n");
>> +
>> +     len = (vc->width * vc->height * vc->format->depth) >> 3;
>> +     virt = pci_alloc_consistent(dev->pci_dev, len,
>> +                                 &vc->dma_descs[pb].phys);
>> +     if (!virt) {
>> +             v4l2_err(&dev->v4l2_dev, "dma%d: unable to allocate %s-buffer\n",
>> +                      vc->ch, pb ? "B" : "P");
>> +             return -ENOMEM;
>> +     }
>> +     vc->dma_descs[pb].size = len;
>> +     vc->dma_descs[pb].virt = virt;
>> +     reg_write(dev, reg, vc->dma_descs[pb].phys);
>> +
>> +     return 0;
>> +}
>> +
>> +static void tw686x_buffer_refill(struct tw686x_video_channel *vc, unsigned int pb)
>> +{
>> +     struct tw686x_v4l2_buf *buf;
>> +
>> +     while (!list_empty(&vc->vidq_queued)) {
>> +
>> +             buf = list_first_entry(&vc->vidq_queued,
>> +                     struct tw686x_v4l2_buf, list);
>> +             list_del(&buf->list);
>> +
>> +             vc->curr_bufs[pb] = buf;
>> +             return;
>> +     }
>> +     vc->curr_bufs[pb] = NULL;
>> +}
>> +
>> +static void tw686x_clear_queue(struct tw686x_video_channel *vc)
>> +{
>> +     unsigned int pb;
>> +
>> +     while (!list_empty(&vc->vidq_queued)) {
>> +             struct tw686x_v4l2_buf *buf;
>> +
>> +             buf = list_first_entry(&vc->vidq_queued,
>> +                     struct tw686x_v4l2_buf, list);
>> +             list_del(&buf->list);
>> +             vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +     }
>> +
>> +     for (pb = 0; pb < 2; pb++) {
>> +             if (vc->curr_bufs[pb])
>> +                     vb2_buffer_done(&vc->curr_bufs[pb]->vb.vb2_buf,
>> +                                     VB2_BUF_STATE_ERROR);
>> +             vc->curr_bufs[pb] = NULL;
>> +     }
>> +}
>> +
>> +static int tw686x_start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +     struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
>> +     struct tw686x_dev *dev = vc->dev;
>> +     struct pci_dev *pci_dev;
>> +     unsigned long flags;
>> +     int pb;
>> +
>> +     /* Check device presence */
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     pci_dev = dev->pci_dev;
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +     if (!pci_dev)
>> +             return -ENODEV;
>> +
>> +     spin_lock_irqsave(&vc->qlock, flags);
>> +
>> +     /* Sanity check */
>> +     if (!vc->dma_descs[0].virt || !vc->dma_descs[1].virt) {
>> +             spin_unlock_irqrestore(&vc->qlock, flags);
>> +             v4l2_err(&dev->v4l2_dev, "video%d: refusing to start without DMA buffers\n",
>> +                      vc->num);
>> +             return -ENOMEM;
>
> If start_streaming fails with an error, then you need to call vb2_buffer_done
> with status VB2_BUF_STATE_QUEUED for all buffers.
>

Ah, OK. Will fix it.

>> +     }
>> +
>> +     for (pb = 0; pb < 2; pb++)
>> +             tw686x_buffer_refill(vc, pb);
>> +     spin_unlock_irqrestore(&vc->qlock, flags);
>> +
>> +     vc->sequence = 0;
>> +     vc->pb = 0;
>> +
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     tw686x_enable_channel(dev, vc->ch);
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +
>> +     mod_timer(&dev->dma_delay_timer, jiffies + msecs_to_jiffies(100));
>> +
>> +     return 0;
>> +}
>> +
>> +static void tw686x_stop_streaming(struct vb2_queue *vq)
>> +{
>> +     struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
>> +     struct tw686x_dev *dev = vc->dev;
>> +     struct pci_dev *pci_dev;
>> +     unsigned long flags;
>> +
>> +     /* Check device presence */
>> +     spin_lock_irqsave(&dev->lock, flags);
>> +     pci_dev = dev->pci_dev;
>> +     spin_unlock_irqrestore(&dev->lock, flags);
>> +     if (pci_dev)
>> +             tw686x_disable_channel(dev, vc->ch);
>> +
>> +     spin_lock_irqsave(&vc->qlock, flags);
>> +     tw686x_clear_queue(vc);
>> +     spin_unlock_irqrestore(&vc->qlock, flags);
>> +}
>> +
>> +static int tw686x_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct tw686x_video_channel *vc = vb2_get_drv_priv(vb->vb2_queue);
>> +     unsigned int size =
>> +             (vc->width * vc->height * vc->format->depth) >> 3;
>> +
>> +     if (vb2_plane_size(vb, 0) < size)
>> +             return -EINVAL;
>> +     vb2_set_plane_payload(vb, 0, size);
>> +     return 0;
>> +}
>> +
>> +static struct vb2_ops tw686x_video_qops = {
>> +     .queue_setup            = tw686x_queue_setup,
>> +     .buf_queue              = tw686x_buf_queue,
>> +     .buf_prepare            = tw686x_buf_prepare,
>> +     .start_streaming        = tw686x_start_streaming,
>> +     .stop_streaming         = tw686x_stop_streaming,
>> +     .wait_prepare           = vb2_ops_wait_prepare,
>> +     .wait_finish            = vb2_ops_wait_finish,
>> +};
>> +
>> +static int tw686x_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +     struct tw686x_video_channel *vc;
>> +     struct tw686x_dev *dev;
>> +     unsigned ch;
>> +
>> +     vc = container_of(ctrl->handler, struct tw686x_video_channel,
>> +                       ctrl_handler);
>> +     dev = vc->dev;
>> +     ch = vc->ch;
>> +
>> +     switch (ctrl->id) {
>> +     case V4L2_CID_BRIGHTNESS:
>> +             reg_write(dev, BRIGHT[ch], ctrl->val & 0xFF);
>> +             return 0;
>> +
>> +     case V4L2_CID_CONTRAST:
>> +             reg_write(dev, CONTRAST[ch], ctrl->val);
>> +             return 0;
>> +
>> +     case V4L2_CID_SATURATION:
>> +             reg_write(dev, SAT_U[ch], ctrl->val);
>> +             reg_write(dev, SAT_V[ch], ctrl->val);
>> +             return 0;
>> +
>> +     case V4L2_CID_HUE:
>> +             reg_write(dev, HUE[ch], ctrl->val & 0xFF);
>> +             return 0;
>> +     }
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops ctrl_ops = {
>> +     .s_ctrl = tw686x_s_ctrl,
>> +};
>> +
>> +static int tw686x_g_fmt_vid_cap(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +
>> +     f->fmt.pix.width = vc->width;
>> +     f->fmt.pix.height = vc->height;
>> +     f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +     f->fmt.pix.pixelformat = vc->format->fourcc;
>> +     f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +     f->fmt.pix.bytesperline = (f->fmt.pix.width * vc->format->depth) / 8;
>> +     f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     unsigned int video_height = TW686X_VIDEO_HEIGHT(vc->video_standard);
>> +     const struct tw686x_format *format;
>> +
>> +     format = format_by_fourcc(f->fmt.pix.pixelformat);
>> +     if (!format) {
>> +             format = &formats[0];
>> +             f->fmt.pix.pixelformat = format->fourcc;
>> +     }
>> +
>> +     if (f->fmt.pix.width <= TW686X_VIDEO_WIDTH / 2)
>> +             f->fmt.pix.width = TW686X_VIDEO_WIDTH / 2;
>> +     else
>> +             f->fmt.pix.width = TW686X_VIDEO_WIDTH;
>> +
>> +     if (f->fmt.pix.height <= video_height / 2)
>> +             f->fmt.pix.height = video_height / 2;
>> +     else
>> +             f->fmt.pix.height = video_height;
>> +
>> +     f->fmt.pix.bytesperline = (f->fmt.pix.width * format->depth) / 8;
>> +     f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
>> +     f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +     f->fmt.pix.field = V4L2_FIELD_INTERLACED;
>> +
>> +     return 0;
>> +}
>> +
>> +static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
>> +                             struct v4l2_format *f)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     u32 val, width, line_width, height;
>> +     unsigned long bitsperframe;
>> +     int err, pb;
>> +
>> +     if (vb2_is_busy(&vc->vidq))
>> +             return -EBUSY;
>> +
>> +     bitsperframe = vc->width * vc->height * vc->format->depth;
>> +     err = tw686x_try_fmt_vid_cap(file, priv, f);
>> +     if (err)
>> +             return err;
>> +
>> +     vc->format = format_by_fourcc(f->fmt.pix.pixelformat);
>> +     vc->width = f->fmt.pix.width;
>> +     vc->height = f->fmt.pix.height;
>> +
>> +     /* We need new DMA buffers if the framesize has changed */
>> +     if (bitsperframe != vc->width * vc->height * vc->format->depth) {
>> +
>
> Remove empty line.
>

OK.

>> +             for (pb = 0; pb < 2; pb++)
>> +                     tw686x_free_dma(vc, pb);
>> +
>> +             for (pb = 0; pb < 2; pb++) {
>> +                     err = tw686x_alloc_dma(vc, pb);
>> +                     if (err) {
>> +                             if (pb > 0)
>> +                                     tw686x_free_dma(vc, 0);
>> +                             return err;
>> +                     }
>> +             }
>> +     }
>> +
>> +     val = reg_read(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch]);
>> +
>> +     if (vc->width <= TW686X_VIDEO_WIDTH / 2)
>> +             val |= BIT(23);
>> +     else
>> +             val &= ~BIT(23);
>> +
>> +     if (vc->height <= TW686X_VIDEO_HEIGHT(vc->video_standard) / 2)
>> +             val |= BIT(24);
>> +     else
>> +             val &= ~BIT(24);
>> +
>> +     val &= ~(0x7 << 20);
>> +     val |= vc->format->mode << 20;
>> +     reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
>> +
>> +     /* Program the DMA frame size */
>> +     width = (vc->width * 2) & 0x7ff;
>> +     height = vc->height / 2;
>> +     line_width = (vc->width * 2) & 0x7ff;
>> +     val = (height << 22) | (line_width << 11)  | width;
>> +     reg_write(vc->dev, VDMA_WHP[vc->ch], val);
>> +     return 0;
>> +}
>> +
>> +static int tw686x_querycap(struct file *file, void *priv,
>> +                        struct v4l2_capability *cap)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     struct tw686x_dev *dev = vc->dev;
>> +
>> +     strcpy(cap->driver, "tw686x");
>> +     strcpy(cap->card, dev->name);
>> +     sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci_dev));
>
> strlcpy and snprintf
>

Will fix.

>> +     cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +                        V4L2_CAP_READWRITE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     struct v4l2_format f;
>> +     u32 val, ret;
>> +
>> +     if (vc->video_standard == id)
>> +             return 0;
>> +
>> +     if (vb2_is_busy(&vc->vidq))
>> +             return -EBUSY;
>> +
>> +     if (id & V4L2_STD_NTSC)
>> +             val = 0;
>> +     else if (id & V4L2_STD_PAL)
>> +             val = 1;
>> +     else if (id & V4L2_STD_SECAM)
>> +             val = 2;
>> +     else if (id & V4L2_STD_NTSC_443)
>> +             val = 3;
>> +     else if (id & V4L2_STD_PAL_M)
>> +             val = 4;
>> +     else if (id & V4L2_STD_PAL_Nc)
>> +             val = 5;
>> +     else if (id & V4L2_STD_PAL_60)
>> +             val = 6;
>> +     else
>> +             return -EINVAL;
>> +
>> +     vc->video_standard = id;
>> +     reg_write(vc->dev, SDT[vc->ch], val);
>> +
>> +     val = reg_read(vc->dev, VIDEO_CONTROL1);
>> +     if (id & V4L2_STD_625_50)
>> +             val |= (1 << (SYS_MODE_DMA_SHIFT + vc->ch));
>> +     else
>> +             val &= ~(1 << (SYS_MODE_DMA_SHIFT + vc->ch));
>> +     reg_write(vc->dev, VIDEO_CONTROL1, val);
>> +
>> +     /*
>> +      * Adjust format after V4L2_STD_525_60/V4L2_STD_625_50 change,
>> +      * calling g_fmt and s_fmt will sanitize the height
>> +      * according to the standard.
>> +      */
>> +     ret = tw686x_g_fmt_vid_cap(file, priv, &f);
>> +     if (!ret)
>> +             tw686x_s_fmt_vid_cap(file, priv, &f);
>> +     return 0;
>> +}
>> +
>> +static int tw686x_querystd(struct file *file, void *priv, v4l2_std_id *std)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     struct tw686x_dev *dev = vc->dev;
>> +     unsigned int old_std, detected_std = 0;
>> +     unsigned long end;
>> +
>> +     if (vb2_is_streaming(&vc->vidq))
>> +             return -EBUSY;
>> +
>> +     /* Enable and start standard detection */
>> +     old_std = reg_read(dev, SDT[vc->ch]);
>> +     reg_write(dev, SDT[vc->ch], 0x7);
>> +     reg_write(dev, SDT_EN[vc->ch], 0xff);
>> +
>> +     end = jiffies + msecs_to_jiffies(500);
>> +     while (time_is_after_jiffies(end)) {
>> +
>> +             detected_std = reg_read(dev, SDT[vc->ch]);
>> +             if (!(detected_std & BIT(7)))
>> +                     break;
>> +             msleep(100);
>> +     }
>> +     reg_write(dev, SDT[vc->ch], old_std);
>> +
>> +     /* Exit if still busy */
>> +     if (detected_std & BIT(7))
>> +             return 0;
>> +
>> +     detected_std = (detected_std >> 4) & 0x7;
>> +     switch (detected_std) {
>> +     case TW686X_STD_NTSC_M:
>> +             *std &= V4L2_STD_NTSC;
>> +             break;
>> +     case TW686X_STD_NTSC_443:
>> +             *std &= V4L2_STD_NTSC_443;
>> +             break;
>> +     case TW686X_STD_PAL_M:
>> +             *std &= V4L2_STD_PAL_M;
>> +             break;
>> +     case TW686X_STD_PAL_60:
>> +             *std &= V4L2_STD_PAL_60;
>> +             break;
>> +     case TW686X_STD_PAL:
>> +             *std &= V4L2_STD_PAL;
>> +             break;
>> +     case TW686X_STD_PAL_CN:
>> +             *std &= V4L2_STD_PAL_Nc;
>> +             break;
>> +     case TW686X_STD_SECAM:
>> +             *std &= V4L2_STD_SECAM;
>> +             break;
>> +     default:
>> +             *std = 0;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int tw686x_g_std(struct file *file, void *priv, v4l2_std_id *id)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +
>> +     *id = vc->video_standard;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_enum_fmt_vid_cap(struct file *file, void *priv,
>> +                                struct v4l2_fmtdesc *f)
>> +{
>> +     if (f->index >= ARRAY_SIZE(formats))
>> +             return -EINVAL;
>> +
>> +     strlcpy(f->description, formats[f->index].name, sizeof(f->description));
>
> Drop this line, this is now done by the v4l2 core.
>

OK.

>> +     f->pixelformat = formats[f->index].fourcc;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_g_parm(struct file *file, void *priv,
>> +                      struct v4l2_streamparm *sp)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     struct v4l2_captureparm *cp = &sp->parm.capture;
>> +
>> +     if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +             return -EINVAL;
>> +     sp->parm.capture.readbuffers = 3;
>> +
>> +     cp->capability = V4L2_CAP_TIMEPERFRAME;
>> +     cp->timeperframe.numerator = 1;
>> +     cp->timeperframe.denominator = vc->fps;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_s_parm(struct file *file, void *priv,
>> +                      struct v4l2_streamparm *sp)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     struct v4l2_captureparm *cp = &sp->parm.capture;
>> +     unsigned int denominator = cp->timeperframe.denominator;
>> +     unsigned int numerator = cp->timeperframe.numerator;
>> +     unsigned int fps;
>> +
>> +     if (vb2_is_busy(&vc->vidq))
>> +             return -EBUSY;
>> +
>> +     fps = (!numerator || !denominator) ? 0 : denominator / numerator;
>> +     if (vc->video_standard & V4L2_STD_625_50)
>> +             fps = (!fps || fps > 25) ? 25 : fps;
>> +     else
>> +             fps = (!fps || fps > 30) ? 30 : fps;
>> +     tw686x_set_framerate(vc, fps);
>> +
>> +     return tw686x_g_parm(file, priv, sp);
>> +}
>
> Why do you need to implement g/s_parm? This is not typically done for SDTV
> capture devices since you cannot set it. And the v4l2 core will provide a
> default g_parm implementation that does the right thing. I think you can
> just delete these two functions.
>

Hm, I think it's a left over from the code this driver is based. I haven't
really used this ioctl.

>> +
>> +static int tw686x_s_input(struct file *file, void *priv, unsigned int i)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     u32 val;
>> +
>> +     if (i >= TW686X_INPUTS_PER_CH)
>> +             return -EINVAL;
>> +
>
> I would add this here:
>
>         if (i == vc->input)
>                 return 0;
>

Ah, right.

>> +     /*
>> +      * Not sure we are able to support on the fly input change
>> +      */
>> +     if (vb2_is_busy(&vc->vidq))
>> +             return -EBUSY;
>> +
>> +     vc->input = i;
>> +
>> +     val = reg_read(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch]);
>> +     val &= ~(0x3 << 30);
>> +     val |= i << 30;
>> +     reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
>> +     return 0;
>> +}
>> +
>> +static int tw686x_g_input(struct file *file, void *priv, unsigned int *i)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +
>> +     *i = vc->input;
>> +     return 0;
>> +}
>> +
>> +static int tw686x_enum_input(struct file *file, void *priv,
>> +                          struct v4l2_input *i)
>> +{
>> +     struct tw686x_video_channel *vc = video_drvdata(file);
>> +     unsigned int vidstat;
>> +
>> +     if (i->index >= TW686X_INPUTS_PER_CH)
>> +             return -EINVAL;
>> +
>> +     sprintf(i->name, "Composite%d", i->index);
>> +     i->type = V4L2_INPUT_TYPE_CAMERA;
>> +     i->std = vc->device->tvnorms;
>> +     i->capabilities = V4L2_IN_CAP_STD;
>> +
>> +     vidstat = reg_read(vc->dev, VIDSTAT[vc->ch]);
>> +     i->status = 0;
>> +     if (vidstat & TW686X_VIDSTAT_VDLOSS)
>> +             i->status |= V4L2_IN_ST_NO_SIGNAL;
>> +     if (!(vidstat & TW686X_VIDSTAT_HLOCK))
>> +             i->status |= V4L2_IN_ST_NO_H_LOCK;
>> +
>> +     return 0;
>> +}
>> +
>> +const struct v4l2_file_operations tw686x_video_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = v4l2_fh_open,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .release        = vb2_fop_release,
>> +     .poll           = vb2_fop_poll,
>> +     .read           = vb2_fop_read,
>> +     .mmap           = vb2_fop_mmap,
>> +};
>> +
>> +const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
>> +     .vidioc_querycap                = tw686x_querycap,
>> +     .vidioc_g_fmt_vid_cap           = tw686x_g_fmt_vid_cap,
>> +     .vidioc_s_fmt_vid_cap           = tw686x_s_fmt_vid_cap,
>> +     .vidioc_enum_fmt_vid_cap        = tw686x_enum_fmt_vid_cap,
>> +     .vidioc_try_fmt_vid_cap         = tw686x_try_fmt_vid_cap,
>> +
>> +     .vidioc_querystd                = tw686x_querystd,
>> +     .vidioc_g_std                   = tw686x_g_std,
>> +     .vidioc_s_std                   = tw686x_s_std,
>> +
>> +     .vidioc_g_parm                  = tw686x_g_parm,
>> +     .vidioc_s_parm                  = tw686x_s_parm,
>> +
>> +     .vidioc_enum_input              = tw686x_enum_input,
>> +     .vidioc_g_input                 = tw686x_g_input,
>> +     .vidioc_s_input                 = tw686x_s_input,
>> +
>> +     .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>> +     .vidioc_querybuf                = vb2_ioctl_querybuf,
>> +     .vidioc_qbuf                    = vb2_ioctl_qbuf,
>> +     .vidioc_dqbuf                   = vb2_ioctl_dqbuf,
>> +     .vidioc_create_bufs             = vb2_ioctl_create_bufs,
>> +     .vidioc_streamon                = vb2_ioctl_streamon,
>> +     .vidioc_streamoff               = vb2_ioctl_streamoff,
>> +
>> +     .vidioc_log_status              = v4l2_ctrl_log_status,
>> +     .vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
>> +     .vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
>> +};
>> +
>> +static void tw686x_buffer_copy(struct tw686x_video_channel *vc,
>> +                            unsigned int pb, struct vb2_v4l2_buffer *vb)
>> +{
>> +     struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
>> +     struct vb2_buffer *vb2_buf = &vb->vb2_buf;
>> +
>> +     vb->field = V4L2_FIELD_INTERLACED;
>> +     vb->sequence = vc->sequence++;
>> +
>> +     memcpy(vb2_plane_vaddr(vb2_buf, 0), desc->virt, desc->size);
>> +     vb2_buf->timestamp = ktime_get_ns();
>> +     vb2_buffer_done(vb2_buf, VB2_BUF_STATE_DONE);
>> +}
>> +
>> +void tw686x_video_irq(struct tw686x_dev *dev, unsigned long requests,
>> +                   unsigned int pb_status, unsigned int fifo_status,
>> +                   unsigned int *reset_ch)
>> +{
>> +     struct tw686x_video_channel *vc;
>> +     struct vb2_v4l2_buffer *vb;
>> +     unsigned long flags;
>> +     unsigned int ch, pb;
>> +
>> +     for_each_set_bit(ch, &requests, max_channels(dev)) {
>> +
>
> Remove empty line.
>

OK.

>> +             vc = &dev->video_channels[ch];
>> +
>> +             /*
>> +              * This can either be a blue frame (with signal-lost bit set)
>> +              * or a good frame (with signal-lost bit clear). If we have just
>> +              * got signal, then this channel needs resetting.
>> +              */
>> +             if (vc->no_signal && !(fifo_status & BIT(ch))) {
>> +                     v4l2_printk(KERN_DEBUG, &dev->v4l2_dev,
>> +                                 "video%d: signal recovered\n", vc->num);
>> +                     vc->no_signal = false;
>> +                     *reset_ch |= BIT(ch);
>> +                     vc->pb = 0;
>> +                     continue;
>> +             }
>> +             vc->no_signal = !!(fifo_status & BIT(ch));
>> +
>> +             /* Check FIFO errors only if there's signal */
>> +             if (!vc->no_signal) {
>> +                     u32 fifo_ov, fifo_bad;
>> +
>> +                     fifo_ov = (fifo_status >> 24) & BIT(ch);
>> +                     fifo_bad = (fifo_status >> 16) & BIT(ch);
>> +                     if (fifo_ov || fifo_bad) {
>> +                             /* Mark this channel for reset */
>> +                             v4l2_printk(KERN_DEBUG, &dev->v4l2_dev, "video%d: FIFO error\n", vc->num);
>> +                             *reset_ch |= BIT(ch);
>> +                             vc->pb = 0;
>> +                             continue;
>> +                     }
>> +             }
>> +
>> +             pb = !!(pb_status & BIT(ch));
>> +             if (vc->pb != pb) {
>> +                     /* Mark this channel for reset */
>> +                     v4l2_printk(KERN_DEBUG, &dev->v4l2_dev,
>> +                                 "video%d: unexpected p-b buffer!\n", vc->num);
>> +                     *reset_ch |= BIT(ch);
>> +                     vc->pb = 0;
>> +                     continue;
>> +             }
>> +
>> +             /* handle video stream */
>> +             spin_lock_irqsave(&vc->qlock, flags);
>> +             if (vc->curr_bufs[pb]) {
>> +                     vb = &vc->curr_bufs[pb]->vb;
>> +                     tw686x_buffer_copy(vc, pb, vb);
>
> You have to copy the data? It's not possible the program the DMA so that
> it DMAs into the buffer itself? That's quite unusual for a PCI device.
>

Yes, it's possible and I spent an enormous amount of time trying to make it work
(originally using scatter-gather mode, and then with frame mode).

However, despite my many efforts it always stucked (sooner or later in
the tests)
into a hard machine freeze. There are two apparent sources for the freeze:

(1) To make the above work you need to program the registers so the chip DMAs
into a new buffer each time the current DMA buffer is completed.

(2) Also, when a signal error is detected and/or signal is lost and recovered,
the DMA channels are re-programmed as well.

It was only when all the registers write got removed and minimized to the bare
minimum (registers are written before streaming starts and then stay mostly
untouched) that I got a stable driver working fine for several weeks.

The ugly delay timer is meant to mitigate (2). And the buffer copy is
to workaround (1).

Chip and board vendors couldn't provide any explanation for this
behavior. I have
two different boards (one with 1-chip, one with 2-chips and a PCIe switch),
and the issues are present on both.

In any case, the vendor's Windows driver does the similar buffer-copy.

I understand that on some platforms this implementation could be too
costly (it's
completely cheap on any modern x86), and I intend to provide some option
to provide "frame DMA-to-buffer" and "scatter-gather DMA".

However, I wanted to get this basic version merged first.

(Sorry, I should have included all this in the cover letter since
it was pretty obvious you would ask :)

>> +             }
>> +             vc->pb = !pb;
>> +             tw686x_buffer_refill(vc, pb);
>> +             spin_unlock_irqrestore(&vc->qlock, flags);
>> +     }
>> +}
>> +
>> +void tw686x_video_free(struct tw686x_dev *dev)
>> +{
>> +     unsigned int ch, pb;
>> +
>> +     for (ch = 0; ch < max_channels(dev); ch++) {
>> +             struct tw686x_video_channel *vc = &dev->video_channels[ch];
>> +
>> +             if (vc->device)
>> +                     video_unregister_device(vc->device);
>> +
>> +             for (pb = 0; pb < 2; pb++)
>> +                     tw686x_free_dma(vc, pb);
>> +     }
>> +}
>> +
>> +int tw686x_video_init(struct tw686x_dev *dev)
>> +{
>> +     unsigned int ch, val, pb;
>> +     int err;
>> +
>> +     err = v4l2_device_register(&dev->pci_dev->dev, &dev->v4l2_dev);
>> +     if (err)
>> +             return err;
>> +
>> +     for (ch = 0; ch < max_channels(dev); ch++) {
>> +             struct tw686x_video_channel *vc = &dev->video_channels[ch];
>> +             struct video_device *vdev;
>> +
>> +             mutex_init(&vc->vb_mutex);
>> +             spin_lock_init(&vc->qlock);
>> +             INIT_LIST_HEAD(&vc->vidq_queued);
>> +
>> +             vc->dev = dev;
>> +             vc->ch = ch;
>> +
>> +             /* default settings */
>> +             vc->format = &formats[0];
>> +             vc->video_standard = V4L2_STD_NTSC;
>> +             vc->width = TW686X_VIDEO_WIDTH;
>> +             vc->height = TW686X_VIDEO_HEIGHT(vc->video_standard);
>> +             vc->input = 0;
>> +
>> +             reg_write(vc->dev, SDT[ch], 0);
>> +             tw686x_set_framerate(vc, 30);
>> +
>> +             reg_write(dev, VDELAY_LO[ch], 0x14);
>> +             reg_write(dev, HACTIVE_LO[ch], 0xD0);
>> +             reg_write(dev, VIDEO_SIZE[ch], 0);
>> +
>> +             for (pb = 0; pb < 2; pb++) {
>> +                     err = tw686x_alloc_dma(vc, pb);
>> +                     if (err)
>> +                             goto error;
>> +             }
>> +
>> +             vdev = video_device_alloc();
>> +             if (!vdev) {
>> +                     v4l2_err(&dev->v4l2_dev, "dma%d: unable to allocate device\n", ch);
>> +                     err = -ENOMEM;
>> +                     goto error;
>> +             }
>> +
>> +             vc->vidq.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
>> +             vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +             vc->vidq.drv_priv = vc;
>> +             vc->vidq.buf_struct_size = sizeof(struct tw686x_v4l2_buf);
>> +             vc->vidq.ops = &tw686x_video_qops;
>> +             vc->vidq.mem_ops = &vb2_vmalloc_memops;
>> +             vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +             vc->vidq.min_buffers_needed = 2;
>> +             vc->vidq.lock = &vc->vb_mutex;
>> +
>> +             err = vb2_queue_init(&vc->vidq);
>> +             if (err)
>> +                     goto error;
>> +
>> +             snprintf(vdev->name, sizeof(vdev->name), "%s video", dev->name);
>> +             vdev->fops = &tw686x_video_fops;
>> +             vdev->ioctl_ops = &tw686x_video_ioctl_ops;
>> +             vdev->release = video_device_release;
>> +             vdev->v4l2_dev = &dev->v4l2_dev;
>> +             vdev->queue = &vc->vidq;
>> +             vdev->tvnorms = V4L2_STD_525_60 | V4L2_STD_625_50;
>> +             vdev->minor = -1;
>> +             vdev->lock = &vc->vb_mutex;
>> +             vc->device = vdev;
>> +             video_set_drvdata(vdev, vc);
>> +             err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>> +             if (err < 0)
>> +                     goto error;
>
> Move this down to the end of the loop. Userspace can use the video device
> as soon as it is created, so it is wise to create it only after everything
> else has been configured.
>

OK.

>> +             vc->num = vdev->num;
>> +
>> +             err = v4l2_ctrl_handler_init(&vc->ctrl_handler, 4);
>> +             if (err) {
>> +                     v4l2_err(&dev->v4l2_dev,
>> +                              "video%d: cannot init ctrl handler\n",
>> +                              vc->num);
>> +                     goto error;
>> +             }
>> +             vdev->ctrl_handler = &vc->ctrl_handler;
>> +             v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
>> +                               V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
>> +             v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
>> +                               V4L2_CID_CONTRAST, 0, 255, 1, 100);
>> +             v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
>> +                               V4L2_CID_SATURATION, 0, 255, 1, 128);
>> +             v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
>> +                               V4L2_CID_HUE, -128, 127, 1, 0);
>> +             err = vc->ctrl_handler.error;
>> +             if (err)
>> +                     goto error;
>> +
>> +             err = v4l2_ctrl_handler_setup(&vc->ctrl_handler);
>> +             if (err)
>> +                     goto error;
>> +     }
>> +
>> +     /* Set DMA frame mode on all channels. Only supported mode for now. */
>> +     val = TW686X_DEF_PHASE_REF;
>> +     for (ch = 0; ch < max_channels(dev); ch++)
>> +             val |= TW686X_FRAME_MODE << (16 + ch * 2);
>> +     reg_write(dev, PHASE_REF, val);
>> +
>> +     reg_write(dev, MISC2[0], 0xE7);
>> +     reg_write(dev, VCTRL1[0], 0xCC);
>> +     reg_write(dev, LOOP[0], 0xA5);
>> +     if (max_channels(dev) > 4) {
>> +             reg_write(dev, VCTRL1[1], 0xCC);
>> +             reg_write(dev, LOOP[1], 0xA5);
>> +             reg_write(dev, MISC2[1], 0xE7);
>> +     }
>> +     return 0;
>> +
>> +error:
>> +     tw686x_video_free(dev);
>> +     return err;
>> +}
>> diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
>> new file mode 100644
>> index 000000000000..0ffb0be84aa2
>> --- /dev/null
>> +++ b/drivers/media/pci/tw686x/tw686x.h
>> @@ -0,0 +1,189 @@
>> +/*
>> + * Copyright (C) 2015 VanguardiaSur - www.vanguardiasur.com.ar
>> + *
>> + * Copyright (C) 2015 Industrial Research Institute for Automation
>> + * and Measurements PIAP
>> + * Written by Krzysztof Hałasa
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/mutex.h>
>> +#include <linux/pci.h>
>> +#include <linux/timer.h>
>> +#include <linux/videodev2.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <sound/pcm.h>
>> +
>> +#include "tw686x-regs.h"
>> +
>> +#define TYPE_MAX_CHANNELS    0x0F
>> +#define TYPE_SECOND_GEN              0x10
>> +#define TW686X_DEF_PHASE_REF 0x1518
>> +
>> +#define TW686X_FIELD_MODE    0x3
>> +#define TW686X_FRAME_MODE    0x2
>> +/* 0x1 is reserved */
>> +#define TW686X_SG_MODE               0x0
>> +
>> +#define TW686X_PAGE_SIZE     4096
>> +#define TW686X_AUDIO_PAGE_MAX        16
>> +
>> +struct tw686x_format {
>> +     char *name;
>> +     unsigned fourcc;
>> +     unsigned depth;
>> +     unsigned mode;
>> +};
>> +
>> +struct tw686x_dma_desc {
>> +     dma_addr_t phys;
>> +     void *virt;
>> +     unsigned size;
>> +};
>> +
>> +struct tw686x_audio_buf {
>> +     dma_addr_t dma;
>> +     void *virt;
>> +     struct list_head list;
>> +};
>> +
>> +struct tw686x_v4l2_buf {
>> +     struct vb2_v4l2_buffer vb;
>> +     struct list_head list;
>> +};
>> +
>> +struct tw686x_audio_channel {
>> +     struct tw686x_dev *dev;
>> +     struct snd_pcm_substream *ss;
>> +     unsigned int ch;
>> +     struct tw686x_audio_buf *curr_bufs[2];
>> +     struct tw686x_dma_desc dma_descs[2];
>> +     dma_addr_t ptr;
>> +
>> +     struct tw686x_audio_buf buf[TW686X_AUDIO_PAGE_MAX];
>> +     struct list_head buf_list;
>> +     spinlock_t lock;
>> +};
>> +
>> +struct tw686x_video_channel {
>> +     struct tw686x_dev *dev;
>> +
>> +     struct vb2_queue vidq;
>> +     struct list_head vidq_queued;
>> +     struct video_device *device;
>> +     struct tw686x_v4l2_buf *curr_bufs[2];
>> +     struct tw686x_dma_desc dma_descs[2];
>> +
>> +     struct v4l2_ctrl_handler ctrl_handler;
>> +     const struct tw686x_format *format;
>> +     struct mutex vb_mutex;
>> +     spinlock_t qlock;
>> +     v4l2_std_id video_standard;
>> +     unsigned int width, height;
>> +     unsigned int h_halve, v_halve;
>> +     unsigned int ch;
>> +     unsigned int num;
>> +     unsigned int fps;
>> +     unsigned int input;
>> +     unsigned int sequence;
>> +     unsigned int pb;
>> +     bool no_signal;
>> +};
>> +
>> +/**
>> + * struct tw686x_dev - global device status
>> + * @lock: spinlock controlling access to the
>> + *        shared device registers (DMA enable/disable).
>> + */
>> +struct tw686x_dev {
>> +     spinlock_t lock;
>> +
>> +     struct v4l2_device v4l2_dev;
>> +     struct snd_card *snd_card;
>> +
>> +     char name[32];
>> +     unsigned int type;
>> +     struct pci_dev *pci_dev;
>> +     __u32 __iomem *mmio;
>> +
>> +     void *alloc_ctx;
>> +
>> +     struct tw686x_video_channel *video_channels;
>> +     struct tw686x_audio_channel *audio_channels;
>> +
>> +     int audio_rate; /* per-device value */
>> +
>> +     struct timer_list dma_delay_timer;
>> +     u32 pending_dma_en; /* must be protected by lock */
>> +     u32 pending_dma_cmd; /* must be protected by lock */
>> +};
>> +
>> +static inline uint32_t reg_read(struct tw686x_dev *dev, unsigned reg)
>> +{
>> +     return readl(dev->mmio + reg);
>> +}
>> +
>> +static inline void reg_write(struct tw686x_dev *dev, unsigned reg,
>> +                          uint32_t value)
>> +{
>> +     writel(value, dev->mmio + reg);
>> +}
>> +
>> +static inline void tw686x_disable_channel(struct tw686x_dev *dev,
>> +                                       unsigned int channel)
>> +{
>> +     u32 dma_en = reg_read(dev, DMA_CHANNEL_ENABLE);
>> +     u32 dma_cmd = reg_read(dev, DMA_CMD);
>> +
>> +     dma_en &= ~BIT(channel);
>> +     dma_cmd &= ~BIT(channel);
>> +
>> +     /* Must remove it from pending too */
>> +     dev->pending_dma_en &= ~BIT(channel);
>> +     dev->pending_dma_cmd &= ~BIT(channel);
>> +
>> +     /* Stop DMA if no channels are enabled */
>> +     if (!dma_en)
>> +             dma_cmd = 0;
>> +     reg_write(dev, DMA_CHANNEL_ENABLE, dma_en);
>> +     reg_write(dev, DMA_CMD, dma_cmd);
>> +}
>> +
>> +static inline void tw686x_enable_channel(struct tw686x_dev *dev,
>> +                                      unsigned int channel)
>> +{
>> +     u32 dma_en = reg_read(dev, DMA_CHANNEL_ENABLE);
>> +     u32 dma_cmd = reg_read(dev, DMA_CMD);
>> +
>> +     dev->pending_dma_en |= dma_en | BIT(channel);
>> +     dev->pending_dma_cmd |= dma_cmd | BIT(31) | BIT(channel);
>> +}
>
> I think these should be normal functions. I see no reason for en/disabling
> channel to be inline.
>

OK.

>> +
>> +static inline unsigned max_channels(struct tw686x_dev *dev)
>> +{
>> +     return dev->type & TYPE_MAX_CHANNELS; /* 4 or 8 channels */
>> +}
>> +
>> +static inline unsigned is_second_gen(struct tw686x_dev *dev)
>> +{
>> +     /* each channel has its own DMA SG table */
>> +     return dev->type & TYPE_SECOND_GEN;
>> +}
>> +
>> +int tw686x_video_init(struct tw686x_dev *dev);
>> +void tw686x_video_free(struct tw686x_dev *dev);
>> +void tw686x_video_irq(struct tw686x_dev *dev, unsigned long requests,
>> +                   unsigned int pb_status, unsigned int fifo_status,
>> +                   unsigned int *reset_ch);
>> +
>> +int tw686x_audio_init(struct tw686x_dev *dev);
>> +void tw686x_audio_free(struct tw686x_dev *dev);
>> +void tw686x_audio_irq(struct tw686x_dev *dev, unsigned long requests,
>> +                   unsigned int pb_status);
>>
>
> Regards,
>
>         Hans

Thanks a lot for the thorough review!

-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
