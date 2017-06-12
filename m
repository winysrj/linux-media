Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:32971 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdFLJ7n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 05:59:43 -0400
Received: by mail-yw0-f174.google.com with SMTP id 63so34154863ywr.0
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 02:59:42 -0700 (PDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com. [209.85.161.179])
        by smtp.gmail.com with ESMTPSA id t130sm1952015ywa.0.2017.06.12.02.59.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jun 2017 02:59:40 -0700 (PDT)
Received: by mail-yw0-f179.google.com with SMTP id 63so34154632ywr.0
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 02:59:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com> <1496799279-8774-4-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 12 Jun 2017 18:59:18 +0900
Message-ID: <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Please see my comments inline.

On Wed, Jun 7, 2017 at 10:34 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> This patch adds CIO2 CSI-2 device driver for
> Intel's IPU3 camera sub-system support.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/Kconfig                |    2 +
>  drivers/media/pci/Makefile               |    3 +-
>  drivers/media/pci/intel/Makefile         |    5 +
>  drivers/media/pci/intel/ipu3/Kconfig     |   17 +
>  drivers/media/pci/intel/ipu3/Makefile    |    1 +
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1788 ++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h |  424 +++++++
>  7 files changed, 2239 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/intel/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
>  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
[snip]
> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> new file mode 100644
> index 0000000..2a895d6
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/Kconfig
> @@ -0,0 +1,17 @@
> +config VIDEO_IPU3_CIO2
> +       tristate "Intel ipu3-cio2 driver"
> +       depends on VIDEO_V4L2 && PCI
> +       depends on MEDIA_CONTROLLER
> +       depends on HAS_DMA
> +       depends on ACPI

I wonder if it wouldn't make sense to make this depend on X86 (||
COMPILE_TEST) as well. Are we expecting a standalone PCI(e) card with
this device in the future?

> +       select V4L2_FWNODE
> +       select VIDEOBUF2_DMA_SG
> +
> +       ---help---
> +       This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
> +       Skylake and Kaby Lake SoCs and used for capturing images and
> +       video from a camera sensor.
> +
> +       Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
> +       connected camera.
> +       The module will be called ipu3-cio2.
> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
> new file mode 100644
> index 0000000..20186e3
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> new file mode 100644
> index 0000000..69c47fc
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
[snip]
> +static int cio2_fbpt_init_dummy(struct cio2_device *cio2)
> +{
> +       unsigned int i;
> +
> +       cio2->dummy_page = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> +                                       &cio2->dummy_page_bus_addr, GFP_KERNEL);
> +       cio2->dummy_lop = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> +                                       &cio2->dummy_lop_bus_addr, GFP_KERNEL);

Something is not right here. Why noncoherent memory is allocated, but
coherent memory is freed in the free function above? Wasn't the
intention to just always use coherent memory throughout the driver?

> +       if (!cio2->dummy_page || !cio2->dummy_lop) {
> +               cio2_fbpt_exit_dummy(cio2);
> +               return -ENOMEM;
> +       }
> +       /*
> +        * List of Pointers(LOP) contains 1024x32b pointers to 4KB page each
> +        * Initialize each entry to dummy_page bus base address.
> +        */
> +       for (i = 0; i < PAGE_SIZE / sizeof(*cio2->dummy_lop); i++)
> +               cio2->dummy_lop[i] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> +
> +       return 0;
> +}
[snip]
> +/* Initialize fpbt entries to point to a given buffer */
> +static void cio2_fbpt_entry_init_buf(struct cio2_device *cio2,
> +                                    struct cio2_buffer *b,
> +                                    struct cio2_fbpt_entry
> +                                    entry[CIO2_MAX_LOPS])
> +{
> +       struct vb2_buffer *vb = &b->vbb.vb2_buf;
> +       unsigned int length = vb->planes[0].length;
> +       dma_addr_t lop_bus_addr = b->lop_bus_addr;
> +       int remaining;
> +
> +       entry[0].first_entry.first_page_offset =
> +               offset_in_page(vb2_plane_vaddr(vb, 0));

nit: Even though it's technically the same value, it's kind of
logically confusing that a function for virtual addresses is used for
DMA calculations. Similarly for offset_in_page, since it refers to CPU
pages.

> +       remaining = length + entry[0].first_entry.first_page_offset;
> +       entry[1].second_entry.num_of_pages = DIV_ROUND_UP(remaining, PAGE_SIZE);
> +       /*
> +        * last_page_available_bytes has the offset of the last byte in the
> +        * last page which is still accessible by DMA. DMA cannot access
> +        * beyond this point. Valid range for this is from 0 to 4095.
> +        * 0 indicates 1st byte in the page is DMA accessible.
> +        * 4095 (PAGE_SIZE - 1) means every single byte in the last page
> +        * is available for DMA transfer.
> +        */
> +       entry[1].second_entry.last_page_available_bytes =
> +                       (remaining & ~PAGE_MASK) ?
> +                               (remaining & ~PAGE_MASK) - 1 : PAGE_SIZE - 1;

nit: Probably PAGE_SIZE is not going to change easily, but it's
referring to CPU default page size. At least for clarity, you should
have your own defines for CIO2 page sizes.

> +       /* Fill FBPT */
> +       remaining = length;
> +       while (remaining > 0) {
> +               entry->lop_page_addr = lop_bus_addr >> PAGE_SHIFT;
> +               lop_bus_addr += PAGE_SIZE;
> +               remaining -= PAGE_SIZE / sizeof(u32) * PAGE_SIZE;
> +               entry++;
> +       }

By any chance, doesn't the hardware provide some simple mode for
contiguous buffers? Since we have an MMU anyway, we could use
vb2_dma_contig and simplify the code significantly.

> +
> +       /*
> +        * The first not meaningful FBPT entry should point to a valid LOP
> +        */
> +       entry->lop_page_addr = cio2->dummy_lop_bus_addr >> PAGE_SHIFT;
> +
> +       cio2_fbpt_entry_enable(cio2, entry);
> +}
> +
> +static int cio2_fbpt_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +       struct device *dev = &cio2->pci_dev->dev;
> +
> +       q->fbpt = dma_alloc_noncoherent(dev, CIO2_FBPT_SIZE,
> +                       &q->fbpt_bus_addr, GFP_KERNEL);

_coherent?

> +       if (!q->fbpt)
> +               return -ENOMEM;
> +
> +       memset(q->fbpt, 0, CIO2_FBPT_SIZE);
> +
> +       return 0;
> +}
> +
> +static void cio2_fbpt_exit(struct cio2_queue *q, struct device *dev)
> +{
> +       dma_free_coherent(dev, CIO2_FBPT_SIZE, q->fbpt, q->fbpt_bus_addr);
> +}
> +
> +/**************** CSI2 hardware setup ****************/
> +
> +/*
> + * This should come from sensor driver. No
> + * driver interface nor requirement yet.
> + */
> +static u8 sensor_vc;   /* Virtual channel */
> +
> +/*
> + * The CSI2 receiver has several parameters affecting
> + * the receiver timings. These depend on the MIPI bus frequency
> + * F in Hz (sensor transmitter rate) as follows:
> + *     register value = (A/1e9 + B * UI) / COUNT_ACC
> + * where
> + *      UI = 1 / (2 * F) in seconds
> + *      COUNT_ACC = counter accuracy in seconds
> + *      For IPU3 COUNT_ACC = 0.0625
> + *
> + * A and B are coefficients from the table below,
> + * depending whether the register minimum or maximum value is
> + * calculated.
> + *                                     Minimum     Maximum
> + * Clock lane                          A     B     A     B
> + * reg_rx_csi_dly_cnt_termen_clane     0     0    38     0
> + * reg_rx_csi_dly_cnt_settle_clane    95    -8   300   -16
> + * Data lanes
> + * reg_rx_csi_dly_cnt_termen_dlane0    0     0    35
> + * reg_rx_csi_dly_cnt_settle_dlane0   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane1    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane1   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane2    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane2   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane3    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane3   85    -2   145    -6
> + *
> + * We use the minimum values of both A and B.

Why?

> + */
> +static int cio2_rx_timing(s32 a, s32 b, s64 freq)
> +{
> +       int r;
> +       const u32 accinv = 16;
> +       const u32 ds = 8; /* divde shift */

typo: divide

> +
> +       freq = (s32)freq >> ds;

Why do we demote freq from 64 to 32 bits here?

> +       if (WARN_ON(freq <= 0))
> +               return -EINVAL;

It generally doesn't make sense for the frequency to be negative, so
maybe the argument should have been unsigned to start with? (And
32-bit if we don't expect frequencies higher than 4 GHz anyway.)

> +
> +       /* b could be 0, -2 or -8, so r < 500000000 */

Definitely. Anything <= 0 is also less than 500000000. Let's take a
look at the computation below again:

1) accinv is multiplied by b,
2) 500000000 is divided by 256 (=== shift right by 8 bits) = 1953125,
3) accinv*b is multiplied by 1953125 to form the value of r.

Now let's see at possible maximum absolute values for particular steps:
1) 16 * -8 = -128 (signed 8 bits),
2) 1953125 (unsigned 21 bits),
3) -128 * 1953125 = -249999872 (signed 29 bits).

So I think the important thing to note in the comment is:

/* b could be 0, -2 or -8, so |accinv * b| is always less than (1 <<
ds) and thus |r| < 500000000. */

> +       r = accinv * b * (500000000 >> ds);

On the other hand, you lose some precision here. If you used s64
instead and did the divide shift at the end ((accinv * b * 500000000)
>> ds), for the example above you would get -250007629. (Depending on
how big freq is, it might not matter, though.)

Also nit: What is 500000000? We have local constants defined above, I
think it could also make sense to do the same for this one. The
compiler should do constant propagation and simplify respective
calculations anyway.

> +       r /= freq;
> +       /* max value of a is 95 */
> +       r += accinv * a;
> +
> +       return r;
> +};
> +
> +/* Computation for the Delay value for Termination enable of Clock lane HS Rx */
> +static int cio2_csi2_calc_timing(struct cio2_device *cio2, struct cio2_queue *q,
> +                           struct cio2_csi2_timing *timing)
> +{
> +       struct device *dev = &cio2->pci_dev->dev;
> +       struct v4l2_querymenu qm = {.id = V4L2_CID_LINK_FREQ, };
> +       struct v4l2_ctrl *link_freq;
> +       s64 freq;
> +       int r;
> +
> +       if (q->sensor)
> +               link_freq = v4l2_ctrl_find(q->sensor->ctrl_handler,
> +                                               V4L2_CID_LINK_FREQ);

Is it even possible to have this function called with !q->sensor? If
yes, maybe the function should check it and fail earlier?

> +       if (!link_freq) {
> +               dev_err(dev, "failed to find LINK_FREQ\n");
> +               return -EPIPE;
> +       };
> +
> +       qm.index = v4l2_ctrl_g_ctrl(link_freq);

We will crash here or even dereference some invalid memory if (!q->sensor).

> +       r = v4l2_querymenu(q->sensor->ctrl_handler, &qm);
> +       if (r) {
> +               dev_err(dev, "failed to get menu item\n");
> +               return r;
> +       }
> +
> +       if (!qm.value)
> +               return -EINVAL;

I think an error message would make sense here.

> +       freq = qm.value;
> +
> +       dev_info(dev, "link freq is %lld\n", qm.value);

Do we need to print this? Perhaps dev_dbg() could be more appropriate.

> +
> +       timing->clk_termen = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_A,
> +                               CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_B, freq);
> +       /* test freq/div_shift > 0 */
> +       if (timing->clk_termen < 0)

Either the comment should say >= 0 or the check be <= 0.

> +               return -EINVAL;

Given that freq comes from the sensor, the calculation might involve a
subtraction (B might be negative) and returned value is not allowed to
be negative, is it really okay to always use the minimum values?

> +
> +       timing->clk_settle = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_A,
> +                               CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_B, freq);
> +       timing->dat_termen = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_A,
> +                               CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_B, freq);
> +       timing->dat_settle = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_A,
> +                               CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_B, freq);

No need to check the above for > 0?

> +
> +       dev_dbg(dev, "freq ct value is %d\n", timing->clk_termen);
> +       dev_dbg(dev, "freq cs value is %d\n", timing->clk_settle);
> +       dev_dbg(dev, "freq dt value is %d\n", timing->dat_termen);
> +       dev_dbg(dev, "freq ds value is %d\n", timing->dat_settle);
> +
> +       return 0;
> +};
[snip]
> +static int cio2_hw_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +       static const int NUM_VCS = 4;
> +       static const int SID;   /* Stream id */
> +       static const int ENTRY;
> +       static const int FBPT_WIDTH = DIV_ROUND_UP(CIO2_MAX_LOPS,
> +                                       CIO2_FBPT_SUBENTRY_UNIT);
> +       const u32 num_buffers1 = CIO2_MAX_BUFFERS - 1;
> +       void __iomem *const base = cio2->base;
> +       u8 mipicode, lanes, csi2bus = q->csi2.port;
> +       struct cio2_csi2_timing timing;
> +       int i, r;
> +
> +       /* TODO: add support for virtual channels */
> +       sensor_vc = 0;

Modifying a global variable here. I think it would make more sense to
make it a local variable for this function then and also define a
macro with the default VC number.

> +       mipicode = r = cio2_hw_mbus_to_mipicode(
> +                       q->subdev_fmt.code);
> +       if (r < 0)
> +               return r;
> +
> +       lanes = r = q->csi2.num_of_lanes;
> +       if (r < 0)
> +               return r;
[snip]
> +       r = cio2_csi2_calc_timing(cio2, q, &timing);
> +       if (r) {
> +               /* Use default values */

Is it really the good thing to do here? Perhaps calling
cio2_csi2_calc_timing() before starting to program the hardware and
bailing out if it fails would be a better choice?

> +               for (i = -1; i < lanes; i++) {

-1?

> +                       writel(0x4, q->csi_rx_base +
> +                               CIO2_REG_CSIRX_DLY_CNT_TERMEN(i));
> +                       writel(0x570, q->csi_rx_base +
> +                               CIO2_REG_CSIRX_DLY_CNT_SETTLE(i));
> +               }
[snip]
> +static void cio2_hw_exit(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +       void __iomem *base = cio2->base;
> +       unsigned int i, maxloops = 1000;
> +
> +       /* Disable CSI receiver and MIPI backend devices */
> +       writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
> +       writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
> +
> +       /* Halt DMA */
> +       writel(0, base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN));
> +       do {
> +               if (readl(base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN)) &
> +                   CIO2_CDMAC0_DMA_HALTED)
> +                       break;
> +               usleep_range(1000, 2000);
> +       } while (--maxloops);
> +       if (!maxloops)
> +               dev_err(&cio2->pci_dev->dev,
> +                       "DMA %i can not be halted\n", CIO2_DMA_CHAN);

Does the code below ensure that the hardware is gracefully cut from
the bus to avoid memory corruption?

> +
> +       for (i = 0; i < CIO2_NUM_PORTS; i++) {
> +               writel(readl(base + CIO2_REG_PXM_FRF_CFG(i)) |
> +                      CIO2_PXM_FRF_CFG_ABORT, base + CIO2_REG_PXM_FRF_CFG(i));
> +               writel(readl(base + CIO2_REG_PBM_FOPN_ABORT) |
> +                      CIO2_PBM_FOPN_ABORT(i), base + CIO2_REG_PBM_FOPN_ABORT);
> +       }
> +}
> +
> +static void cio2_buffer_done(struct cio2_device *cio2, unsigned int dma_chan)
> +{
> +       struct device *dev = &cio2->pci_dev->dev;
> +       struct cio2_queue *q = cio2->cur_queue;
> +       int buffers_found = 0;
> +
> +       if (dma_chan >= CIO2_QUEUES) {
> +               dev_err(dev, "bad DMA channel %i\n", dma_chan);
> +               return;
> +       }
> +
> +       /* Find out which buffer(s) are ready */
> +       do {
> +               struct cio2_fbpt_entry *const entry =
> +                       &q->fbpt[q->bufs_first * CIO2_MAX_LOPS];
> +               struct cio2_buffer *b;
> +
> +               if (entry->first_entry.ctrl & CIO2_FBPT_CTRL_VALID)
> +                       break;
> +
> +               b = q->bufs[q->bufs_first];
> +               if (b) {
> +                       u64 ns = ktime_get_ns();
> +                       int bytes = entry[1].second_entry.num_of_bytes;
> +
> +                       q->bufs[q->bufs_first] = NULL;
> +                       atomic_dec(&q->bufs_queued);
> +                       dev_dbg(&cio2->pci_dev->dev,
> +                               "buffer %i done\n", b->vbb.vb2_buf.index);
> +
> +                       /* Fill vb2 buffer entries and tell it's ready */
> +                       vb2_set_plane_payload(&b->vbb.vb2_buf, 0, bytes);
> +                       b->vbb.vb2_buf.timestamp = ns;
> +                       b->vbb.flags = V4L2_BUF_FLAG_DONE;
> +                       b->vbb.field = V4L2_FIELD_NONE;
> +                       memset(&b->vbb.timecode, 0, sizeof(b->vbb.timecode));
> +                       b->vbb.sequence = entry[0].first_entry.frame_num;
> +                       vb2_buffer_done(&b->vbb.vb2_buf, VB2_BUF_STATE_DONE);
> +               }
> +               cio2_fbpt_entry_init_dummy(cio2, entry);
> +               q->bufs_first = (q->bufs_first + 1) % CIO2_MAX_BUFFERS;
> +               buffers_found++;

Personally, I'm a bit afraid of such potentially infinite loops in
interrupt handlers (if the CPU doesn't process the buffers faster than
the hardware produces, it would never finish spinning). Let me defer
this to other reviewers, though...

> +       } while (1);
> +
> +       if (buffers_found == 0)
> +               dev_warn(&cio2->pci_dev->dev,
> +                        "no ready buffers found on DMA channel %i\n",
> +                        dma_chan);
> +}
[snip]
> +static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
> +{
> +       struct cio2_device *cio2 = cio2_ptr;
> +       void __iomem *const base = cio2->base;
> +       struct device *dev = &cio2->pci_dev->dev;
> +       u32 int_status, int_clear;
> +
> +       int_clear = int_status = readl(base + CIO2_REG_INT_STS);
> +       if (!int_status)
> +               return IRQ_NONE;

CodingStyle states clearly: "Don't put multiple assignments on a
single line either.  Kernel coding style
is super simple.  Avoid tricky expressions."

> +
> +       if (int_status & CIO2_INT_IOOE) {
> +               /* Interrupt on Output Error:

CodingStyle: Multi-line comment should start with an empty line.

> +                * 1) SRAM is full and FS received, or
> +                * 2) An invalid bit detected by DMA.
> +                */
> +               u32 oe_status, oe_clear;
> +
> +               oe_clear = oe_status = readl(base + CIO2_REG_INT_STS_EXT_OE);

Multiple assignments on a single ine.

> +
> +               if (oe_status & CIO2_INT_EXT_OE_DMAOE_MASK) {
> +                       dev_err(dev, "DMA output error: 0x%x\n",
> +                               (oe_status & CIO2_INT_EXT_OE_DMAOE_MASK)
> +                               >> CIO2_INT_EXT_OE_DMAOE_SHIFT);
> +                       oe_status &= ~CIO2_INT_EXT_OE_DMAOE_MASK;
> +               }
> +               if (oe_status & CIO2_INT_EXT_OE_OES_MASK) {
> +                       dev_err(dev, "DMA output error on CSI2 buses: 0x%x\n",
> +                               (oe_status & CIO2_INT_EXT_OE_OES_MASK)
> +                               >> CIO2_INT_EXT_OE_OES_SHIFT);
> +                       oe_status &= ~CIO2_INT_EXT_OE_OES_MASK;
> +               }
> +               writel(oe_clear, base + CIO2_REG_INT_STS_EXT_OE);
> +               if (oe_status)
> +                       dev_warn(dev, "unknown interrupt 0x%x on OE\n",
> +                                oe_status);
> +               int_status &= ~CIO2_INT_IOOE;
> +       }
> +
> +       if (int_status & CIO2_INT_IOC_MASK) {
> +               /* DMA IO done -- frame ready */
> +               u32 clr = 0;
> +               unsigned int d;
> +
> +               for (d = 0; d < CIO2_NUM_DMA_CHAN; d++)
> +                       if (int_status & CIO2_INT_IOC(d)) {
> +                               clr |= CIO2_INT_IOC(d);
> +                               dev_dbg(dev, "DMA %i done\n", d);
> +                               cio2_buffer_done(cio2, d);
> +                       }
> +               int_status &= ~clr;

Perhaps a construct using lfs/ffs would be a bit smarter here. For example:

        while (int_status & CIO2_INT_IOC_MASK) {
                d = __ffs(int_status & CIO2_INT_IOC_MASK) - 1;
                int_status &= ~CIO2_INT_IOC(d);
                dev_dbg(dev, "DMA %i done\n", d);
                cio2_buffer_done(cio2, d);
        }

> +       }
> +
> +       if (int_status & CIO2_INT_IOS_IOLN_MASK) {
> +               /* DMA IO starts or reached specified line */
> +               u32 clr = 0;
> +               unsigned int d;
> +
> +               for (d = 0; d < CIO2_NUM_DMA_CHAN; d++)
> +                       if (int_status & CIO2_INT_IOS_IOLN(d)) {
> +                               clr |= CIO2_INT_IOS_IOLN(d);
> +                               if (d == CIO2_DMA_CHAN)
> +                                       cio2_queue_event_sof(cio2,
> +                                                            cio2->cur_queue);
> +                               dev_dbg(dev,
> +                                       "DMA %i started or reached line\n", d);
> +                       }
> +               int_status &= ~clr;

Ditto.

> +       }
> +
> +       if (int_status & (CIO2_INT_IOIE | CIO2_INT_IOIRQ)) {
> +               /* CSI2 receiver (error) interrupt */
> +               u32 ie_status, ie_clear;
> +               unsigned int port;
> +
> +               ie_clear = ie_status = readl(base + CIO2_REG_INT_STS_EXT_IE);

Multiple assignments.

> +
> +               for (port = 0; port < CIO2_NUM_PORTS; port++) {

CIO2_NUM_PORTS is small and the bits are scattered through ie_status,
so I guess no __ffs() trick here.

> +                       u32 port_status = (ie_status >> (port * 8)) & 0xff;
> +                       void __iomem *const csi_rx_base =
> +                                               base + CIO2_REG_PIPE_BASE(port);
> +                       unsigned int i;
> +
> +                       while (port_status) {
> +                               i = ffs(port_status) - 1;
> +                               dev_err(dev, "port %i error %s\n",
> +                                       port, cio2_port_errs[i]);
> +                               ie_status &= ~BIT(port * 8 + i);
> +                               port_status &= ~BIT(i);
> +                       }

Yeah, exactly like this. ;)

> +
> +                       if (ie_status & CIO2_INT_EXT_IE_IRQ(port)) {
> +                               u32 csi2_status, csi2_clear;
> +
> +                               csi2_clear = csi2_status = readl(csi_rx_base +
> +                                               CIO2_REG_IRQCTRL_STATUS);
> +                               for (i = 0; i < ARRAY_SIZE(cio2_irq_errs);
> +                                    i++) {
> +                                       if (csi2_status & (1 << i)) {
> +                                               dev_err(dev,
> +                                                       "CSI-2 receiver port %i: %s\n",
> +                                                       port, cio2_irq_errs[i]);
> +                                               csi2_status &= ~(1 << i);
> +                                       }
> +                               }

__ffs() trick applies here too.

> +
> +                               writel(csi2_clear,
> +                                      csi_rx_base + CIO2_REG_IRQCTRL_CLEAR);
> +                               if (csi2_status)
> +                                       dev_warn(dev,
> +                                                "unknown CSI2 error 0x%x on port %i\n",
> +                                                csi2_status, port);
> +
> +                               ie_status &= ~CIO2_INT_EXT_IE_IRQ(port);
> +                       }
> +               }
> +
> +               writel(ie_clear, base + CIO2_REG_INT_STS_EXT_IE);
> +               if (ie_status)
> +                       dev_warn(dev, "unknown interrupt 0x%x on IE\n",
> +                                ie_status);
> +
> +               int_status &= ~(CIO2_INT_IOIE | CIO2_INT_IOIRQ);
> +       }
> +
> +       writel(int_clear, base + CIO2_REG_INT_STS);
> +       if (int_status)
> +               dev_warn(dev, "unknown interrupt 0x%x on INT\n", int_status);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +/**************** Videobuf2 interface ****************/
> +
> +static void cio2_vb2_return_all_buffers(struct cio2_queue *q,
> +                                       enum vb2_buffer_state state)

Hmm, is there ever a reason to return all buffers with a state other
than _ERROR?

> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> +               if (q->bufs[i]) {
> +                       atomic_dec(&q->bufs_queued);
> +                       vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf, state);
> +               }
> +       }
> +}
> +
> +static int cio2_vb2_queue_setup(struct vb2_queue *vq,
> +                               unsigned int *num_buffers,
> +                               unsigned int *num_planes,
> +                               unsigned int sizes[],
> +                               struct device *alloc_devs[])
> +{
> +       struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +       struct cio2_queue *q = container_of(vq, struct cio2_queue, vbq);
> +       u32 width = q->subdev_fmt.width;
> +       u32 height = q->subdev_fmt.height;
> +       u32 pixelformat = q->pixelformat;
> +       unsigned int i, szimage;
> +       int r = 0;
> +
> +       for (i = 0; i < ARRAY_SIZE(cio2_csi2_fmts); i++) {
> +               if (pixelformat == cio2_csi2_fmts[i])
> +                       break;
> +       }
> +
> +       /* Use SRGGB10 instead of return err */
> +       if (i >= ARRAY_SIZE(cio2_csi2_fmts))

I think this should be impossible, since S_FMT should have already
validated (and corrected) the setting.

> +               pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> +
> +       alloc_devs[0] = &cio2->pci_dev->dev;

Hmm, so it doesn't go through the IPU MMU in the end?

> +       szimage = cio2_bytesperline(width) * height;
> +
> +       if (*num_planes) {
> +               /*
> +                * Only single plane is supported
> +                */
> +               if (*num_planes != 1 || sizes[0] < szimage)
> +                       return -EINVAL;

S_FMT should validate this and then queue_setup should never get an
invalid value.

> +       }
> +
> +       *num_planes = 1;
> +       sizes[0] = szimage;
> +
> +       *num_buffers = clamp_val(*num_buffers, 1, CIO2_MAX_BUFFERS);
> +
> +       /* Initialize buffer queue */
> +       for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> +               q->bufs[i] = NULL;
> +               cio2_fbpt_entry_init_dummy(cio2, &q->fbpt[i * CIO2_MAX_LOPS]);
> +       }
> +       atomic_set(&q->bufs_queued, 0);
> +       q->bufs_first = 0;
> +       q->bufs_next = 0;
> +
> +       return r;
> +}
> +
> +/* Called after each buffer is allocated */
> +static int cio2_vb2_buf_init(struct vb2_buffer *vb)
> +{
> +       struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> +       struct device *dev = &cio2->pci_dev->dev;
> +       struct cio2_buffer *b =
> +               container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> +       unsigned int length = vb->planes[0].length;
> +       int lops  = DIV_ROUND_UP(DIV_ROUND_UP(length, PAGE_SIZE) + 1,
> +                                PAGE_SIZE / sizeof(u32));
> +       u32 *lop;
> +       struct sg_table *sg;
> +       struct sg_page_iter sg_iter;
> +
> +       if (lops <= 0 || lops > CIO2_MAX_LOPS) {
> +               dev_err(dev, "%s: bad buffer size (%i)\n", __func__, length);
> +               return -ENOSPC;         /* Should never happen */
> +       }
> +
> +       /* Allocate LOP table */
> +       b->lop = lop = dma_alloc_noncoherent(dev, lops * PAGE_SIZE,
> +                                       &b->lop_bus_addr, GFP_KERNEL);

_coherent?

> +       if (!lop)
> +               return -ENOMEM;
> +
> +       /* Fill LOP */
> +       sg = vb2_dma_sg_plane_desc(vb, 0);
> +       if (!sg)
> +               return -EFAULT;

I'd say -ENOMEM is better here. (But actually it should be impossible,
if allocation succeeded previously.)

> +
> +       for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0)
> +               *lop++ = sg_page_iter_dma_address(&sg_iter) >> PAGE_SHIFT;
> +       *lop++ = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> +
> +       return 0;
> +}
> +
> +/* Transfer buffer ownership to cio2 */
> +static void cio2_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +       struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> +       struct cio2_queue *q =
> +               container_of(vb->vb2_queue, struct cio2_queue, vbq);
> +       struct cio2_buffer *b =
> +               container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> +       struct cio2_fbpt_entry *entry;
> +       unsigned int next = q->bufs_next;
> +       int bufs_queued = atomic_inc_return(&q->bufs_queued);
> +
> +       if (vb2_start_streaming_called(&q->vbq)) {

Shouldn't it be vb2_is_streaming()? (There is not much difference,
though, except that vb2_start_streaming_called() returns true, even
before .start_streaming finished, while vb2_is_streaming() does so
only after it returns successfully.)

> +               u32 fbpt_rp =
> +                       (readl(cio2->base + CIO2_REG_CDMARI(CIO2_DMA_CHAN))
> +                        >> CIO2_CDMARI_FBPT_RP_SHIFT)
> +                       & CIO2_CDMARI_FBPT_RP_MASK;
> +
> +               /*
> +                * fbpt_rp is the fbpt entry that the dma is currently working
> +                * on, but since it could jump to next entry at any time,
> +                * assume that we might already be there.
> +                */
> +               fbpt_rp = (fbpt_rp + 1) % CIO2_MAX_BUFFERS;

Hmm, this is really racy. This code can be pre-empted and not execute
for quite long time, depending on system load, resuming after the
hardware goes even further. Technically you could prevent this using
*_irq_save()/_irq_restore(), but I'd try to find a way that doesn't
rely on the timing, if possible.

> +
> +               if (bufs_queued <= 1)
> +                       next = fbpt_rp + 1;     /* Buffers were drained */
> +               else if (fbpt_rp == next)
> +                       next++;
> +               next %= CIO2_MAX_BUFFERS;
> +       }
> +
> +       while (q->bufs[next]) {
> +               /* If the entry is used, get the next one,
> +                * We can not break here if all are filled,
> +                * Will wait for one free, otherwise it will crash
> +                */
> +               dev_dbg(&cio2->pci_dev->dev,
> +                       "entry %i was already full!\n", next);
> +               next = (next + 1) % CIO2_MAX_BUFFERS;

A busy waiting, possibly infinite, loop. Hmm.

I think we could do something smarter here, such as sleeping on a
wait_queue, which is woken up from the interrupt handler.

Also, why do you think it will crash? I think you can just do return
the buffer to vb2 with _ERROR status and bail out, if you can't queue
due to some failure.

> +       }
> +
> +       q->bufs[next] = b;
> +       entry = &q->fbpt[next * CIO2_MAX_LOPS];
> +       cio2_fbpt_entry_init_buf(cio2, b, entry);
> +       q->bufs_next = (next + 1) % CIO2_MAX_BUFFERS;
> +}
[snip]
> +static int cio2_set_power(struct vb2_queue *vq, int enable)
> +{
> +       struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +       struct device *dev = &cio2->pci_dev->dev;
> +       int ret = 0;
> +
> +       if (enable) {
> +               ret = pm_runtime_get_sync(dev);
> +               if (ret < 0) {
> +                       dev_info(&cio2->pci_dev->dev,
> +                               "failed to get power %d\n", ret);
> +                       pm_runtime_put(dev);
> +               }
> +       } else {
> +               ret = pm_runtime_put(dev);
> +       }
> +
> +       /* return 0 if power is active */
> +       return (ret >= 0) ? 0 : ret;

nit: I think this function is unnecessary, as it only adds one more
level of indirection and also combines two completely different code
paths together, especially since it is called exactly once with
enable==1 and once with enable==0. I'd suggest just pasting respective
code in place of the call instead.

> +}
[snip]
> +static int cio2_v4l2_querycap(struct file *file, void *fh,
> +                             struct v4l2_capability *cap)
> +{
> +       struct cio2_device *cio2 = video_drvdata(file);
> +
> +       strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
> +       strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
> +       snprintf(cap->bus_info, sizeof(cap->bus_info),
> +                "PCI:%s", pci_name(cio2->pci_dev));
> +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;

Hmm, I thought single plane queue type was deprecated these days and
_MPLANE recommended for all new drivers. I'll defer this to other
reviewers, though.

> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +       return 0;
> +}
[snip]
> +static int cio2_v4l2_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +       u32 pixelformat = f->fmt.pix.pixelformat;
> +       unsigned int i;
> +
> +       cio2_v4l2_g_fmt(file, fh, f);
> +
> +       for (i = 0; i < ARRAY_SIZE(cio2_csi2_fmts); i++) {
> +               if (pixelformat == cio2_csi2_fmts[i])
> +                       break;
> +       }
> +
> +       /* Use SRGGB10 as default if not found */
> +       if (i >= ARRAY_SIZE(cio2_csi2_fmts))
> +               pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> +
> +       f->fmt.pix.pixelformat = pixelformat;
> +       f->fmt.pix.bytesperline = cio2_bytesperline(f->fmt.pix.width);
> +       f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;

Shouldn't you use f->fmt.pix_mp instead?

> +
> +       return 0;
> +}
[snip]
> +
> +       /* Initialize vbq */
> +       vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       vbq->io_modes = VB2_USERPTR | VB2_MMAP;

VB2_DMABUF?

> +       vbq->ops = &cio2_vb2_ops;
> +       vbq->mem_ops = &vb2_dma_sg_memops;
> +       vbq->buf_struct_size = sizeof(struct cio2_buffer);
> +       vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +       vbq->min_buffers_needed = 1;
> +       vbq->drv_priv = cio2;
> +       vbq->lock = &q->lock;

Does the code take into account queue operations and video device
operations being asynchronous regarding each other? Given that in this
case there is always one queue per video device, maybe it would just
make sense to use the same lock for both? (This happens if you leave
vbq->lock with NULL.)

Best regards,
Tomasz
