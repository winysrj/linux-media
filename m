Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45684 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1I1MBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 08:01:50 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 28 Sep 2011 17:31:42 +0530
Subject: RE: [PATCH RESEND 2/4] davinci vpbe: add dm365 VPBE display driver
 changes
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE8@dbde02.ent.ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
 <1316410529-14744-3-git-send-email-manjunath.hadli@ti.com>
 <201109261501.49077.hverkuil@xs4all.nl>
In-Reply-To: <201109261501.49077.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 26, 2011 at 18:31:48, Hans Verkuil wrote:
> On Monday, September 19, 2011 07:35:27 Manjunath Hadli wrote:
> > This patch implements the core additions to the display driver, mainly 
> > controlling the VENC and other encoders for dm365.
> > This patch also includes addition of amplifier subdevice to the vpbe 
> > driver and interfacing with venc subdevice.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > ---
> >  drivers/media/video/davinci/vpbe.c |   55 ++++++++++++++++++++++++++++++++++--
> >  include/media/davinci/vpbe.h       |   16 ++++++++++
> >  2 files changed, 68 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/davinci/vpbe.c 
> > b/drivers/media/video/davinci/vpbe.c
> > index d773d30..21a8645 100644
> > --- a/drivers/media/video/davinci/vpbe.c
> > +++ b/drivers/media/video/davinci/vpbe.c
> > @@ -141,11 +141,12 @@ static int vpbe_enum_outputs(struct vpbe_device *vpbe_dev,
> >  	return 0;
> >  }
> >  
> > -static int vpbe_get_mode_info(struct vpbe_device *vpbe_dev, char 
> > *mode)
Hans,

> > +static int vpbe_get_mode_info(struct vpbe_device *vpbe_dev, char *mode,
> > +			      int output_index)
> >  {
> >  	struct vpbe_config *cfg = vpbe_dev->cfg;
> >  	struct vpbe_enc_mode_info var;
> > -	int curr_output = vpbe_dev->current_out_index;
> > +	int curr_output = output_index;
> >  	int i;
> >  
> >  	if (NULL == mode)
> > @@ -245,6 +246,8 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
> >  	struct encoder_config_info *curr_enc_info =
> >  			vpbe_current_encoder_info(vpbe_dev);
> >  	struct vpbe_config *cfg = vpbe_dev->cfg;
> > +	struct venc_platform_data *venc_device = vpbe_dev->venc_device;
> > +	enum v4l2_mbus_pixelcode if_params;
> >  	int enc_out_index;
> >  	int sd_index;
> >  	int ret = 0;
> > @@ -274,6 +277,8 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
> >  			goto out;
> >  		}
> >  
> > +		if_params = cfg->outputs[index].if_params;
> > +		venc_device->setup_if_config(if_params);
> >  		if (ret)
> >  			goto out;
> >  	}
> > @@ -293,7 +298,7 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
> >  	 * encoder.
> >  	 */
> >  	ret = vpbe_get_mode_info(vpbe_dev,
> > -				 cfg->outputs[index].default_mode);
> > +				 cfg->outputs[index].default_mode, index);
> >  	if (!ret) {
> >  		struct osd_state *osd_device = vpbe_dev->osd_device;
> >  
> > @@ -367,6 +372,11 @@ static int vpbe_s_dv_preset(struct vpbe_device 
> > *vpbe_dev,
> >  
> >  	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
> >  					s_dv_preset, dv_preset);
> > +	if (!ret && (vpbe_dev->amp != NULL)) {
> > +		/* Call amplifier subdevice */
> > +		ret = v4l2_subdev_call(vpbe_dev->amp, video,
> > +				s_dv_preset, dv_preset);
> > +	}
> >  	/* set the lcd controller output for the given mode */
> >  	if (!ret) {
> >  		struct osd_state *osd_device = vpbe_dev->osd_device; @@ -566,6 
> > +576,8 @@ static int platform_device_get(struct device *dev, void 
> > *data)
> >  
> >  	if (strcmp("vpbe-osd", pdev->name) == 0)
> >  		vpbe_dev->osd_device = platform_get_drvdata(pdev);
> > +	if (strcmp("vpbe-venc", pdev->name) == 0)
> > +		vpbe_dev->venc_device = dev_get_platdata(&pdev->dev);
> >  
> >  	return 0;
> >  }
> > @@ -584,6 +596,7 @@ static int platform_device_get(struct device *dev, 
> > void *data)  static int vpbe_initialize(struct device *dev, struct 
> > vpbe_device *vpbe_dev)  {
> >  	struct encoder_config_info *enc_info;
> > +	struct amp_config_info *amp_info;
> >  	struct v4l2_subdev **enc_subdev;
> >  	struct osd_state *osd_device;
> >  	struct i2c_adapter *i2c_adap;
> > @@ -704,6 +717,39 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
> >  			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders"
> >  				 " currently not supported");
> >  	}
> > +	/* Add amplifier subdevice for dm365 */
> > +	if ((strcmp(vpbe_dev->cfg->module_name, "dm365-vpbe-display") == 0) &&
> > +			vpbe_dev->cfg->amp != NULL) {
> > +		vpbe_dev->amp = kmalloc(sizeof(struct v4l2_subdev *),
> > +					GFP_KERNEL);
> 
> Huh? Why alloc a struct v4l2_subdev pointer here?
> 
> > +		if (vpbe_dev->amp == NULL) {
> > +			v4l2_err(&vpbe_dev->v4l2_dev,
> > +				"unable to allocate memory for sub device");
> > +			ret = -ENOMEM;
> > +			goto vpbe_fail_v4l2_device;
> > +		}
> > +		amp_info = vpbe_dev->cfg->amp;
> > +		if (amp_info->is_i2c) {
> > +			vpbe_dev->amp = v4l2_i2c_new_subdev_board(
> > +			&vpbe_dev->v4l2_dev, i2c_adap,
> > +			&amp_info->board_info, NULL);
> 
> Especially since it is overwritten here! And so causes a memory leak.
> The kmalloc above (and the kfree below) feels like old code that should have been removed.

Thank you Hans. It was old code to be removed. Good catch. This piece of code is now removed and tested.
> 
> > +			if (!vpbe_dev->amp) {
> > +				v4l2_err(&vpbe_dev->v4l2_dev,
> > +					 "amplifier %s failed to register",
> > +					 amp_info->module_name);
> > +				ret = -ENODEV;
> > +				goto vpbe_fail_amp_register;
> > +			}
> > +			v4l2_info(&vpbe_dev->v4l2_dev,
> > +					  "v4l2 sub device %s registered\n",
> > +					  amp_info->module_name);
> > +		} else {
> > +			    vpbe_dev->amp = NULL;
> > +			    v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c amplifiers"
> > +			    " currently not supported");
> > +		}
> > +	} else
> > +	    vpbe_dev->amp = NULL;
> >  
> >  	/* set the current encoder and output to that of venc by default */
> >  	vpbe_dev->current_sd_index = 0;
> > @@ -731,6 +777,8 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
> >  	/* TBD handling of bootargs for default output and mode */
> >  	return 0;
> >  
> > +vpbe_fail_amp_register:
> > +	kfree(vpbe_dev->amp);
> >  vpbe_fail_sd_register:
> >  	kfree(vpbe_dev->encoders);
> >  vpbe_fail_v4l2_device:
> > @@ -757,6 +805,7 @@ static void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
> >  	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
> >  		clk_put(vpbe_dev->dac_clk);
> >  
> > +	kfree(vpbe_dev->amp);
> >  	kfree(vpbe_dev->encoders);
> >  	vpbe_dev->initialized = 0;
> >  	/* disable vpss clocks */
> > diff --git a/include/media/davinci/vpbe.h 
> > b/include/media/davinci/vpbe.h index 8b11fb0..8bc1b3c 100644
> > --- a/include/media/davinci/vpbe.h
> > +++ b/include/media/davinci/vpbe.h
> > @@ -63,6 +63,7 @@ struct vpbe_output {
> >  	 * output basis. If per mode is needed, we may have to move this to
> >  	 * mode_info structure
> >  	 */
> > +	enum v4l2_mbus_pixelcode if_params;
> >  };
> >  
> >  /* encoder configuration info */
> > @@ -74,6 +75,15 @@ struct encoder_config_info {
> >  	struct i2c_board_info board_info;
> >  };
> >  
> > +/*amplifier configuration info */
> > +struct amp_config_info {
> > +	char module_name[32];
> > +	/* Is this an i2c device ? */
> > +	unsigned int is_i2c:1;
> > +	/* i2c subdevice board info */
> > +	struct i2c_board_info board_info;
> > +};
> > +
> >  /* structure for defining vpbe display subsystem components */  
> > struct vpbe_config {
> >  	char module_name[32];
> > @@ -84,6 +94,8 @@ struct vpbe_config {
> >  	/* external encoder information goes here */
> >  	int num_ext_encoders;
> >  	struct encoder_config_info *ext_encoders;
> > +	/* amplifier information goes here */
> > +	struct amp_config_info *amp;
> >  	int num_outputs;
> >  	/* Order is venc outputs followed by LCD and then external encoders */
> >  	struct vpbe_output *outputs;
> > @@ -158,6 +170,8 @@ struct vpbe_device {
> >  	struct v4l2_subdev **encoders;
> >  	/* current encoder index */
> >  	int current_sd_index;
> > +	/* external amplifier v4l2 subdevice */
> > +	struct v4l2_subdev *amp;
> >  	struct mutex lock;
> >  	/* device initialized */
> >  	int initialized;
> > @@ -165,6 +179,8 @@ struct vpbe_device {
> >  	struct clk *dac_clk;
> >  	/* osd_device pointer */
> >  	struct osd_state *osd_device;
> > +	/* venc device pointer */
> > +	struct venc_platform_data *venc_device;
> >  	/*
> >  	 * fields below are accessed by users of vpbe_device. Not the
> >  	 * ones above
> > 
> 
> Regards,
> 
> 	Hans
> 

Rgds,
Manju

