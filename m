Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46175
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbcGHRLa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 13:11:30 -0400
Subject: Re: [PATCH] media: Doc s5p-mfc add missing fields to s5p_mfc_dev
 structure definition
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org
References: <1467987120-5167-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <dc642c89-736c-67c0-b5aa-8062ca5c83d2@osg.samsung.com>
Date: Fri, 8 Jul 2016 13:11:18 -0400
MIME-Version: 1.0
In-Reply-To: <1467987120-5167-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On 07/08/2016 10:12 AM, Shuah Khan wrote:
> Add missing documentation for s5p_mfc_dev structure definition.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 9eb2481..1d06d6a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -291,7 +291,9 @@ struct s5p_mfc_priv_buf {
>   * @warn_start:		hardware error code from which warnings start
>   * @mfc_ops:		ops structure holding HW operation function pointers
>   * @mfc_cmds:		cmd structure holding HW commands function pointers
> + * @mfc_regs:		structure holding MFC registers
>   * @fw_ver:		loaded firmware sub-version
> + * risc_on:		flag indicates RISC is on or off
>   *
>   */
>  struct s5p_mfc_dev {
> 

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
