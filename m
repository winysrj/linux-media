Return-path: <mchehab@gaivota>
Received: from comal.ext.ti.com ([198.47.26.152]:54311 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0LPMkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 07:40:41 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 16 Dec 2010 18:10:20 +0530
Subject: RE: [PATCH v6 7/7] davinci vpbe: Readme text for Dm6446 vpbe
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402EFC3CB0A@dbde02.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401BE4AC743@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Murali,
 Will update the doc.

Thank you,
-Manju
On Wed, Dec 15, 2010 at 20:49:00, Karicheri, Muralidharan wrote:
> Manju,
> 
> Could you review the Document? I think it is not updated to reflect the latest status:
> 
> >+ Current status:-
> >+
> >+ A build tested version of vpbe controller is available.
> 
> I guess you have already tested this using the v4l2 driver.
> 
> >+ v4l2 driver
> >+    - A version is already developed which is to be cleaned up and 
> >+ unit
> >tested
> 
> Ditto. v4l2 driver is already tested, right?
> 
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> 
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media- 
> >owner@vger.kernel.org] On Behalf Of Manjunath Hadli
> >Sent: Wednesday, December 15, 2010 4:12 AM
> >To: LMML
> >Cc: dlos; Mauro Carvalho Chehab; Hans Verkuil; Hadli, Manjunath
> >Subject: [PATCH v6 7/7] davinci vpbe: Readme text for Dm6446 vpbe
> >
> >Please refer to this file for detailed documentation of davinci vpbe 
> >v4l2 driver
> >
> >Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> >Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> >Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> >---
> > Documentation/video4linux/README.davinci-vpbe |  100
> >+++++++++++++++++++++++++
> > 1 files changed, 100 insertions(+), 0 deletions(-) create mode 100644 
> > Documentation/video4linux/README.davinci-vpbe
> >
> >diff --git a/Documentation/video4linux/README.davinci-vpbe
> >b/Documentation/video4linux/README.davinci-vpbe
> >new file mode 100644
> >index 0000000..3ff2dc3
> >--- /dev/null
> >+++ b/Documentation/video4linux/README.davinci-vpbe
> >@@ -0,0 +1,100 @@
> >+
> >+                VPBE V4L2 driver design 
> >+ =====================================================================
> >+ =
> >+
> >+ File partitioning
> >+ -----------------
> >+ V4L2 display device driver
> >+         drivers/media/video/davinci/vpbe_display.c
> >+         drivers/media/video/davinci/vpbe_display.h
> >+
> >+ VPBE display controller
> >+         drivers/media/video/davinci/vpbe.c
> >+         drivers/media/video/davinci/vpbe.h
> >+
> >+ VPBE venc sub device driver
> >+         drivers/media/video/davinci/vpbe_venc.c
> >+         drivers/media/video/davinci/vpbe_venc.h
> >+         drivers/media/video/davinci/vpbe_venc_regs.h
> >+
> >+ VPBE osd driver
> >+         drivers/media/video/davinci/vpbe_osd.c
> >+         drivers/media/video/davinci/vpbe_osd.h
> >+         drivers/media/video/davinci/vpbe_osd_regs.h
> >+
> >+ Functional partitioning
> >+ -----------------------
> >+
> >+ Consists of the following (in the same order as the list under file
> >+ partitioning):-
> >+
> >+ 1. V4L2 display driver
> >+    Implements video2 and video3 device nodes and
> >+    provides v4l2 device interface to manage VID0 and VID1 layers.
> >+
> >+ 2. Display controller
> >+    Loads up venc, osd and external encoders such as ths8200. It provides
> >+    a set of API calls to V4L2 drivers to set the output/standards
> >+    in the venc or external sub devices. It also provides
> >+    a device object to access the services from osd sub device
> >+    using sub device ops. The connection of external encoders to venc LCD
> >+    controller port is done at init time based on default output and
> >standard
> >+    selection or at run time when application change the output through
> >+    V4L2 IOCTLs.
> >+
> >+    When connetected to an external encoder, vpbe controller is also
> >responsible
> >+    for setting up the interface between venc and external encoders 
> >+ based
> >on
> >+    board specific settings (specified in board-xxx-evm.c). This allows
> >+    interfacing external encoders such as ths8200. The setup_if_config()
> >+    is implemented for this as well as configure_venc() (part of the 
> >+ next
> >patch)
> >+    API to set timings in venc for a specific display resolution. As 
> >+ of
> >this
> >+    patch series, the interconnection and enabling ans setting of the
> >external
> >+    encoders is not present, and would be a part of the next patch series.
> >+
> >+ 3. Venc subdevice
> >+    Responsible for setting outputs provided through internal dacs and
> >also
> >+    setting timings at LCD controller port when external encoders are
> >connected
> >+    at the port or LCD panel timings required. When external 
> >+ encoder/LCD
> >panel
> >+    is connected, the timings for a specific standard/preset is 
> >+ retrieved
> >from
> >+    the board specific table and the values are used to set the timings in
> >+    venc using non-standard timing mode.
> >+
> >+    Support LCD Panel displays using the venc. For example to support 
> >+ a
> >Logic
> >+    PD display, it requires setting up the LCD controller port with a 
> >+ set
> >of
> >+    timings for the resolution supported and setting the dot clock. So 
> >+ we
> >could
> >+    add the available outputs as a board specific entry (i.e add the
> >"LogicPD"
> >+    output name to board-xxx-evm.c). A table of timings for various LCDs
> >+    supported can be maintained in the board specific setup file to
> >support
> >+    various LCD displays.
> >+
> >+ 4. osd subdevice
> >+    Osd subdevice implements all osd layer management and hardware
> >specific
> >+    features. In the legacfy drivers (LSPxxx), the hardware specific
> >features
> >+    are configured through proprietary IOCTLs at the fb device interface.
> >Since
> >+    subdevices are going to support device nodes, application will be able
> >+    to configure the hardware feature directly by opening the osd
> >subdevice
> >+    node and by calling the related IOCTL. So these proprietary IOCTLs are
> >+    to be removed from the FB Device driver when doing up port of 
> >+ these
> >drivers to
> >+    mainline kernel. The V4L2 and FB device nodes supports only IOCTLS 
> >+ as
> >per
> >+    the associated spec. The rest of the IOCTLs are to be moved to osd and
> >+    venc subdevices.
> >+
> >+ Current status:-
> >+
> >+ A build tested version of vpbe controller is available.
> >+
> >+ Following are TBDs.
> >+
> >+ vpbe display controller
> >+    - review and modify the handling of external encoders.
> >+    - add support for selecting external encoder as default at probe time.
> >+
> >+ vpbe venc sub device
> >+    - add timings for supporting ths8200
> >+    - add support for LogicPD LCD.
> >+
> >+ v4l2 driver
> >+    - A version is already developed which is to be cleaned up and 
> >+ unit
> >tested
> >+
> >+ FB drivers
> >+    - Add support for fbdev drivers.- Ready and part of subsequent patches.
> >--
> >1.6.2.4
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" 
> >in the body of a message to majordomo@vger.kernel.org More majordomo 
> >info at  http://vger.kernel.org/majordomo-info.html
> 

