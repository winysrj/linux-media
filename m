Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2GZAM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 20:12:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Date: Thu, 26 Jul 2012 02:12:33 +0200
Message-ID: <1918750.d6McV9yAhK@avalon>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E93ED8F@DBDE01.ent.ti.com>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <6781973.T5EQaLmeMs@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E93ED8F@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

On Tuesday 17 July 2012 10:43:54 Hadli, Manjunath wrote:
> On Sun, Jul 15, 2012 at 18:16:25, Laurent Pinchart wrote:
> > On Wednesday 11 July 2012 21:09:26 Manjunath Hadli wrote:
> > > Add documentation on the Davinci VPFE driver. Document the subdevs,
> > > and private IOTCLs the driver implements
> > > 
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>

[snip]

> > > +	DAVINCI CCDC
> > > +	DAVINCI PREVIEWER
> > > +	DAVINCI RESIZER
> > 
> > the DM36x VPFE documentation doesn't split the hardware in CCDC, PREVIEWER
> > and RESIZER modules, but in ISIF, IPIPEIF and IPIPE. Why don't you use
> > those names ? It looks like you're introducing an abstraction layer on
> > top of the existing driver. Why is that needed, why don't you just port
> > the driver to the MC API instead ?
> 
> Please see below my comment for "enumerating internal modules".
> 
> > > +	DAVINCI AEW
> > > +	DAVINCI AF
> > > +
> > > +Each possible link in the VPFE is modeled by a link in the Media
> > > controller +interface. For an example program see [1].
> > > +
> > > +
> > > +Private IOCTLs
> > > +==============
> > > +
> > > +The Davinci Video processing Front End (VPFE) driver supports standard
> > > V4L2 +IOCTLs and controls where possible and practical. Much of the
> > > functions provided
> > > +by the VPFE, however, does not fall under the standard IOCTLs.
> > > +
> > > +In general, there is a private ioctl for configuring each of the blocks
> > > +containing hardware-dependent functions.
> > > +
> > > +The following private IOCTLs are supported:
> > > +
> > > +1: IOCTL: PREV_S_PARAM/PREV_G_PARAM
> > > +Description:
> > > +	Sets/Gets the parameters required by the previewer module
> > > +Parameter:
> > > +	/**
> > > +	 * struct prev_module_param- structure to configure preview modules
> > > +	 * @version: Version of the preview module
> > 
> > Who is responsible for filling this field, the application or the driver ?
> 
> The application is responsible for filling this info. He would enumerate the
> capabilities first and  set them using S_PARAM/G_PARAM.
> 
> > > +	 * @len: Length of the module config structure
> > > +	 * @module_id: Module id
> > > +	 * @param: pointer to module config parameter.
> > 
> > What is module_id for ? What does param point to ?
> 
> There are a lot of tiny modules in the previewer/resizer which are
> enumerated as individual modules. The param points to the parameter set
> that the module expects to be set.
> 
> > > +	 */
> > > +	struct prev_module_param {
> > > +		char version[IMP_MAX_NAME_SIZE];
> > 
> > Is there a need to express the version as a string instead of an integer ?
> 
> It could be integer. It is generally a fixed point num, and easy to read it
> as a string than an integer. Can I keep it as a string?
> 
> > > +		unsigned short len;
> > > +		unsigned short module_id;
> > > +		void *param;
> > > +	};
> > > +
> > > +2: IOCTL: PREV_S_CONFIG/PREV_G_CONFIG
> > > +Description:
> > > +	Sets/Gets the configuration required by the previewer channel
> > > +Parameter:
> > > +	/**
> > > +	 * struct prev_channel_config - structure for configuring the
> > > previewer
> > > channel
> > > +	 * @len: Length of the user configuration
> > > +	 * @config: pointer to either single shot config or continuous
> > > +	 */
> > > +	struct prev_channel_config {
> > > +		unsigned short len;
> > > +		void *config;
> > > +	};
> > 
> > What's the difference between parameters and configuration ? What does
> > config point to ?
> 
> Config is setting which is required for a subdev to function based on what
> it is set for (single shot/continuous.) common to all platforms. Parameters
> are the settings for individual small sub-ips which might be slightly
> different from one platform to another. Config points to
> prev_single_shot_config or  prev_continuous_config currently defined in
> linux/dm3656ipipe.h. I think we will move it to a common location.
> > > +
> > > +3: IOCTL: PREV_ENUM_CAP
> > > +Description:
> > > +	Queries the modules available in the image processor for preview the
> > > +	input image.
> > > +Parameter:
> > > +	/**
> > > +	 * struct prev_cap - structure to enumerate capabilities of previewer
> > > +	 * @index: application use this to iterate over the available modules
> > > +	 * @version: version of the preview module
> > > +	 * @module_id: module id
> > > +	 * @control: control operation allowed in continuous mode? 1 -
> > > allowed, 0
> > > - not allowed
> > > +	 * @path: path on which the module is sitting
> > > +	 * @module_name: module name
> > > +	 */
> > > +	struct prev_cap {
> > > +		unsigned short index;
> > > +		char version[IMP_MAX_NAME_SIZE];
> > > +		unsigned short module_id;
> > > +		char control;
> > > +		enum imp_data_paths path;
> > > +		char module_name[IMP_MAX_NAME_SIZE];
> > > +	};
> > 
> > Enumerating internal modules is exactly what the MC API was designed for.
> > Why do you reimplement that using private ioctls ?
> 
> The number of these sub-Ips are quite a few in DM365 and Dm355, having a lot
> of them In a way that may be bewildering to the end-user to be able to
> connect them quickly and properly. But overall, these are nothing but
> exposed subips of what we call as CCDC,Previewer  and Resizer.It Made a lot
> of logical sense to keep it that way, give a default configuration for
> everything, and if at all the user wants the fine grain config control, be
> able to give (mainly for the configurations- not so much for connections).
> In most of the cases the param IOTCLs are only used for fine-tuning the
> image and not expected to be used as a regular flow of a normal
> application. I do not think there could be any justification for making all
> these nitty gritty which keep changing for each IPs as part of regular V4L2
> IOCTLs. In future, if there is a common theme that emerges, we could
> definitely relook into this.
> > > +
> > > +4: IOCTL: RSZ_S_CONFIG/RSZ_G_CONFIG
> > > +Description:
> > > +	Sets/Gets the configuration required by the resizer channel
> > > +Parameter:
> > > +	/**
> > > +	 * struct rsz_channel_config - structure for configuring the resizer
> > > channel +	 * @chain: chain this resizer at the previewer output
> > > +	 * @len: length of the user configuration
> > > +	 * @config: pointer to either single shot config or continuous
> > > +	 */
> > > +	struct rsz_channel_config {
> > > +		unsigned char chain;
> > > +		unsigned short len;
> > > +		void *config;
> > > +	};
> > 
> > Same question as for the preview engine, what does this do, what does
> > config point to ? What is the chain parameter for ?
> 
> Config points to rsz_single_shot_config and rsz_continuous_config defined in
> dm365ipipe.h As mentioned earlier, we could move the definition to a common
> header. The chain param is to indicate if resizer and previewer are
> chained. We will remove this.
> > > +
> > > +5: IOCTL: VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS
> > > +Description:
> > > +	Sets/Gets the CCDC parameter
> > > +Parameter:
> > > +	/**
> > > +	 * struct ccdc_config_params_raw - structure for configuring ccdc
> > > params
> > > +	 * @linearize: linearization parameters for image sensor data input
> > > +	 * @df_csc: data formatter or CSC
> > > +	 * @dfc: defect Pixel Correction (DFC) configuration
> > > +	 * @bclamp: Black/Digital Clamp configuration
> > > +	 * @gain_offset: Gain, offset adjustments
> > 
> > Can't you use subdev V4L2 controls for gains ?
> 
> In that case only gain has to be taken out as a generic IOCTL. Since that is
> is The parameter which could be taken out of this big structure
> 
> > > +	 * @culling: Culling
> > > +	 * @pred: predictor for DPCM compression
> > > +	 * @horz_offset: horizontal offset for Gain/LSC/DFC
> > > +	 * @vert_offset: vertical offset for Gain/LSC/DFC
> > > +	 * @col_pat_field0: color pattern for field 0
> > > +	 * @col_pat_field1: color pattern for field 1
> > 
> > Shouldn't color patterns be computed automatically by the driver based on
> > the media bus pixel code ?
> 
> OK.
> 
> > > +	 * @data_size: data size from 8 to 16 bits
> > > +	 * @data_shift: data shift applied before storing to SDRAM
> > 
> > Ditto, this should probably be computed automatically.
> 
> Do you want to define new MBUS formats for these?
> 
> > > +	 * @test_pat_gen: enable input test pattern generation
> > 
> > You could use a subdev V4L2 control for that.
> 
> Ok.
> 
> > > +	 */
> > > +	struct ccdc_config_params_raw {
> > > +		struct ccdc_linearize linearize;
> > > +		struct ccdc_df_csc df_csc;
> > > +		struct ccdc_dfc dfc;
> > > +		struct ccdc_black_clamp bclamp;
> > > +		struct ccdc_gain_offsets_adj gain_offset;
> > > +		struct ccdc_cul culling;
> > > +		enum ccdc_dpcm_predictor pred;
> > > +		unsigned short horz_offset;
> > > +		unsigned short vert_offset;
> > > +		struct ccdc_col_pat col_pat_field0;
> > > +		struct ccdc_col_pat col_pat_field1;
> > > +		enum ccdc_data_size data_size;
> > > +		enum ccdc_datasft data_shift;
> > > +		unsigned char test_pat_gen;
> > > +	};

[snip
> > > +
> > > +6: IOCTL: AF_S_PARAM/AF_G_PARAM
> > > +Description:
> > > +	AF_S_PARAM performs the hardware setup and sets the parameter for
> > > +	AF engine.AF_G_PARAM gets the parameter setup in AF engine
> > > +Parameter:
> > > +	/**
> > > +	 * struct af_configuration - struct to configure parameters of AF
> > > engine
> > > +	 * @alaw_enable: ALAW status
> > > +	 * @fv_sel: focus value selection
> > > +	 * @hmf_config: HMF configurations
> > > +	 * @rgb_pos: RGB Positions. Only applicable with AF_HFV_ONLY 
selection
> > > +	 * @iir_config: IIR filter configurations
> > > +	 * @fir_config: FIR filter configuration
> > > +	 * @paxel_config: Paxel parameters
> > > +	 * @mode: accumulator mode
> > > +	 */
> > > +	struct af_configuration {
> > > +		enum af_enable_flag alaw_enable;
> > 
> > Can this be computed automatically based on the media bus pixel code ?
> 
> Ok. Sure.
> 
> > > +		enum af_focus_val_sel fv_sel;
> > > +		struct af_hmf hmf_config;
> > > +		enum rgbpos rgb_pos;
> > 
> > Same here ?
> 
> New MBUS formats here as well?
> 
> > > +		struct af_iir iir_config;
> > > +		struct af_fir fir_config;
> > > +		struct af_paxel paxel_config;
> > > +		enum af_mode mode;
> > > +	};
> > > +
> > > +7: IOCTL: AF_GET_STAT
> > > +Description:
> > > +	Copy the entire statistics located in application buffer
> > > +	to user space from the AF engine
> > > +Parameter:
> > > +	/**
> > > +	 * struct af_statdata - structure to get statistics from AF engine
> > > +	 * @buffer: pointer to buffer
> > > +	 * @buf_length: length of buffer
> > > +	 */
> > > +	struct af_statdata {
> > > +		void *buffer;
> > > +		int buf_length;
> > > +	};
> > 
> > The OMAP3 ISP driver also needs to export statistics data to userspace. We
> > should design a common API here.
> 
>  Sure we can take it up sometime later.

[snip]

> > > +9: IOCTL: AEW_GET_STAT
> > > +Description:
> > > +	Copy the entire statistics located in application buffer
> > > +	to user space from the AEW engine
> > > +Parameter:
> > > +	/**
> > > +	 * struct aew_statdata - structure to get statistics from AEW engine
> > > +	 * @buffer: pointer to buffer
> > > +	 * @buf_length: length of buffer
> > > +	 */
> > > +	struct aew_statdata {
> > > +		void *buffer;
> > > +		int buf_length;
> > > +	};
> > 
> > Same comment as for AF_GET_STAT.
> 
> Yes, we can discuss about it to make it common. I would prefer we get this
> driver in and make amends when you are doing it for OMAP.

-- 
Regards,

Laurent Pinchart
