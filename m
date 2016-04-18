Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36671 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbcDRSFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 14:05:38 -0400
Received: by mail-ob0-f172.google.com with SMTP id j9so100995922obd.3
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 11:05:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459550307-688-5-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1459550307-688-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<1459550307-688-5-git-send-email-ezequiel@vanguardiasur.com.ar>
Date: Mon, 18 Apr 2016 11:05:37 -0700
Message-ID: <CAJ+vNU2bJK1HJKtvS28Fn3QGHcSGu6g6tm-Wb7R34KNPb-LWwQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] tw686x: Add support for DMA scatter-gather mode
From: Tim Harvey <tharvey@gateworks.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 1, 2016 at 3:38 PM, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
> Now that the driver has the infrastructure to support more
> DMA modes, let's add the DMA scatter-gather mode.
>
> In this mode, the device delivers sequential top-bottom
> frames.
>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
>  drivers/media/pci/tw686x/Kconfig        |   1 +
>  drivers/media/pci/tw686x/tw686x-core.c  |   4 +
>  drivers/media/pci/tw686x/tw686x-video.c | 188 ++++++++++++++++++++++++++++++++
>  drivers/media/pci/tw686x/tw686x.h       |  14 +++
>  4 files changed, 207 insertions(+)
>
> diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
> index ef8ca85522f8..34ff37712313 100644
> --- a/drivers/media/pci/tw686x/Kconfig
> +++ b/drivers/media/pci/tw686x/Kconfig
> @@ -4,6 +4,7 @@ config VIDEO_TW686X
>         depends on HAS_DMA
>         select VIDEOBUF2_VMALLOC
>         select VIDEOBUF2_DMA_CONTIG
> +       select VIDEOBUF2_DMA_SG
>         select SND_PCM
>         help
>           Support for Intersil/Techwell TW686x-based frame grabber cards.
> diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
> index 9a7646c0f9f6..586bc6723c93 100644
> --- a/drivers/media/pci/tw686x/tw686x-core.c
> +++ b/drivers/media/pci/tw686x/tw686x-core.c
> @@ -65,6 +65,8 @@ static const char *dma_mode_name(unsigned int mode)
>                 return "memcpy";
>         case TW686X_DMA_MODE_CONTIG:
>                 return "contig";
> +       case TW686X_DMA_MODE_SG:
> +               return "sg";
>         default:
>                 return "unknown";
>         }
> @@ -81,6 +83,8 @@ static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
>                 dma_mode = TW686X_DMA_MODE_MEMCPY;
>         else if (!strcasecmp(val, dma_mode_name(TW686X_DMA_MODE_CONTIG)))
>                 dma_mode = TW686X_DMA_MODE_CONTIG;
> +       else if (!strcasecmp(val, dma_mode_name(TW686X_DMA_MODE_SG)))
> +               dma_mode = TW686X_DMA_MODE_SG;
>         else
>                 return -EINVAL;
>         return 0;
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> index ed6abb4c41c2..16228c559f9a 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -20,6 +20,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-event.h>
>  #include <media/videobuf2-dma-contig.h>
> +#include <media/videobuf2-dma-sg.h>
>  #include <media/videobuf2-vmalloc.h>
>  #include "tw686x.h"
>  #include "tw686x-regs.h"
> @@ -28,6 +29,10 @@
>  #define TW686X_VIDEO_WIDTH             720
>  #define TW686X_VIDEO_HEIGHT(id)                ((id & V4L2_STD_625_50) ? 576 : 480)
>
> +#define TW686X_MAX_SG_ENTRY_SIZE       4096
> +#define TW686X_MAX_SG_DESC_COUNT       256 /* PAL 720x576 needs 203 4-KB pages */
> +#define TW686X_SG_TABLE_SIZE           (TW686X_MAX_SG_DESC_COUNT * sizeof(struct tw686x_sg_desc))
> +
>  static const struct tw686x_format formats[] = {
>         {
>                 .fourcc = V4L2_PIX_FMT_UYVY,
> @@ -196,6 +201,174 @@ const struct tw686x_dma_ops contig_dma_ops = {
>         .field          = V4L2_FIELD_INTERLACED,
>  };
>
> +static int tw686x_sg_desc_fill(struct tw686x_sg_desc *descs,
> +                              struct tw686x_v4l2_buf *buf,
> +                              unsigned int buf_len)
> +{
> +       struct sg_table *vbuf = vb2_dma_sg_plane_desc(&buf->vb.vb2_buf, 0);
> +       unsigned int len, entry_len;
> +       struct scatterlist *sg;
> +       int i, count;
> +
> +       /* Clear the scatter-gather table */
> +       memset(descs, 0, TW686X_SG_TABLE_SIZE);
> +
> +       count = 0;
> +       for_each_sg(vbuf->sgl, sg, vbuf->nents, i) {
> +               dma_addr_t phys = sg_dma_address(sg);
> +               len = sg_dma_len(sg);
> +
> +               while (len && buf_len) {
> +
> +                       if (count == TW686X_MAX_SG_DESC_COUNT)
> +                               return -ENOMEM;
> +
> +                       entry_len = min_t(unsigned int, len,
> +                                         TW686X_MAX_SG_ENTRY_SIZE);
> +                       entry_len = min_t(unsigned int, entry_len, buf_len);
> +                       descs[count].phys = cpu_to_le32(phys);
> +                       descs[count++].flags_length =
> +                                       cpu_to_le32(BIT(30) | entry_len);
> +                       phys += entry_len;
> +                       len -= entry_len;
> +                       buf_len -= entry_len;
> +               }
> +
> +               if (!buf_len)
> +                       return 0;
> +       }
> +
> +       return -ENOMEM;
> +}
> +
> +static void tw686x_sg_buf_refill(struct tw686x_video_channel *vc,
> +                                unsigned int pb)
> +{
> +       struct tw686x_dev *dev = vc->dev;
> +       struct tw686x_v4l2_buf *buf;
> +
> +       while (!list_empty(&vc->vidq_queued)) {
> +               unsigned int buf_len;
> +
> +               buf = list_first_entry(&vc->vidq_queued,
> +                       struct tw686x_v4l2_buf, list);
> +               list_del(&buf->list);
> +
> +               buf_len = (vc->width * vc->height * vc->format->depth) >> 3;
> +               if (tw686x_sg_desc_fill(vc->sg_descs[pb], buf, buf_len)) {
> +                       v4l2_err(&dev->v4l2_dev,
> +                                "dma%d: unable to fill %s-buffer\n",
> +                                vc->ch, pb ? "B" : "P");
> +                       vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +                       continue;
> +               }
> +
> +               buf->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
> +               vc->curr_bufs[pb] = buf;
> +               return;
> +       }
> +
> +       vc->curr_bufs[pb] = NULL;
> +}
> +
> +static void tw686x_sg_dma_free(struct tw686x_video_channel *vc,
> +                              unsigned int pb)
> +{
> +       struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
> +       struct tw686x_dev *dev = vc->dev;
> +
> +       if (desc->size) {
> +               pci_free_consistent(dev->pci_dev, desc->size,
> +                                   desc->virt, desc->phys);
> +               desc->virt = NULL;
> +       }
> +
> +       vc->sg_descs[pb] = NULL;
> +}
> +
> +static int tw686x_sg_dma_alloc(struct tw686x_video_channel *vc,
> +                              unsigned int pb)
> +{
> +       struct tw686x_dma_desc *desc = &vc->dma_descs[pb];
> +       struct tw686x_dev *dev = vc->dev;
> +       u32 reg = pb ? DMA_PAGE_TABLE1_ADDR[vc->ch] :
> +                      DMA_PAGE_TABLE0_ADDR[vc->ch];
> +       void *virt;
> +
> +       if (desc->size) {
> +
> +               virt = pci_alloc_consistent(dev->pci_dev, desc->size,
> +                                           &desc->phys);
> +               if (!virt) {
> +                       v4l2_err(&dev->v4l2_dev,
> +                                "dma%d: unable to allocate %s-buffer\n",
> +                                vc->ch, pb ? "B" : "P");
> +                       return -ENOMEM;
> +               }
> +               desc->virt = virt;
> +               reg_write(dev, reg, desc->phys);
> +       } else {
> +               virt = dev->video_channels[0].dma_descs[pb].virt +
> +                      vc->ch * TW686X_SG_TABLE_SIZE;
> +       }
> +
> +       vc->sg_descs[pb] = virt;
> +       return 0;
> +}
> +
> +static void tw686x_sg_cleanup(struct tw686x_dev *dev)
> +{
> +       vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
> +}
> +
> +static int tw686x_sg_setup(struct tw686x_dev *dev)
> +{
> +       unsigned int sg_table_size, pb, ch, channels;
> +
> +       dev->alloc_ctx = vb2_dma_sg_init_ctx(&dev->pci_dev->dev);
> +       if (IS_ERR(dev->alloc_ctx)) {
> +               dev_err(&dev->pci_dev->dev, "unable to init DMA context\n");
> +               return PTR_ERR(dev->alloc_ctx);
> +       }
> +
> +       if (is_second_gen(dev)) {
> +               /*
> +                * TW6865/TW6869: each channel needs a pair of
> +                * P-B descriptor tables.
> +                */
> +               channels = max_channels(dev);
> +               sg_table_size = TW686X_SG_TABLE_SIZE;
> +       } else {
> +               /*
> +                * TW6864/TW6868: we need to allocate a pair of
> +                * P-B descriptor tables, common for all channels.
> +                * Each table will be bigger than 4 KB.
> +                */
> +               channels = 1;
> +               sg_table_size = max_channels(dev) * TW686X_SG_TABLE_SIZE;
> +       }
> +
> +       for (ch = 0; ch < channels; ch++) {
> +               struct tw686x_video_channel *vc = &dev->video_channels[ch];
> +
> +               for (pb = 0; pb < 2; pb++)
> +                       vc->dma_descs[pb].size = sg_table_size;
> +       }
> +
> +       return 0;
> +}
> +
> +const struct tw686x_dma_ops sg_dma_ops = {
> +       .setup          = tw686x_sg_setup,
> +       .cleanup        = tw686x_sg_cleanup,
> +       .alloc          = tw686x_sg_dma_alloc,
> +       .free           = tw686x_sg_dma_free,
> +       .buf_refill     = tw686x_sg_buf_refill,
> +       .mem_ops        = &vb2_dma_sg_memops,
> +       .hw_dma_mode    = TW686X_SG_MODE,
> +       .field          = V4L2_FIELD_SEQ_TB,
> +};
> +
>  static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
>  {
>         static const unsigned int map[15] = {
> @@ -545,6 +718,19 @@ static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
>         else
>                 val &= ~BIT(24);
>
> +       val &= ~0x7ffff;
> +
> +       /* Program the DMA scatter-gather */
> +       if (dev->dma_mode == TW686X_DMA_MODE_SG) {
> +               u32 start_idx, end_idx;
> +
> +               start_idx = is_second_gen(dev) ?
> +                               0 : vc->ch * TW686X_MAX_SG_DESC_COUNT;
> +               end_idx = start_idx + TW686X_MAX_SG_DESC_COUNT - 1;
> +
> +               val |= (end_idx << 10) | start_idx;
> +       }
> +
>         val &= ~(0x7 << 20);
>         val |= vc->format->mode << 20;
>         reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], val);
> @@ -882,6 +1068,8 @@ int tw686x_video_init(struct tw686x_dev *dev)
>                 dev->dma_ops = &memcpy_dma_ops;
>         else if (dev->dma_mode == TW686X_DMA_MODE_CONTIG)
>                 dev->dma_ops = &contig_dma_ops;
> +       else if (dev->dma_mode == TW686X_DMA_MODE_SG)
> +               dev->dma_ops = &sg_dma_ops;
>         else
>                 return -EINVAL;
>
> diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
> index 938f16b2449a..fe848a40f9d0 100644
> --- a/drivers/media/pci/tw686x/tw686x.h
> +++ b/drivers/media/pci/tw686x/tw686x.h
> @@ -34,6 +34,7 @@
>
>  #define TW686X_DMA_MODE_MEMCPY         0
>  #define TW686X_DMA_MODE_CONTIG         1
> +#define TW686X_DMA_MODE_SG             2
>
>  struct tw686x_format {
>         char *name;
> @@ -48,6 +49,12 @@ struct tw686x_dma_desc {
>         unsigned size;
>  };
>
> +struct tw686x_sg_desc {
> +       /* 3 MSBits for flags, 13 LSBits for length */
> +       __le32 flags_length;
> +       __le32 phys;
> +};
> +
>  struct tw686x_audio_buf {
>         dma_addr_t dma;
>         void *virt;
> @@ -80,6 +87,7 @@ struct tw686x_video_channel {
>         struct video_device *device;
>         struct tw686x_v4l2_buf *curr_bufs[2];
>         struct tw686x_dma_desc dma_descs[2];
> +       struct tw686x_sg_desc *sg_descs[2];
>
>         struct v4l2_ctrl_handler ctrl_handler;
>         const struct tw686x_format *format;
> @@ -154,6 +162,12 @@ static inline unsigned max_channels(struct tw686x_dev *dev)
>         return dev->type & TYPE_MAX_CHANNELS; /* 4 or 8 channels */
>  }
>
> +static inline unsigned is_second_gen(struct tw686x_dev *dev)
> +{
> +       /* each channel has its own DMA SG table */
> +       return dev->type & TYPE_SECOND_GEN;
> +}
> +
>  void tw686x_enable_channel(struct tw686x_dev *dev, unsigned int channel);
>  void tw686x_disable_channel(struct tw686x_dev *dev, unsigned int channel);
>
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ezequiel,

Thanks for adding this support, and thanks to Krzysztof for the
original driver and efforts as well!

As with the TW686X_DMA_MODE_CONTIG, this one also helps out in the
hardware config I have with limited coherent_pool mem.

Tested-by: Tim Harvey <tharvey@gateworks.com>
