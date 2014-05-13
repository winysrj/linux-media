Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52749 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759744AbaEMJTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 05:19:17 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
References: <1394529345-31952-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1394529345-31952-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v2] [media] s5p-mfc: add init buffer cmd to MFCV6
Date: Tue, 13 May 2014 11:19:30 +0200
Message-id: <025401cf6e8c$72835480$5789fd80$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
> Kumar K
> Sent: Tuesday, March 11, 2014 10:16 AM
> 
> From: avnd kiran <avnd.kiran@samsung.com>
> 
> Latest MFC v6 firmware requires tile mode and loop filter setting to be
> done as part of Init buffer command, in sync with v7. Since there are
> two versions of v6 firmware with different interfaces, it is
> differenciated using the version number read back from firmware which
> is a hexadecimal value based on the firmware date.
> 
> Signed-off-by: avnd kiran <avnd.kiran@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
> Changes from v1
> ---------------
> - Check for v6 firmware date for differenciating old and new firmware
>   as per comments from Kamil and Sylwester.
> ---
>  drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
>  drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    2 --
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    8 +++---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   30
> ++++++++++++++++++++---
>  5 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> index 8d0b686..b47567c 100644
> --- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> @@ -132,6 +132,7 @@
>  #define S5P_FIMV_D_METADATA_BUFFER_ADDR_V6	0xf448
>  #define S5P_FIMV_D_METADATA_BUFFER_SIZE_V6	0xf44c
>  #define S5P_FIMV_D_NUM_MV_V6			0xf478
> +#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6	0xf47c
>  #define S5P_FIMV_D_CPB_BUFFER_ADDR_V6		0xf4b0
>  #define S5P_FIMV_D_CPB_BUFFER_SIZE_V6		0xf4b4
> 
> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
> b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
> index ea5ec2a..82c96fa 100644
> --- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
> @@ -18,8 +18,6 @@
>  #define S5P_FIMV_CODEC_VP8_ENC_V7	25
> 
>  /* Additional registers for v7 */
> -#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7		0xf47c
> -
>  #define S5P_FIMV_E_SOURCE_FIRST_ADDR_V7			0xf9e0
>  #define S5P_FIMV_E_SOURCE_SECOND_ADDR_V7		0xf9e4
>  #define S5P_FIMV_E_SOURCE_THIRD_ADDR_V7			0xf9e8
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 4d17df9..f5404a6 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -287,6 +287,7 @@ struct s5p_mfc_priv_buf {
>   * @warn_start:		hardware error code from which warnings
start
>   * @mfc_ops:		ops structure holding HW operation function
> pointers
>   * @mfc_cmds:		cmd structure holding HW commands function
> pointers
> + * @ver:		firmware sub version
>   *
>   */
>  struct s5p_mfc_dev {
> @@ -330,6 +331,7 @@ struct s5p_mfc_dev {
>  	int warn_start;
>  	struct s5p_mfc_hw_ops *mfc_ops;
>  	struct s5p_mfc_hw_cmds *mfc_cmds;
> +	int ver;
>  };
> 
>  /**
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index 2475a3c..ba1d302 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -240,7 +240,6 @@ static inline void s5p_mfc_clear_cmds(struct
> s5p_mfc_dev *dev)
>  /* Initialize hardware */
>  int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)  {
> -	unsigned int ver;
>  	int ret;
> 
>  	mfc_debug_enter();
> @@ -302,12 +301,13 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
>  		return -EIO;
>  	}
>  	if (IS_MFCV6_PLUS(dev))
> -		ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
> +		dev->ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
>  	else
> -		ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
> +		dev->ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
> 
>  	mfc_debug(2, "MFC F/W version : %02xyy, %02xmm, %02xdd\n",
> -		(ver >> 16) & 0xFF, (ver >> 8) & 0xFF, ver & 0xFF);
> +		(dev->ver >> 16) & 0xFF, (dev->ver >> 8) & 0xFF,
> +		dev->ver & 0xFF);
>  	s5p_mfc_clock_off();
>  	mfc_debug_leave();
>  	return 0;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 90edb19..356cfe5 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -14,6 +14,7 @@
> 
>  #undef DEBUG
> 
> +#include <linux/bcd.h>
>  #include <linux/delay.h>
>  #include <linux/mm.h>
>  #include <linux/io.h>
> @@ -1269,6 +1270,29 @@ static int s5p_mfc_set_enc_params_vp8(struct
> s5p_mfc_ctx *ctx)
>  	return 0;
>  }
> 
> +/* Check if newer v6 firmware with changed init buffer interface */
> +static bool s5p_mfc_is_v6_new(struct s5p_mfc_dev *dev) {
> +	unsigned long cur_fw, v6_new_fw;
> +	unsigned int y, m, d;
> +
> +	if (IS_MFCV7(dev))
> +		return false;
> +
> +	y = bcd2bin((dev->ver >> 16) & 0xFF) + 2000;
> +	m = bcd2bin((dev->ver >> 8) & 0xFF);
> +	d = bcd2bin(dev->ver & 0xFF);
> +
> +	cur_fw = mktime(y, m, d, 0, 0, 0);
> +	/*
> +	 * Firmware versions from date 29/06/2012 are coming with new
> interface
> +	 * for init buffer
> +	 */
> +	v6_new_fw = mktime(2012, 6, 29, 0, 0, 0);
> +
> +	return cur_fw >= v6_new_fw;
> +}

Hold on for a minute. The firmware date is an integer in the format YYMMDD,
there is no firmware
prior to 2000. So a simple greater-than check should be sufficient.

return dev->ver >= 120629;
or better
return dev->ver >= MFC_V6_NEW_FIRMWARE;
with 
#define MFC_V6_NEW_FIRMWARE 

Also, maybe some versioning should be added? We don't want to have "new"
firmware
and "newer" firmware.

return dev->ver >= MFC_V6_FIRMWARE_INTERFACE_V2; ?

Year 2100 problem? Firmware only supplies two digits anyway, so any firmware
released after 2100 will require changes to the kernel.

> +
>  /* Initialize decoding */
>  static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)  { @@ -
> 1296,7 +1320,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx
> *ctx)
>  		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
>  	}
> 
> -	if (IS_MFCV7(dev)) {
> +	if (IS_MFCV7(dev) || s5p_mfc_is_v6_new(dev)) {
>  		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
>  		reg = 0;
>  	}
> @@ -1311,8 +1335,8 @@ static int s5p_mfc_init_decode_v6(struct
> s5p_mfc_ctx *ctx)
>  	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
>  		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
> 
> -	if (IS_MFCV7(dev))
> -		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
> +	if (IS_MFCV7(dev) || s5p_mfc_is_v6_new(dev))
> +		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
>  	else
>  		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
> 
> --
> 1.7.9.5

