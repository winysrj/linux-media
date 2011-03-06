Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37106 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1CFR3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 12:29:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [RFC] davinci: vpfe: mdia controller implementation for capture
Date: Sun, 6 Mar 2011 18:29:40 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299425765-14004-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1299425765-14004-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061829.40535.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

On Sunday 06 March 2011 16:36:05 Manjunath Hadli wrote:
> Introduction
> ------------
> This is the proposal of the initial version of design and implementation 
> of the Davinci family (dm644x,dm355,dm365)VPFE (Video Port Front End)
> drivers using Media Controloler , the initial version which supports
> the following:
> 1) dm365 vpfe
> 2) ccdc,previewer,resizer,h3a,af blocks
> 3) supports only continuous mode and not on-the-fly
> 4) supports user pointer exchange and memory mapped modes for buffer
> allocation
> 
> This driver bases its design on Laurent Pinchart's Media Controller Design
> whose patches for Media Controller and subdev enhancements form the base.
> The driver also takes copious elements taken from Laurent Pinchart and
> others' OMAP ISP driver based on Media Controller. So thank you all the
> people who are responsible for the Media Controller and the OMAP ISP
> driver.

You're welcome :-)

> Also, the core functionality of the driver comes from the arago vpfe
> capture driver of which the CCDC capture was based on V4L2, with other
> drivers like Previwer, Resizer and other being individual character
> drivers.

The CCDC, preview and resizer modules look very similar to their OMAP3 
counterparts. I think we should aim at sharing code between the drivers. It's 
hard enough to develop, review and maintain one driver, let's not duplicate 
the effort.

> The current driver caters to dm6446,dm355 and dm365 of which the current
> implementation works for dm365. The three VPFE IPs have some common
> elements in terms of some highe level functionality but there are
> differences in terms of register definitions and some core blocks.
> 
> The individual specifications for each of these can be found here:
> dm6446 vpfe: http://www.ti.com/litv/pdf/sprue38h
> dm355  vpfe: http://www.ti.com/litv/pdf/spruf71a
> dm365  vpfe: http://www.ti.com/litv/pdf/sprufg8c
> 
> The initial version of the  driver implementation can be found here:
> 
> http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h=refs
> /heads/mc_release
> 
> Driver Design: Main entities
> ----------------------------
> The hardware modules for dm355,dm365 are mainly ipipe, ipipeif,isif. These
> hardware modules are generically exposed to the user level in the for of
> dm6446 style modules. Mainly -
> ccdc, previewer, resizer in addition to the other histogram and
> auto color/white balance correction and auto focus modules.
> 
> 1)MT9P031 sensor  module for RAW capture
> 2)TVP7002 decoder module for HD inputs
> 3)TVP514x decoder module for SD inputs
> 4)CCDC capture module
> 5)Previewer Module for Bayer to YUV conversion
> 6)Resizer Module for scaling
> 
> 
> Connection for on-the-fly capture
> ---------------------------------
> Mt9P031 ------>CCDC--->Previewer(optional)--->Resizer(optional)--->Video
> 
> TVP7002 ---
> 
> TV514x  ---
> 
> File Organisation
> -----------------
> 
> main driver files
> ----------------
> drivers/media/video/davinci/vpfe_capture.c
> include/media/davinci/vpfe_capture.h
> 
> Instantiatiation of the v4l2 device, media device and all  subdevs from
> here.
> 
> video Interface files
> ---------------------
> drivers/media/video/davinci/vpfe_video.c
> include/media/davinci/vpfe_video.h
> 
> Implements all the v4l2 video operations with a generic implementation for
> continuous and one shot mode.
> 
> subdev interface files
> ----------------------
> These file implement the subdev interface functionality for
> each of the subdev entities - mainly the entry points and their
> implementations in a IP generic way.
> 
> drivers/media/video/davinci/vpfe_ccdc.c
> drivers/media/video/davinci/vpfe_previewer.c
> drivers/media/video/davinci/vpfe_resizer.c
> drivers/media/video/davinci/vpfe_af.c
> drivers/media/video/davinci/vpfe_aew.c
> drivers/media/video/tvp514x.c
> drivers/media/video/tvp7002.c
> drivers/media/video/ths7353.c
> 
> include/media/davinci/vpfe_ccdc.h
> include/media/davinci/vpfe_previewer.h
> include/media/davinci/vpfe_resizer.h
> include/media/davinci/vpfe_af.h
> include/media/davinci/vpfe_aew.h
> include/media/tvp514x.h
> drivers/media/video/tvp514x_regs.h
> include/media/tvp7002.h
> drivers/media/video/tvp7002_reg.h
> 
> core implementation files
> -------------------------
> These provide a core implementation routines for ccdc, ipipeif,
> ipipe,aew, af, resizer hardware modules.
> 
> drivers/char/imp_common.c
> drivers/media/video/davinci/dm365_ccdc.c
> drivers/media/video/davinci/dm355_ccdc.c
> drivers/media/video/davinci/dm644x_ccdc.c
> drivers/char/dm355_ipipe.c
> drivers/char/dm355_ipipe_hw.c
> drivers/char/dm355_def_para.c
> drivers/char/dm365_ipipe.c
> drivers/char/dm365_def_para.c
> drivers/char/dm365_ipipe_hw.c
> drivers/char/dm6446_imp.c
> drivers/char/davinci_resizer_hw.c
> drivers/char/dm3xx_ipipe.c
> drivers/media/video/davinci/dm365_aew.c
> drivers/media/video/davinci/dm365_af.c
> drivers/media/video/davinci/dm365_a3_hw.c
> drivers/media/video/davinci/dm355_aew.c
> drivers/media/video/davinci/dm355_af.c
> drivers/media/video/davinci/dm355_aew_hw.c
> drivers/media/video/davinci/dm355_af_hw.c
> 
> include/media/davinci/imp_common.h
> include/media/davinci/dm365_ccdc.h
> include/media/davinci/dm355_ccdc.h
> include/media/davinci/dm644x_ccdc.h
> include/media/davinci/dm355_ipipe.h
> include/media/davinci/dm365_ipipe.h
> include/media/davinci/imp_hw_if.h
> include/media/davinci/dm3xx_ipipe.h
> include/media/davinci/dm365_aew.h
> include/media/davinci/dm365_af.h
> include/media/davinci/dm365_a3_hw.h
> include/media/davinci/dm355_aew.h
> include/media/davinci/dm355_af.h
> include/media/davinci/dm355_aew_hw.h
> include/media/davinci/dm355_af_hw.h
> include/media/davinci/vpfe_types.h
> 
> drivers/media/video/davinci/dm365_ccdc_regs.h
> drivers/media/video/davinci/dm355_ccdc_regs.h
> drivers/media/video/davinci/dm644x_ccdc_regs.h
> drivers/media/video/davinci/ccdc_hw_device.h
> drivers/char/dm355_ipipe_hw.h
> drivers/char/dm355_def_para.h
> drivers/char/dm365_def_para.h
> drivers/char/dm365_ipipe_hw.h
> drivers/char/davinci_resizer_hw.h
> 
> TODOs:
> ======
> 1. Single shot implementation for previewer and resizer.
> 2. Seperation of v4l2 video related structures and routines to aid single
> shot implementation.
> 3. Support NV12 format
> 4. Move the files from char folder to drivers/media/video along with
> headers

Why are the drivers in drivers/char for ?

> 5. Make the aew and af headers common between dm355 and dm365.
> 6. Enable dm355 and dm6446 functionality by making appropriate platform
> changes

-- 
Regards,

Laurent Pinchart
