Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGaRlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 13:41:04 -0400
Message-ID: <1406828460.16697.78.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 05/28] gpu: ipu-v3: Add units required for video capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 31 Jul 2014 19:41:00 +0200
In-Reply-To: <1406820432.16697.58.camel@paszta.hi.pengutronix.de>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
	 <1403744755-24944-6-git-send-email-steve_longerbeam@mentor.com>
	 <1406820432.16697.58.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 31.07.2014, 17:27 +0200 schrieb Philipp Zabel:
> > +static void init_csc_rgb2ycbcr(u32 __iomem *base)
> > +{
> > +	/*
> > +	 * Y = R *  .299 + G *  .587 + B *  .114;
> > +	 * U = R * -.169 + G * -.332 + B *  .500 + 128.;
> > +	 * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
> > +	 */
> > +	const u32 coeff[4][3] = {
> > +		{0x004D, 0x0096, 0x001D},
> > +		{0x01D5, 0x01AB, 0x0080},
> > +		{0x0080, 0x0195, 0x01EB},
> > +		{0x0000, 0x0200, 0x0200},	/* A0, A1, A2 */
> > +	};
> > +	u32 param;
> > +
> > +	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
> > +		(coeff[1][1] << 9) | coeff[2][2];
> > +	writel(param, base++);
> > +
> > +	/* scale = 1, sat = 0 */
> > +	param = (coeff[3][0] >> 5) | (1UL << 8);
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
> > +		(coeff[1][0] << 9) | coeff[2][0];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] >> 5);
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
> > +		(coeff[1][2] << 9) | coeff[2][1];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] >> 5);
> > +	writel(param, base++);
> > +}
> > +
> > +static void init_csc_rgb2rgb(u32 __iomem *base)
> > +{
> > +	/* transparent RGB->RGB matrix for graphics combining */
> > +	const u32 coeff[4][3] = {
> > +		{0x0080, 0x0000, 0x0000},
> > +		{0x0000, 0x0080, 0x0000},
> > +		{0x0000, 0x0000, 0x0080},
> > +		{0x0000, 0x0000, 0x0000},	/* A0, A1, A2 */
> > +	};
> > +	u32 param;
> > +
> > +	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
> > +		(coeff[1][1] << 9) | coeff[2][2];
> > +	writel(param, base++);
> > +
> > +	/* scale = 2, sat = 0 */
> > +	param = (coeff[3][0] >> 5) | (2UL << 8);
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
> > +		(coeff[1][0] << 9) | coeff[2][0];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] >> 5);
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
> > +		(coeff[1][2] << 9) | coeff[2][1];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] >> 5);
> > +	writel(param, base++);
> > +}
> > +
> > +static void init_csc_ycbcr2rgb(u32 __iomem *base)
> > +{
> > +	/*
> > +	 * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
> > +	 * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
> > +	 * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
> > +	 */
> > +	const u32 coeff[4][3] = {
> > +		{149, 0, 204},
> > +		{149, 462, 408},
> > +		{149, 255, 0},
> > +		{8192 - 446, 266, 8192 - 554},	/* A0, A1, A2 */
> > +	};
> > +	u32 param;
> > +
> > +	param = (coeff[3][0] << 27) | (coeff[0][0] << 18) |
> > +		(coeff[1][1] << 9) | coeff[2][2];
> > +	writel(param, base++);
> > +
> > +	/* scale = 2, sat = 0 */
> > +	param = (coeff[3][0] >> 5) | (2L << (40 - 32));
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] << 27) | (coeff[0][1] << 18) |
> > +		(coeff[1][0] << 9) | coeff[2][0];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][1] >> 5);
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] << 27) | (coeff[0][2] << 18) |
> > +		(coeff[1][2] << 9) | coeff[2][1];
> > +	writel(param, base++);
> > +
> > +	param = (coeff[3][2] >> 5);
> > +	writel(param, base++);
> > +}

Instead of repeating the same code three times, we could have three
global static const arrays for coefficients and scaling factors, and
only one function to apply any of them (or merge the code into
init_csc).

[...]
> > +static int calc_resize_coeffs(struct ipu_ic *ic,
> > +			      u32 in_size, u32 out_size,
> > +			      u32 *resize_coeff,
> > +			      u32 *downsize_coeff)
> > +{
> > +	struct ipu_ic_priv *priv = ic->priv;
> > +	struct ipu_soc *ipu = priv->ipu;
> > +	u32 temp_size, temp_downsize;
> > +
> > +	/*
> > +	 * Input size cannot be more than 4096, and output size cannot
> > +	 * be more than 1024
> > +	 */
> > +	if (in_size > 4096) {
> > +		dev_err(ipu->dev, "Unsupported resize (in_size > 4096)\n");
> > +		return -EINVAL;
> > +	}
> > +	if (out_size > 1024) {
> > +		dev_err(ipu->dev, "Unsupported resize (out_size > 1024)\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Cannot downsize more than 8:1 */
> > +	if ((out_size << 3) < in_size) {
> > +		dev_err(ipu->dev, "Unsupported downsize\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Compute downsizing coefficient */
> > +	temp_downsize = 0;
> > +	temp_size = in_size;
> > +	while (((temp_size > 1024) || (temp_size >= out_size * 2)) &&
> > +	       (temp_downsize < 2)) {
> > +		temp_size >>= 1;
> > +		temp_downsize++;
> > +	}
> > +	*downsize_coeff = temp_downsize;
> > +
> > +	/*
> > +	 * compute resizing coefficient using the following equation:
> > +	 * resize_coeff = M * (SI - 1) / (SO - 1)
> > +	 * where M = 2^13, SI = input size, SO = output size
> > +	 */
> > +	*resize_coeff = (8192L * (temp_size - 1)) / (out_size - 1);
> > +	if (*resize_coeff >= 16384L) {
> > +		dev_err(ipu->dev, "Warning! Overflow on resize coeff.\n");
> > +		*resize_coeff = 0x3FFF;
> > +	}
> > +
> > +	return 0;
> > +}

This is fine for now, but to support tiled mem2mem scaling we will have
to make the scaling coefficient calculation independent from the tile
size.

[...]

regards
Philipp

