Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55825 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZANWLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 17:11:02 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "mchehab@infradead.org" <mchehab@infradead.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"sakari.ailus@nokia.com" <sakari.ailus@nokia.com>,
	"tuukka.o.toivonen@nokia.com" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Wed, 14 Jan 2009 16:10:14 -0600
Subject: RE: [REVIEW PATCH 04/14] OMAP: CAM: Add ISP user header and
 register defs
Message-ID: <A24693684029E5489D1D202277BE8944153C47FF@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> Sent: Tuesday, January 13, 2009 2:42 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org; video4linux-
> list@redhat.com; Sakari Ailus; Tuukka.O Toivonen; Nagalla, Hari
> Subject: Re: [REVIEW PATCH 04/14] OMAP: CAM: Add ISP user header and
> register defs
>
> On Mon, 12 Jan 2009 20:03:15 -0600
> "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> wrote:
>
> > +/* ISP Private IOCTLs */
> > +#define VIDIOC_PRIVATE_ISP_CCDC_CFG    \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct
> ispccdc_update_config)
> > +#define VIDIOC_PRIVATE_ISP_PRV_CFG \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct ispprv_update_config)
> > +#define VIDIOC_PRIVATE_ISP_AEWB_CFG \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 4, struct isph3a_aewb_config)
> > +#define VIDIOC_PRIVATE_ISP_AEWB_REQ \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct isph3a_aewb_data)
> > +#define VIDIOC_PRIVATE_ISP_HIST_CFG \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct isp_hist_config)
> > +#define VIDIOC_PRIVATE_ISP_HIST_REQ \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 7, struct isp_hist_data)
> > +#define VIDIOC_PRIVATE_ISP_AF_CFG \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 8, struct af_configuration)
> > +#define VIDIOC_PRIVATE_ISP_AF_REQ \
> > +       _IOWR('V', BASE_VIDIOC_PRIVATE + 9, struct isp_af_data)
>
> Are those new ioctl meant to be used by the userspace API? If so, we need
> to
> understand each one, since maybe some of them make some sense to be in the
> public API. Also, a proper documentation should be provided for all of
> those
> ioctls.

Yes, this Private IOCTLs that we added to the driver are currently being used by some of our customers by their userspace applications that contain algos for performing Auto Focus, AutoExposure, Auto White Balance, and some other gain table programming into the driver. A description of each one is shown below:

************************************************
OMAP3 ISP driver Private IOCTLs explanation

- VIDIOC_PRIVATE_ISP_CCDC_CFG: Configures the OMAP3 ISP CCDC module settings contained in struct ispccdc_update_config (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/**
 * ispccdc_update_config - Structure for CCDC configuration.
 * @update: Specifies which CCDC registers should be updated.
 * @flag: Specifies which CCDC functions should be enabled.
 * @alawip: Enable/Disable A-Law compression.
 * @bclamp: Black clamp control register.
 * @blcomp: Black level compensation value for RGrGbB Pixels. 2's complement.
 * @fpc: Number of faulty pixels corrected in the frame, address of FPC table.
 * @cull: Cull control register.
 * @colptn: Color pattern of the sensor.
 * @lsc: Pointer to LSC gain table.
 */
struct ispccdc_update_config {
        __u16 update;
        __u16 flag;
        enum alaw_ipwidth alawip;
        struct ispccdc_bclamp *bclamp;
        struct ispccdc_blcomp *blcomp;
        struct ispccdc_fpc *fpc;
        struct ispccdc_lsc_config *lsc_cfg;
        struct ispccdc_culling *cull;
        __u32 colptn;
        __u8 *lsc;
};

- VIDIOC_PRIVATE_ISP_PRV_CFG: Configures the OMAP3 ISP Preview module settings contained in struct ispprv_update_config (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/**
 * struct ispprv_update_config - Structure for Preview Configuration (user).
 * @update: Specifies which ISP Preview registers should be updated.
 * @flag: Specifies which ISP Preview functions should be enabled.
 * @yen: Pointer to luma enhancement table.
 * @shading_shift: 3bit value of shift used in shading compensation.
 * @prev_hmed: Pointer to structure containing the odd and even distance.
 *             between the pixels in the image along with the filter threshold.
 * @prev_cfa: Pointer to structure containing the CFA interpolation table, CFA.
 *            format in the image, vertical and horizontal gradient threshold.
 * @csup: Pointer to Structure for Chrominance Suppression coefficients.
 * @prev_wbal: Pointer to structure for White Balance.
 * @prev_blkadj: Pointer to structure for Black Adjustment.
 * @rgb2rgb: Pointer to structure for RGB to RGB Blending.
 * @prev_csc: Pointer to structure for Color Space Conversion from RGB-YCbYCr.
 * @yclimit: Pointer to structure for Y, C Value Limit.
 * @prev_dcor: Pointer to structure for defect correction.
 * @prev_nf: Pointer to structure for Noise Filter
 * @red_gamma: Pointer to red gamma correction table.
 * @green_gamma: Pointer to green gamma correction table.
 * @blue_gamma: Pointer to blue gamma correction table.
 */
struct ispprv_update_config {
        __u16 update;
        __u16 flag;
        void *yen;
        __u32 shading_shift;
        struct ispprev_hmed *prev_hmed;
        struct ispprev_cfa *prev_cfa;
        struct ispprev_csup *csup;
        struct ispprev_wbal *prev_wbal;
        struct ispprev_blkadj *prev_blkadj;
        struct ispprev_rgbtorgb *rgb2rgb;
        struct ispprev_csc *prev_csc;
        struct ispprev_yclimit *yclimit;
        struct ispprev_dcor *prev_dcor;
        struct ispprev_nf *prev_nf;
        __u32 *red_gamma;
        __u32 *green_gamma;
        __u32 *blue_gamma;
};

- VIDIOC_PRIVATE_ISP_AEWB_CFG: Configures OMAP3 ISP Statistic Collection Modules for Auto Exposure and Auto White Balance algos in userspace. Settings sent using struct isph3a_aewb_config (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/**
 * struct isph3a_aewb_config - AE AWB configuration reset values.
 * saturation_limit: Saturation limit.
 * @win_height: Window Height. Range 2 - 256, even values only.
 * @win_width: Window Width. Range 6 - 256, even values only.
 * @ver_win_count: Vertical Window Count. Range 1 - 128.
 * @hor_win_count: Horizontal Window Count. Range 1 - 36.
 * @ver_win_start: Vertical Window Start. Range 0 - 4095.
 * @hor_win_start: Horizontal Window Start. Range 0 - 4095.
 * @blk_ver_win_start: Black Vertical Windows Start. Range 0 - 4095.
 * @blk_win_height: Black Window Height. Range 2 - 256, even values only.
 * @subsample_ver_inc: Subsample Vertical points increment Range 2 - 32, even
 *                     values only.
 * @subsample_hor_inc: Subsample Horizontal points increment Range 2 - 32, even
 *                     values only.
 * @alaw_enable: AEW ALAW EN flag.
 * @aewb_enable: AE AWB stats generation EN flag.
 */
struct isph3a_aewb_config {
        __u16 saturation_limit;
        __u16 win_height;
        __u16 win_width;
        __u16 ver_win_count;
        __u16 hor_win_count;
        __u16 ver_win_start;
        __u16 hor_win_start;
        __u16 blk_ver_win_start;
        __u16 blk_win_height;
        __u16 subsample_ver_inc;
        __u16 subsample_hor_inc;
        __u8 alaw_enable;
        __u8 aewb_enable;
};

- VIDIOC_PRIVATE_ISP_AEWB_REQ: Used for Auto Exposure and White balance control loops. Retrieves specific frame statistics (based on config set on other IOCTL), and configures used sensor and ISP gains too. Uses struct isph3a_aewb_data (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/**
 * struct isph3a_aewb_data - Structure of data sent to or received from user
 * @h3a_aewb_statistics_buf: Pointer to pass to user.
 * @shutter: Shutter speed.
 * @gain: Sensor analog Gain.
 * @shutter_cap: Shutter speed for capture.
 * @gain_cap: Sensor Gain for capture.
 * @dgain: White balance digital gain.
 * @wb_gain_b: White balance color gain blue.
 * @wb_gain_r: White balance color gain red.
 * @wb_gain_gb: White balance color gain green blue.
 * @wb_gain_gr: White balance color gain green red.
 * @frame_number: Frame number of requested stats.
 * @curr_frame: Current frame number being processed.
 * @update: Bitwise flags to update parameters.
 * @ts: Timestamp of returned framestats.
 * @field_count: Sequence number of returned framestats.
 */
struct isph3a_aewb_data {
        void *h3a_aewb_statistics_buf;
        __u32 shutter;
        __u16 gain;
        __u32 shutter_cap;
        __u16 gain_cap;
        __u16 dgain;
        __u16 wb_gain_b;
        __u16 wb_gain_r;
        __u16 wb_gain_gb;
        __u16 wb_gain_gr;
        __u16 frame_number;
        __u16 curr_frame;
        __u8 update;
        struct timeval ts;
        unsigned long field_count;
};

- VIDIOC_PRIVATE_ISP_HIST_CFG: Configures OMAP3 ISP Histogram Statistic collection module. Uses struct isp_hist_config (defined in arch/arm/plat-omap/include/mach/isp_user.h).

struct isp_hist_config {
        __u8 hist_source;               /* CCDC or Memory */
        __u8 input_bit_width;   /* Needed o know the size per pixel */
        __u8 hist_frames;               /* Num of frames to be processed and
                                 * accumulated
                                 */
        __u8 hist_h_v_info;     /* frame-input width and height if source is
                                 * memory
                                 */
        __u16 hist_radd;                /* frame-input address in memory */
        __u16 hist_radd_off;    /* line-offset for frame-input */
        __u16 hist_bins;        /* number of bins: 32, 64, 128, or 256 */
        __u16 wb_gain_R;        /* White Balance Field-to-Pattern Assignments */
        __u16 wb_gain_RG;       /* White Balance Field-to-Pattern Assignments */
        __u16 wb_gain_B;        /* White Balance Field-to-Pattern Assignments */
        __u16 wb_gain_BG;       /* White Balance Field-to-Pattern Assignments */
        __u8 num_regions;               /* number of regions to be configured */
        __u16 reg0_hor;         /* Region 0 size and position */
        __u16 reg0_ver;         /* Region 0 size and position */
        __u16 reg1_hor;         /* Region 1 size and position */
        __u16 reg1_ver;         /* Region 1 size and position */
        __u16 reg2_hor;         /* Region 2 size and position */
        __u16 reg2_ver;         /* Region 2 size and position */
        __u16 reg3_hor;         /* Region 3 size and position */
        __u16 reg3_ver;         /* Region 3 size and position */
};

- VIDIOC_PRIVATE_ISP_HIST_REQ: Retrieves specific frame statistics (based on config set on other IOCTL). Uses struct isp_hist_data (defined in arch/arm/plat-omap/include/mach/isp_user.h).

struct isp_hist_data {
        __u32 *hist_statistics_buf;     /* Pointer to pass to user */
};

- VIDIOC_PRIVATE_ISP_AF_CFG: Configures OMAP3 ISP Statistic Collection Modules for Auto Focus algo in userspace. Settings sent using struct af_configuration (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/* Contains the parameters required for hardware set up of AF Engine */
struct af_configuration {
        enum af_alaw_enable alaw_enable;        /*ALWAW status */
        struct af_hmf hmf_config;       /*HMF configurations */
        enum rgbpos rgb_pos;            /*RGB Positions */
        struct af_iir iir_config;       /*IIR filter configurations */
        struct af_paxel paxel_config;   /*Paxel parameters */
        enum af_mode mode;              /*Accumulator mode */
        enum af_config_flag af_config; /*Flag indicates Engine is configured */
};

- VIDIOC_PRIVATE_ISP_AF_REQ: Used for Auto Focus control loop. Retrieves specific frame statistics (based on config set on other IOCTL), and configures used lens driver position. Uses struct isp_af_data (defined in arch/arm/plat-omap/include/mach/isp_user.h).

/**
 * struct isp_af_data - AF statistics data to transfer between driver and user.
 * @af_statistics_buf: Pointer to pass to user.
 * @lens_current_position: Read value of lens absolute position.
 * @desired_lens_direction: Lens desired location.
 * @update: Bitwise flags to update parameters.
 * @frame_number: Data for which frame is desired/given.
 * @curr_frame: Current frame number being processed by AF module.
 * @xtrastats: Extra statistics structure.
 */
struct isp_af_data {
        void *af_statistics_buf;
        __u16 lens_current_position;
        __u16 desired_lens_direction;
        __u16 update;
        __u16 frame_number;
        __u16 curr_frame;
        struct isp_af_xtrastats xtrastats;
};

************************************************

I hope this helps in understanding the driver Private IOCTLs better.

Anything else please let me know.

Regards,
Sergio

>
> Cheers,
> Mauro

