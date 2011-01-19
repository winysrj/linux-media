Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:57786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1ASQU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 11:20:27 -0500
Date: Wed, 19 Jan 2011 17:20:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How to support MIPI CSI-2 controller in soc-camera framework?
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF5AF@SC-VEXCH2.marvell.com>
Message-ID: <Pine.LNX.4.64.1101191701430.620@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101181811590.19950@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF54D@SC-VEXCH2.marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF5AF@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(a general request: could you please configure your mailer to wrap lines 
at somewhere around 70 characters?)

On Tue, 18 Jan 2011, Qing Xu wrote:

> Hi,
> 
> Our chip support both MIPI and parallel interface. The HW connection logic is
> sensor(such as ov5642) -> our MIPI controller(handle DPHY timing/ CSI-2 
> things) -> our camera controller (handle DMA transmitting/ fmt/ size 
> things). Now, I find the driver of sh_mobile_csi2.c, it seems like a 
> CSI-2 driver, but I don't quite understand how it works:
> 1) how the host controller call into this driver?

This is a normal v4l2-subdev driver. Platform data for the 
sh_mobile_ceu_camera driver provides a link to CSI2 driver data, then the 
host driver loads the CSI2 driver, which then links itself into the 
subdevice list. Look at arch/arm/mach-shmobile/board-ap4evb.c how the data 
is linked:

static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
	.csi2_dev = &csi2_device.dev,
};

and in the hosz driver drivers/media/video/sh_mobile_ceu_camera.c look in 
the sh_mobile_ceu_probe function below the lines:

	csi2 = pcdev->pdata->csi2_dev;
	if (csi2) {
...


> 2) how the host controller/sensor negotiate MIPI variable with this 
> driver, such as D-PHY timing(hs_settle/hs_termen/clk_settle/clk_termen), 
> number of lanes...?

Since I only had a limited number of MIPI setups, I haven't implemented 
maximum flexibility. A part of the parameters is hard-coded, another part 
is provided in the platform driver, yet another part is calculated 
dynamically.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
