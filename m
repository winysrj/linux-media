Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46085 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZCDPin (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 10:38:43 -0500
Message-ID: <49AEA071.9020900@maxwell.research.nokia.com>
Date: Wed, 04 Mar 2009 17:38:25 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	DongSoo Kim <dongsoo.kim@gmail.com>
Subject: Re: [RFC 0/9] OMAP3 ISP and camera drivers
References: <19F8576C6E063C45BE387C64729E73940427BCA193@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427BCA193@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hiremath, Vaibhav wrote:
> [Hiremath, Vaibhav] Sakari, Let me ask you basic question, have you
> tested/verified these patch-sets?

For the ISP and camera drivers, yes. That's actually the only thing 
that's contained in the patchset.

> The reason I am asking this question is, for me it was not working. I
> had to debug this and found that -
> 
> - Changes missing in devices.c file, so isp_probe function will not
> be called at all, keeping omap3isp = NULL. You will end up into
> kernel crash in omap34xxcam_device_register.

Anyway a crash shouldn't happen here. Could I see the kernel oops if 
there was such?

> - The patches from Hiroshi DOYU doesn't build as is, you need to add
> one include line #include <linux/hardirq.h> in iovmmu.c (I am using
> the patches submitted on 16th Jan 2009)

Just pull the iommu branch, the Hiroshi's original patches are missing 
some hacks that you need to use them now. I'd expect Hiroshi to update 
the patchset when he comes back.

> I have attached "git diff" output here with this mail for reference.

Please pull also the "base" branch.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
