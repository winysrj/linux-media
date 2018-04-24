Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:45671 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbeDXEgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 00:36:17 -0400
Received: by mail-vk0-f45.google.com with SMTP id 203so10810992vka.12
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 21:36:17 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id d35sm1115957uag.47.2018.04.23.21.36.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Apr 2018 21:36:16 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id q189so10819328vkb.0
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 21:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20180308094807.9443-1-jacob-chen@iotwrt.com> <20180308094807.9443-4-jacob-chen@iotwrt.com>
In-Reply-To: <20180308094807.9443-4-jacob-chen@iotwrt.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 24 Apr 2018 04:28:49 +0000
Message-ID: <CAAFQd5APomi1tx0X=agbSQfsX3SLBwqsXyqGhWzS4mdDcS+N9g@mail.gmail.com>
Subject: Re: [PATCH v6 03/17] media: rkisp1: Add user space ABI definitions
To: Jacob Chen <jacob-chen@iotwrt.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy <jeffy.chen@rock-chips.com>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Chen Jacob <jacob2.chen@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 8, 2018 at 6:48 PM Jacob Chen <jacob-chen@iotwrt.com> wrote:
[snip]
> +/**
> + * struct cifisp_lsc_config - Configuration used by Lens shading
correction
> + *
> + * refer to REF_01 for details
> + */
> +struct cifisp_lsc_config {
> +       __u32 r_data_tbl[CIFISP_LSC_DATA_TBL_SIZE];
> +       __u32 gr_data_tbl[CIFISP_LSC_DATA_TBL_SIZE];
> +       __u32 gb_data_tbl[CIFISP_LSC_DATA_TBL_SIZE];
> +       __u32 b_data_tbl[CIFISP_LSC_DATA_TBL_SIZE];
> +
> +       __u32 x_grad_tbl[CIFISP_LSC_GRAD_TBL_SIZE];
> +       __u32 y_grad_tbl[CIFISP_LSC_GRAD_TBL_SIZE];
> +
> +       __u32 x_size_tbl[CIFISP_LSC_SIZE_TBL_SIZE];
> +       __u32 y_size_tbl[CIFISP_LSC_SIZE_TBL_SIZE];

Looking at the code, we only need 12 bits of each, so perhaps it could make
sense to make those __u16? Also, the natural layout for these seems to be
two-dimensional, i.e. [CIFISP_LSC_NUM_SECTORS][CIFISP_LSC_NUM_SECTORS]. I
think it wouldn't be a problem to define it this way for UAPI too.

> +       __u16 config_width;
> +       __u16 config_height;

These 2 seem unused. Just making sure. If they are part of hardware LSC
configuration, then we should keep them.

[snip]
> +struct cifisp_awb_meas_config {
> +       /*
> +        * Note: currently the h and v offsets are mapped to grid offsets
> +        */

Perhaps should be part of the kerneldoc comment above? Also, I don't seem
to understand what this means.

> +       struct cifisp_window awb_wnd;
> +       __u32 awb_mode;
> +       __u8 max_y;
> +       __u8 min_y;
> +       __u8 max_csum;
> +       __u8 min_c;
> +       __u8 frames;
> +       __u8 awb_ref_cr;
> +       __u8 awb_ref_cb;
> +       __u8 enable_ymax_cmp;
> +} __attribute__ ((packed));
> +
> +/**
> + * struct cifisp_awb_gain_config - Configuration used by auto white
balance gain
> + *
> + * out_data_x = ( AWB_GEAIN_X * in_data + 128) >> 8

typo: AWB_GAIN?

> + */
> +struct cifisp_awb_gain_config {
> +       __u16 gain_red;
> +       __u16 gain_green_r;
> +       __u16 gain_blue;
> +       __u16 gain_green_b;
> +} __attribute__ ((packed));
> +
> +/**
> + * struct cifisp_flt_config - Configuration used by ISP filtering
> + *
> + * @mode: ISP_FILT_MODE register fields (from enum cifisp_flt_mode)
> + * @grn_stage1: ISP_FILT_MODE register fields
> + * @chr_h_mode: ISP_FILT_MODE register fields
> + * @chr_v_mode: ISP_FILT_MODE register fields

Missing documentation for remaining fields.

> + *
> + * refer to REF_01 for details.
> + */
> +
> +struct cifisp_flt_config {
> +       __u32 mode;
> +       __u8 grn_stage1;
> +       __u8 chr_h_mode;
> +       __u8 chr_v_mode;

Maybe we could move u8 below u32 to optimize the alignment?

[snip]
> +/**
> + * struct cifisp_hst_config - Configuration used by Histogram
> + *
> + * @mode: histogram mode (from enum cifisp_histogram_mode)
> + * @histogram_predivider: process every stepsize pixel, all other pixels
are skipped
> + * @meas_window: coordinates of the measure window
> + * @hist_weight: weighting factor for sub-windows
> + */
> +struct cifisp_hst_config {
> +       __u32 mode;
> +       __u8 histogram_predivider;
> +       struct cifisp_window meas_window;

Perhaps could swap the two above for better alignment?

> +       __u8 hist_weight[CIFISP_HISTOGRAM_WEIGHT_GRIDS_SIZE];
> +} __attribute__ ((packed));
> +
> +/**
> + * struct cifisp_aec_config - Configuration used by Auto Exposure Control
> + *
> + * @mode: Exposure measure mode (from enum cifisp_exp_meas_mode)
> + * @autostop: stop mode (from enum cifisp_exp_ctrl_autostop)
> + * @meas_window: coordinates of the measure window
> + */
> +struct cifisp_aec_config {
> +       __u32 mode;
> +       __u32 autostop;
> +       struct cifisp_window meas_window;
> +} __attribute__ ((packed));
> +
> +/**
> + * struct cifisp_afc_config - Configuration used by Auto Focus Control
> + *
> + * @num_afm_win: max CIFISP_AFM_MAX_WINDOWS
> + * @afm_win: coordinates of the meas window
> + * @thres: threshold used for minimizing the influence of noise
> + * @var_shift: the number of bits for the shift operation at the end of
the calculation chain.
> + */
> +struct cifisp_afc_config {
> +       __u8 num_afm_win;
> +       struct cifisp_window afm_win[CIFISP_AFM_MAX_WINDOWS];
> +       __u32 thres;
> +       __u32 var_shift;

Perhaps could put afm_win[] and then num_afm_win here, for better alignment?

Best regards,
Tomasz
