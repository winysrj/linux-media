Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55752 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0JOMRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 08:17:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 ISP driver segfaults
Date: Fri, 15 Oct 2010 14:17:37 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTikq8pmOpGn1N4xbiB2nmsNzrC4wzcD0_HUJpZ1J@mail.gmail.com>
In-Reply-To: <AANLkTikq8pmOpGn1N4xbiB2nmsNzrC4wzcD0_HUJpZ1J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151417.38508.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Friday 15 October 2010 13:59:24 Bastian Hecht wrote:
> Hello ISP driver developers,
> 
> after the lastest pull of branch 'devel' of
> git://gitorious.org/maemo-multimedia/omap3isp-rx51 I get a segfault
> when I register my ISP_device.
> The segfault happens in isp.c in line
>      isp->iommu = iommu_get("isp");
> 
> I noticed that with the new kernel the module iommu is loaded
> automatically after booting while it wasn't in before my pull (my old
> pull is about 3 days old).
> Tell me what kind of further info you need. Btw, I run an Igepv2.

Can you make sure that both the omap-iommu and iommu2 modules are loaded 
before omap3-isp.ko ?

-- 
Regards,

Laurent Pinchart
