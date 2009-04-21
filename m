Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:37473 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZDUNs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 09:48:58 -0400
Message-ID: <49EDCE9F.2030700@maxwell.research.nokia.com>
Date: Tue, 21 Apr 2009 16:48:15 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Weng, Wending" <WWeng@rheinmetall.ca>
CC: linux-media@vger.kernel.org,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: need help for omap3 isp-camera interface
References: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
In-Reply-To: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Weng, Wending wrote:
> Hi All,
> 
> I'm working on video image capture(omap3 isp) interface(PSP 1.0.2),
> and have met many difficulties. At the camera side, the 8 bits BT656
> signal are connected to cam_d[0-7], which looks OK. The cam_fld,
> cam_hs and cam_vs are also connected, At the omap3 side, I use
> saMmapLoopback.c, it runs, however, it receives only HS_VS_IRQ, but
> no any image data. I checked FLDSTAT(CCDC_SYN_MODE), it's never
> changed. Right now, I don't know what to check, if you can give some
> suggestions, your help will be greatly appreciated. Thanks in
> advance.

I haven't been using the parallel interface nor I know anyone else who 
would have. Sergio, any idea?

Anyway, this sounds like a problem in the parallel receiver side. You 
could try also configuring the VD1 IRQ to happen much earlier, say on 
10th line. See ISPCCDC_VDINT handling in ispccdc.c.

I'm going to update the patchset as soon as I get linux-omap booting again.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
