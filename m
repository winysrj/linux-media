Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CEV70A006248
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 10:31:08 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CEU5ki011444
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 10:30:05 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>, "linux-omap@vger.kernel.org"
	<linux-omap@vger.kernel.org>
Date: Fri, 12 Sep 2008 19:59:44 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02C42B43C8@dbde02.ent.ti.com>
In-Reply-To: <1221144955.12281.6.camel@tubuntu>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: [PREVIEW] New display subsystem for OMAP2/3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Tomi
> Valkeinen
> Sent: Thursday, September 11, 2008 8:26 PM
> To: linux-omap@vger.kernel.org
> Subject: [PREVIEW] New display subsystem for OMAP2/3
> 
> Display Subsystem driver for OMAP2 and 3 (DSS2)
> -----------------------------------------------
> 
> This is an almost total rewrite of the current OmapFB driver (let's call it
> DSS1). The main targets for this work are to implement DSI, TV-out and multiple
> display support.
> 
> The DSS2 driver (omap-dss module) lives in arch/arm/plat-omap/dss/, and the FB,
> panel and controller drivers live in drivers/video/omap2/. DSS1 and DSS2 live
> currently side by side, you can choose which one to use.
> 
> I know it would be best to modify the DSS1 driver to implement the missing
> features, but the task seemed overwhelming. The DSS1 driver was just not
> designed for multiple displays or other outputs than parallel and rfbi, and I
> thought maintaining a patch set to change those wasn't something I could handle
> and stay sane. So I implemented DSS2 parallel to the DSS1.
> 
> I'm sending this now as a preview. DSS2 is in no way ready yet, even though it
> should be usable. I'm interested to hear comments about it, most importantly if
> it is ok to have DSS2 as a separate driver from DSS1 or is it a no-no.
> 
> Some code, especially in the dispc and rfbi, was taken and modified from the
> DSS1 driver by Imre Deak and others.
> 
> The patch set is about 200kB, so I decided not to send it as email, but to put
> it to http://www.bat.org/~tomba/omap-dss/
> 
> Architecture
> ------------
> 
> DSS driver has to be loaded first, then the panel and the controller drivers
> are loaded and they register themselves to the DSS. At this point the DSS is
> ready. The DSS abstracts each display behind a struct omap_display, and these
> are the main interface to the DSS.
> 
> OmapFB driver gets a display from DSS, initializes framebuffer memory,
> configures the display and activates it. Currently OmapFB only uses the first
> display.  Also, one could implement other ways to handle the displays as the
> DSS does not depend on OmapFB in any way.
> 
> And a piece of cool ascii art:
> 
>                 DSS
>                /   \
>               /     \        +--- Panel
>              /       \      /
> Panel----Display     Display
>              \       /      \
>               \     /        +--- Ctrl
>                \   /
>               OmapFB
> 
> Porting panel and controller drivers to DSS2 is trivial. However, only OMAP3
> SDP panel driver is currently ported, as I don't have any other public
> hardware.
> 
> Features
> --------
> 
> Current implemented and tested features include:
> - DSI output in command mode
> - SDI output (not tested for a while, might've gotten broken)
> - RFBI output (not tested for a while, might've gotten broken)
> - Parallel output (OMAP3 SDP, both LCD and DVI)
> - All pieces can be compiled as a module or inside kernel
> - Display timing change (with, for example, fbset)
> - Using DISPC to update any of the outputs
> - Using CPU to update RFBI or DSI output
> - OMAP DISPC planes
> - RGB16, RGB24 packed, RGB24 unpacked
> - YUV2, UYVY
> 
> TODO
> ----
> 
> OMAP2 not tested for some time
> - DSS2 did work on OMAP2, but I haven't been able to test it for some time.
> 
> DSS locking
> - Things break if you change dispc settings during DSI screen update.  Probably
>   the same for RFBI.
> 
> Error checking
> - Lots of checks are missing or implemented just as BUG()
> 
> Rotate (external FB)
> Rotate (VRFB)
> Rotate (SMS)
> VENC
> 
> Pixel clock
> - Currently allows only pixel clocks that can be exactly produced.
> - Use DSI PLL to produce pixel clock
> 
> System DMA update for DSI
> - Can be used for RGB16 and RGB24P modes. Probably not for RGB24U (how
>   to skip the empty byte?)
> 
> Power management
> - Clocks on/off in the first place
> 
> Multiple display handling
> - Perhaps extra framebuffers, and an ioctl to map any of the FBs to any of the
>   DISPC planes or L4. So, for example, fb1 could be GFX plane, fb0 could be
>   updated with CPU. Then later on fb1 could be changed to use CPU with an
>   ioctl, and fb0 to use GFX.
> - Because of the dependencies of the DISPC planes, LCD/DIGIT output,
>   the application has to know what it is doing.
> 
> Resolution change
> - The x/y res of the framebuffer are not display resolutions, but just the
>   resolution of the framebuffer (and the plane).
> - The display resolution affects all planes on the display.
> - Display resolution is not really a framebuffer feature. A sysfs
>   entry for each display? If yes, is that an omapfb or DSS feature?
>   Changing resolution affects the framebuffers.
> 
> DSI configuration
> - Currently quite hardcoded configuration
> 
> OMAP1 support
> - Not sure if needed
> 
Hi,
It's time to re-design DSS frame buffer driver for the OMAP2/3.  Current frame buffer driver is not covering the most of the functionality of the OMAP2/3 DSS Hardware like multiple outputs and multiple overlay managers supported by OMAP2/3 class of SoC. Again there is no V4L2 interface exposed by the DSS drivers for controlling the video pipelines of the DSS which is highly desirable feature as the video pipelines of the DSS hardware is a natural fit to the V4L2 architecture.

We have already initiated the re-designing of the DSS drivers and already posted the RFC for the same on the Linux-Omap and the V4L2 mailing lists.  Below is the link for the RFC submitted by us on the open source mailing lists -

http://lists-archives.org/video4linux/23648-omap3-display-driver-v4l2.html
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg02510.html

Typically most of the modern display devices which include the OMAP2 and OMAP3, are required to support two separate types of interfaces - V4L2 interface for the video planes and fbdev interface for graphics planes. It is impossible for these two drivers on separate frameworks to co-exist as independent full fledged drivers. Hence this has been one of the main aspects we are trying to address through our design, which includes as a common DSS library which can be used by both of the drivers.

VIDEO0(V4L2)    VIDEO1(V4L2)   GFX0(fbdev0)
		|	|		|
		|	|		|
		----DSS Library----
		     |    | 
		    LCD   TV


Here, the DSS library is the central set of APIs which is designed to make sure that, there are no conflicts for resources, resources being the Graphics plane (pipeline), Video planes (pipelines) and Overlay Managers. Display library is not tied to any interfaces, like V4L2 or FBDEV.

Output devices registers to the DSS library and applications will be able to switch/exchange/change parameters through their interfaces going through the DSS library.

We believe that currently your implementation does not address these important aspects and lot of the users will be at loss of functionality if this is not addressed.

Below is the link to our implementation which we were about to post as mentioned in the RFC posted earlier. Please have a look at this.

https://omapzoom.org/gf/project/omapkernel/docman/?subdir=10

Following are the important features of the DSS library.  Detail design about the DSS library is also available under above link.

1. 	Display library will be the master controlling the DSS hardware. Any driver
	required to configure the DSS registers should call the DSS library APIs.
2. 	Display library includes modular functions for programming the video and
	graphics pipeline of the DSS independently of the framework (V4L2 and FBDEV)
	used.
3. 	Display library includes functions for controlling the clock management and
	interrupt management. Since these functionalities is shared between the
	individual pipelines and individual pipelines may be controlled by different
	drivers (V4L2 and FBDEV). Display library will maintain the reference count and
	necessary data structures for concurrency handling.
4. 	Display library has interface for registering and deregistering the encoders
	attached with the overlay managers.
5. 	Display library includes functions for selecting the output and standards. Based
	on the output selected display library will select the active encoder from the
	registered encoders.
6. 	Display library supports programming of the overlay managers registers
	depending upon the output and mode selected. It will maintain the data
	structures for overlay manager parameters as the overlay managers are shared
	between the pipelines.
7. 	Display library supports saving and restoring of the context for power
	management.
8. 	Display library is easily extendable to add the DSI, SDI and RFBI functionality 
	supported by DSS Hardware.

Let us work together to get a best design out for OMAP2/3 DSS.


Thanks and Regards,
Hardik


> FBSET
> -----
> 
> fbset with omap planes support can be found at
> http://www.bat.org/~tomba/fbset/
> 
> The debian package is from ubuntu, with a patch that adds omap support.
> 
> ---
> 
>  arch/arm/mach-omap2/board-3430sdp.c       |   66 +-
>  arch/arm/plat-omap/Kconfig                |    2 +
>  arch/arm/plat-omap/Makefile               |    2 +
>  arch/arm/plat-omap/dss/Kconfig            |    5 +
>  arch/arm/plat-omap/dss/Makefile           |    6 +
>  arch/arm/plat-omap/dss/dispc.c            | 1539 +++++++++++++++++++
>  arch/arm/plat-omap/dss/display.c          |  304 ++++
>  arch/arm/plat-omap/dss/dpi.c              |  196 +++
>  arch/arm/plat-omap/dss/dsi.c              | 2371 +++++++++++++++++++++++++++++
>  arch/arm/plat-omap/dss/dss.c              |  389 +++++
>  arch/arm/plat-omap/dss/dss.h              |  191 +++
>  arch/arm/plat-omap/dss/rfbi.c             | 1274 ++++++++++++++++
>  arch/arm/plat-omap/dss/sdi.c              |  152 ++
>  arch/arm/plat-omap/dss/venc.c             |  501 ++++++
>  arch/arm/plat-omap/fb.c                   |    9 +-
>  arch/arm/plat-omap/include/mach/display.h |  358 +++++
>  arch/arm/plat-omap/include/mach/omapfb.h  |    7 +
>  drivers/video/Kconfig                     |    1 +
>  drivers/video/Makefile                    |    1 +
>  drivers/video/omap/Kconfig                |    2 +-
>  drivers/video/omap2/Kconfig               |   20 +
>  drivers/video/omap2/Makefile              |    4 +
>  drivers/video/omap2/omapfb.c              | 1377 +++++++++++++++++
>  drivers/video/omap2/panel-sdp3430-dvi.c   |  157 ++
>  drivers/video/omap2/panel-sdp3430.c       |  187 +++
>  25 files changed, 9108 insertions(+), 13 deletions(-)
> 
> --
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
