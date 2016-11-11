Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56864 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933540AbcKKNVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 08:21:30 -0500
Subject: Re: [PATCH 2/5] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <46394837-c3f0-8487-750b-95dae7bcf859@xs4all.nl>
Date: Fri, 11 Nov 2016 14:21:22 +0100
MIME-Version: 1.0
In-Reply-To: <1478706284-59134-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

A quick review:

On 11/09/2016 04:44 PM, Ramesh Shanmugasundaram wrote:
> This patch adds driver support for MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  .../devicetree/bindings/media/i2c/max2175.txt      |   61 +
>  drivers/media/i2c/Kconfig                          |    4 +
>  drivers/media/i2c/Makefile                         |    2 +
>  drivers/media/i2c/max2175/Kconfig                  |    8 +
>  drivers/media/i2c/max2175/Makefile                 |    4 +
>  drivers/media/i2c/max2175/max2175.c                | 1558 ++++++++++++++++++++
>  drivers/media/i2c/max2175/max2175.h                |  108 ++
>  7 files changed, 1745 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
> 

<snip>

> diff --git a/drivers/media/i2c/max2175/max2175.c b/drivers/media/i2c/max2175/max2175.c
> new file mode 100644
> index 0000000..ec45b52
> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.c
> @@ -0,0 +1,1558 @@

<snip>

> +/* Read/Write bit(s) on top of regmap */
> +static int max2175_read(struct max2175 *ctx, u8 idx, u8 *val)
> +{
> +	u32 regval;
> +	int ret = regmap_read(ctx->regmap, idx, &regval);
> +
> +	if (ret)
> +		v4l2_err(ctx->client, "read ret(%d): idx 0x%02x\n", ret, idx);
> +
> +	*val = regval;

Does regmap_read initialize regval even if it returns an error? If not,
then I would initialize regval to 0 to prevent *val being uninitialized.

> +	return ret;
> +}
> +
> +static int max2175_write(struct max2175 *ctx, u8 idx, u8 val)
> +{
> +	int ret = regmap_write(ctx->regmap, idx, val);
> +
> +	if (ret)
> +		v4l2_err(ctx->client, "write ret(%d): idx 0x%02x val 0x%02x\n",
> +			 ret, idx, val);
> +	return ret;
> +}
> +
> +static u8 max2175_read_bits(struct max2175 *ctx, u8 idx, u8 msb, u8 lsb)
> +{
> +	u8 val;
> +
> +	if (max2175_read(ctx, idx, &val))
> +		return 0;
> +
> +	return max2175_get_bitval(val, msb, lsb);
> +}
> +
> +static bool max2175_read_bit(struct max2175 *ctx, u8 idx, u8 bit)
> +{
> +	return !!max2175_read_bits(ctx, idx, bit, bit);
> +}
> +
> +static int max2175_write_bits(struct max2175 *ctx, u8 idx,
> +			     u8 msb, u8 lsb, u8 newval)
> +{
> +	int ret = regmap_update_bits(ctx->regmap, idx, GENMASK(msb, lsb),
> +				     newval << lsb);
> +
> +	if (ret)
> +		v4l2_err(ctx->client, "wbits ret(%d): idx 0x%02x\n", ret, idx);
> +
> +	return ret;
> +}
> +
> +static int max2175_write_bit(struct max2175 *ctx, u8 idx, u8 bit, u8 newval)
> +{
> +	return max2175_write_bits(ctx, idx, bit, bit, newval);
> +}
> +
> +/* Checks expected pattern every msec until timeout */
> +static int max2175_poll_timeout(struct max2175 *ctx, u8 idx, u8 msb, u8 lsb,
> +				u8 exp_bitval, u32 timeout_ms)
> +{
> +	unsigned int val;
> +
> +	return regmap_read_poll_timeout(ctx->regmap, idx, val,
> +			(max2175_get_bitval(val, msb, lsb) == exp_bitval),
> +			1000, timeout_ms * 1000);
> +}
> +
> +static int max2175_poll_csm_ready(struct max2175 *ctx)
> +{
> +	int ret;
> +
> +	ret = max2175_poll_timeout(ctx, 69, 1, 1, 0, 50);
> +	if (ret)
> +		v4l2_err(ctx->client, "csm not ready\n");
> +
> +	return ret;
> +}
> +
> +#define MAX2175_IS_BAND_AM(ctx)		\
> +	(max2175_read_bits(ctx, 5, 1, 0) == MAX2175_BAND_AM)
> +
> +#define MAX2175_IS_BAND_VHF(ctx)	\
> +	(max2175_read_bits(ctx, 5, 1, 0) == MAX2175_BAND_VHF)
> +
> +#define MAX2175_IS_FM_MODE(ctx)		\
> +	(max2175_read_bits(ctx, 12, 5, 4) == 0)
> +
> +#define MAX2175_IS_FMHD_MODE(ctx)	\
> +	(max2175_read_bits(ctx, 12, 5, 4) == 1)
> +
> +#define MAX2175_IS_DAB_MODE(ctx)	\
> +	(max2175_read_bits(ctx, 12, 5, 4) == 2)
> +
> +static int max2175_band_from_freq(u32 freq)
> +{
> +	if (freq >= 144000 && freq <= 26100000)
> +		return MAX2175_BAND_AM;
> +	else if (freq >= 65000000 && freq <= 108000000)
> +		return MAX2175_BAND_FM;
> +	else

No need for these 'else' keywords.

> +		return MAX2175_BAND_VHF;
> +}
> +
> +static int max2175_update_i2s_mode(struct max2175 *ctx, u32 rx_mode,
> +				   u32 i2s_mode)
> +{
> +	max2175_write_bits(ctx, 29, 2, 0, i2s_mode);
> +
> +	/* Based on I2S mode value I2S_WORD_CNT values change */
> +	switch (i2s_mode) {
> +	case MAX2175_I2S_MODE3:
> +		max2175_write_bits(ctx, 30, 6, 0, 1);
> +		break;
> +	case MAX2175_I2S_MODE2:
> +	case MAX2175_I2S_MODE4:
> +		max2175_write_bits(ctx, 30, 6, 0, 0);
> +		break;
> +	case MAX2175_I2S_MODE0:
> +		max2175_write_bits(ctx, 30, 6, 0,
> +			ctx->rx_modes[rx_mode].i2s_word_size);
> +		break;
> +	}
> +	mxm_dbg(ctx, "update_i2s_mode %u, rx_mode %u\n", i2s_mode, rx_mode);
> +	return 0;
> +}
> +
> +static void max2175_i2s_enable(struct max2175 *ctx, bool enable)
> +{
> +	if (enable) {
> +		/* Use old setting */
> +		max2175_write_bits(ctx, 104, 3, 0, ctx->i2s_test);
> +	} else {
> +		/* Cache old setting */
> +		ctx->i2s_test = max2175_read_bits(ctx, 104, 3, 0);
> +		max2175_write_bits(ctx, 104, 3, 0, 9);	/* Keep SCK alive */
> +	}
> +	mxm_dbg(ctx, "i2s %sabled: old val %u\n", enable ? "en" : "dis",
> +		ctx->i2s_test);
> +}
> +
> +static void max2175_set_filter_coeffs(struct max2175 *ctx, u8 m_sel,
> +				      u8 bank, const u16 *coeffs)
> +{
> +	unsigned int i;
> +	u8 coeff_addr, upper_address = 24;
> +
> +	mxm_dbg(ctx, "set_filter_coeffs: m_sel %d bank %d\n", m_sel, bank);
> +	max2175_write_bits(ctx, 114, 5, 4, m_sel);
> +
> +	if (m_sel == 2)
> +		upper_address = 12;
> +
> +	for (i = 0; i < upper_address; i++) {
> +		coeff_addr = i + bank * 24;
> +		max2175_write(ctx, 115, coeffs[i] >> 8);
> +		max2175_write(ctx, 116, coeffs[i]);
> +		max2175_write(ctx, 117, coeff_addr | 1 << 7);
> +	}
> +	max2175_write_bit(ctx, 117, 7, 0);
> +}
> +
> +static void max2175_load_fmeu_1p2(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fmeu1p2_map); i++)
> +		max2175_write(ctx, fmeu1p2_map[i].idx, fmeu1p2_map[i].val);
> +
> +	ctx->decim_ratio = 36;
> +
> +	/* Load the Channel Filter Coefficients into channel filter bank #2 */
> +	max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 0, ch_coeff_fmeu);
> +	max2175_set_filter_coeffs(ctx, MAX2175_EQ_MSEL, 0,
> +				  eq_coeff_fmeu1_ra02_m6db);
> +}
> +
> +static void max2175_load_dab_1p2(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dab12_map); i++)
> +		max2175_write(ctx, dab12_map[i].idx, dab12_map[i].val);
> +
> +	ctx->decim_ratio = 1;
> +
> +	/* Load the Channel Filter Coefficients into channel filter bank #2 */
> +	max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 2, ch_coeff_dab1);
> +}
> +
> +static void max2175_load_fmna_1p0(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fmna1p0_map); i++)
> +		max2175_write(ctx, fmna1p0_map[i].idx, fmna1p0_map[i].val);
> +}
> +
> +static void max2175_load_fmna_2p0(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fmna2p0_map); i++)
> +		max2175_write(ctx, fmna2p0_map[i].idx, fmna2p0_map[i].val);
> +}
> +
> +static void max2175_set_bbfilter(struct max2175 *ctx)
> +{
> +	if (MAX2175_IS_BAND_AM(ctx)) {
> +		max2175_write_bits(ctx, 12, 3, 0, ctx->rom_bbf_bw_am);
> +		mxm_dbg(ctx, "set_bbfilter AM: rom %d\n", ctx->rom_bbf_bw_am);
> +	} else if (MAX2175_IS_DAB_MODE(ctx)) {
> +		max2175_write_bits(ctx, 12, 3, 0, ctx->rom_bbf_bw_dab);
> +		mxm_dbg(ctx, "set_bbfilter DAB: rom %d\n", ctx->rom_bbf_bw_dab);
> +	} else {
> +		max2175_write_bits(ctx, 12, 3, 0, ctx->rom_bbf_bw_fm);
> +		mxm_dbg(ctx, "set_bbfilter FM: rom %d\n", ctx->rom_bbf_bw_fm);
> +	}
> +}
> +
> +static bool max2175_set_csm_mode(struct max2175 *ctx,
> +			  enum max2175_csm_mode new_mode)
> +{
> +	int ret = max2175_poll_csm_ready(ctx);
> +
> +	if (ret)
> +		return ret;
> +
> +	max2175_write_bits(ctx, 0, 2, 0, new_mode);
> +	mxm_dbg(ctx, "set csm new mode %d\n", new_mode);
> +
> +	/* Wait for a fixed settle down time depending on new mode */
> +	switch (new_mode) {
> +	case MAX2175_PRESET_TUNE:
> +		usleep_range(51100, 51500);	/* 51.1ms */
> +		break;
> +	/*
> +	 * Other mode switches need different sleep values depending on band &
> +	 * mode
> +	 */
> +	default:
> +		break;
> +	}
> +
> +	return max2175_poll_csm_ready(ctx);
> +}
> +
> +static int max2175_csm_action(struct max2175 *ctx,
> +			      enum max2175_csm_mode action)
> +{
> +	int ret;
> +
> +	mxm_dbg(ctx, "csm_action: %d\n", action);
> +
> +	/* Other actions can be added in future when needed */
> +	ret = max2175_set_csm_mode(ctx, MAX2175_LOAD_TO_BUFFER);
> +	if (ret)
> +		return ret;
> +	return max2175_set_csm_mode(ctx, MAX2175_PRESET_TUNE);
> +}
> +
> +static int max2175_set_lo_freq(struct max2175 *ctx, u64 lo_freq)
> +{
> +	u64 scaled_lo_freq, scaled_npf, scaled_integer, scaled_fraction;
> +	u32 frac_desired, int_desired, lo_mult = 1;
> +	const u32 scale_factor = 1000000U;
> +	u8 loband_bits = 0, vcodiv_bits = 0;
> +	enum max2175_band band;
> +	int ret;
> +
> +	/* Scale to larger number for precision */
> +	scaled_lo_freq = lo_freq * scale_factor * 100;
> +	band = max2175_read_bits(ctx, 5, 1, 0);
> +
> +	mxm_dbg(ctx, "set_lo_freq: scaled lo_freq %llu lo_freq %llu band %d\n",
> +		scaled_lo_freq, lo_freq, band);
> +
> +	switch (band) {
> +	case MAX2175_BAND_AM:
> +		if (max2175_read_bit(ctx, 5, 7) == 0)
> +			lo_mult = 16;
> +		break;
> +	case MAX2175_BAND_FM:
> +		if (lo_freq <= 74700000) {
> +			lo_mult = 16;
> +		} else if (lo_freq > 74700000 && lo_freq <= 110000000) {
> +			loband_bits = 1;
> +		} else {
> +			loband_bits = 1;
> +			vcodiv_bits = 3;
> +		}
> +		lo_mult = 8;
> +		break;
> +	case MAX2175_BAND_VHF:
> +		if (lo_freq <= 210000000) {
> +			loband_bits = 2;
> +			vcodiv_bits = 2;
> +		} else {
> +			loband_bits = 2;
> +			vcodiv_bits = 1;
> +		}
> +		lo_mult = 4;
> +		break;
> +	default:
> +		loband_bits = 3;
> +		vcodiv_bits = 2;
> +		lo_mult = 2;
> +		break;
> +	}
> +
> +	if (band == MAX2175_BAND_L)
> +		scaled_npf = div_u64(div_u64(scaled_lo_freq, ctx->xtal_freq),
> +				     lo_mult);
> +	else
> +		scaled_npf = div_u64(scaled_lo_freq, ctx->xtal_freq) * lo_mult;
> +
> +	scaled_npf = div_u64(scaled_npf, 100);
> +	scaled_integer = div_u64(scaled_npf, scale_factor) * scale_factor;
> +	int_desired = div_u64(scaled_npf, scale_factor);
> +	scaled_fraction = scaled_npf - scaled_integer;
> +	frac_desired = div_u64(scaled_fraction << 20, scale_factor);
> +
> +	/* Check CSM is not busy */
> +	ret = max2175_poll_csm_ready(ctx);
> +	if (ret)
> +		return ret;
> +
> +	mxm_dbg(ctx, "loband %u vcodiv %u lo_mult %u scaled_npf %llu\n",
> +		loband_bits, vcodiv_bits, lo_mult, scaled_npf);
> +	mxm_dbg(ctx, "scaled int %llu frac %llu desired int %u frac %u\n",
> +		scaled_integer, scaled_fraction, int_desired, frac_desired);
> +
> +	/* Write the calculated values to the appropriate registers */
> +	max2175_write(ctx, 1, int_desired);
> +	max2175_write_bits(ctx, 2, 3, 0, (frac_desired >> 16) & 0xf);
> +	max2175_write(ctx, 3, frac_desired >> 8);
> +	max2175_write(ctx, 4, frac_desired);
> +	max2175_write_bits(ctx, 5, 3, 2, loband_bits);
> +	max2175_write_bits(ctx, 6, 7, 6, vcodiv_bits);
> +	return ret;
> +}
> +
> +static int max2175_set_nco_freq(struct max2175 *ctx, s64 nco_freq_desired)
> +{
> +	s64  nco_freq, nco_val_desired;
> +	u64 abs_nco_freq;
> +	const u32 scale_factor = 1000000U;
> +	u32 clock_rate, nco_reg;
> +	int ret;
> +
> +	mxm_dbg(ctx, "set_nco_freq: freq %lld\n", nco_freq_desired);
> +	clock_rate = ctx->xtal_freq / ctx->decim_ratio;
> +	nco_freq = -nco_freq_desired;
> +
> +	if (nco_freq < 0)
> +		abs_nco_freq = -nco_freq;
> +	else
> +		abs_nco_freq = nco_freq;
> +
> +	/* Scale up the values for precision */
> +	if (abs_nco_freq < (clock_rate / 2)) {
> +		nco_val_desired = div_s64(2 * nco_freq * scale_factor,
> +					  clock_rate);
> +	} else {
> +		if (nco_freq < 0)
> +			nco_val_desired =
> +			div_s64(-2 * (clock_rate - abs_nco_freq) * scale_factor,
> +				clock_rate);
> +		else
> +			nco_val_desired =
> +			div_s64(2 * (clock_rate - abs_nco_freq) * scale_factor,
> +				clock_rate);
> +	}
> +
> +	/* Scale down to get the fraction */
> +	if (nco_freq < 0)
> +		nco_reg = 0x200000 + div_s64(nco_val_desired << 20,
> +						  scale_factor);
> +	else
> +		nco_reg = div_s64(nco_val_desired << 20, scale_factor);
> +
> +	/* Check CSM is not busy */
> +	ret = max2175_poll_csm_ready(ctx);
> +	if (ret)
> +		return ret;
> +
> +	mxm_dbg(ctx, "clk %u decim %u abs %llu desired %lld reg %u\n",
> +		clock_rate, ctx->decim_ratio, abs_nco_freq,
> +		nco_val_desired, nco_reg);
> +
> +	/* Write the calculated values to the appropriate registers */
> +	max2175_write_bits(ctx, 7, 4, 0, (nco_reg >> 16) & 0x1f);
> +	max2175_write(ctx, 8, nco_reg >> 8);
> +	max2175_write(ctx, 9, nco_reg);
> +	return ret;
> +}
> +
> +static int max2175_set_rf_freq_non_am_bands(struct max2175 *ctx, u64 freq,
> +					    u32 lo_pos)
> +{
> +	s64 adj_freq;
> +	u64 low_if_freq;
> +	int ret;
> +
> +	mxm_dbg(ctx, "rf_freq: non AM bands\n");
> +
> +	if (MAX2175_IS_FM_MODE(ctx))
> +		low_if_freq = 128000;
> +	else if (MAX2175_IS_FMHD_MODE(ctx))
> +		low_if_freq = 228000;
> +	else
> +		return max2175_set_lo_freq(ctx, freq);
> +
> +	if (MAX2175_IS_BAND_VHF(ctx) == (lo_pos == MAX2175_LO_ABOVE_DESIRED))
> +		adj_freq = freq + low_if_freq;
> +	else
> +		adj_freq = freq - low_if_freq;
> +
> +	ret = max2175_set_lo_freq(ctx, adj_freq);
> +	if (ret)
> +		return ret;
> +
> +	return max2175_set_nco_freq(ctx, low_if_freq);
> +}
> +
> +static int max2175_set_rf_freq(struct max2175 *ctx, u64 freq, u32 lo_pos)
> +{
> +	int ret;
> +
> +	if (MAX2175_IS_BAND_AM(ctx))
> +		ret = max2175_set_nco_freq(ctx, freq);
> +	else
> +		ret = max2175_set_rf_freq_non_am_bands(ctx, freq, lo_pos);
> +
> +	mxm_dbg(ctx, "set_rf_freq: ret %d freq %llu\n", ret, freq);
> +	return ret;
> +}
> +
> +static int max2175_tune_rf_freq(struct max2175 *ctx, u64 freq, u32 hsls)
> +{
> +	int ret;
> +
> +	ret = max2175_set_rf_freq(ctx, freq, hsls);
> +	if (ret)
> +		return ret;
> +
> +	ret = max2175_csm_action(ctx, MAX2175_BUFFER_PLUS_PRESET_TUNE);
> +	if (ret)
> +		return ret;
> +
> +	mxm_dbg(ctx, "tune_rf_freq: old %u new %llu\n", ctx->freq, freq);
> +	ctx->freq = freq;
> +	return ret;
> +}
> +
> +static void max2175_set_hsls(struct max2175 *ctx, u32 lo_pos)
> +{
> +	mxm_dbg(ctx, "set_hsls: lo_pos %u\n", lo_pos);
> +
> +	if ((lo_pos == MAX2175_LO_BELOW_DESIRED) == MAX2175_IS_BAND_VHF(ctx))
> +		max2175_write_bit(ctx, 5, 4, 1);
> +	else
> +		max2175_write_bit(ctx, 5, 4, 0);
> +}
> +
> +static void max2175_set_eu_rx_mode(struct max2175 *ctx, u32 rx_mode)
> +{
> +	switch (rx_mode) {
> +	case MAX2175_EU_FM_1_2:
> +		max2175_load_fmeu_1p2(ctx);
> +		break;
> +
> +	case MAX2175_DAB_1_2:
> +		max2175_load_dab_1p2(ctx);
> +		break;
> +	}
> +	/* Master is the default setting */
> +	if (!ctx->master)
> +		max2175_write_bit(ctx, 30, 7, 1);
> +
> +	/* Cache i2s_test value at this point */
> +	ctx->i2s_test = max2175_read_bits(ctx, 104, 3, 0);
> +}
> +
> +static void max2175_set_na_rx_mode(struct max2175 *ctx, u32 rx_mode)
> +{
> +	switch (rx_mode) {
> +	case MAX2175_NA_FM_1_0:
> +		max2175_load_fmna_1p0(ctx);
> +		break;
> +	case MAX2175_NA_FM_2_0:
> +		max2175_load_fmna_2p0(ctx);
> +		break;
> +	}
> +	/* Master is the default setting */
> +	if (!ctx->master)
> +		max2175_write_bit(ctx, 30, 7, 1);
> +
> +	/* Cache i2s_test value at this point */
> +	ctx->i2s_test = max2175_read_bits(ctx, 104, 3, 0);
> +	ctx->decim_ratio = 27;
> +
> +	/* Load the Channel Filter Coefficients into channel filter bank #2 */
> +	max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 0, ch_coeff_fmna);
> +	max2175_set_filter_coeffs(ctx, MAX2175_EQ_MSEL, 0,
> +				  eq_coeff_fmna1_ra02_m6db);
> +}
> +
> +static int max2175_set_rx_mode(struct max2175 *ctx, u32 rx_mode, u32 hsls)
> +{
> +	mxm_dbg(ctx, "set_rx_mode: %u am_hiz %u\n", rx_mode, ctx->am_hiz);
> +	if (ctx->xtal_freq == MAX2175_EU_XTAL_FREQ)
> +		max2175_set_eu_rx_mode(ctx, rx_mode);
> +	else
> +		max2175_set_na_rx_mode(ctx, rx_mode);
> +
> +	if (ctx->am_hiz) {
> +		mxm_dbg(ctx, "setting AM HiZ related config\n");
> +		max2175_write_bit(ctx, 50, 5, 1);
> +		max2175_write_bit(ctx, 90, 7, 1);
> +		max2175_write_bits(ctx, 73, 1, 0, 2);
> +		max2175_write_bits(ctx, 80, 5, 0, 33);
> +	}
> +
> +	/* Load BB filter trim values saved in ROM */
> +	max2175_set_bbfilter(ctx);
> +
> +	/* Set HSLS */
> +	max2175_set_hsls(ctx, hsls);
> +
> +	ctx->mode_resolved = true;
> +	return 0;
> +}
> +
> +static bool max2175_i2s_rx_mode_valid(struct max2175 *ctx,
> +					 u32 mode, u32 i2s_mode)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ctx->rx_modes[mode].i2s_modes); i++)
> +		if (ctx->rx_modes[mode].i2s_modes[i] == i2s_mode)
> +			return true;
> +
> +	v4l2_err(ctx->client, "i2s_mode %u not suitable for cur rx mode %u\n",
> +		 i2s_mode, mode);
> +	return false;
> +}
> +
> +static int max2175_rx_mode_from_freq(struct max2175 *ctx, u32 freq, u32 *mode)
> +{
> +	unsigned int i;
> +	int band = max2175_band_from_freq(freq);
> +
> +	/* Pick the first match always */
> +	for (i = 0; i <= ctx->rx_mode->maximum; i++) {
> +		if (ctx->rx_modes[i].band == band) {
> +			*mode = i;
> +			mxm_dbg(ctx, "rx_mode_from_freq: freq %u mode %d\n",
> +				freq, *mode);
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static bool max2175_freq_rx_mode_valid(struct max2175 *ctx,
> +					 u32 mode, u32 freq)
> +{
> +	int band = max2175_band_from_freq(freq);
> +
> +	return (ctx->rx_modes[mode].band == band);
> +}
> +
> +static void max2175_load_adc_presets(struct max2175 *ctx)
> +{
> +	unsigned int i, j;
> +
> +	for (i = 0; i < 2; i++)
> +		for (j = 0; j < 23; j++)
> +			max2175_write(ctx, 146 + j + i * 55, adc_presets[i][j]);
> +}
> +
> +static int max2175_init_power_manager(struct max2175 *ctx)
> +{
> +	int ret;
> +
> +	/* Execute on-chip power-up/calibration */
> +	max2175_write_bit(ctx, 99, 2, 0);
> +	usleep_range(1000, 1500);
> +	max2175_write_bit(ctx, 99, 2, 1);
> +
> +	/* Wait for the power manager to finish. */
> +	ret = max2175_poll_timeout(ctx, 69, 7, 7, 1, 50);
> +	if (ret)
> +		v4l2_err(ctx->client, "init pm failed\n");
> +	return ret;
> +}
> +
> +static int max2175_recalibrate_adc(struct max2175 *ctx)
> +{
> +	int ret;
> +
> +	/* ADC Re-calibration */
> +	max2175_write(ctx, 150, 0xff);
> +	max2175_write(ctx, 205, 0xff);
> +	max2175_write(ctx, 147, 0x20);
> +	max2175_write(ctx, 147, 0x00);
> +	max2175_write(ctx, 202, 0x20);
> +	max2175_write(ctx, 202, 0x00);
> +
> +	ret = max2175_poll_timeout(ctx, 69, 4, 3, 3, 50);
> +	if (ret)
> +		v4l2_err(ctx->client, "adc recalibration failed\n");
> +	return ret;
> +}
> +
> +static u8 max2175_read_rom(struct max2175 *ctx, u8 row)
> +{
> +	u8 data;
> +
> +	max2175_write_bit(ctx, 56, 4, 0);
> +	max2175_write_bits(ctx, 56, 3, 0, row);
> +
> +	usleep_range(2000, 2500);
> +	max2175_read(ctx, 58, &data);
> +
> +	max2175_write_bits(ctx, 56, 3, 0, 0);
> +
> +	mxm_dbg(ctx, "read_rom: row %d data 0x%02x\n", row, data);
> +	return data;
> +}
> +
> +static void max2175_load_from_rom(struct max2175 *ctx)
> +{
> +	u8 data = 0;
> +
> +	data = max2175_read_rom(ctx, 0);
> +	ctx->rom_bbf_bw_am = data & 0x0f;
> +	max2175_write_bits(ctx, 81, 3, 0, data >> 4);
> +
> +	data = max2175_read_rom(ctx, 1);
> +	ctx->rom_bbf_bw_fm = data & 0x0f;
> +	ctx->rom_bbf_bw_dab = data >> 4;
> +
> +	data = max2175_read_rom(ctx, 2);
> +	max2175_write_bits(ctx, 82, 4, 0, data & 0x1f);
> +	max2175_write_bits(ctx, 82, 7, 5, data >> 5);
> +
> +	data = max2175_read_rom(ctx, 3);
> +	if (ctx->am_hiz) {
> +		data &= 0x0f;
> +		data |= max2175_read_rom(ctx, 7) & 0x40 >> 2;
> +		if (!data)
> +			data |= 2;
> +	} else {
> +		data = data & 0xf0 >> 4;
> +		data |= max2175_read_rom(ctx, 7) & 0x80 >> 3;
> +		if (!data)
> +			data |= 30;
> +	}
> +	max2175_write_bits(ctx, 80, 5, 0, data + 31);
> +
> +	data = max2175_read_rom(ctx, 6);
> +	max2175_write_bits(ctx, 81, 7, 6, data >> 6);
> +}
> +
> +static void max2175_load_full_fm_eu_1p0(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(full_fm_eu_1p0); i++)
> +		max2175_write(ctx, i + 1, full_fm_eu_1p0[i]);
> +
> +	usleep_range(5000, 5500);
> +	ctx->decim_ratio = 36;
> +}
> +
> +static void max2175_load_full_fm_na_1p0(struct max2175 *ctx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(full_fm_na_1p0); i++)
> +		max2175_write(ctx, i + 1, full_fm_na_1p0[i]);
> +
> +	usleep_range(5000, 5500);
> +	ctx->decim_ratio = 27;
> +}
> +
> +static int max2175_core_init(struct max2175 *ctx, u32 refout_bits)
> +{
> +	int ret;
> +
> +	/* MAX2175 uses 36.864MHz clock for EU & 40.154MHz for NA region */
> +	if (ctx->xtal_freq == MAX2175_EU_XTAL_FREQ)
> +		max2175_load_full_fm_eu_1p0(ctx);
> +	else
> +		max2175_load_full_fm_na_1p0(ctx);
> +
> +	/* The default settings assume master */
> +	if (!ctx->master)
> +		max2175_write_bit(ctx, 30, 7, 1);
> +
> +	mxm_dbg(ctx, "refout_bits %u\n", refout_bits);
> +
> +	/* Set REFOUT */
> +	max2175_write_bits(ctx, 56, 7, 5, refout_bits);
> +
> +	/* ADC Reset */
> +	max2175_write_bit(ctx, 99, 1, 0);
> +	usleep_range(1000, 1500);
> +	max2175_write_bit(ctx, 99, 1, 1);
> +
> +	/* Load ADC preset values */
> +	max2175_load_adc_presets(ctx);
> +
> +	/* Initialize the power management state machine */
> +	ret = max2175_init_power_manager(ctx);
> +	if (ret)
> +		return ret;
> +
> +	/* Recalibrate ADC */
> +	ret = max2175_recalibrate_adc(ctx);
> +	if (ret)
> +		return ret;
> +
> +	/* Load ROM values to appropriate registers */
> +	max2175_load_from_rom(ctx);
> +
> +	if (ctx->xtal_freq == MAX2175_EU_XTAL_FREQ) {
> +		/* Load FIR coefficients into bank 0 */
> +		max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 0,
> +					  ch_coeff_fmeu);
> +		max2175_set_filter_coeffs(ctx, MAX2175_EQ_MSEL, 0,
> +					  eq_coeff_fmeu1_ra02_m6db);
> +	} else {
> +		/* Load FIR coefficients into bank 0 */
> +		max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 0,
> +					  ch_coeff_fmna);
> +		max2175_set_filter_coeffs(ctx, MAX2175_EQ_MSEL, 0,
> +					  eq_coeff_fmna1_ra02_m6db);
> +	}
> +	mxm_dbg(ctx, "core initialized\n");
> +	return 0;
> +}
> +
> +static void max2175_s_ctrl_i2s_mode(struct max2175 *ctx, u32 i2s_mode)
> +{
> +	mxm_dbg(ctx, "s_ctrl_i2s_mode: %u resolved %d\n", i2s_mode,
> +		ctx->mode_resolved);
> +
> +	/*
> +	 * Update i2s mode on device only when mode is resolved & it is valid
> +	 * for the configured mode
> +	 */
> +	if (ctx->mode_resolved &&
> +	    max2175_i2s_rx_mode_valid(ctx, ctx->rx_mode->val, i2s_mode))
> +		max2175_update_i2s_mode(ctx, ctx->rx_mode->val, i2s_mode);
> +}
> +
> +static void max2175_s_ctrl_rx_mode(struct max2175 *ctx, u32 rx_mode)
> +{
> +	/* Load mode. Range check already done */
> +	max2175_set_rx_mode(ctx, rx_mode, ctx->hsls->val);
> +
> +	/* Get current i2s_mode and update if needed for given rx_mode */
> +	if (max2175_i2s_rx_mode_valid(ctx, rx_mode, ctx->i2s_mode->val))
> +		max2175_update_i2s_mode(ctx, rx_mode, ctx->i2s_mode->val);
> +	else
> +		ctx->i2s_mode->val = max2175_read_bits(ctx, 29, 2, 0);
> +
> +	mxm_dbg(ctx, "s_ctrl_rx_mode: %u curr freq %u\n", rx_mode, ctx->freq);
> +
> +	/* Check if current freq valid for mode & update */
> +	if (max2175_freq_rx_mode_valid(ctx, rx_mode, ctx->freq))
> +		max2175_tune_rf_freq(ctx, ctx->freq, ctx->hsls->val);
> +	else
> +		/* Use default freq of mode if current freq is not valid */
> +		max2175_tune_rf_freq(ctx, ctx->rx_modes[rx_mode].freq,
> +				     ctx->hsls->val);
> +}
> +
> +static int max2175_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct max2175 *ctx = max2175_from_ctrl_hdl(ctrl->handler);
> +	int ret = 0;
> +
> +	mxm_dbg(ctx, "s_ctrl: id 0x%x, val %u\n", ctrl->id, ctrl->val);
> +	switch (ctrl->id) {
> +	case V4L2_CID_MAX2175_I2S_ENABLE:
> +		max2175_i2s_enable(ctx, ctrl->val == 1);
> +		break;
> +	case V4L2_CID_MAX2175_I2S_MODE:
> +		max2175_s_ctrl_i2s_mode(ctx, ctrl->val);
> +		break;
> +	case V4L2_CID_MAX2175_HSLS:
> +		max2175_set_hsls(ctx, ctx->hsls->val);
> +		break;
> +	case V4L2_CID_MAX2175_RX_MODE:
> +		max2175_s_ctrl_rx_mode(ctx, ctrl->val);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int max2175_get_lna_gain(struct max2175 *ctx)
> +{
> +	int gain = 0;
> +	enum max2175_band band = max2175_read_bits(ctx, 5, 1, 0);
> +
> +	switch (band) {
> +	case MAX2175_BAND_AM:
> +		gain = max2175_read_bits(ctx, 51, 3, 1);
> +		break;
> +	case MAX2175_BAND_FM:
> +		gain = max2175_read_bits(ctx, 50, 3, 1);
> +		break;
> +	case MAX2175_BAND_VHF:
> +		gain = max2175_read_bits(ctx, 52, 3, 0);
> +		break;
> +	default:
> +		break;
> +	}
> +	return gain;
> +}
> +
> +static int max2175_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct max2175 *ctx = max2175_from_ctrl_hdl(ctrl->handler);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_RF_TUNER_LNA_GAIN:
> +		ctrl->val = max2175_get_lna_gain(ctx);
> +		break;
> +	case V4L2_CID_RF_TUNER_IF_GAIN:
> +		ctrl->val = max2175_read_bits(ctx, 49, 4, 0);
> +		break;
> +	case V4L2_CID_RF_TUNER_PLL_LOCK:
> +		ctrl->val = (max2175_read_bits(ctx, 60, 7, 6) == 3);
> +		break;
> +	}
> +	mxm_dbg(ctx, "g_volatile_ctrl: id 0x%x val %d\n", ctrl->id, ctrl->val);
> +	return 0;
> +};
> +
> +static int max2175_set_freq_and_mode(struct max2175 *ctx, u32 freq)
> +{
> +	u32 rx_mode;
> +	int ret;
> +
> +	/* Get band from frequency */
> +	ret = max2175_rx_mode_from_freq(ctx, freq, &rx_mode);
> +	if (ret)
> +		return ret;
> +
> +	mxm_dbg(ctx, "set_freq_and_mode: freq %u rx_mode %d\n", freq, rx_mode);
> +
> +	/* Load mode */
> +	max2175_set_rx_mode(ctx, rx_mode, ctx->hsls->val);
> +	ctx->rx_mode->val = rx_mode;
> +
> +	/* Get current i2s_mode and update if needed for given rx_mode */
> +	if (max2175_i2s_rx_mode_valid(ctx, rx_mode, ctx->i2s_mode->val))
> +		max2175_update_i2s_mode(ctx, rx_mode, ctx->i2s_mode->val);
> +	else
> +		ctx->i2s_mode->val = max2175_read_bits(ctx, 29, 2, 0);
> +
> +	/* Tune to the new freq given */
> +	return max2175_tune_rf_freq(ctx, freq, ctx->hsls->val);
> +}
> +
> +static int max2175_s_frequency(struct v4l2_subdev *sd,
> +			       const struct v4l2_frequency *vf)
> +{
> +	struct max2175 *ctx = max2175_from_sd(sd);
> +	u32 freq;
> +	int ret = 0;
> +
> +	mxm_dbg(ctx, "s_freq: new %u curr %u, mode_resolved %d\n",
> +		vf->frequency, ctx->freq, ctx->mode_resolved);
> +
> +	if (vf->tuner != 0)
> +		return -EINVAL;
> +
> +	freq = clamp(vf->frequency, ctx->bands_rf->rangelow,
> +		     ctx->bands_rf->rangehigh);
> +
> +	/* Check new freq valid for rx_mode if already resolved */
> +	if (ctx->mode_resolved &&
> +	    max2175_freq_rx_mode_valid(ctx, ctx->rx_mode->val, freq))
> +		ret = max2175_tune_rf_freq(ctx, freq, ctx->hsls->val);
> +	else
> +		/* Find default rx_mode for freq and tune to it */
> +		ret = max2175_set_freq_and_mode(ctx, freq);
> +
> +	mxm_dbg(ctx, "s_freq: ret %d curr %u mode_resolved %d mode %u\n",
> +		ret, ctx->freq, ctx->mode_resolved, ctx->rx_mode->val);
> +	return ret;
> +}
> +
> +static int max2175_g_frequency(struct v4l2_subdev *sd,
> +			       struct v4l2_frequency *vf)
> +{
> +	struct max2175 *ctx = max2175_from_sd(sd);
> +	int ret = 0;
> +
> +	if (vf->tuner != 0)
> +		return -EINVAL;
> +
> +	/* RF freq */
> +	vf->type = V4L2_TUNER_RF;
> +	vf->frequency = ctx->freq;
> +	return ret;
> +}
> +
> +static int max2175_enum_freq_bands(struct v4l2_subdev *sd,
> +			    struct v4l2_frequency_band *band)
> +{
> +	struct max2175 *ctx = max2175_from_sd(sd);
> +
> +	if (band->tuner == 0 && band->index == 0)
> +		*band = *ctx->bands_rf;
> +	else
> +		return -EINVAL;

This is a bit ugly. I would invert the condition and return -EINVAL.
Then assign *band and return 0.

> +
> +	return 0;
> +}
> +
> +static int max2175_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> +{
> +	struct max2175 *ctx = max2175_from_sd(sd);
> +
> +	if (vt->index > 0)
> +		return -EINVAL;
> +
> +	strlcpy(vt->name, "RF", sizeof(vt->name));
> +	vt->type = V4L2_TUNER_RF;
> +	vt->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
> +	vt->rangelow = ctx->bands_rf->rangelow;
> +	vt->rangehigh = ctx->bands_rf->rangehigh;
> +	return 0;
> +}
> +
> +static int max2175_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
> +{
> +	/* Check tuner index is valid */
> +	if (vt->index > 0)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_tuner_ops max2175_tuner_ops = {
> +	.s_frequency = max2175_s_frequency,
> +	.g_frequency = max2175_g_frequency,
> +	.enum_freq_bands = max2175_enum_freq_bands,
> +	.g_tuner = max2175_g_tuner,
> +	.s_tuner = max2175_s_tuner,
> +};
> +
> +static const struct v4l2_subdev_ops max2175_ops = {
> +	.tuner = &max2175_tuner_ops,
> +};
> +
> +static const struct v4l2_ctrl_ops max2175_ctrl_ops = {
> +	.s_ctrl = max2175_s_ctrl,
> +	.g_volatile_ctrl = max2175_g_volatile_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_i2s_en = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_I2S_ENABLE,
> +	.name = "I2S Enable",
> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +	.def = 1,
> +};
> +
> +static const char * const max2175_ctrl_i2s_modes[] = {
> +	[MAX2175_I2S_MODE0]	= "i2s mode 0",
> +	[MAX2175_I2S_MODE1]	= "i2s mode 1 (skipped)",
> +	[MAX2175_I2S_MODE2]	= "i2s mode 2",
> +	[MAX2175_I2S_MODE3]	= "i2s mode 3",
> +	[MAX2175_I2S_MODE4]	= "i2s mode 4",
> +};
> +
> +static const struct v4l2_ctrl_config max2175_i2s_mode = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_I2S_MODE,
> +	.name = "I2S MODE value",
> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = ARRAY_SIZE(max2175_ctrl_i2s_modes) - 1,
> +	.def = 0,
> +	.menu_skip_mask = 0x02,
> +	.qmenu = max2175_ctrl_i2s_modes,
> +};

Is this something that is changed dynamically? It looks more like a
device tree thing (it's not clear what it does, so obviously I
can't be sure).

> +
> +static const struct v4l2_ctrl_config max2175_hsls = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_HSLS,
> +	.name = "HSLS above/below desired",
> +	.type = V4L2_CTRL_TYPE_INTEGER,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +	.def = 1,
> +};
> +
> +static const char * const max2175_ctrl_eu_rx_modes[] = {
> +	[MAX2175_EU_FM_1_2]	= "EU FM 1.2",
> +	[MAX2175_DAB_1_2]	= "DAB 1.2",
> +};
> +
> +static const char * const max2175_ctrl_na_rx_modes[] = {
> +	[MAX2175_NA_FM_1_0]	= "NA FM 1.0",
> +	[MAX2175_NA_FM_2_0]	= "NA FM 2.0",
> +};
> +
> +static const struct v4l2_ctrl_config max2175_eu_rx_mode = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_RX_MODE,
> +	.name = "RX MODE",
> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = ARRAY_SIZE(max2175_ctrl_eu_rx_modes) - 1,
> +	.def = 0,
> +	.qmenu = max2175_ctrl_eu_rx_modes,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_na_rx_mode = {
> +	.ops = &max2175_ctrl_ops,
> +	.id = V4L2_CID_MAX2175_RX_MODE,
> +	.name = "RX MODE",
> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = ARRAY_SIZE(max2175_ctrl_na_rx_modes) - 1,
> +	.def = 0,
> +	.qmenu = max2175_ctrl_na_rx_modes,
> +};

Please document all these controls better. This is part of the public API, so
you need to give more information what this means exactly.

> +
> +static int max2175_refout_load_to_bits(struct i2c_client *client, u32 load,
> +				       u32 *bits)
> +{
> +	if (load >= 0 && load <= 40)
> +		*bits = load / 10;
> +	else if (load >= 60 && load <= 70)
> +		*bits = load / 10 - 1;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int max2175_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct max2175 *ctx;
> +	struct v4l2_subdev *sd;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct clk *clk;
> +	struct regmap *regmap;
> +	bool master = true, am_hiz = false;
> +	u32 refout_load, refout_bits = 0;	/* REFOUT disabled */
> +	int ret;
> +
> +	/* Parse DT properties */
> +	if (of_find_property(client->dev.of_node, "maxim,slave", NULL))
> +		master = false;
> +
> +	if (of_find_property(client->dev.of_node, "maxim,am-hiz", NULL))
> +		am_hiz = true;
> +
> +	if (!of_property_read_u32(client->dev.of_node, "maxim,refout-load-pF",
> +				  &refout_load)) {
> +		ret = max2175_refout_load_to_bits(client, refout_load,
> +						  &refout_bits);
> +		if (ret) {
> +			dev_err(&client->dev, "invalid refout_load %u\n",
> +				refout_load);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	clk = devm_clk_get(&client->dev, "xtal");
> +	if (IS_ERR(clk)) {
> +		ret = PTR_ERR(clk);
> +		dev_err(&client->dev, "cannot get xtal clock %d\n", ret);
> +		return -ENODEV;
> +	}
> +
> +	regmap = devm_regmap_init_i2c(client, &max2175_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		ret = PTR_ERR(regmap);
> +		dev_err(&client->dev, "regmap init failed %d\n", ret);
> +		return -ENODEV;
> +	}
> +
> +	/* Alloc tuner context */
> +	ctx = devm_kzalloc(&client->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (ctx == NULL)
> +		return -ENOMEM;
> +
> +	sd = &ctx->sd;
> +	ctx->master = master;
> +	ctx->am_hiz = am_hiz;
> +	ctx->mode_resolved = false;
> +	ctx->regmap = regmap;
> +	ctx->xtal_freq = clk_get_rate(clk);
> +	dev_info(&client->dev, "xtal freq %luHz\n", ctx->xtal_freq);
> +
> +	v4l2_i2c_subdev_init(sd, client, &max2175_ops);
> +	ctx->client = client;
> +
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* Controls */
> +	hdl = &ctx->ctrl_hdl;
> +	ret = v4l2_ctrl_handler_init(hdl, 7);
> +	if (ret) {
> +		dev_err(&client->dev, "ctrl handler init failed\n");
> +		goto err;
> +	}
> +
> +	ctx->lna_gain = v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +					  V4L2_CID_RF_TUNER_LNA_GAIN,
> +					  0, 15, 1, 2);
> +	ctx->lna_gain->flags |= (V4L2_CTRL_FLAG_VOLATILE |
> +				 V4L2_CTRL_FLAG_READ_ONLY);
> +	ctx->if_gain = v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +					 V4L2_CID_RF_TUNER_IF_GAIN,
> +					 0, 31, 1, 0);
> +	ctx->if_gain->flags |= (V4L2_CTRL_FLAG_VOLATILE |
> +				V4L2_CTRL_FLAG_READ_ONLY);
> +	ctx->pll_lock = v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +					  V4L2_CID_RF_TUNER_PLL_LOCK,
> +					  0, 1, 1, 0);
> +	ctx->pll_lock->flags |= (V4L2_CTRL_FLAG_VOLATILE |
> +				 V4L2_CTRL_FLAG_READ_ONLY);
> +	ctx->i2s_en = v4l2_ctrl_new_custom(hdl, &max2175_i2s_en, NULL);
> +	ctx->i2s_mode = v4l2_ctrl_new_custom(hdl, &max2175_i2s_mode, NULL);
> +	ctx->hsls = v4l2_ctrl_new_custom(hdl, &max2175_hsls, NULL);
> +
> +	if (ctx->xtal_freq == MAX2175_EU_XTAL_FREQ) {
> +		ctx->rx_mode = v4l2_ctrl_new_custom(hdl,
> +						    &max2175_eu_rx_mode, NULL);
> +		ctx->rx_modes = eu_rx_modes;
> +		ctx->bands_rf = &eu_bands_rf;
> +	} else {
> +		ctx->rx_mode = v4l2_ctrl_new_custom(hdl,
> +						    &max2175_na_rx_mode, NULL);
> +		ctx->rx_modes = na_rx_modes;
> +		ctx->bands_rf = &na_bands_rf;
> +	}
> +	ctx->sd.ctrl_handler = &ctx->ctrl_hdl;
> +
> +	/* Set the defaults */
> +	ctx->freq = ctx->bands_rf->rangelow;
> +
> +	/* Register subdev */
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret) {
> +		dev_err(&client->dev, "register subdev failed\n");
> +		goto err_reg;
> +	}
> +
> +	/* Initialize device */
> +	ret = max2175_core_init(ctx, refout_bits);
> +	if (ret)
> +		goto err_init;
> +
> +	dev_info(&client->dev, "probed\n");
> +	return 0;
> +
> +err_init:
> +	v4l2_async_unregister_subdev(sd);
> +err_reg:
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +err:
> +	return ret;
> +}
> +
> +static int max2175_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct max2175 *ctx = max2175_from_sd(sd);
> +
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +	v4l2_async_unregister_subdev(sd);
> +	dev_info(&client->dev, "removed\n");
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max2175_id[] = {
> +	{ DRIVER_NAME, 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, max2175_id);
> +
> +static const struct of_device_id max2175_of_ids[] = {
> +	{ .compatible = "maxim, max2175", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, max2175_of_ids);
> +
> +static struct i2c_driver max2175_driver = {
> +	.driver = {
> +		.name	= DRIVER_NAME,
> +		.of_match_table = max2175_of_ids,
> +	},
> +	.probe		= max2175_probe,
> +	.remove		= max2175_remove,
> +	.id_table	= max2175_id,
> +};
> +
> +module_i2c_driver(max2175_driver);
> +
> +MODULE_DESCRIPTION("Maxim MAX2175 RF to Bits tuner driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>");
> diff --git a/drivers/media/i2c/max2175/max2175.h b/drivers/media/i2c/max2175/max2175.h
> new file mode 100644
> index 0000000..2d858aa
> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.h
> @@ -0,0 +1,108 @@
> +/*
> + * Maxim Integrated MAX2175 RF to Bits tuner driver
> + *
> + * This driver & most of the hard coded values are based on the reference
> + * application delivered by Maxim for this chip.
> + *
> + * Copyright (C) 2016 Maxim Integrated Products
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MAX2175_H__
> +#define __MAX2175_H__
> +
> +#define MAX2175_EU_XTAL_FREQ	36864000	/* In Hz */
> +#define MAX2175_NA_XTAL_FREQ	40186125	/* In Hz */
> +
> +enum max2175_region {
> +	MAX2175_REGION_EU = 0,	/* Europe */
> +	MAX2175_REGION_NA,	/* North America */
> +};
> +
> +
> +enum max2175_band {
> +	MAX2175_BAND_AM = 0,
> +	MAX2175_BAND_FM,
> +	MAX2175_BAND_VHF,
> +	MAX2175_BAND_L,
> +};
> +
> +enum max2175_eu_mode {
> +	/* EU modes */
> +	MAX2175_EU_FM_1_2 = 0,
> +	MAX2175_DAB_1_2,
> +
> +	/* Other possible modes to add in future
> +	 * MAX2175_DAB_1_0,
> +	 * MAX2175_DAB_1_3,
> +	 * MAX2175_EU_FM_2_2,
> +	 * MAX2175_EU_FMHD_4_0,
> +	 * MAX2175_EU_AM_1_0,
> +	 * MAX2175_EU_AM_2_2,
> +	 */
> +};
> +
> +enum max2175_na_mode {
> +	/* NA modes */
> +	MAX2175_NA_FM_1_0 = 0,
> +	MAX2175_NA_FM_2_0,
> +
> +	/* Other possible modes to add in future
> +	 * MAX2175_NA_FMHD_1_0,
> +	 * MAX2175_NA_FMHD_1_2,
> +	 * MAX2175_NA_AM_1_0,
> +	 * MAX2175_NA_AM_1_2,
> +	 */
> +};
> +
> +/* Supported I2S modes */
> +enum {
> +	MAX2175_I2S_MODE0 = 0,
> +	MAX2175_I2S_MODE1,
> +	MAX2175_I2S_MODE2,
> +	MAX2175_I2S_MODE3,
> +	MAX2175_I2S_MODE4,
> +};
> +
> +/* Coefficient table groups */
> +enum {
> +	MAX2175_CH_MSEL = 0,
> +	MAX2175_EQ_MSEL,
> +	MAX2175_AA_MSEL,
> +};
> +
> +/* HSLS LO injection polarity */
> +enum {
> +	MAX2175_LO_BELOW_DESIRED = 0,
> +	MAX2175_LO_ABOVE_DESIRED,
> +};
> +
> +/* Channel FSM modes */
> +enum max2175_csm_mode {
> +	MAX2175_LOAD_TO_BUFFER = 0,
> +	MAX2175_PRESET_TUNE,
> +	MAX2175_SEARCH,
> +	MAX2175_AF_UPDATE,
> +	MAX2175_JUMP_FAST_TUNE,
> +	MAX2175_CHECK,
> +	MAX2175_LOAD_AND_SWAP,
> +	MAX2175_END,
> +	MAX2175_BUFFER_PLUS_PRESET_TUNE,
> +	MAX2175_BUFFER_PLUS_SEARCH,
> +	MAX2175_BUFFER_PLUS_AF_UPDATE,
> +	MAX2175_BUFFER_PLUS_JUMP_FAST_TUNE,
> +	MAX2175_BUFFER_PLUS_CHECK,
> +	MAX2175_BUFFER_PLUS_LOAD_AND_SWAP,
> +	MAX2175_NO_ACTION
> +};
> +
> +#endif /* __MAX2175_H__ */
> 

Regards,

	Hans
