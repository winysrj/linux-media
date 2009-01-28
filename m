Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZA1Qjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 11:39:45 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 28 Jan 2009 22:09:12 +0530
Subject: RE: [PATCH v2] v4l/tvp514x: make the module aware of rich people
Message-ID: <19F8576C6E063C45BE387C64729E739403FA78FEB2@dbde02.ent.ti.com>
In-Reply-To: <4980862E.10001@linutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
> Sent: Wednesday, January 28, 2009 9:52 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Mauro Carvalho Chehab; video4linux-
> list@redhat.com
> Subject: Re: [PATCH v2] v4l/tvp514x: make the module aware of rich
> people
> 
> Hiremath, Vaibhav wrote:
> > [Hiremath, Vaibhav] I am really sorry; actually I was really busy
> with our internal release process and still going.
> > Definitely I will try to find some time tomorrow to test this
> patch.
> No problem.
> 
> >> v2: Make the content of the registers (brightness, \ldots) per
> >> decoder
> >>     and not global.
> >> v1: Initial version
> >>
> > [Hiremath, Vaibhav] Just for knowledge, how are you validating
> these changes? On which board are you testing/validating?
> This is custom design. My HW vendor was using advXXXX chips in the
> past
> but was not very happy with them and switch over to this chip.
> 
> >>  drivers/media/video/tvp514x.c |  166 ++++++++++++++++++++++-----
> ---
> >> -----------
> >>  1 files changed, 90 insertions(+), 76 deletions(-)
> >>
> >> diff --git a/drivers/media/video/tvp514x.c
> >> b/drivers/media/video/tvp514x.c
> >> index 8e23aa5..99cfc40 100644
> >> --- a/drivers/media/video/tvp514x.c
> >> +++ b/drivers/media/video/tvp514x.c
> >> @@ -86,45 +86,8 @@ struct tvp514x_std_info {
> >>  	struct v4l2_standard standard;
> >>  };
> >>
> >> -/**
> >> - * struct tvp514x_decoded - TVP5146/47 decoder object
> >> - * @v4l2_int_device: Slave handle
> >> - * @pdata: Board specific
> >> - * @client: I2C client data
> >> - * @id: Entry from I2C table
> >> - * @ver: Chip version
> >> - * @state: TVP5146/47 decoder state - detected or not-detected
> >> - * @pix: Current pixel format
> >> - * @num_fmts: Number of formats
> >> - * @fmt_list: Format list
> >> - * @current_std: Current standard
> >> - * @num_stds: Number of standards
> >> - * @std_list: Standards list
> >> - * @route: input and output routing at chip level
> >> - */
> >> -struct tvp514x_decoder {
> >> -	struct v4l2_int_device *v4l2_int_device;
> >> -	const struct tvp514x_platform_data *pdata;
> >> -	struct i2c_client *client;
> >> -
> >> -	struct i2c_device_id *id;
> >> -
> >> -	int ver;
> >> -	enum tvp514x_state state;
> >> -
> >> -	struct v4l2_pix_format pix;
> >> -	int num_fmts;
> >> -	const struct v4l2_fmtdesc *fmt_list;
> >> -
> >> -	enum tvp514x_std current_std;
> >> -	int num_stds;
> >> -	struct tvp514x_std_info *std_list;
> >> -
> >> -	struct v4l2_routing route;
> >> -};
> >> -
> >
> > [Hiremath, Vaibhav] You may want to revisit this change, since
> there is only one line addition to the struct "struct tvp514x_reg".
> Patch will look clean if it only indicates the changes.
> I'm adding also
> | +	struct tvp514x_reg
> | tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
> 
[Hiremath, Vaibhav] This is the only line I was also talking about.

> which contains vp514x_reg_list_default which is defined below. I
> prefered
> not to do a forward declration of tvp514x_reg_list_default and
> therefore I
> moved tvp514x_decoder just after it.
> Would you prefer it with a forward declarion?
> 
[Hiremath, Vaibhav] Since this is static and default declaration I would prefer it to be moved above struct tvp514x_decoder.

> >>  /* TVP514x default register values */
> >> -static struct tvp514x_reg tvp514x_reg_list[] = {
> >> +static struct tvp514x_reg tvp514x_reg_list_default[] = {
> >>  	{TOK_WRITE, REG_INPUT_SEL, 0x05},	/* Composite selected */
> >>  	{TOK_WRITE, REG_AFE_GAIN_CTRL, 0x0F},
> >>  	{TOK_WRITE, REG_VIDEO_STD, 0x00},	/* Auto mode */
> >> @@ -186,6 +149,44 @@ static struct tvp514x_reg tvp514x_reg_list[]
> =
> >> {
> >>  	{TOK_TERM, 0, 0},
> >>  };
> >>
> >> +/**
> >> + * struct tvp514x_decoded - TVP5146/47 decoder object
> >
> > [Hiremath, Vaibhav] Please correct the spelling mistake
> > "tvp514x_decoder", I had missed this in my original patch.
> okay.
> 
> >> + * @v4l2_int_device: Slave handle
> >> + * @pdata: Board specific
> >> + * @client: I2C client data
> >> + * @id: Entry from I2C table
> >> + * @ver: Chip version
> >> + * @state: TVP5146/47 decoder state - detected or not-detected
> >> + * @pix: Current pixel format
> >> + * @num_fmts: Number of formats
> >> + * @fmt_list: Format list
> >> + * @current_std: Current standard
> >> + * @num_stds: Number of standards
> >> + * @std_list: Standards list
> >> + * @route: input and output routing at chip level
> > [Hiremath, Vaibhav] You may want to add the new parameter added to
> this struct.
> good point.
> 
> >> + */
> >> +struct tvp514x_decoder {
> >> +	struct v4l2_int_device v4l2_int_device;
> >> +	const struct tvp514x_platform_data *pdata;
> >> +	struct i2c_client *client;
> >> +
> >> +	struct i2c_device_id *id;
> >> +
> >> +	int ver;
> >> +	enum tvp514x_state state;
> >> +
> >> +	struct v4l2_pix_format pix;
> >> +	int num_fmts;
> >> +	const struct v4l2_fmtdesc *fmt_list;
> >> +
> >> +	enum tvp514x_std current_std;
> >> +	int num_stds;
> >> +	struct tvp514x_std_info *std_list;
> >> +
> >> +	struct v4l2_routing route;
> >> +	struct tvp514x_reg
> >> tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
> >> +};
> >> +
> >>  /* List of image formats supported by TVP5146/47 decoder
> >>   * Currently we are using 8 bit mode only, but can be
> >>   * extended to 10/20 bit mode.
> 
> >> @@ -1392,26 +1390,39 @@ static struct v4l2_int_device
> >> tvp514x_int_device = {
> >>  static int
> >>  tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id
> >> *id)
> >>  {
> >> -	struct tvp514x_decoder *decoder = &tvp514x_dev;
> >> +	struct tvp514x_decoder *decoder;
> >>  	int err;
> >>
> >>  	/* Check if the adapter supports the needed features */
> >>  	if (!i2c_check_functionality(client->adapter,
> >> I2C_FUNC_SMBUS_BYTE_DATA))
> >>  		return -EIO;
> >>
> >> -	decoder->pdata = client->dev.platform_data;
> >> -	if (!decoder->pdata) {
> >> +	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
> >> +	if (!decoder)
> >> +		return -ENOMEM;
> >> +
> >> +	if (!client->dev.platform_data) {
> >>  		v4l_err(client, "No platform data!!\n");
> >> -		return -ENODEV;
> >> +		err = -ENODEV;
> >> +		goto out_free;
> >>  	}
> >> +
> >> +	*decoder = tvp514x_dev;
> >> +	decoder->v4l2_int_device.priv = decoder;
> >> +	decoder->pdata = client->dev.platform_data;
> >> +
> >> +	BUILD_BUG_ON(sizeof(decoder->tvp514x_regs) !=
> >> +			sizeof(tvp514x_reg_list_default));
> > [Hiremath, Vaibhav] Do we really need to check this? I think you
> are defining the decoder-
> >tvp514x_regs[sizeof(tvp514x_reg_list_default)].
> I can get rid of it if you want. It is just a sanity check.
> 
[Hiremath, Vaibhav] I think there is no need to add unnecessary check here, you can remove this.

> >> +	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
> >> +			sizeof(tvp514x_reg_list_default));
> 

