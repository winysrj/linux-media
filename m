Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46278 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbcDYHlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 03:41:07 -0400
Subject: Re: [PATCH v7 2/8] [media] VPU: mediatek: support Mediatek VPU
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1461299131-57851-1-git-send-email-tiffany.lin@mediatek.com>
 <1461299131-57851-2-git-send-email-tiffany.lin@mediatek.com>
 <1461299131-57851-3-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571DCA04.8000703@xs4all.nl>
Date: Mon, 25 Apr 2016 09:40:52 +0200
MIME-Version: 1.0
In-Reply-To: <1461299131-57851-3-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2016 06:25 AM, Tiffany Lin wrote:
> From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> 
> The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
> It is able to handle video decoding/encoding of in a range of formats.
> The driver provides with VPU firmware download, memory management and
> the communication interface between CPU and VPU.
> For VPU initialization, it will create virtual memory for CPU access and
> IOMMU address for vcodec hw device access. When a decode/encode instance
> opens a device node, vpu driver will download vpu firmware to the device.
> A decode/encode instant will decode/encode a frame using VPU
> interface to interrupt vpu to handle decoding/encoding jobs.
> 
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> 
> ---
>  drivers/media/platform/Kconfig           |   13 +
>  drivers/media/platform/Makefile          |    2 +
>  drivers/media/platform/mtk-vpu/Makefile  |    3 +
>  drivers/media/platform/mtk-vpu/mtk_vpu.c |  950 ++++++++++++++++++++++++++++++
>  drivers/media/platform/mtk-vpu/mtk_vpu.h |  162 +++++
>  5 files changed, 1130 insertions(+)
>  create mode 100644 drivers/media/platform/mtk-vpu/Makefile
>  create mode 100755 drivers/media/platform/mtk-vpu/mtk_vpu.c
>  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
> 


> +int vpu_load_firmware(struct platform_device *pdev)
> +{
> +	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
> +	struct device *dev = &pdev->dev;
> +	struct vpu_run *run = &vpu->run;
> +	const struct firmware *vpu_fw;
> +	int ret;
> +
> +	if (!pdev) {
> +		dev_err(dev, "VPU platform device is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = vpu_clock_enable(vpu);
> +	if (ret) {
> +		dev_err(dev, "enable clock failed %d\n", ret);
> +		return ret;
> +	}
> +
> +	mutex_lock(&vpu->vpu_mutex);
> +
> +	if (vpu_running(vpu)) {
> +		mutex_unlock(&vpu->vpu_mutex);
> +		vpu_clock_disable(vpu);
> +		dev_warn(dev, "vpu is running already\n");

This warning should be dropped. Currently vpu_load_firmware is called
every time the video device is opened and no one else has the video device
open. So calling this multiple times is perfectly normal and the log shouldn't
be spammed with warnings.

I would recommend adding a fw_loaded bool to struct mtk_vpu and just
check that at the beginning of this function and just return 0 if it is true.

Then you don't need to enable the vpu clock either.

I hope I understand the hw correctly, though.

Assuming you can do this, then this code from the v4l driver needs an
additional comment:

>>> +	if (v4l2_fh_is_singular(&ctx->fh)) {

Add a comment here that says that vpu_load_firmware checks if it was
loaded already and does nothing in that case.

>>> +		ret = vpu_load_firmware(dev->vpu_plat_dev);
>>> +		if (ret < 0) {
>>> +			/*
>>> +			  * Return 0 if downloading firmware successfully,
>>> +			  * otherwise it is failed
>>> +			  */
>>> +			mtk_v4l2_err("vpu_load_firmware failed!");
>>> +			goto err_load_fw;
>>> +		}

That makes it clear to the reader (i.e. me :-) ) that you can safely call
vpu_load_firmware multiple times.

Regards,

	Hans

> +		return 0;
> +	}
> +
> +	run->signaled = false;
> +	dev_dbg(vpu->dev, "firmware request\n");
> +	/* Downloading program firmware to device*/
> +	ret = load_requested_vpu(vpu, vpu_fw, P_FW);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to request %s, %d\n", VPU_P_FW, ret);
> +		goto OUT_LOAD_FW;
> +	}
> +
> +	/* Downloading data firmware to device */
> +	ret = load_requested_vpu(vpu, vpu_fw, D_FW);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to request %s, %d\n", VPU_D_FW, ret);
> +		goto OUT_LOAD_FW;
> +	}
> +
> +	/* boot up vpu */
> +	vpu_cfg_writel(vpu, 0x1, VPU_RESET);
> +
> +	ret = wait_event_interruptible_timeout(run->wq,
> +					       run->signaled,
> +					       msecs_to_jiffies(INIT_TIMEOUT_MS)
> +					       );
> +	if (ret == 0) {
> +		ret = -ETIME;
> +		dev_err(dev, "wait vpu initialization timout!\n");
> +		goto OUT_LOAD_FW;
> +	} else if (-ERESTARTSYS == ret) {
> +		dev_err(dev, "wait vpu interrupted by a signal!\n");
> +		goto OUT_LOAD_FW;
> +	}
> +
> +	ret = 0;
> +	dev_info(dev, "vpu is ready. Fw version %s\n", run->fw_ver);
> +
> +OUT_LOAD_FW:
> +	mutex_unlock(&vpu->vpu_mutex);
> +	vpu_clock_disable(vpu);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vpu_load_firmware);

