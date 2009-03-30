Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail12.sea5.speakeasy.net ([69.17.117.14]:43396 "EHLO
	mail12.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386AbZC3VfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 17:35:20 -0400
Date: Mon, 30 Mar 2009 14:35:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Chaithrika U S <chaithrika@ti.com>, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 3/4] ARM: DaVinci: DM646x Video: Add VPIF display driver
In-Reply-To: <200903301552.07252.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903301410550.28292@shell2.speakeasy.net>
References: <1238073752-9930-1-git-send-email-chaithrika@ti.com>
 <200903301552.07252.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 30 Mar 2009, Hans Verkuil wrote:
> On Thursday 26 March 2009 14:22:32 Chaithrika U S wrote:
> > +                           /* one field is displayed configure the next
> > +                              frame if it is available else hold on current
> > +                              frame */

Comment isn't in standard format with *'s on the side.  If you split this
into multiple functions like Hans suggested it wouldn't be indented so
much.

> > +static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
> > +					struct v4l2_fmtdesc *fmt)
> > +{
> > +	unsigned int index = 0;
> > +
> > +	if (fmt->index != 0) {
> > +		v4l2_err(&vpif_obj.v4l2_dev, "Invalid format index\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Fill in the information about format */
> > +	index = fmt->index;
> > +	memset(fmt, 0, sizeof(*fmt));
>
> For most if not all of these functions v4l2_ioctl2 will take care of zeroing
> the structs.

It is supposed to be all of them.  If there are any I missed let me know so
I can fix it.

> > +static int vpif_g_fmt_vid_out(struct file *file, void *priv,
> > +				struct v4l2_format *fmt)
> > +{
[...]
> > +	/* Check the validity of the buffer type */
> > +	if (common->fmt.type != fmt->type)
> > +		return -EINVAL;
> > +
> > +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != fmt->type) {
> > +		if (vid_ch->std_info.vbi_supported == 0)
> > +			return -EINVAL;
> > +	}

All XXX_fmt_vid_out methods will only be called with fmt->type equal to
VIDEO_OUTPUT.  You don't need to check.

> > +static int vpif_s_fmt_vid_out(struct file *file, void *priv,
> > +				struct v4l2_format *fmt)
> > +{
> > +	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == fmt->type) {

Don't need this check.

> > +		struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
> > +		/* Check for valid field format */
> > +		ret = vpif_check_format(channel, pixfmt);
> > +		if (ret)
> > +			return ret;

Rather than fail if the format requested isn't acceptable to the driver,
you should modify the requested format to something that is.  For example,
if you need an even number of lines and they ask for an odd number, reduce
the number of lines by 1 instead of failing.

> > +static int vpif_enum_output(struct file *file, void *fh,
> > +				struct v4l2_output *output)
> > +{
> > +
> > +	struct vpif_config *config = vpif_dev->platform_data;
> > +	int index = output->index;
> > +
> > +	memset(output, 0, sizeof(*output));
> > +	if (index > config->output_count) {
> > +		v4l2_dbg(1, debug, &vpif_obj.v4l2_dev,
> > +						"Invalid output index\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	output->index = index;

Another save index, memset, restore index sequence that isn't needed.

> > +#define ISALIGNED(a)    (0 == (a%8))
>
> Here you need parenthesis: (0 == ((a) % 8))

If 'a' isn't unsigned, then (0 == ((a) & 7)) will be more efficient.  For
unsigned values the compiler should be able to make the transformation to
using & instead of %, but not for signed.

> > +struct vpif_config_params {
> > +	u8 min_numbuffers;
> > +	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
> > +	u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
> > +	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
> > +};

If you put the larger fields first the structure will be padded less.
