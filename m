Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:12687 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbbDHLu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 07:50:29 -0400
Message-ID: <552513B4.4050001@cisco.com>
Date: Wed, 08 Apr 2015 13:40:36 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Hans Verkuil <hansverk@cisco.com>, kernel@pengutronix.de,
	linux-media@vger.kernel.org
Subject: Re: [RFC 00/12] TC358743 async subdev and dt support
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
Hans forwarded this patch series to me now, since I haven't received if 
for some reason. I will prioritize upstreaming of the driver the next 
couple of days and create a new RFC. I will also go through your patches 
and give you feedback!

Regards,
Mats


On 03/30/2015 01:10 PM, Philipp Zabel wrote:
> Hi Mats,
>
> did you have time to work on the TC358743 driver some more in the meanwhile?
> These are the changes I have made locally to v1 to get it to work on i.MX6.
>
> regards
> Philipp
>
> Mats Randgaard (1):
>    [media] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
>
> Philipp Zabel (11):
>    [media] tc358743: register v4l2 asynchronous subdevice
>    [media] tc358743: support probe from device tree
>    [media] tc358743: fix set_pll to enable PLL with default frequency
>    [media] tc358743: fix lane number calculation to include blanking
>    [media] tc358743: split set_csi into set_csi and start_csi
>    [media] tc358743: also set TCLK_TRAILCNT and TCLK_POSTCNT
>    [media] tc358743: parse MIPI CSI-2 endpoint, support noncontinuous
>      clock
>    [media] tc358743: add direct interrupt handling
>    [media] tc358743: detect chip by ChipID instead of IntMask
>    [media] tc358743: don't return E2BIG from G_EDID
>    [media] tc358743: allow event subscription
>
>   MAINTAINERS                        |    6 +
>   drivers/media/i2c/Kconfig          |   12 +
>   drivers/media/i2c/Makefile         |    1 +
>   drivers/media/i2c/tc358743.c       | 1979 ++++++++++++++++++++++++++++++++++++
>   drivers/media/i2c/tc358743_regs.h  |  670 ++++++++++++
>   include/media/tc358743.h           |   89 ++
>   include/uapi/linux/v4l2-controls.h |    4 +
>   7 files changed, 2761 insertions(+)
>   create mode 100644 drivers/media/i2c/tc358743.c
>   create mode 100644 drivers/media/i2c/tc358743_regs.h
>   create mode 100644 include/media/tc358743.h
>

