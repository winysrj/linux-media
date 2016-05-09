Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:7295 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750907AbcEIJAZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 05:00:25 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>
Subject: V4L2 SDR compliance test?
Date: Mon, 9 May 2016 09:00:20 +0000
Message-ID: <SG2PR06MB1038A920EEE2D8ED6E239FB4C3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maintainers, All,

Renesas R-Car SoCs have Digital Radio Interface (DRIF) controllers. They are 
receive only SPI slave modules that support I2S format. The targeted
application of these controllers is SDR.

While evaluating the V4L2 SDR framework for this controller, we noticed the 
compliance test demands TUNER ioctls for SDR device. As a SoC controller,
DRIF is independent of tuner functionality as a third party provides this
device. The DRIF driver will support V4L2_CID_xxx & V4L2_SDR_FMT_xxx ioctls
but not the tuner ioctls.

Two possible cases:
-------------------
1) Third party tuner driver
	- The framework does provide support to register tuner as a subdev
and can be bound to the SDR device using notifier callbacks

2) User space Tuner app 
	- We also have cases where the tuner s/w logic can be a vendor
supplied user space application or library that talks to the chip using generic
system calls - like i2c read/writes.

The DRIF driver code as such will have v4l2_async_notifier_register only to be
informed if a tuner device attaches. But this may or may not happen
depending on the target board.

>From upstream V4L2 SDR driver perspective, these DRIF patches will FAIL
V4L2 compliance tests (a criteria needed to submit fresh driver patches).

Questions are 
1) Is this approach acceptable to the maintainers?
2) Should the SDR compliance tests be updated for these evolving use cases?
------------------

Thanks,
Ramesh
