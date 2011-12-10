Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42106 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1LJJNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 04:13:00 -0500
Message-ID: <4EE32299.5000006@iki.fi>
Date: Sat, 10 Dec 2011 11:12:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Alex Gershgorin <alexg@meprolight.com>
CC: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OMAP3ISP boot problem
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8989923C@MEP-EXCH.meprolight.com> <4875438356E7CA4A8F2145FCD3E61C0B2C89899243@MEP-EXCH.meprolight.com>,<4EE3170B.7000807@iki.fi> <4875438356E7CA4A8F2145FCD3E61C0B2C89899244@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2C89899244@MEP-EXCH.meprolight.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alex Gershgorin wrote:
> Hi Sakari,
>
> Thank you for your quick response and sorry for stupid question.
> Yes CONFIG_OMAP_IOMMU and CONFIG_OMAP_IOVMM enabled,
> because OMAP 3 camera controller depends on the CONFIG_OMAP_IOVMM  and CONFIG_OMAP_IOMMU.
> Please tell me how I can use dmabuf instead of the IOMMU/IOVMM API.

Unfortunately that real fix isn't available yet and won't be for some 
time. Still, it should be fully functional currently.

Looking at the backtrace again, it seems to crash in 
driver_find_device(). That looks fishy.

Do you have the ISP driver compiled into the kernel? I might try it as a 
module, albeit it of course should work when it's linked to the kernel 
as well.

-- 
Sakari Ailus
sakari.ailus@iki.fi
