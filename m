Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CVNgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 09:36:06 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Mon, 22 Mar 2010 08:36:00 -0500
Subject: RE: omap2 camera
Message-ID: <A24693684029E5489D1D202277BE89445428BE8E@dlee02.ent.ti.com>
References: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com>
In-Reply-To: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Viral,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Viral Mehta
> Sent: Monday, March 22, 2010 5:20 AM
> To: linux-media@vger.kernel.org
> Subject: omap2 camera
> 
> Hi list,
> 
> I am using OMAP2430 board and I wanted to test camera module on that
> board.
> I am using latest 2.6.33 kernel. However, it looks like camera module is
> not supported with latest kernel.
> 
> Anyone is having any idea? Also, do we require to have ex3691 sensor
> driver in mainline kernel in order to get omap24xxcam working ?
> 
> These are the steps I followed,
> 1. make omap2430_sdp_defconfig
> 2. Enable omap2 camera option which is under drivers/media/video
> 3. make uImage
> 
> And with this uImage, camera is not working. I would appreciate any help.

I'm adding Sakari Ailus to the CC list, which is the owner of the driver.

Regards,
Sergio

> 
> Thanks,
> Viral
> 
> This Email may contain confidential or privileged information for the
> intended recipient (s) If you are not the intended recipient, please do
> not use or disseminate the information, notify the sender and delete it
> from your system.
> 
> ______________________________________________________________________
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
