Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18899 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaIOOmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 10:42:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBY006AY6C38O50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:45:39 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kiran AVND' <avnd.kiran@samsung.com>, linux-media@vger.kernel.org
Cc: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
 <1410763393-12183-11-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-11-git-send-email-avnd.kiran@samsung.com>
Subject: RE: [PATCH 10/17] [media] s5p-mfc: modify mfc wakeup sequence for V8
Date: Mon, 15 Sep 2014 16:42:47 +0200
Message-id: <022d01cfd0f3$519eb6a0$f4dc23e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kiran,

> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
> Sent: Monday, September 15, 2014 8:43 AM
> 
> From: Arun Mankuzhi <arun.m@samsung.com>
> 
> From MFC V8, the MFC wakeup sequence has changed.
> MFC wakeup command has to be sent after the host receives firmware load
> complete status from risc.
> 
> Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   78
> +++++++++++++++++++-----
>  1 files changed, 61 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index 24d5252..8531c72 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -352,6 +352,58 @@ int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
>  	return ret;
>  }
> 
> +static int s5p_mfc_v8_wait_wakeup(struct s5p_mfc_dev *dev) {
> +	int ret;
> +
> +	/* Release reset signal to the RISC */
> +	dev->risc_on = 1;
> +	mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
> +
> +	if (s5p_mfc_wait_for_done_dev(dev,
> S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
> +		mfc_err("Failed to reset MFCV8\n");
> +		return -EIO;
> +	}
> +	mfc_debug(2, "Write command to wakeup MFCV8\n");
> +	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
> +	if (ret) {
> +		mfc_err("Failed to send command to MFCV8 - timeout\n");
> +		return ret;
> +	}
> +
> +	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
> +		mfc_err("Failed to wakeup MFC\n");
> +		return -EIO;
> +	}
> +	return ret;
> +}
> +
> +static int s5p_mfc_wait_wakeup(struct s5p_mfc_dev *dev) {
> +	int ret;
> +
> +	/* Send MFC wakeup command */
> +	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
> +	if (ret) {
> +		mfc_err("Failed to send command to MFC - timeout\n");
> +		return ret;
> +	}
> +
> +	/* Release reset signal to the RISC */
> +	if (IS_MFCV6_PLUS(dev)) {
> +		dev->risc_on = 1;
> +		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
> +	} else {
> +		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
> +	}
> +
> +	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
> +		mfc_err("Failed to wakeup MFC\n");
> +		return -EIO;
> +	}
> +	return ret;
> +}
> +
>  int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)  {
>  	int ret;
> @@ -364,6 +416,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
>  	ret = s5p_mfc_reset(dev);
>  	if (ret) {
>  		mfc_err("Failed to reset MFC - timeout\n");
> +		s5p_mfc_clock_off();
>  		return ret;
>  	}
>  	mfc_debug(2, "Done MFC reset..\n");
> @@ -372,25 +425,16 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
>  	/* 2. Initialize registers of channel I/F */
>  	s5p_mfc_clear_cmds(dev);
>  	s5p_mfc_clean_dev_int_flags(dev);
> -	/* 3. Initialize firmware */
> -	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
> -	if (ret) {
> -		mfc_err("Failed to send command to MFC - timeout\n");
> -		return ret;
> -	}
> -	/* 4. Release reset signal to the RISC */
> -	if (IS_MFCV6_PLUS(dev)) {
> -		dev->risc_on = 1;
> -		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
> -	}
> +	/* 3. Send MFC wakeup command and wait for completion*/
> +	if (IS_MFCV8(dev))
> +		ret = s5p_mfc_v8_wait_wakeup(dev);
>  	else
> -		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);

I think that this solution is messy. There are two functions - one
for v8, another for other versions. In the latter there are if conditions
that further change its behaviour accordingly to the version.

I think there are two possible solutions:
- introduce one function per version
- use one function with if statements to change its behaviour for various
  MFC versions

The former will introduce repeated code, hence I suggest the latter
solution.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> -	mfc_debug(2, "Ok, now will write a command to wakeup the
> system\n");
> -	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
> -		mfc_err("Failed to load firmware\n");
> -		return -EIO;
> -	}
> +		ret = s5p_mfc_wait_wakeup(dev);
> +
>  	s5p_mfc_clock_off();
> +	if (ret)
> +		return ret;
> +
>  	dev->int_cond = 0;
>  	if (dev->int_err != 0 || dev->int_type !=
>  						S5P_MFC_R2H_CMD_WAKEUP_RET)
{
> --
> 1.7.3.rc2

