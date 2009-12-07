Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55467 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbZLGU6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 15:58:48 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Mon, 7 Dec 2009 14:58:48 -0600
Subject: RE: [PATCH 1/5 - v0] V4L-vpfe capture - adding CCDC driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE40155BEC323@dlee06.ent.ti.com>
References: <1259703533-1789-1-git-send-email-m-karicheri2@ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE87A7BD@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE87A7BD@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

>
>Hi Murali,
>
>Here is a (styling related) review from an non-video person. The


[MK] The styling was mostly done by one of our intern who is new to open source coding. So I will fix it based on your comments.

>review is neither complete nor exhaustive (the patch is huge!),
>but I thought will send across whatever I have for you to take a look.
>
[MK] Yes Sure!

>On Wed, Dec 02, 2009 at 03:08:49, Karicheri, Muralidharan wrote:
>> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>
>> This patch is for adding support for DM365 CCDC. This will allow to
>> capture YUV video frames from TVP5146 video decoder on DM365 EVM. The
>vpfe
>> capture driver will use this module to configure ISIF (a.k.a CCDC)
>> module to allow YUV data capture. This driver is written for
>ccdc_hw_device
>> interface used by vpfe capture driver to configure the ccdc module.
>> This patch is tested using NTSC & PAL video sources and verified for
>> both formats.
>>
>> NOTE: This is the initial version for review.
>
>Typically "RFC" is put instead of "PATCH" in subject line
>to convey this.
[MK] IMO, RFC is for something that is a proposal to make some changes in the architecture/implementation to get feedback from the reviewers. But here it is a real code that is being reviewed. I just mentioned it to make sure no body complains that it doesn't apply to the latest tree :). This is based on
what I see in the mailing list.
>
>>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> ---
>>  drivers/media/video/davinci/dm365_ccdc.c      | 1529
>+++++++++++++++++++++++++
>>  drivers/media/video/davinci/dm365_ccdc_regs.h |  293 +++++
>>  include/media/davinci/dm365_ccdc.h            |  555 +++++++++
>>  3 files changed, 2377 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
>>  create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
>>  create mode 100644 include/media/davinci/dm365_ccdc.h
>>
>> diff --git a/drivers/media/video/davinci/dm365_ccdc.c
>b/drivers/media/video/davinci/dm365_ccdc.c
>
>Hopefully it is possible to choose a "generic" name
>instead of tying it to an SoC.
>
[MK]I agree there is problem here. For example, we have same ccdc IP used
across DM6446, OMAP34xx and Sitara (earlier Shiva). We have it named
currently as dm644x_ccdc.c. I have checked the DM6446 and OMAP34xx PRG
and finds that CCDC IP has a Peripheral identification (TID) and class
identification (CID). For OMAP & DM6446, they have the same values. So
We might be able to rename them as ccdc_<TID><CID>.c. But for CCDC on
DM355, we don't have a PID/CID for ccdc. So how do we name it? I don't
see a uniform way we can name the driver for these IPs.

Probably change dm365_ccdc.c to isif.c since that is the IP name on
DM365. ISIF stands for Image Sensor Interface.

>> new file mode 100644
>> index 0000000..2f27696
>> --- /dev/null
>> +++ b/drivers/media/video/davinci/dm365_ccdc.c
>> @@ -0,0 +1,1529 @@
>
>[...]
>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/io.h>
>> +#include <linux/videodev2.h>
>> +#include <mach/mux.h>
>> +#include <media/davinci/dm365_ccdc.h>
>> +#include <media/davinci/vpss.h>
>> +#include "dm365_ccdc_regs.h"
>> +#include "ccdc_hw_device.h"
>
>Typically the includes are grouped using empty lines
>based on the folder "linux", "media" "mach" etc.
>
[MK]This is not strictly followed in the community, But I think it is good
to do this for better readability.
>> +
>> +static struct device *dev;
>> +
>> +/* Defauts for module configuation paramaters */
>> +static struct ccdc_config_params_raw ccdc_config_defaults = {
>> +    .linearize = {
>> +            .en = 0,
>> +            .corr_shft = CCDC_NO_SHIFT,
>> +            .scale_fact = {1, 0},
>> +    },
>> +    .df_csc = {
>> +            .df_or_csc = 0,
>> +            .csc = {
>> +                    .en = 0
>
>Should use ',' at the end of line so adding
>new members leads to adding just one line.
>There are more of these in this static init
>below.
>
[MK] Ok.

>> +            },
>> +    },
>> +    .dfc = {
>> +            .en = 0
>> +    },
>> +    .bclamp = {
>> +            .en = 0
>> +    },
>> +    .gain_offset = {
>> +            .gain = {
>> +                    .r_ye = {1, 0},
>> +                    .gr_cy = {1, 0},
>> +                    .gb_g = {1, 0},
>> +                    .b_mg = {1, 0},
>> +            },
>> +    },
>> +    .culling = {
>> +            .hcpat_odd = 0xff,
>> +            .hcpat_even = 0xff,
>> +            .vcpat = 0xff
>> +    },
>> +    .compress = {
>> +            .alg = CCDC_ALAW,
>> +    },
>> +};
>> +
>> +/* ISIF operation configuration */
>> +struct ccdc_oper_config {
>> +    enum vpfe_hw_if_type if_type;
>> +    struct ccdc_ycbcr_config ycbcr;
>> +    struct ccdc_params_raw bayer;
>> +    enum ccdc_data_pack data_pack;
>> +    void *__iomem base_addr;
>> +    void *__iomem linear_tbl0_addr;
>> +    void *__iomem linear_tbl1_addr;
>
>Usually it is void __iomem *foo;
[MK] Correct.

>
>> +};
>> +
>> +static struct ccdc_oper_config ccdc_cfg = {
>> +    .ycbcr = {
>> +            .pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
>> +            .frm_fmt = CCDC_FRMFMT_INTERLACED,
>> +            .win = CCDC_WIN_NTSC,
>> +            .fid_pol = VPFE_PINPOL_POSITIVE,
>> +            .vd_pol = VPFE_PINPOL_POSITIVE,
>> +            .hd_pol = VPFE_PINPOL_POSITIVE,
>> +            .pix_order = CCDC_PIXORDER_CBYCRY,
>> +            .buf_type = CCDC_BUFTYPE_FLD_INTERLEAVED,
>> +    },
>> +    .bayer = {
>> +            .pix_fmt = CCDC_PIXFMT_RAW,
>> +            .frm_fmt = CCDC_FRMFMT_PROGRESSIVE,
>> +            .win = CCDC_WIN_VGA,
>> +            .fid_pol = VPFE_PINPOL_POSITIVE,
>> +            .vd_pol = VPFE_PINPOL_POSITIVE,
>> +            .hd_pol = VPFE_PINPOL_POSITIVE,
>> +            .gain = {
>> +                    .r_ye = {1, 0},
>> +                    .gr_cy = {1, 0},
>> +                    .gb_g = {1, 0},
>> +                    .b_mg = {1, 0},
>> +            },
>> +            .cfa_pat = CCDC_CFA_PAT_MOSAIC,
>> +            .data_msb = CCDC_BIT_MSB_11,
>> +            .config_params = {
>> +                    .data_shift = CCDC_NO_SHIFT,
>> +                    .col_pat_field0 = {
>> +                            .olop = CCDC_GREEN_BLUE,
>> +                            .olep = CCDC_BLUE,
>> +                            .elop = CCDC_RED,
>> +                            .elep = CCDC_GREEN_RED,
>> +                    },
>> +                    .col_pat_field1 = {
>> +                            .olop = CCDC_GREEN_BLUE,
>> +                            .olep = CCDC_BLUE,
>> +                            .elop = CCDC_RED,
>> +                            .elep = CCDC_GREEN_RED,
>> +                    },
>> +                    .test_pat_gen = 0,
>> +            },
>> +    },
>> +    .data_pack = CCDC_DATA_PACK8,
>> +};
>> +
>> +/* Raw Bayer formats */
>> +static u32 ccdc_raw_bayer_pix_formats[] =
>> +            {V4L2_PIX_FMT_SBGGR8, V4L2_PIX_FMT_SBGGR16};
>> +
>> +/* Raw YUV formats */
>> +static u32 ccdc_raw_yuv_pix_formats[] =
>> +            {V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YUYV};
>> +
>> +/* register access routines */
>> +static inline u32 regr(u32 offset)
>> +{
>> +    return __raw_readl(ccdc_cfg.base_addr + offset);
>> +}
>> +
>> +static inline void regw(u32 val, u32 offset)
>> +{
>> +    __raw_writel(val, ccdc_cfg.base_addr + offset);
>> +}
>> +
>> +static inline u32 ccdc_merge(u32 mask, u32 val, u32 offset)
>
>"merge" was not intuitive until I read the implementation.
>How about "modify" (as used in arch/arm/mach-davinci/dma.c)?

Merge sounds okay to me. Besides, it is within the same file.
So not difficult to check what the function does. I will add
a function header.
>
>> +{
>> +    u32 new_val = (regr(offset) & ~mask) | (val & mask);
>> +
>> +    regw(new_val, offset);
>> +    return new_val;
>> +}
>> +
>> +static inline void regw_lin_tbl(u32 val, u32 offset, int i)
>> +{
>> +    if (!i)
>> +            __raw_writel(val, ccdc_cfg.linear_tbl0_addr + offset);
>> +    else
>> +            __raw_writel(val, ccdc_cfg.linear_tbl1_addr + offset);
>> +}
>> +
>> +static void ccdc_disable_all_modules(void)
>> +{
>> +    /* disable BC */
>> +    regw(0, CLAMPCFG);
>> +    /* disable vdfc */
>> +    regw(0, DFCCTL);
>> +    /* disable CSC */
>> +    regw(0, CSCCTL);
>> +    /* disable linearization */
>> +    regw(0, LINCFG0);
>> +    /* disable other modules here as they are supported */
>> +}
>> +
>> +static void ccdc_enable(int en)
>> +{
>> +    if (!en) {
>> +            /* Before disable isif, disable all ISIF modules */
>
>Could you use ccdc instead of isif in the comments too?

If name of the file to be changed, then I will rename all functions
to isif_ and comments will reflect the same.

>
>> +            ccdc_disable_all_modules();
>> +            /**
>> +             * wait for next VD. Assume lowest scan rate is 12 Hz. So
>> +             * 100 msec delay is good enough
>> +             */
>> +    }
>
>The comment explaining the msleep seems mis-placed.
>
[MK] Ok.
>> +    msleep(100);
>> +    ccdc_merge(CCDC_SYNCEN_VDHDEN_MASK, en, SYNCEN);
>> +}
>> +
>> +static void ccdc_enable_output_to_sdram(int en)
>> +{
>> +    ccdc_merge(CCDC_SYNCEN_WEN_MASK, en << CCDC_SYNCEN_WEN_SHIFT,
>SYNCEN);
>> +}
>> +
>> +static void ccdc_config_culling(struct ccdc_cul *cul)
>> +{
>> +    u32 val;
>> +
>> +    /* Horizontal pattern */
>> +    val = (cul->hcpat_even) << CULL_PAT_EVEN_LINE_SHIFT;
>
>No need of parenthesis.

[MK] Correct.
>
>> +    val |= cul->hcpat_odd;
>> +    regw(val, CULH);
>> +
>> +    /* vertical pattern */
>> +    regw(cul->vcpat, CULV);
>> +
>> +    /* LPF */
>> +    ccdc_merge((CCDC_LPF_MASK << CCDC_LPF_SHIFT),
>> +               (cul->en_lpf << CCDC_LPF_SHIFT), MODESET);
>
>.. ditto ..
>
[MK] Ok.
>> +}
>> +
>> +static void ccdc_config_gain_offset(void)
>> +{
>> +    struct ccdc_gain_offsets_adj *gain_off_ptr =
>> +            &ccdc_cfg.bayer.config_params.gain_offset;
>> +    u32 val;
>> +
>> +    val = ((gain_off_ptr->gain_sdram_en & 1) << GAIN_SDRAM_EN_SHIFT) |
>> +    ((gain_off_ptr->gain_ipipe_en & 1) << GAIN_IPIPE_EN_SHIFT) |
>> +    ((gain_off_ptr->gain_h3a_en & 1) << GAIN_H3A_EN_SHIFT) |
>> +    ((gain_off_ptr->offset_sdram_en & 1) << OFST_SDRAM_EN_SHIFT) |
>> +    ((gain_off_ptr->offset_ipipe_en & 1) << OFST_IPIPE_EN_SHIFT) |
>> +    ((gain_off_ptr->offset_h3a_en & 1) << OFST_H3A_EN_SHIFT);
>
>I think the intent here is to convert an arbitrary
>gain_off_ptr->foo to 0 or 1. In that case you can
>use !!gain_off_ptr->foo
>
[MK] That is a good idea !

>> +
>> +    ccdc_merge(GAIN_OFFSET_EN_MASK, val, CGAMMAWD);
>> +
>> +    val = ((gain_off_ptr->gain.r_ye.integer & GAIN_INTEGER_MASK)
>> +            << GAIN_INTEGER_SHIFT);
>> +    val |= (ccdc_cfg.bayer.
>> +            config_params.gain_offset.gain.r_ye.decimal &
>> +            GAIN_DECIMAL_MASK);
>> +    regw(val, CRGAIN);
>> +
>> +    val = ((gain_off_ptr->gain.gr_cy
>> +            .integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT);
>> +    val |= (gain_off_ptr->gain.gr_cy
>> +            .decimal & GAIN_DECIMAL_MASK);
>> +    regw(val, CGRGAIN);
>> +
>> +    val = ((gain_off_ptr->gain.gb_g
>> +            .integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT);
>> +    val |= (gain_off_ptr->gain.gb_g
>> +            .decimal & GAIN_DECIMAL_MASK);
>> +    regw(val, CGBGAIN);
>> +
>> +    val = ((gain_off_ptr->gain.b_mg
>> +            .integer & GAIN_INTEGER_MASK) << GAIN_INTEGER_SHIFT);
>> +    val |= (gain_off_ptr->gain.b_mg
>> +            .decimal & GAIN_DECIMAL_MASK);
>
>Breaking the line at the . is making reading difficult.
>Can you break at '<<' instead?
>
[MK] Correct.

>> +    regw(val, CBGAIN);
>> +
>> +    regw((gain_off_ptr->offset &
>> +            OFFSET_MASK), COFSTA);
>
>Not sure if we really need to break here. Are you hitting
>the 80 char limit even here?
>
[MK] Looks unnecessary

>> +}
>> +
>> +static void ccdc_restore_defaults(void)
>> +{
>> +    enum vpss_ccdc_source_sel source = VPSS_CCDCIN;
>> +    int i;
>> +
>> +    memcpy(&ccdc_cfg.bayer.config_params, &ccdc_config_defaults,
>> +            sizeof(struct ccdc_config_params_raw));
>> +
>> +    dev_dbg(dev, "\nstarting ccdc_restore_defaults...");
>> +    /* Enable clock to ISIF, IPIPEIF and BL */
>> +    vpss_enable_clock(VPSS_CCDC_CLOCK, 1);
>> +    vpss_enable_clock(VPSS_IPIPEIF_CLOCK, 1);
>> +    vpss_enable_clock(VPSS_BL_CLOCK, 1);
>> +
>> +    /* set all registers to default value */
>> +    for (i = 0; i <= 0x1f8; i += 4)
>> +            regw(0, i);
>
>Hmm, something like this is not usually expected.
>You would anyway be programming all the relevant
>registers again. So, why is this required?
>
[MK] Will investigate if this can be removed. I think the implementation
assumes that all register values are restored to default.

>> +
>> +    /* no culling support */
>> +    regw(0xffff, CULH);
>> +    regw(0xff, CULV);
>> +
>> +    /* Set default offset and gain */
>> +    ccdc_config_gain_offset();
>> +
>> +    vpss_select_ccdc_source(source);
>> +
>> +    dev_dbg(dev, "\nEnd of ccdc_restore_defaults...");
>> +}
>> +
>> +static int ccdc_open(struct device *device)
>> +{
>> +    dev = device;
>> +    ccdc_restore_defaults();
>> +    return 0;
>> +}
>> +
>> +/* This function will configure the window size to be capture in CCDC
>reg */
>> +static void ccdc_setwin(struct v4l2_rect *image_win,
>> +                    enum ccdc_frmfmt frm_fmt, int ppc)
>> +{
>> +    int horz_start, horz_nr_pixels;
>> +    int vert_start, vert_nr_lines;
>> +    int mid_img = 0;
>> +
>> +    dev_dbg(dev, "\nStarting ccdc_setwin...");
>> +    /**
>> +     * ppc - per pixel count. indicates how many pixels per cell
>
>Kernel doc style comments are only useful for
>API description, I guess.
[MK] yes. Will change
>
>> +     * output to SDRAM. example, for ycbcr, it is one y and one c, so 2.
>> +     * raw capture this is 1
>> +     */
>> +    horz_start = image_win->left << (ppc - 1);
>> +    horz_nr_pixels = ((image_win->width) << (ppc - 1)) - 1;
>> +
>> +    /* Writing the horizontal info into the registers */
>> +    regw(horz_start & START_PX_HOR_MASK, SPH);
>> +    regw(horz_nr_pixels & NUM_PX_HOR_MASK, LNH);
>> +    vert_start = image_win->top;
>> +
>> +    if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
>> +            vert_nr_lines = (image_win->height >> 1) - 1;
>> +            vert_start >>= 1;
>> +            /* To account for VD since line 0 doesn't have any data */
>> +            vert_start += 1;
>> +    } else {
>> +            /* To account for VD since line 0 doesn't have any data */
>> +            vert_start += 1;
>> +            vert_nr_lines = image_win->height - 1;
>> +            /* configure VDINT0 and VDINT1 */
>> +            mid_img = vert_start + (image_win->height / 2);
>> +            regw(mid_img, VDINT1);
>> +    }
>> +
>> +    regw(0, VDINT0);
>> +    regw(vert_start & START_VER_ONE_MASK, SLV0);
>> +    regw(vert_start & START_VER_TWO_MASK, SLV1);
>> +    regw(vert_nr_lines & NUM_LINES_VER, LNV);
>> +}
>> +
>> +static void ccdc_config_bclamp(struct ccdc_black_clamp *bc)
>> +{
>> +    u32 val;
>> +
>> +    /**
>> +     * DC Offset is always added to image data irrespective of bc enable
>> +     * status
>> +     */
>
>.. ditto ..
[MK] Will change
>
>> +    val = bc->dc_offset & CCDC_BC_DCOFFSET_MASK;
>> +    regw(val, CLDCOFST);
>> +
>> +    if (bc->en) {
>> +            val = (bc->bc_mode_color & CCDC_BC_MODE_COLOR_MASK) <<
>> +                    CCDC_BC_MODE_COLOR_SHIFT;
>> +
>> +            /* Enable BC and horizontal clamp caculation paramaters */
>> +            val = val | 1 | ((bc->horz.mode & CCDC_HORZ_BC_MODE_MASK) <<
>> +            CCDC_HORZ_BC_MODE_SHIFT);
>> +
>> +            regw(val, CLAMPCFG);
>> +
>> +            if (bc->horz.mode != CCDC_HORZ_BC_DISABLE) {
>> +                    /**
>> +                     * Window count for calculation
>> +                     * Base window selection
>> +                     * pixel limit
>> +                     * Horizontal size of window
>> +                     * vertical size of the window
>> +                     * Horizontal start position of the window
>> +                     * Vertical start position of the window
>> +                     */
>> +                    val = (bc->horz.win_count_calc &
>> +                            CCDC_HORZ_BC_WIN_COUNT_MASK) |
>> +                            ((bc->horz.base_win_sel_calc & 1)
>> +                            << CCDC_HORZ_BC_WIN_SEL_SHIFT) |
>> +                            ((bc->horz.clamp_pix_limit & 1)
>> +                            << CCDC_HORZ_BC_PIX_LIMIT_SHIFT) |
>> +                            ((bc->horz.win_h_sz_calc &
>> +                            CCDC_HORZ_BC_WIN_H_SIZE_MASK)
>> +                            << CCDC_HORZ_BC_WIN_H_SIZE_SHIFT) |
>> +                            ((bc->horz.win_v_sz_calc &
>> +                            CCDC_HORZ_BC_WIN_V_SIZE_MASK)
>> +                            << CCDC_HORZ_BC_WIN_V_SIZE_SHIFT);
>> +
>> +                    regw(val, CLHWIN0);
>> +
>> +                    val = (bc->horz.win_start_h_calc &
>> +                            CCDC_HORZ_BC_WIN_START_H_MASK);
>> +                    regw(val, CLHWIN1);
>> +
>> +                    val =
>> +                        (bc->horz.
>> +                         win_start_v_calc & CCDC_HORZ_BC_WIN_START_V_MASK);
>
>Too much broken line. Suggest breaking at & instead.
>
[MK] Ok.

>> +                    regw(val, CLHWIN2);
>> +            }
>> +
>> +            /* vertical clamp caculation paramaters */
>> +
>> +            /* OB H Valid */
>> +            val = (bc->vert.ob_h_sz_calc & CCDC_VERT_BC_OB_H_SZ_MASK);
>> +
>> +            /* Reset clamp value sel for previous line */
>> +            val |= ((bc->vert.reset_val_sel &
>> +                    CCDC_VERT_BC_RST_VAL_SEL_MASK)
>> +                    << CCDC_VERT_BC_RST_VAL_SEL_SHIFT);
>> +
>> +            /* Line average coefficient */
>> +            val |= (bc->vert.line_ave_coef <<
>> +                    CCDC_VERT_BC_LINE_AVE_COEF_SHIFT);
>> +            regw(val, CLVWIN0);
>> +
>> +            /* Configured reset value */
>> +            if (bc->vert.reset_val_sel ==
>> +                CCDC_VERT_BC_USE_CONFIG_CLAMP_VAL) {
>> +                    val =
>> +                        (bc->vert.
>> +                         reset_clamp_val & CCDC_VERT_BC_RST_VAL_MASK);
>
>.. ditto .. There are other places in the patch
>where line breaks needs revisit.
[MK] Ok.
>
>> +                    regw(val, CLVRV);
>> +            }
>> +
>> +            /* Optical Black horizontal start position */
>> +            val = (bc->vert.ob_start_h & CCDC_VERT_BC_OB_START_HORZ_MASK);
>> +            regw(val, CLVWIN1);
>> +
>> +            /* Optical Black vertical start position */
>> +            val = (bc->vert.ob_start_v & CCDC_VERT_BC_OB_START_VERT_MASK);
>> +            regw(val, CLVWIN2);
>> +
>> +            val = (bc->vert.ob_v_sz_calc & CCDC_VERT_BC_OB_VERT_SZ_MASK);
>> +            regw(val, CLVWIN3);
>> +
>> +            /* Vertical start position for BC subtraction */
>> +            val = (bc->vert_start_sub & CCDC_BC_VERT_START_SUB_V_MASK);
>> +            regw(val, CLSV);
>> +    }
>> +}
>> +
>> +static void ccdc_config_linearization(struct ccdc_linearize *linearize)
>> +{
>> +    u32 val, i;
>> +    if (!linearize->en) {
>
>Typically an empty line is used after variable
>declarations.
>
[MK] Ok.

>> +            regw(0, LINCFG0);
>> +            return;
>> +    }
>> +
>> +    /* shift value for correction */
>> +    val = (linearize->corr_shft & CCDC_LIN_CORRSFT_MASK)
>> +        << CCDC_LIN_CORRSFT_SHIFT;
>> +    /* enable */
>> +    val |= 1;
>> +    regw(val, LINCFG0);
>> +
>> +    /* Scale factor */
>> +    val = (linearize->scale_fact.integer & 1)
>> +        << CCDC_LIN_SCALE_FACT_INTEG_SHIFT;
>> +    val |= (linearize->scale_fact.decimal &
>> +                            CCDC_LIN_SCALE_FACT_DECIMAL_MASK);
>> +    regw(val, LINCFG1);
>> +
>> +    for (i = 0; i < CCDC_LINEAR_TAB_SIZE; i++) {
>> +            val = linearize->table[i] & CCDC_LIN_ENTRY_MASK;
>> +            if (i%2)
>> +                    regw_lin_tbl(val, ((i >> 1) << 2), 1);
>> +            else
>> +                    regw_lin_tbl(val, ((i >> 1) << 2), 0);
>> +    }
>> +}
>> +
>> +static void ccdc_config_dfc(struct ccdc_dfc *vdfc)
>> +{
>> +#define DFC_WRITE_WAIT_COUNT        1000
>> +    u32 val, count = DFC_WRITE_WAIT_COUNT;
>> +    int i;
>> +
>> +    if (!vdfc->en)
>> +            return;
>> +
>> +    /* Correction mode */
>> +    val = ((vdfc->corr_mode & CCDC_VDFC_CORR_MOD_MASK)
>> +            << CCDC_VDFC_CORR_MOD_SHIFT);
>> +
>> +    /* Correct whole line or partial */
>> +    if (vdfc->corr_whole_line)
>> +            val |= 1 << CCDC_VDFC_CORR_WHOLE_LN_SHIFT;
>> +
>> +    /* level shift value */
>> +    val |= (vdfc->def_level_shift & CCDC_VDFC_LEVEL_SHFT_MASK) <<
>> +            CCDC_VDFC_LEVEL_SHFT_SHIFT;
>> +
>> +    regw(val, DFCCTL);
>> +
>> +    /* Defect saturation level */
>> +    val = vdfc->def_sat_level & CCDC_VDFC_SAT_LEVEL_MASK;
>> +    regw(val, VDFSATLV);
>> +
>> +    regw(vdfc->table[0].pos_vert & CCDC_VDFC_POS_MASK, DFCMEM0);
>> +    regw(vdfc->table[0].pos_horz & CCDC_VDFC_POS_MASK, DFCMEM1);
>> +    if (vdfc->corr_mode == CCDC_VDFC_NORMAL ||
>> +        vdfc->corr_mode == CCDC_VDFC_HORZ_INTERPOL_IF_SAT) {
>> +            regw(vdfc->table[0].level_at_pos, DFCMEM2);
>> +            regw(vdfc->table[0].level_up_pixels, DFCMEM3);
>> +            regw(vdfc->table[0].level_low_pixels, DFCMEM4);
>> +    }
>> +
>> +    val = regr(DFCMEMCTL);
>> +    /* set DFCMARST and set DFCMWR */
>> +    val |= 1 << CCDC_DFCMEMCTL_DFCMARST_SHIFT;
>> +    val |= 1;
>> +    regw(val, DFCMEMCTL);
>> +
>> +    while (count && (regr(DFCMEMCTL) & 0x01))
>> +            count--;
>
>This is CPU speed dependent. Suggest using udelay()
>or loops_per_jiffy instead.
>
[MK] will investigate.
>> +
>> +    val = regr(DFCMEMCTL);
>> +    if (!count) {
>> +            dev_dbg(dev, "defect table write timeout !!!\n");
>> +            return;
>> +    }
>> +
>> +    for (i = 1; i < vdfc->num_vdefects; i++) {
>> +            regw(vdfc->table[i].pos_vert & CCDC_VDFC_POS_MASK,
>> +                       DFCMEM0);
>> +            regw(vdfc->table[i].pos_horz & CCDC_VDFC_POS_MASK,
>> +                       DFCMEM1);
>> +            if (vdfc->corr_mode == CCDC_VDFC_NORMAL ||
>> +                vdfc->corr_mode == CCDC_VDFC_HORZ_INTERPOL_IF_SAT) {
>> +                    regw(vdfc->table[i].level_at_pos, DFCMEM2);
>> +                    regw(vdfc->table[i].level_up_pixels, DFCMEM3);
>> +                    regw(vdfc->table[i].level_low_pixels, DFCMEM4);
>> +            }
>> +            val = regr(DFCMEMCTL);
>> +            /* clear DFCMARST and set DFCMWR */
>> +            val &= ~(1 << CCDC_DFCMEMCTL_DFCMARST_SHIFT);
>
>Could use BIT(x) here.
[MK] Will check
>
>> +            val |= 1;
>> +            regw(val, DFCMEMCTL);
>> +
>> +            count = DFC_WRITE_WAIT_COUNT;
>> +            while (count && (regr(DFCMEMCTL) & 0x01))
>> +                    count--;
>> +
>> +            val = regr(DFCMEMCTL);
>> +            if (!count) {
>> +                    dev_err(dev, "defect table write timeout !!!\n");
>> +                    return;
>> +            }
>> +    }
>> +    if (vdfc->num_vdefects < CCDC_VDFC_TABLE_SIZE) {
>> +            /* Extra cycle needed */
>> +            regw(0, DFCMEM0);
>> +            regw(0x1FFF, DFCMEM1);
>> +            val = 1;
>> +            regw(val, DFCMEMCTL);
>> +    }
>> +
>> +    /* enable VDFC */
>> +    ccdc_merge((1 << CCDC_VDFC_EN_SHIFT), (1 << CCDC_VDFC_EN_SHIFT),
>> +               DFCCTL);
>> +
>> +    ccdc_merge((1 << CCDC_VDFC_EN_SHIFT), (0 << CCDC_VDFC_EN_SHIFT),
>> +               DFCCTL);
>> +
>> +    regw(0x6, DFCMEMCTL);
>> +    for (i = 0 ; i < vdfc->num_vdefects; i++) {
>> +            count = DFC_WRITE_WAIT_COUNT;
>> +            while (count && (regr(DFCMEMCTL) & 0x2))
>> +                    count--;
>> +
>> +            val = regr(DFCMEMCTL);
>> +            if (!count) {
>> +                    dev_err(dev, "defect table write timeout !!!\n");
>> +                    return;
>> +            }
>> +
>> +            val = regr(DFCMEM0) | regr(DFCMEM1) | regr(DFCMEM2) |
>> +                    regr(DFCMEM3) | regr(DFCMEM4);
>> +            regw(0x2, DFCMEMCTL);
>> +    }
>> +}
>> +
>
>[...]
>
>> +
>> +static int ccdc_config_raw(void)
>> +{
>> +    struct ccdc_params_raw *params = &ccdc_cfg.bayer;
>> +    struct ccdc_config_params_raw *module_params =
>> +            &ccdc_cfg.bayer.config_params;
>> +    struct vpss_pg_frame_size frame_size;
>> +    struct vpss_sync_pol sync;
>> +    u32 val;
>> +
>> +    dev_dbg(dev, "\nStarting ccdc_config_raw..\n");
>> +
>> +    /* Configure CCDCFG register */
>> +
>> +    /**
>> +     * Set CCD Not to swap input since input is RAW data
>> +     * Set FID detection function to Latch at V-Sync
>> +     * Set WENLOG - ccdc valid area
>> +     * Set TRGSEL
>> +     * Set EXTRG
>> +     * Packed to 8 or 16 bits
>> +     */
>> +
>> +    val = CCDC_YCINSWP_RAW | CCDC_CCDCFG_FIDMD_LATCH_VSYNC |
>> +            CCDC_CCDCFG_WENLOG_AND | CCDC_CCDCFG_TRGSEL_WEN |
>> +            CCDC_CCDCFG_EXTRG_DISABLE | (ccdc_cfg.data_pack &
>> +            CCDC_DATA_PACK_MASK);
>> +
>> +    dev_dbg(dev, "Writing 0x%x to ...CCDCFG \n", val);
>> +    regw(val, CCDCFG);
>> +
>> +    /**
>> +     * Configure the vertical sync polarity(MODESET.VDPOL)
>> +     * Configure the horizontal sync polarity (MODESET.HDPOL)
>> +     * Configure frame id polarity (MODESET.FLDPOL)
>> +     * Configure data polarity
>> +     * Configure External WEN Selection
>> +     * Configure frame format(progressive or interlace)
>> +     * Configure pixel format (Input mode)
>> +     * Configure the data shift
>> +     */
>> +
>> +    val = CCDC_VDHDOUT_INPUT |
>> +            ((params->vd_pol & CCDC_VD_POL_MASK) << CCDC_VD_POL_SHIFT) |
>> +            ((params->hd_pol & CCDC_HD_POL_MASK) << CCDC_HD_POL_SHIFT) |
>> +            ((params->fid_pol & CCDC_FID_POL_MASK) << CCDC_FID_POL_SHIFT) |
>> +            ((CCDC_DATAPOL_NORMAL & CCDC_DATAPOL_MASK)
>> +                    << CCDC_DATAPOL_SHIFT) |
>> +            ((CCDC_EXWEN_DISABLE & CCDC_EXWEN_MASK) << CCDC_EXWEN_SHIFT) |
>> +            ((params->frm_fmt & CCDC_FRM_FMT_MASK) << CCDC_FRM_FMT_SHIFT) |
>> +            ((params->pix_fmt & CCDC_INPUT_MASK) << CCDC_INPUT_SHIFT) |
>> +            ((params->config_params.data_shift & CCDC_DATASFT_MASK)
>> +                    << CCDC_DATASFT_SHIFT);
>> +
>> +    regw(val, MODESET);
>> +    dev_dbg(dev, "Writing 0x%x to MODESET...\n", val);
>> +
>> +    /**
>> +     * Configure GAMMAWD register
>> +     * CFA pattern setting
>> +     */
>> +    val = (params->cfa_pat & CCDC_GAMMAWD_CFA_MASK) <<
>> +            CCDC_GAMMAWD_CFA_SHIFT;
>> +
>> +    /* Gamma msb */
>> +    if (module_params->compress.alg == CCDC_ALAW)
>> +            val = val | CCDC_ALAW_ENABLE;
>
>val |= CCDC_ALAW_ENABLE;
>
>> +
>> +    val = val | ((params->data_msb & CCDC_ALAW_GAMA_WD_MASK) <<
>> +                    CCDC_ALAW_GAMA_WD_SHIFT);
>
>.. ditto ..
>
[MK] Will check.
>> +static int ccdc_set_pixel_format(unsigned int pixfmt)
>> +{
>> +    if (ccdc_cfg.if_type == VPFE_RAW_BAYER) {
>> +            if (pixfmt == V4L2_PIX_FMT_SBGGR8) {
>> +                    if ((ccdc_cfg.bayer.config_params.compress.alg !=
>> +                                    CCDC_ALAW) &&
>> +                        (ccdc_cfg.bayer.config_params.compress.alg !=
>> +                                    CCDC_DPCM)) {
>> +                            dev_dbg(dev, "Either configure A-Law or"
>> +                                            "DPCM\n");
>
>Space required before DPCM
>
>Thanks,
>Sekhar
[MK] Ok.

