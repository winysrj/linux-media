Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:12486 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbEDOM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 10:12:29 -0400
Received: from [10.47.76.63] ([10.47.76.63])
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t44ECQri009991
	for <linux-media@vger.kernel.org>; Mon, 4 May 2015 14:12:26 GMT
Message-ID: <55477E4A.4090402@cisco.com>
Date: Mon, 04 May 2015 16:12:26 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [RFC 00/12] TC358743 async subdev and dt support
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de> <55477D9C.7050006@cisco.com>
In-Reply-To: <55477D9C.7050006@cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
Thank you for reviewing, testing and committing new patches to the 
driver for TC358743!

Fixed in latest version of the driver:

   * [media] tc358743: split set_csi into set_csi and start_csi
   * [media] tc358743: also set TCLK_TRAILCNT and TCLK_POSTCNT
   * [media] tc358743: don't return E2BIG from G_EDID

The code seems fine to me, but I am not able to test it:

   * [media] tc358743: add direct interrupt handling
   * [media] tc358743: allow event subscription

The rest of the patches are commented inline.

Regards,
Mats Randgaard



On 03/30/2015 01:10 PM, Philipp Zabel wrote:
> Hi Mats,
 >
 > did you have time to work on the TC358743 driver some more in the
 > meanwhile? These are the changes I have made locally to v1 to get it
 > to work on i.MX6.
 >
 > regards Philipp
 >
 > Mats Randgaard (1): [media] Driver for Toshiba TC358743 CSI-2 to
 > HDMI bridge
 >
 > Philipp Zabel (11): [media] tc358743: register v4l2 asynchronous
 > subdevice [media] tc358743: support probe from device tree [media]
 > tc358743: fix set_pll to enable PLL with default frequency [media]
 > tc358743: fix lane number calculation to include blanking [media]
 > tc358743: split set_csi into set_csi and start_csi [media] tc358743:
 > also set TCLK_TRAILCNT and TCLK_POSTCNT [media] tc358743: parse MIPI
 > CSI-2 endpoint, support noncontinuous clock [media] tc358743: add
 > direct interrupt handling [media] tc358743: detect chip by ChipID
 > instead of IntMask [media] tc358743: don't return E2BIG from G_EDID
 > [media] tc358743: allow event subscription
 >
 > MAINTAINERS                        |    6 +
 > drivers/media/i2c/Kconfig |   12 + drivers/media/i2c/Makefile
 > |    1 + drivers/media/i2c/tc358743.c       | 1979
 > ++++++++++++++++++++++++++++++++++++
 > drivers/media/i2c/tc358743_regs.h  |  670 ++++++++++++
 > include/media/tc358743.h           |   89 ++
 > include/uapi/linux/v4l2-controls.h |    4 + 7 files changed, 2761
 > insertions(+) create mode 100644 drivers/media/i2c/tc358743.c create
 > mode 100644 drivers/media/i2c/tc358743_regs.h create mode 100644
 > include/media/tc358743.h
 >
