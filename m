Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51601 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0CQUXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 16:23:51 -0400
Message-ID: <4BA13A4F.8070808@maxwell.research.nokia.com>
Date: Wed, 17 Mar 2010 22:23:43 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3camera] Camera bring-up on Zoom3 (OMAP3630)
References: <A24693684029E5489D1D202277BE894453CC5C3F@dlee02.ent.ti.com> <201003162330.17454.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894454137054@dlee02.ent.ti.com> <201003171514.27538.laurent.pinchart@ideasonboard.com> <4BA0E434.1040402@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE8944541370C5@dlee02.ent.ti.com> <4BA0EE24.7030309@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE894454137189@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894454137189@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
>> What exactly does not work?
> 
> Ok, let me explain:
> 
> In my boardfile, I have:
> 
> static struct omap34xxcam_platform_data zoom_camera_pdata = {
> 	.isp			= &omap3isp_device,
> 	.subdevs[0] = zoom_camera_primary_subdevs,
> 	.sensors[0] = {
> 		.capture_mem = IMX046_BIGGEST_FRAME_BYTE_SIZE * 2,
> 		.ival_default	= { 1, 10 },
> 	},
> };
> 
> As I only have 1 sensor.
> 
> However, when omap34xxcam_probe runs, it loops through pdata->subdevs[i], in which 'i' goes from 0 to OMAP34XXCAM_VIDEODEVS - 1.
> 
> And this is what generates an "oops" message in the driver.

Ok, now I get it. Thanks. :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
