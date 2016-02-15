Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:20352 "EHLO
	mailgw02.hq.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632AbcBOLUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 06:20:21 -0500
Message-ID: <1455535214.27088.2.camel@mtksdaap41>
Subject: Re: [PATCH v4 2/8] [media] VPU: mediatek: support Mediatek VPU
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Date: Mon, 15 Feb 2016 19:20:14 +0800
In-Reply-To: <56C1A36D.6010908@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <56C1A36D.6010908@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-02-15 at 11:07 +0100, Hans Verkuil wrote:
> Hi Tiffany,
> 
> A small review comment below:
> 
> On 02/04/2016 12:34 PM, Tiffany Lin wrote:
> > The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
> > It is able to handle video decoding/encoding of in a range of formats.
> > The driver provides with VPU firmware download, memory management and
> > the communication interface between CPU and VPU.
> > For VPU initialization, it will create virtual memory for CPU access and
> > IOMMU address for vcodec hw device access. When a decode/encode instance
> > opens a device node, vpu driver will download vpu firmware to the device.
> > A decode/encode instant will decode/encode a frame using VPU
> > interface to interrupt vpu to handle decoding/encoding jobs.
> > 
> > Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  drivers/media/platform/Kconfig           |    9 +
> >  drivers/media/platform/Makefile          |    2 +
> >  drivers/media/platform/mtk-vpu/Makefile  |    1 +
> >  drivers/media/platform/mtk-vpu/mtk_vpu.c |  994 ++++++++++++++++++++++++++++++
> >  drivers/media/platform/mtk-vpu/mtk_vpu.h |  167 +++++
> >  5 files changed, 1173 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-vpu/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
> > 
> 
> <snip>
> 
> > diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> > new file mode 100644
> > index 0000000..f54fd89
> > --- /dev/null
> > +++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> > @@ -0,0 +1,994 @@
> 
> <snip>
> 
> > +static ssize_t vpu_debug_read(struct file *file, char __user *user_buf,
> > +			      size_t count, loff_t *ppos)
> > +{
> > +	char buf[256];
> > +	unsigned int len;
> > +	unsigned int running, pc, vpu_to_host, host_to_vpu, wdt;
> > +	int ret;
> > +	struct device *dev = file->private_data;
> > +	struct mtk_vpu *vpu = dev_get_drvdata(dev);
> > +
> > +	ret = vpu_clock_enable(vpu);
> > +	if (ret) {
> > +		dev_err(vpu->dev, "[VPU] enable clock failed %d\n", ret);
> > +		return 0;
> > +	}
> > +
> > +	/* vpu register status */
> > +	running = vpu_running(vpu);
> > +	pc = vpu_cfg_readl(vpu, VPU_PC_REG);
> > +	wdt = vpu_cfg_readl(vpu, VPU_WDT_REG);
> > +	host_to_vpu = vpu_cfg_readl(vpu, HOST_TO_VPU);
> > +	vpu_to_host = vpu_cfg_readl(vpu, VPU_TO_HOST);
> > +	vpu_clock_disable(vpu);
> > +
> > +	if (running) {
> > +		len = sprintf(buf, "VPU is running\n\n"
> 
> Please use snprintf.
> 
Got it, we will fix this in next version.

> > +		"FW Version: %s\n"
> > +		"PC: 0x%x\n"
> > +		"WDT: 0x%x\n"
> > +		"Host to VPU: 0x%x\n"
> > +		"VPU to Host: 0x%x\n",
> > +		vpu->run.fw_ver, pc, wdt,
> > +		host_to_vpu, vpu_to_host);
> > +	} else {
> > +		len = sprintf(buf, "VPU not running\n");
> 
> Ditto.
> 
> sprintf always makes me feel uncomfortable :-)
> 
Sorry about that, we will check patch series and remove all sprintf in
next version.

> > +	}
> > +
> > +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> > +}
> 
> Regards,
> 
> 	Hans
> 


