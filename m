Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50810 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751426AbdFZQdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 12:33:35 -0400
Date: Mon, 26 Jun 2017 19:33:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v1 4/6] [media] ov9650: use write_array() for resolution
 sequences
Message-ID: <20170626163330.GR12407@valkosipuli.retiisi.org.uk>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-5-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498143942-12682-5-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Jun 22, 2017 at 05:05:40PM +0200, Hugues Fruchet wrote:
> Align resolution sequences on initialization sequence using
> i2c_rv structure NULL terminated .This add flexibility
> on resolution sequence size.
> Document resolution related registers by using corresponding
> define instead of hexa address/value.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov9650.c | 98 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 64 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 4311da6..8b283c9 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -227,11 +227,16 @@ struct ov965x_ctrls {
>  	u8 update;
>  };
>  
> +struct i2c_rv {
> +	u8 addr;
> +	u8 value;
> +};
> +
>  struct ov965x_framesize {
>  	u16 width;
>  	u16 height;
>  	u16 max_exp_lines;
> -	const u8 *regs;
> +	const struct i2c_rv *regs;
>  };
>  
>  struct ov965x_interval {
> @@ -280,9 +285,11 @@ struct ov965x {
>  	u8 apply_frame_fmt;
>  };
>  
> -struct i2c_rv {
> -	u8 addr;
> -	u8 value;
> +struct ov965x_pixfmt {
> +	u32 code;
> +	u32 colorspace;
> +	/* REG_TSLB value, only bits [3:2] may be set. */
> +	u8 tslb_reg;
>  };
>  
>  static const struct i2c_rv ov965x_init_regs[] = {
> @@ -342,30 +349,59 @@ struct i2c_rv {
>  	{ REG_NULL, 0 }
>  };
>  
> -#define NUM_FMT_REGS 14
> -/*
> - * COM7,  COM3,  COM4, HSTART, HSTOP, HREF, VSTART, VSTOP, VREF,
> - * EXHCH, EXHCL, ADC,  OCOM,   OFON
> - */
> -static const u8 frame_size_reg_addr[NUM_FMT_REGS] = {
> -	0x12, 0x0c, 0x0d, 0x17, 0x18, 0x32, 0x19, 0x1a, 0x03,
> -	0x2a, 0x2b, 0x37, 0x38, 0x39,
> -};
> -
> -static const u8 ov965x_sxga_regs[NUM_FMT_REGS] = {
> -	0x00, 0x00, 0x00, 0x1e, 0xbe, 0xbf, 0x01, 0x81, 0x12,
> -	0x10, 0x34, 0x81, 0x93, 0x51,
> +static const struct i2c_rv ov965x_sxga_regs[] = {
> +	{ REG_COM7, 0x00 },
> +	{ REG_COM3, 0x00 },
> +	{ REG_COM4, 0x00 },
> +	{ REG_HSTART, 0x1e },
> +	{ REG_HSTOP, 0xbe },
> +	{ 0x32, 0xbf },
> +	{ REG_VSTART, 0x01 },
> +	{ REG_VSTOP, 0x81 },
> +	{ REG_VREF, 0x12 },
> +	{ REG_EXHCH, 0x10 },
> +	{ REG_EXHCL, 0x34 },
> +	{ REG_ADC, 0x81 },
> +	{ REG_ACOM, 0x93 },
> +	{ REG_OFON, 0x51 },
> +	{ REG_NULL, 0 },
>  };
>  
> -static const u8 ov965x_vga_regs[NUM_FMT_REGS] = {
> -	0x40, 0x04, 0x80, 0x26, 0xc6, 0xed, 0x01, 0x3d, 0x00,
> -	0x10, 0x40, 0x91, 0x12, 0x43,
> +static const struct i2c_rv ov965x_vga_regs[] = {
> +	{ REG_COM7, 0x40 },
> +	{ REG_COM3, 0x04 },
> +	{ REG_COM4, 0x80 },
> +	{ REG_HSTART, 0x26 },
> +	{ REG_HSTOP, 0xc6 },
> +	{ 0x32, 0xed },
> +	{ REG_VSTART, 0x01 },
> +	{ REG_VSTOP, 0x3d },
> +	{ REG_VREF, 0x00 },
> +	{ REG_EXHCH, 0x10 },
> +	{ REG_EXHCL, 0x40 },
> +	{ REG_ADC, 0x91 },
> +	{ REG_ACOM, 0x12 },
> +	{ REG_OFON, 0x43 },
> +	{ REG_NULL, 0 },
>  };
>  
>  /* Determined empirically. */
> -static const u8 ov965x_qvga_regs[NUM_FMT_REGS] = {
> -	0x10, 0x04, 0x80, 0x25, 0xc5, 0xbf, 0x00, 0x80, 0x12,
> -	0x10, 0x40, 0x91, 0x12, 0x43,
> +static const struct i2c_rv ov965x_qvga_regs[] = {
> +	{ REG_COM7, 0x10 },
> +	{ REG_COM3, 0x04 },
> +	{ REG_COM4, 0x80 },
> +	{ REG_HSTART, 0x25 },
> +	{ REG_HSTOP, 0xc5 },
> +	{ 0x32, 0xbf },
> +	{ REG_VSTART, 0x00 },
> +	{ REG_VSTOP, 0x80 },
> +	{ REG_VREF, 0x12 },
> +	{ REG_EXHCH, 0x10 },
> +	{ REG_EXHCL, 0x40 },
> +	{ REG_ADC, 0x91 },
> +	{ REG_ACOM, 0x12 },
> +	{ REG_OFON, 0x43 },
> +	{ REG_NULL, 0 },
>  };
>  
>  static const struct ov965x_framesize ov965x_framesizes[] = {
> @@ -387,13 +423,6 @@ struct i2c_rv {
>  	},
>  };
>  
> -struct ov965x_pixfmt {
> -	u32 code;
> -	u32 colorspace;
> -	/* REG_TSLB value, only bits [3:2] may be set. */
> -	u8 tslb_reg;
> -};

Any particular reason for moving struct ov965x_pixfmt definition?

> -
>  static const struct ov965x_pixfmt ov965x_formats[] = {
>  	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 0x00},
>  	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG, 0x04},
> @@ -1268,11 +1297,12 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
>  
>  static int ov965x_set_frame_size(struct ov965x *ov965x)
>  {
> -	int i, ret = 0;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, ov965x->client, "%s\n", __func__);
>  
> -	for (i = 0; ret == 0 && i < NUM_FMT_REGS; i++)
> -		ret = ov965x_write(ov965x->client, frame_size_reg_addr[i],
> -				   ov965x->frame_size->regs[i]);
> +	ret = ov965x_write_array(ov965x->client,
> +				 ov965x->frame_size->regs);
>  	return ret;
>  }
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
