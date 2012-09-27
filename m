Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48682 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752320Ab2I0UIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 16:08:12 -0400
Message-ID: <5064B229.7010707@iki.fi>
Date: Thu, 27 Sep 2012 23:08:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: paul@pwsan.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/2] omap3: Provide means for changing CSI2 PHY configuration
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk> <1348696236-3470-1-git-send-email-sakari.ailus@iki.fi> <2067951.ZTSQvUdPug@avalon>
In-Reply-To: <2067951.ZTSQvUdPug@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thanks for the patch.
>
> On Thursday 27 September 2012 00:50:35 Sakari Ailus wrote:
>> The OMAP 3630 has configuration how the ISP CSI-2 PHY pins are connected to
>> the actual CSI-2 receivers outside the ISP itself. Allow changing this
>> configuration from the ISP driver.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>
> Just one small comment below, otherwise
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
>> ---
>>   arch/arm/mach-omap2/control.c              |   86 +++++++++++++++++++++++++
>>   arch/arm/mach-omap2/control.h              |   15 +++++
>>   arch/arm/mach-omap2/include/mach/control.h |   13 ++++
>>   3 files changed, 114 insertions(+), 0 deletions(-)
>>   create mode 100644 arch/arm/mach-omap2/include/mach/control.h
>>
>> diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
>> index 3223b81..11bb900 100644
>> --- a/arch/arm/mach-omap2/control.c
>> +++ b/arch/arm/mach-omap2/control.c
...
>> +	cam_phy_ctrl |= mode << shift;
>> +
>> +	omap_ctrl_writel(cam_phy_ctrl,
>> +			 OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>
> This can fit on one line.

I'll fix that for the next version. I noticed there were a few too long 
lines, too; I've broken them up where it makes sense, and removed a 
useless break statement.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
