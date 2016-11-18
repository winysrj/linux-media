Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:38518 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbcKRJuC (ORCPT
        <rfc822;groupwise-linux-media@vger.kernel.org:0:0>);
        Fri, 18 Nov 2016 04:50:02 -0500
Subject: Re: [PATCH] [media] VPU: mediatek: fix dereference of pdev before
 checking it is null
To: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20161116191650.11486-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Matthias Brugger <mbrugger@suse.com>
Message-ID: <981854b7-78fc-567b-1b35-2cbf8d2b5008@suse.com>
Date: Fri, 18 Nov 2016 10:49:55 +0100
MIME-Version: 1.0
In-Reply-To: <20161116191650.11486-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 16/11/16 20:16, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> pdev is dereferenced using platform_get_drvdata before a check to
> see if it is null, hence there could be a potential null pointer
> dereference issue. Instead, first check if pdev is null and only then
> deference pdev when initializing vpu.
>
> Found with static analysis by CoverityScan, CID 1357797
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Matthias Brugger <mbrugger@suse.com>

>  drivers/media/platform/mtk-vpu/mtk_vpu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> index c9bf58c..41f31b2 100644
> --- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
> +++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> @@ -523,9 +523,9 @@ static int load_requested_vpu(struct mtk_vpu *vpu,
>
>  int vpu_load_firmware(struct platform_device *pdev)
>  {
> -	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
> +	struct mtk_vpu *vpu;
>  	struct device *dev = &pdev->dev;
> -	struct vpu_run *run = &vpu->run;
> +	struct vpu_run *run;
>  	const struct firmware *vpu_fw = NULL;
>  	int ret;
>
> @@ -533,6 +533,8 @@ int vpu_load_firmware(struct platform_device *pdev)
>  		dev_err(dev, "VPU platform device is invalid\n");
>  		return -EINVAL;
>  	}
> +	vpu = platform_get_drvdata(pdev);
> +	run = &vpu->run;
>
>  	mutex_lock(&vpu->vpu_mutex);
>  	if (vpu->fw_loaded) {
>
