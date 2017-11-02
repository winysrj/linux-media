Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48131 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755175AbdKBIMt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 04:12:49 -0400
Subject: Re: [PATCH 1/2] media: s5p-mfc: check for firmware allocation
 before requesting firmware
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <5bbc048a-4b68-de23-373d-eb8a12c5b736@samsung.com>
Date: Thu, 02 Nov 2017 09:12:43 +0100
MIME-version: 1.0
In-reply-to: <e7c1ad0167ca363cc783be11871a04957127a3fa.1507325072.git.shuahkh@osg.samsung.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
        <CGME20171006213015epcas3p2c0d4741e06b2d8c25583fb656b7f5532@epcas3p2.samsung.com>
        <e7c1ad0167ca363cc783be11871a04957127a3fa.1507325072.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On 06.10.2017 23:30, Shuah Khan wrote:
> Check if firmware is allocated before requesting firmware instead of
> requesting firmware only to release it if firmware is not allocated.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index 69ef9c2..f064a0d1 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -55,6 +55,11 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
>  	 * into kernel. */
>  	mfc_debug_enter();
>  
> +	if (!dev->fw_buf.virt) {
> +		mfc_err("MFC firmware is not allocated\n");
> +		return -EINVAL;
> +	}
> +
>  	for (i = MFC_FW_MAX_VERSIONS - 1; i >= 0; i--) {
>  		if (!dev->variant->fw_name[i])
>  			continue;
> @@ -75,11 +80,6 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
>  		release_firmware(fw_blob);
>  		return -ENOMEM;
>  	}
> -	if (!dev->fw_buf.virt) {
> -		mfc_err("MFC firmware is not allocated\n");
> -		release_firmware(fw_blob);
> -		return -EINVAL;
> -	}

Is there any scenario in which dev->fw_buf.virt is null and
s5p_mfc_load_firmware is called?
I suspect this check is not necessary at all.

Regards
Andrzej

>  	memcpy(dev->fw_buf.virt, fw_blob->data, fw_blob->size);
>  	wmb();
>  	release_firmware(fw_blob);
