Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48914 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbeEQPuF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 11:50:05 -0400
Date: Thu, 17 May 2018 09:50:01 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com
Subject: Re: [PATCH 1/4] soc: qcom: mdt_loader: Add check to make scm calls
Message-ID: <20180517155000.GH4995@jcrouse-lnx.qualcomm.com>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-2-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526556740-25494-2-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 05:02:17PM +0530, Vikash Garodia wrote:
> In order to invoke scm calls, ensure that the platform
> has the required support to invoke the scm calls in
> secure world.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/soc/qcom/mdt_loader.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
> index 17b314d..db55d53 100644
> --- a/drivers/soc/qcom/mdt_loader.c
> +++ b/drivers/soc/qcom/mdt_loader.c
> @@ -121,10 +121,12 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
>  	if (!fw_name)
>  		return -ENOMEM;
>  
> -	ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
> -	if (ret) {
> -		dev_err(dev, "invalid firmware metadata\n");
> -		goto out;
> +	if (qcom_scm_is_available()) {
> +		ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
> +		if (ret) {
> +			dev_err(dev, "invalid firmware metadata\n");
> +			goto out;
> +		}
>  	}
>
>  	for (i = 0; i < ehdr->e_phnum; i++) {
> @@ -144,10 +146,13 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
>  	}
>  
>  	if (relocate) {
> -		ret = qcom_scm_pas_mem_setup(pas_id, mem_phys, max_addr - min_addr);
> -		if (ret) {
> -			dev_err(dev, "unable to setup relocation\n");
> -			goto out;
> +		if (qcom_scm_is_available()) {
> +			ret = qcom_scm_pas_mem_setup(pas_id, mem_phys,
> +							max_addr - min_addr);
> +			if (ret) {
> +				dev_err(dev, "unable to setup relocation\n");
> +				goto out;
> +			}
>  		}
>  

As far as I can tell you can make it all the way through the function with
'ret' uninitialized if qcom_scm_is_available() returns false which is a bug, but
I'm confused why you would even bother loading the firmware even if you didn't
have SCM.

Jordan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
