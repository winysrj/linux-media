Return-path: <mchehab@pedra>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48036 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752780Ab1ASGcV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 01:32:21 -0500
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 18 Jan 2011 22:32:16 -0800
Subject: How to support MIPI CSI-2 controller in soc-camera framework?
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF5AF@SC-VEXCH2.marvell.com>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101171826340.16051@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2EF@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101181811590.19950@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF54D@SC-VEXCH2.marvell.com>
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF54D@SC-VEXCH2.marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Our chip support both MIPI and parallel interface. The HW connection logic is
sensor(such as ov5642) -> our MIPI controller(handle DPHY timing/ CSI-2 things) -> our camera controller (handle DMA transmitting/ fmt/ size things). Now, I find the driver of sh_mobile_csi2.c, it seems like a CSI-2 driver, but I don't quite understand how it works:
1) how the host controller call into this driver?
2) how the host controller/sensor negotiate MIPI variable with this driver, such as D-PHY timing(hs_settle/hs_termen/clk_settle/clk_termen), number of lanes...?

Thanks a lot!
Qing Xu

Email: qingx@marvell.com
Application Processor Systems Engineering,
Marvell Technology Group Ltd.
