Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43127 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZFRKfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 06:35:36 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 3/9] dm355 ccdc module for vpfe capture driver
Date: Thu, 18 Jun 2009 12:35:38 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1242412603-11390-1-git-send-email-m-karicheri2@ti.com> <200905281518.18879.laurent.pinchart@skynet.be> <A69FA2915331DC488A831521EAE36FE4013564F71A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4013564F71A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906181235.39038.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sorry not to have answered sooner.

On Tuesday 09 June 2009 00:05:10 Karicheri, Muralidharan wrote:
> > > +
> > > +/* register access routines */
> > > +static inline u32 regr(u32 offset)
> > > +{
> > > +	if (offset <= ccdc_addr_size)
> >
> > This should be <.
> >
> > > +		return __raw_readl(ccdc_base_addr + offset);
> > > +	else {
> > > +		dev_err(dev, "offset exceeds ccdc register address space\n");
> > > +		return -1;
> > > +	}
> > > +}
> > > +
> > > +static inline u32 regw(u32 val, u32 offset)
> > > +{
> > > +	if (offset <= ccdc_addr_size) {
> >
> > This should be <.
>
> [MK] I removed above two checks since we are getting the required IO block
> mapped and this check is not needed. if some reason there is an offset
> outside the valid range, it is a bug and will be caught through oops,
> right?.

Not necessarily. I'm not sure how ioremap works exactly, but accessing data 
outside the remapped region might end up being a valid access. Anyway this 
shouldn't happen unless a bug creeps in the driver. If you want to validate 
the size it should be done in ccdc_set_ccdc_base instead, but that's not 
really required.

> > > +		__raw_writel(val, ccdc_base_addr + offset);
> > > +		return val;
> > > +	} else {
> > > +		dev_err(dev, "offset exceeds ccdc register address space\n");
> > > +		return -1;
> > > +	}
> > > +}
> >
> > Can't you check that ccdc_addr_size is big enough in ccdc_set_ccdc_base ?
> > The read/write access functions could then be made much simpler.
>
> [MK] See above comment
>
> > > +	}
> > > +
> > > +	switch (ctrl->id) {
> > > +	case CCDC_CID_R_GAIN:
> > > +		gain->r_ye = ctrl->value & CCDC_GAIN_MASK;
> > > +		break;
> > > +	case CCDC_CID_GR_GAIN:
> > > +		gain->gr_cy = ctrl->value & CCDC_GAIN_MASK;
> > > +		break;
> > > +	case CCDC_CID_GB_GAIN:
> > > +		gain->gb_g = ctrl->value  & CCDC_GAIN_MASK;
> > > +		break;
> > > +
> > > +	case CCDC_CID_B_GAIN:
> > > +		gain->b_mg = ctrl->value  & CCDC_GAIN_MASK;
> > > +		break;
> >
> >	 case CCDC_CID_OFFSET: ?
> >
> > > +	default:
> > > +		ccdc_hw_params_raw.ccdc_offset = ctrl->value &
> > > CCDC_OFFSET_MASK;
>
> [MK] default is for offset. We are validating the ids above for any of the
> checked values in the switch statement

If you're sure that the control ID is one of the above cases, use 
CCDC_CID_OFFSET instead of default, the code will be easier to read.

> > > +
> > > +static void ccdc_reset(void)
> > > +{
> > > +	int i;
> > > +	/* disable CCDC */
> > > +	dev_dbg(dev, "\nstarting ccdc_reset...");
> > > +	ccdc_enable(0);
> > > +	/* set all registers to default value */
> > > +	for (i = 0; i <= 0x15c; i += 4)
> > > +		regw(0, i);
> >
> > Ouch ! Not all registers have a 0 default value. Beside, blindly resetting
> > all registers sounds hackish. According to the documentation, the proper
> > way to reset the VPFE/VPSS is through the power & sleep controller.
>
> [MK] This function actually write default values in the registers since the
> implementation assume this. So I have renamed it as ccdc_restore_defaults().
> We don't want to reset the ccdc here, only want to write default values.

Some registers have a non-0 default value according to the datasheet.

> > > +/*
> > > + * ======== ccdc_setwin  ========
> > > + *
> > > + * This function will configure the window size to
> > > + * be capture in CCDC reg
> > > + */
> > > +static void ccdc_setwin(struct ccdc_imgwin *image_win,
> > > +			enum ccdc_frmfmt frm_fmt, int ppc)
> >
> > What's does ppc stand for ?
>
> [MK] per pixel count. I documented this.
>
> > > +{
> > > +	int horz_start, horz_nr_pixels;
> >
> > Does horz_nr_pixels really store the number of pixels ? It seems to me it
> > counts the number of bytes. hstart and hsize would then be more
> > appropriate names.
>
> [MK]. It is storing number of pixels and the documentation say so. So names
> used are fine as per hw spec.

Then I'm puzzled by

	horz_start = image_win->left << (ppc - 1);

image_win->left is a number of pixels. Shifting it left by 1 in the YUV case 
will give a number of bytes.

> > > +	int vert_start, vert_nr_lines;
> >
> > If the above comment is correct, this could become vstart and vsize to be
> > consistent.
>
> [MK] No change. See above
>
> > > +	return 0;
> > > +}
> > > +static enum ccdc_buftype ccdc_get_buftype(void)
> > > +{
> > > +	if (ccdc_if_type == VPFE_RAW_BAYER)
> > > +		return ccdc_hw_params_raw.buf_type;
> > > +	return ccdc_hw_params_ycbcr.buf_type;
> > > +}
> > > +
> > > +static int ccdc_enum_pix(enum vpfe_hw_pix_format *hw_pix, int i)
> > > +{
> > > +	int ret = -EINVAL;
> > > +	if (ccdc_if_type == VPFE_RAW_BAYER) {
> > > +		if (i < CCDC_MAX_RAW_BAYER_FORMATS) {
> > > +			*hw_pix = ccdc_raw_bayer_hw_formats[i];
> >
> > How does this compare to memcpy in term of code size and run time ?
>
> [MK] not sure what you are asking here.

I was wondering which of

*hw_pix = ccdc_raw_bayer_hw_formats[i];

and

memcpy(hw_pix, &ccdc_raw_bayer_hw_formats[i], sizeof(*hw_pix));

lead to a smaller code size and run time. It's a minor issue, it can always be 
changed later if memcpy is found to be smaller and faster.

> > > +	return 0;
> > > +}
> > >
> > > +#define CCDC_WIN_PAL	{0, 0, 720, 576}
> > > +#define CCDC_WIN_VGA	{0, 0, 640, 480}
> > > +
> >
> > Most enumerations have too generic names, especially for a header exported
> > to userspace. Beside, you shouldn't use enumerations in userspace <->
> > kernelspace APIs, especially on ARMs. Use #define instead, or, even
> > better, integers where possible (for the sample length for instance).
>
> [MK], renamed all types with ccdc_ prefix. There are numerous parameter
> types here and replacing them with integer will add a lot of code to check
> for their valid values. For example sample length can be 1 or 2 or 4 or 8
> or 16 pixels. If I use integer, I need to make sure user doesn't set it
> other than the values listed above. I don't see a point here. Anyways, I
> have added a TODO, if something come out of this discussion and we decide
> to change it. At this time, I don't see why we should do it.

Ok.

We're at last converging :-) The only issue I'd like to see addressed before 
the code gets committed in the Davinci git tree is the pixels vs. bytes 
comment in ccdc_setwin. I might be wrong in my understanding, in which case 
there's no problem, but I'd like to understand it.

Best regards,

Laurent Pinchart

