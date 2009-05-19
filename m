Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36328 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZESQ4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:56:23 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 19 May 2009 11:55:52 -0500
Subject: MT9T031 and other similar sub devices...
Message-ID: <A69FA2915331DC488A831521EAE36FE401353CD3D6@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi Liakhovetski,

Thanks for your effort to migrate the sensor drivers to sub device framework.

We have interest in mt9t031 and other sensor drivers from Micron since this peripheral is used in our DM355/DM6446 EVMs as well. I have submitted a set of patches for our vpfe_capture driver to the media mailing list for review. This driver runs on DM355/DM6446 EVMs and is developed to use the sub device model to integrate with capture peripheral like TVP5146, MT9T001, MT9T031 etc. If you have a version of mt9t031 driver migrated to sub device, I would like to integrate that with our vpfe_capture driver.

I want to check following with you so as to be on the same page.

1) I see that the mt9t001.c still uses struct soc_camera_device and calls soc_camera_video_start() to start the master. This introduces a reverse dependency from the sub device to bridge driver (correct me if I my understanding is wrong). I guess you plan to remove this dependency in your future patch. With this in the driver, it can't work with our driver since we don't have soc_camera_device. 

2) vpfe_capture driver support raw bayer interface as well as raw yuv interface. Raw bayer interface can be 8-16 bits wide along with HD/VD/field lines. So in order for the bridge driver to configure the interface, it needs to know parameters like interface type (BT.656, BT.1120, Raw image data (8-16) etc), polarity of HD, VD, PCLK, field signals etc. Is there a infrastructure for handling this ? I mean, we should have a way of defining this per platform, which some how can be read by bridge driver to configure the interface to work with a specific sub device.

Regards,

Murali Karicheri
   


