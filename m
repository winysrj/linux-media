Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:55693 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847Ab1F1McM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 08:32:12 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 28 Jun 2011 18:02:01 +0530
Subject: RE: [RFC] Media Controller Capture driver for DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF738@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB593024BBC5CB6@dbde02.ent.ti.com>
 <201105020006.24338.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105020006.24338.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Laurent,
  Sorry for getting back late on this. I was also tied up. I am following it up with the patches.

-Manju

On Mon, May 02, 2011 at 03:36:23, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> On Wednesday 27 April 2011 16:14:03 Hadli, Manjunath wrote:
> > Introduction
> > ------------
> > This is the proposal of the initial version of design and 
> > implementation of the DM365 VPFE (Video Port Front End) drivers using 
> > Media Controloler , the initial version which supports the following:
> > 1) dm365 vpfe
> > 2) ccdc,previewer,resizer,h3a,af blocks
> > 3) supports both continuous and single-shot modes
> > 4) supports user pointer exchange and memory mapped modes for buffer 
> > allocation
> > 
> > This driver bases its design on Laurent Pinchart's Media Controller 
> > Design whose patches for Media Controller and subdev enhancements form the base.
> > The driver also takes copious elements taken from Laurent Pinchart and 
> > others' OMAP ISP driver based on Media Controller. So thank you all 
> > the people who are responsible for the Media Controller and the OMAP 
> > ISP driver.
> 
> You're welcome.
> 
> > Also, the core functionality of the driver comes from the arago vpfe 
> > capture driver of which the CCDC capture was based on V4L2, with other 
> > drivers like Previwer, and Resizer.
> > 
> > The specification for DM365 can be found here:
> > dm365  vpfe: http://www.ti.com/litv/pdf/sprufg8c
> > 
> > The initial version of the  driver implementation can be found here:
> > 
> > http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h
> > =refs
> > /heads/mc_release
> 
> I'll try to review the code, but I got the DM644x V4L2 display driver on my todo-list first :-)
> 
> > Driver Design: Main entities
> > ----------------------------
> > The hardware modules for dm355,dm365 are mainly ipipe, ipipeif,isif. 
> > These hardware modules are generically exposed to the user level in 
> > the for of
> > dm6446 style modules. Mainly -
> > ccdc, previewer, resizer in addition to the other histogram and auto 
> > color/white balance correction and auto focus modules.
> 
> I'm curious, why do you name the modules CCDC and previewer in the code, when they're called ISIF, IPIPEIF and IPIPE in the documentation ? That's quite confusing.
The driver is intended to support Dm365, Dm355 and Dm6446. The three are similar and there are some internal differences. The counterparts for IPIPE in Dm6446 are known by names as CCDC , previewer etc and a good part of the world knows the driver by that name. So rather than changing the names, we decided to keep them as-is.
> 
> > 1)MT9P031 sensor  module for RAW capture
> > 2)TVP7002 decoder module for HD inputs 3)TVP514x decoder module for SD 
> > inputs 4)CCDC capture module 5)Previewer Module for Bayer to YUV 
> > conversion 6)Resizer Module for scaling
> > 
> > Connection for on-the-fly capture
> > ---------------------------------
> > Mt9P031 
> > ------>CCDC--->Previewer(optional)--->Resizer(optional)--->Video
> > 
> > TVP7002 ---
> > 
> > TV514x  ---
> > 
> > File Organisation
> > -----------------
> > 
> > main driver files
> > ----------------
> > drivers/media/video/davinci/vpfe_capture.c
> > include/media/davinci/vpfe_capture.h
> > 
> > Instantiatiation of the v4l2 device, media device and all  subdevs 
> > from here.
> > 
> > video Interface files
> > ---------------------
> > drivers/media/video/davinci/vpfe_video.c
> > include/media/davinci/vpfe_video.h
> > 
> > Implements all the v4l2 video operations with a generic implementation 
> > for continuous and one shot mode.
> > 
> > subdev interface files
> > ----------------------
> > These file implement the subdev interface functionality for each of 
> > the subdev entities - mainly the entry points and their 
> > implementations in a IP generic way.
> > 
> > drivers/media/video/davinci/vpfe_ccdc.c
> > drivers/media/video/davinci/vpfe_previewer.c
> > drivers/media/video/davinci/vpfe_resizer.c
> > drivers/media/video/davinci/vpfe_af.c
> > drivers/media/video/davinci/vpfe_aew.c
> > drivers/media/video/mt9p031.c
> > drivers/media/video/tvp514x.c
> > drivers/media/video/tvp7002.c
> > drivers/media/video/ths7353.c
> > 
> > include/media/davinci/vpfe_ccdc.h
> > include/media/davinci/vpfe_previewer.h
> > include/media/davinci/vpfe_resizer.h
> > include/media/davinci/vpfe_af.h
> > include/media/davinci/vpfe_aew.h
> > include/media/tvp514x.h
> > drivers/media/video/tvp514x_regs.h
> > include/media/tvp7002.h
> > drivers/media/video/tvp7002_reg.h
> > 
> > core implementation files
> > -------------------------
> > These provide a core implementation routines for ccdc, ipipeif, 
> > ipipe,aew, af, resizer hardware modules.
> > 
> > drivers/media/video/davinci/dm365_ccdc.c
> > drivers/media/video/davinci/dm365_ipipe.c
> > drivers/media/video/davinci/dm365_def_para.c
> > drivers/media/video/davinci/dm365_ipipe_hw.c
> > drivers/media/video/davinci/dm3xx_ipipe.c
> > drivers/media/video/davinci/dm365_aew.c
> > drivers/media/video/davinci/dm365_af.c
> > drivers/media/video/davinci/dm365_a3_hw.c
> 
> Why don't you combine the davinci/vpfe_*.c files with the davinci/dm365_*.c files ? What's the reason for splitting functionality between vpfe_ccdc.c and dm365_ccdc.c for instance ?
The driver is intended to support DM365, DM355 and DM6446. So the vpfe_ files implement the high level interfaces whereas the dm365_ files implement the specifics for the device.
> 
> > include/media/davinci/imp_common.h
> > include/media/davinci/dm365_ccdc.h
> > include/media/davinci/dm365_ipipe.h
> > include/media/davinci/imp_hw_if.h
> > include/media/davinci/dm3xx_ipipe.h
> > include/media/davinci/dm365_aew.h
> > include/media/davinci/dm365_af.h
> > include/media/davinci/dm365_a3_hw.h
> > include/media/davinci/vpfe_types.h
> > 
> > drivers/media/video/davinci/dm365_ccdc_regs.h
> > drivers/media/video/davinci/ccdc_hw_device.h
> > drivers/media/video/davinci/dm365_def_para.h
> > drivers/media/video/davinci/dm365_ipipe_hw.h
> > 
> > TODOs:
> > ======
> > 
> > 1. Support NV12/YUYV format
> > 2. Support more than 1 buffer for single-shot mode 3. Enable Resizer-B 
> > 4. Remove duplicate format setting in ipipe 5. Remove function 
> > declarations in dm365_ipipe.c by removing function pointer table 6. 
> > Remove function declarations in dm365_ccdc.c by removing function 
> > pointer table 7. Make multilevel previewer module ioctl into single 
> > level 8. Move kernel only headers into drivers/media/video/davinci 
> > from include/media/davinci
> 
> --
> Regards,
> 
> Laurent Pinchart
> 

