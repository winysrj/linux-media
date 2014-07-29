Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:1967
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753846AbaG2PbJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 11:31:09 -0400
Date: Tue, 29 Jul 2014 23:30:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Robert Schwebel <r.schwebel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	"Hans Verkuil" <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	<kernel@pengutronix.de>
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for
 CODA960
Message-ID: <20140729153050.GE6827@dragon>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
 <20140721160128.27eb7428.m.chehab@samsung.com>
 <20140721191944.GK13730@pengutronix.de>
 <1406033433.4496.16.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406033433.4496.16.camel@paszta.hi.pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Jul 22, 2014 at 02:50:33PM +0200, Philipp Zabel wrote:
> The firmware-imx packages referenced in the Freescale meta-fsl-arm
> repository on github.com contain VPU firmware files. Their use is
> restricted by an EULA. For example:
> http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.0.35-4.0.0.bin
> 
> This contains the files vpu_fw_imx6q.bin and vpu_fw_imx6d.bin, which can
> be converted into v4l-coda960-imx6q.bin and v4l-coda960-imx6dl.bin,
> respectively, by dropping the headers and reordering the rest.
> I described this for i.MX53 earlier here:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html

I followed the step to generate the firmware v4l-coda960-imx6q, and
tested it on next-20140725 with patch 'ARM: dts: imx6qdl: Enable CODA960
VPU' applied on top of it.  But I got the error of 'Wrong firmwarel' as
below.

[    2.582837] coda 2040000.vpu: requesting firmware 'v4l-coda960-imx6q.bin' for CODA960
[    2.593344] coda 2040000.vpu: Firmware code revision: 0
[    2.598649] coda 2040000.vpu: Wrong firmware. Hw: CODA960, Fw: (0x0000), Version: 0.0.0

What am I missing here?

Shawn
