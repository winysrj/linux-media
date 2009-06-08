Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZFHWFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 18:05:17 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 8 Jun 2009 17:05:10 -0500
Subject: RE: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE4013564F71A@dlee06.ent.ti.com>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com>
 <200905281518.18879.laurent.pinchart@skynet.be>
In-Reply-To: <200905281518.18879.laurent.pinchart@skynet.be>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Laurent,

Thanks for reviewing this. See my response below for few comments. Rest of them I have incorporated into my next patch.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com
>> +
>> +/* register access routines */
>> +static inline u32 regr(u32 offset)
>> +{
>> +	if (offset <= ccdc_addr_size)
>
>This should be <.
>
>> +		return __raw_readl(ccdc_base_addr + offset);
>> +	else {
>> +		dev_err(dev, "offset exceeds ccdc register address space\n");
>> +		return -1;
>> +	}
>> +}
>> +
>> +static inline u32 regw(u32 val, u32 offset)
>> +{
>> +	if (offset <= ccdc_addr_size) {
>
>This should be <.
[MK] I removed above two checks since we are getting the required IO block mapped and this check is not needed. if some reason there is an offset outside the valid range, it is a bug and will be caught through oops, right?.
>
>> +		__raw_writel(val, ccdc_base_addr + offset);
>> +		return val;
>> +	} else {
>> +		dev_err(dev, "offset exceeds ccdc register address space\n");
>> +		return -1;
>> +	}
>> +}
>
>Can't you check that ccdc_addr_size is big enough in ccdc_set_ccdc_base ?
>The
>read/write access functions could then be made much simpler.
>
[MK] See above comment
>> +
>> +
>> +/* Query control. Only applicable for Bayer capture */
>> +static int ccdc_queryctrl(struct v4l2_queryctrl *qctrl)
>> +{
>> +	int i, id;
>> +	struct v4l2_queryctrl *control = NULL;
>> +
>> +	dev_dbg(dev, "ccdc_queryctrl: start\n");
>> +	if (NULL == qctrl) {
>
>Can this happen ?
>
[MK] No. removed
>> +		dev_err(dev, "ccdc_queryctrl : invalid user ptr\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (VPFE_RAW_BAYER != ccdc_if_type) {
>> +		dev_err(dev,
>> +		       "ccdc_queryctrl : Not doing Raw Bayer Capture\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	id = qctrl->id;
>> +	memset(qctrl, 0, sizeof(struct v4l2_queryctrl));
>> +	for (i = 0; i < CCDC_MAX_CONTROLS; i++) {
>> +		control = &ccdc_control_info[i];
>> +		if (control->id == id)
>> +			break;
>> +	}
>> +	if (i == CCDC_MAX_CONTROLS) {
>> +	if (NULL == ctrl) {
>> +		dev_err(dev, "ccdc_setcontrol: invalid user ptr\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (ccdc_if_type != VPFE_RAW_BAYER) {
>> +		dev_err(dev,
>> +		       "ccdc_setcontrol: Not doing Raw Bayer Capture\n");
>
>Should user-triggered errors use dev_err or dev_dbg ? I'm not sure we want
>to
>fill the kernel log with KERN_ERR message just because an application
>doesn't
>get its control ids right.
>
[MK] changed to dev_dbg

>> +	}
>> +
>> +	switch (ctrl->id) {
>> +	case CCDC_CID_R_GAIN:
>> +		gain->r_ye = ctrl->value & CCDC_GAIN_MASK;
>> +		break;
>> +	case CCDC_CID_GR_GAIN:
>> +		gain->gr_cy = ctrl->value & CCDC_GAIN_MASK;
>> +		break;
>> +	case CCDC_CID_GB_GAIN:
>> +		gain->gb_g = ctrl->value  & CCDC_GAIN_MASK;
>> +		break;
>> +
>> +	case CCDC_CID_B_GAIN:
>> +		gain->b_mg = ctrl->value  & CCDC_GAIN_MASK;
>> +		break;
>
>	case CCDC_CID_OFFSET: ?
>
>> +	default:
>> +		ccdc_hw_params_raw.ccdc_offset = ctrl->value &
>CCDC_OFFSET_MASK;
[MK] default is for offset. We are validating the ids above for any of the checked values in the switch statement
>> +
>> +static void ccdc_reset(void)
>> +{
>> +	int i;
>> +	/* disable CCDC */
>> +	dev_dbg(dev, "\nstarting ccdc_reset...");
>> +	ccdc_enable(0);
>> +	/* set all registers to default value */
>> +	for (i = 0; i <= 0x15c; i += 4)
>> +		regw(0, i);
>
>Ouch ! Not all registers have a 0 default value. Beside, blindly resetting
>all
>registers sounds hackish. According to the documentation, the proper way to
>reset the VPFE/VPSS is through the power & sleep controller.
>
[MK] This function actually write default values in the registers since the implementation assume this. So I have renamed it as ccdc_restore_defaults(). We don't want to reset the ccdc here, only want to write default values.
>> +	/* no culling support */
>> +	regw(0xffff, CULH);
>> +	regw(0xff, CULV);
>> +	/* Set default Gain and Offset */
>> +	ccdc_hw_params_raw.gain.r_ye = 256;
>> +	ccdc_hw_params_raw.gain.gb_g = 256;
>> +	ccdc_hw_params_raw.gain.gr_cy = 256;
>> +	ccdc_hw_params_raw.gain.b_mg = 256;
>> +	ccdc_hw_params_raw.ccdc_offset = 0;
>> +	ccdc_config_gain_offset();
>> +	/* up to 12 bit sensor */
>> +	regw(0x0FFF, OUTCLIP);
>> +	/* CCDC input Mux select directly from sensor */
>> +	regw_bl(0x00, CCDCMUX);
>> +	dev_dbg(dev, "\nEnd of ccdc_reset...");
>> +}
>> +
>> +static int ccdc_open(struct device *device)
>> +{
>> +	dev = device;
>> +	ccdc_reset();
>> +	return 0;
>> +}
>> +
>> +static int ccdc_close(struct device *device)
>> +{
>> +	/* do nothing for now */
>> +	return 0;
>> +}
>> +/*
>> + * ======== ccdc_setwin  ========
>> + *
>> + * This function will configure the window size to
>> + * be capture in CCDC reg
>> + */
>> +static void ccdc_setwin(struct ccdc_imgwin *image_win,
>> +			enum ccdc_frmfmt frm_fmt, int ppc)
>
>What's does ppc stand for ?
>
[MK] per pixel count. I documented this.
>> +{
>> +	int horz_start, horz_nr_pixels;
>
>Does horz_nr_pixels really store the number of pixels ? It seems to me it
>counts the number of bytes. hstart and hsize would then be more appropriate
>names.
>
[MK]. It is storing number of pixels and the documentation say so. So names used are fine as per hw spec.
>> +	int vert_start, vert_nr_lines;
>
>If the above comment is correct, this could become vstart and vsize to be
>consistent.
>
[MK] No change. See above
>

>> +		while (1) {
>> +			flag = regr(DFCMEMCTL);
>> +			if ((flag & 0x01) == 0x00)
>> +				break;
>> +		}
>
>If there's a hardware error we'll loop indefinitely. How long is the low
>bit
>supposed to remain set ? If the time is supposed to be very short just as a
>for loop with a maximum number of iterations and bail out with an error if
>the
>bit doesn't go low. If the time can be long you should probably schedule()
>inside the for loop as well.
[MK] There is no documentation available to use the counter init value. I have used 1000 and will throw an error if ever reach this. Also added a TODO and will fine tune during image sensor support. 
>> +
>> +		/*Update gainfactor for table 2 - u16q14 */
>> +		temp_gf =
>> +		    (params->lens_sh_corr.gf_table2[0].
>> +		     int_no & CCDC_LSC_INT_MASK) << 14;
>> +		temp_gf |=
>> +		    ((int)(params->lens_sh_corr.gf_table2[0].frac_no) * 16384)
>> +		    & CCDC_LSC_FRAC_MASK;
>> +		regw(temp_gf, LSCMEMD);
>> +
>> +		while (1) {
>> +			if ((regr(LSCMEMCTL) & 0x10) == 0)
>> +				break;
>> +		}
>> +
>> +		/*set the address to incremental mode */
>> +		temp_lcs = 0;
>
>This isn't needed. This function needs to be cleaned up, it's quite
>difficult
>to read at the moment. Regroup the comments, typeset them in normal caps
>with
>normal spaces, make the register setting code more condensed and split the
>code in more than one function.
>
[MK]. Split into multiple functions. cleaned up the code.
>> +		temp_lcs = regr(LSCMEMCTL);
>> +
>> +static int ccdc_set_buftype(enum ccdc_buftype buf_type)
>> +{
>> +	if (ccdc_if_type == VPFE_RAW_BAYER)
>> +		ccdc_hw_params_raw.buf_type = buf_type;
>> +	else
>> +		ccdc_hw_params_ycbcr.buf_type = buf_type;
>
>Can't you regroup ccdc_hw_params_raw and ccdc_hw_params_ycbcr into a single
>structure (or maybe store the common fields in another structure) ? Fields
>that are only applicable for one of the formats would then be ignored for
>the
>other. ccdc_if_type could then be stored in ccdc_hw_params.
>
[MK] I think there is a clear distinction between YCbCr and Raw bayer capture handling. It is cleaner to keep them as separate instead of merging and ignoring unused variable. I don't see any reason why we need this change.
>> +	return 0;
>> +}
>> +static enum ccdc_buftype ccdc_get_buftype(void)
>> +{
>> +	if (ccdc_if_type == VPFE_RAW_BAYER)
>> +		return ccdc_hw_params_raw.buf_type;
>> +	return ccdc_hw_params_ycbcr.buf_type;
>> +}
>> +
>> +static int ccdc_enum_pix(enum vpfe_hw_pix_format *hw_pix, int i)
>> +{
>> +	int ret = -EINVAL;
>> +	if (ccdc_if_type == VPFE_RAW_BAYER) {
>> +		if (i < CCDC_MAX_RAW_BAYER_FORMATS) {
>> +			*hw_pix = ccdc_raw_bayer_hw_formats[i];
>
>How does this compare to memcpy in term of code size and run time ?
>
[MK] not sure what you are asking here.
>> +			ret = 0;
>> +		}
>> +	} else {
>> +		if (i < CCDC_MAX_RAW_YUV_FORMATS) {
>> +			*hw_pix = ccdc_raw_yuv_hw_formats[i];
>> +			ret = 0;
>
>> +	} else {
>> +		if (pixfmt == VPFE_YUYV)
>> +			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_YCBYCR;
>> +		else if (pixfmt == VPFE_UYVY)
>> +			ccdc_hw_params_ycbcr.pix_order = CCDC_PIXORDER_CBYCRY;
>> +		else
>> +			return -1;
>> +	}
>
>You're translating here from VPFE pixel format to CCDC pixel format.
>vpfe_capture.c translated from V4L2 pixel format to VPFE pixel format.
>Can't
>we pass the V4L2 pixel format directly to the CCDC instead ? You could then
>remove the intermediate format, making vpfe_capture.c simpler.
>
[MK] removed the intermediate vpfe pixel format. Now ccdc directly deals with v4l2 pixelformat values.
>> +	return 0;
>> +}

>> +#define CCDC_WIN_PAL	{0, 0, 720, 576}
>> +#define CCDC_WIN_VGA	{0, 0, 640, 480}
>> +
>
>Most enumerations have too generic names, especially for a header exported
>to
>userspace. Beside, you shouldn't use enumerations in userspace <->
>kernelspace
>APIs, especially on ARMs. Use #define instead, or, even better, integers
>where
>possible (for the sample length for instance).
>
[MK], renamed all types with ccdc_ prefix. There are numerous parameter types here and replacing them with integer will add a lot of code to check for their valid values. For example sample length can be 1 or 2 or 4 or 8 or 16 pixels. If I use integer, I need to make sure user doesn't set it other than the values listed above. I don't see a point here. Anyways, I have added a TODO, if something come out of this discussion and we decide to change it. At this time, I don't see why we should do it. 

>> +/* enum for No of pixel per line to be avg. in Black Clamping */
>> +enum sample_length {
>> +	_1PIXELS,
>> +	_2PIXELS,
>> +	_4PIXELS,
>> +	_8PIXELS,
>> +	_16PIXELS
>> +struct ccdc_gain {
