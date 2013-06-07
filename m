Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2692 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3FGJNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:13:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?utf-8?q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC v2 1/2] saa7115: Implement i2c_board_info.platform_data
Date: Fri, 7 Jun 2013 11:12:47 +0200
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	mchehab@redhat.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, g.liakhovetski@gmx.de,
	ezequiel.garcia@free-electrons.com, timo.teras@iki.fi
References: <1370000426-3324-1-git-send-email-jonarne@jonarne.no> <1370000426-3324-2-git-send-email-jonarne@jonarne.no>
In-Reply-To: <1370000426-3324-2-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201306071112.47680.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri May 31 2013 13:40:25 Jon Arne Jørgensen wrote:
> Implement i2c_board_info.platform_data handling in the driver so we can
> make device specific changes to the chips we support.
> 
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> ---
>  drivers/media/i2c/saa7115.c      | 101 +++++++++++++++++++++++++++++++++++++--
>  drivers/media/i2c/saa711x_regs.h |   8 ++++
>  include/media/saa7115.h          |  39 +++++++++++++++
>  3 files changed, 143 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index d6f589a..4a52b4d 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -216,10 +216,7 @@ static const unsigned char saa7111_init[] = {
>  	0x00, 0x00
>  };
>  
> -/* SAA7113/GM7113C init codes
> - * It's important that R_14... R_17 == 0x00
> - * for the gm7113c chip to deliver stable video
> - */
> +/* SAA7113/GM7113C init codes */
>  static const unsigned char saa7113_init[] = {
>  	R_01_INC_DELAY, 0x08,
>  	R_02_INPUT_CNTL_1, 0xc2,
> @@ -248,6 +245,35 @@ static const unsigned char saa7113_init[] = {
>  	0x00, 0x00
>  };
>  
> +/* SAA7113 Init according to the datasheet */
> +static const unsigned char saa7113_datasheet_init[] = {
> +	R_01_INC_DELAY, 0x08,
> +	R_02_INPUT_CNTL_1, 0xc0,
> +	R_03_INPUT_CNTL_2, 0x33,
> +	R_04_INPUT_CNTL_3, 0x00,
> +	R_05_INPUT_CNTL_4, 0x00,
> +	R_06_H_SYNC_START, 0xe9,
> +	R_07_H_SYNC_STOP, 0x0d,
> +	R_08_SYNC_CNTL, 0x98,
> +	R_09_LUMA_CNTL, 0x01,
> +	R_0A_LUMA_BRIGHT_CNTL, 0x80,
> +	R_0B_LUMA_CONTRAST_CNTL, 0x47,
> +	R_0C_CHROMA_SAT_CNTL, 0x40,
> +	R_0D_CHROMA_HUE_CNTL, 0x00,
> +	R_0E_CHROMA_CNTL_1, 0x01,
> +	R_0F_CHROMA_GAIN_CNTL, 0x2a,
> +	R_10_CHROMA_CNTL_2, 0x00,
> +	R_11_MODE_DELAY_CNTL, 0x0c,
> +	R_12_RT_SIGNAL_CNTL, 0x01,
> +	R_13_RT_X_PORT_OUT_CNTL, 0x00,
> +	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
> +	R_15_VGATE_START_FID_CHG, 0x00,
> +	R_16_VGATE_STOP, 0x00,
> +	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
> +
> +	0x00, 0x00
> +};
> +
>  /* If a value differs from the Hauppauge driver values, then the comment starts with
>     'was 0xXX' to denote the Hauppauge value. Otherwise the value is identical to what the
>     Hauppauge driver sets. */
> @@ -1603,6 +1629,64 @@ static const struct v4l2_subdev_ops saa711x_ops = {
>  };
>  
>  /* ----------------------------------------------------------------------- */
> +static void saa711x_write_platform_data(struct saa711x_state *state,
> +					struct saa7115_platform_data *data)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 work;
> +
> +	if (state->ident != V4L2_IDENT_GM7113C)
> +		return;
> +
> +	if (data->horizontal_time_const) {
> +		work = saa711x_read(sd, R_08_SYNC_CNTL);
> +		work &= ~SAA7113_R_08_HTC_MASK;
> +		work |= ((data->horizontal_time_const >> 1) << 3);
> +		v4l2_dbg(1, debug, sd,
> +			 "set R_08 horizontal_time_const: 0x%x\n", work);
> +		saa711x_write(sd, R_08_SYNC_CNTL, work);
> +	}
> +
> +	if (data->vref_len) {
> +		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> +		work &= ~SAA7113_R_10_VRLN_MASK;
> +		work |= (1 << 3);
> +		v4l2_dbg(1, debug, sd, "set R_10 vref_len: 0x%x\n", work);
> +		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
> +	}
> +
> +	if (data->output_format != SAA7113_OFTS_STD_ITU_656) {
> +		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
> +		work &= ~SAA7113_R_10_OFTS_MASK;
> +		work |= (data->output_format << 6);
> +		v4l2_dbg(1, debug, sd, "set R_10 output_format: 0x%x\n", work);
> +		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
> +	}
> +
> +	if (data->rt_signal0) {
> +		work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
> +		work &= ~SAA7113_R_12_RTS0_MASK;
> +		work |= data->rt_signal0;
> +		v4l2_dbg(1, debug, sd, "set R_12 rt_signal0: 0x%x\n", work);
> +		saa711x_write(sd, R_12_RT_SIGNAL_CNTL, work);
> +	}
> +
> +	if (data->rt_signal1) {
> +		work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
> +		work &= ~SAA7113_R_12_RTS1_MASK;
> +		work |= (data->rt_signal1 << 4);
> +		v4l2_dbg(1, debug, sd, "set R_12 rt_signal1: 0x%x\n", work);
> +		saa711x_write(sd, R_12_RT_SIGNAL_CNTL, work);
> +	}
> +
> +	if (data->adc_lsb) {
> +		work = saa711x_read(sd, R_13_RT_X_PORT_OUT_CNTL);
> +		work &= ~SAA7113_R_13_ADLSB_MASK;
> +		work |= (1 << 7);
> +		v4l2_dbg(1, debug, sd, "set R_13 adc_lsb: 0x%x\n", work);
> +		saa711x_write(sd, R_13_RT_X_PORT_OUT_CNTL, work);
> +	}
> +}
>  
>  /**
>   * saa711x_detect_chip - Detects the saa711x (or clone) variant
> @@ -1782,7 +1866,10 @@ static int saa711x_probe(struct i2c_client *client,
>  		break;
>  	case V4L2_IDENT_GM7113C:
>  	case V4L2_IDENT_SAA7113:
> -		saa711x_writeregs(sd, saa7113_init);
> +		if (client->dev.platform_data)
> +			saa711x_writeregs(sd, saa7113_datasheet_init);
> +		else
> +			saa711x_writeregs(sd, saa7113_init);
>  		break;
>  	default:
>  		state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
> @@ -1790,6 +1877,10 @@ static int saa711x_probe(struct i2c_client *client,
>  	}
>  	if (state->ident > V4L2_IDENT_SAA7111A)
>  		saa711x_writeregs(sd, saa7115_init_misc);
> +
> +	if (client->dev.platform_data)
> +		saa711x_write_platform_data(state, client->dev.platform_data);
> +
>  	saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
>  	v4l2_ctrl_handler_setup(hdl);
>  
> diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
> index 4e5f2eb..57918fe 100644
> --- a/drivers/media/i2c/saa711x_regs.h
> +++ b/drivers/media/i2c/saa711x_regs.h
> @@ -201,6 +201,14 @@
>  #define R_FB_PULSE_C_POS_MSB                          0xfb
>  #define R_FF_S_PLL_MAX_PHASE_ERR_THRESH_NUM_LINES     0xff
>  
> +/* SAA7113 bit-masks */
> +#define SAA7113_R_08_HTC_MASK (0x3 << 3)
> +#define SAA7113_R_10_VRLN_MASK (0x1 << 3)
> +#define SAA7113_R_10_OFTS_MASK (0x3 << 6)
> +#define SAA7113_R_12_RTS0_MASK (0xf << 0)
> +#define SAA7113_R_12_RTS1_MASK (0xf << 4)
> +#define SAA7113_R_13_ADLSB_MASK (0x1 << 7)
> +
>  #if 0
>  /* Those structs will be used in the future for debug purposes */
>  struct saa711x_reg_descr {
> diff --git a/include/media/saa7115.h b/include/media/saa7115.h
> index 4079186..d7e1f5a 100644
> --- a/include/media/saa7115.h
> +++ b/include/media/saa7115.h
> @@ -64,5 +64,44 @@
>  #define SAA7115_FREQ_FL_APLL         (1 << 2) /* SA 3A[3], APLL, SAA7114/5 only */
>  #define SAA7115_FREQ_FL_DOUBLE_ASCLK (1 << 3) /* SA 39, LRDIV, SAA7114/5 only */
>  
> +enum saa7113_output_format {
> +	SAA7113_OFTS_STD_ITU_656 = 0x0,
> +	SAA7113_OFTS_VFLAG_BY_VREF = 0x1,
> +	SAA7113_OFTS_VFLAG_BY_DATA_TYPE = 0x2
> +};
> +
> +enum saa7113_horizontal_time_const {
> +	SAA7113_HTC_TV_MODE = 0x1,
> +	SAA7113_HTC_VTR_MODE = 0x3,
> +	SAA7113_HTC_FAST_LOCKING_MODE = 0x7
> +};
> +
> +enum saa7113_rt_signal_cntl {
> +	SAA7113_RTS_ADC_LSB = 0x1,
> +	SAA7113_RTS_GPSW,
> +	SAA7115_RTS_HL,
> +	SAA7113_RTS_VL,
> +	SAA7113_RTS0_DL,
> +	SAA7113_RTS0_PLIN,
> +	SAA7113_RTS0_HREF_HS,
> +	SAA7113_RTS0_HS,
> +	SAA7113_RTS0_HQ,
> +	SAA7113_RTS0_ODD,
> +	SAA7113_RTS0_VS,
> +	SAA7113_RTS0_V123,
> +	SAA7113_RTS0_VGATE,
> +	SAA7113_RTS0_VREF,
> +	SAA7113_RTS0_FID
> +};
> +
> +struct saa7115_platform_data {
> +	bool vref_len;
> +	bool adc_lsb;
> +	enum saa7113_output_format output_format;
> +	enum saa7113_horizontal_time_const horizontal_time_const;
> +	enum saa7113_rt_signal_cntl rt_signal0;
> +	enum saa7113_rt_signal_cntl rt_signal1;
> +};

Please add comments to the various enums and the struct. It should at least
refer to the relevant registers in the datasheet and what the default is if
no pdata is supplied. It is also important to mention which fields are
saa7113 specific, and which are more generic.

I also don't really like the idea of having a second initialization table.
I prefer that any changes necessary are added to the platform_data. Right
now specifying pdata has an unexpected side-effect of changing more than
just what is set in the platform data.

I know it is a lot of work, but this driver is used in many devices, so we
have to be careful making changes to it.

Regards,

	Hans

> +
>  #endif
>  
> 
