Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FBrSc2022321
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 07:53:28 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FBrB1B001600
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 07:53:12 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Mon, 15 Sep 2008 17:22:59 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02C4347CE3@dbde02.ent.ti.com>
In-Reply-To: <1221476854.6312.37.camel@tubuntu>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
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
> From: Tomi Valkeinen [mailto:tomi.valkeinen@nokia.com]
> Sent: Monday, September 15, 2008 4:38 PM
> To: Shah, Hardik
> Cc: linux-omap@vger.kernel.org; video4linux-list@redhat.com
> Subject: RE: [PREVIEW] New display subsystem for OMAP2/3
> 
> On Fri, 2008-09-12 at 19:59 +0530, ext Shah, Hardik wrote:
> >
> > > -----Original Message-----
> > > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
> Tomi
> > > Valkeinen
> > > Sent: Thursday, September 11, 2008 8:26 PM
> > > To: linux-omap@vger.kernel.org
> > > Subject: [PREVIEW] New display subsystem for OMAP2/3
> > >
> > > Display Subsystem driver for OMAP2 and 3 (DSS2)
> > > -----------------------------------------------
> > Hi,
> > It's time to re-design DSS frame buffer driver for the OMAP2/3.  Current frame buffer driver is not
> covering the most of the functionality of the OMAP2/3 DSS Hardware like multiple outputs and multiple
> overlay managers supported by OMAP2/3 class of SoC. Again there is no V4L2 interface exposed by the
> DSS drivers for controlling the video pipelines of the DSS which is highly desirable feature as the
> video pipelines of the DSS hardware is a natural fit to the V4L2 architecture.
> >
> > We have already initiated the re-designing of the DSS drivers and already posted the RFC for the
> same on the Linux-Omap and the V4L2 mailing lists.  Below is the link for the RFC submitted by us on
> the open source mailing lists -
> >
> > http://lists-archives.org/video4linux/23648-omap3-display-driver-v4l2.html
> > http://www.mail-archive.com/linux-omap@vger.kernel.org/msg02510.html
> 
> Ah, I seem to have missed these, I was on my summer holidays at that
> time =). I'll study those.
> 
> >
> > Typically most of the modern display devices which include the OMAP2 and OMAP3, are required to
> support two separate types of interfaces - V4L2 interface for the video planes and fbdev interface
> for graphics planes. It is impossible for these two drivers on separate frameworks to co-exist as
> independent full fledged drivers. Hence this has been one of the main aspects we are trying to
> address through our design, which includes as a common DSS library which can be used by both of the
> drivers.
> >
> > VIDEO0(V4L2)    VIDEO1(V4L2)   GFX0(fbdev0)
> > 		|	|		|
> > 		|	|		|
> > 		----DSS Library----
> > 		     |    |
> > 		    LCD   TV
> >
> >
> > Here, the DSS library is the central set of APIs which is designed to make sure that, there are no
> conflicts for resources, resources being the Graphics plane (pipeline), Video planes (pipelines) and
> Overlay Managers. Display library is not tied to any interfaces, like V4L2 or FBDEV.
> >
> > Output devices registers to the DSS library and applications will be able to switch/exchange/change
> parameters through their interfaces going through the DSS library.
> >
> > We believe that currently your implementation does not address these important aspects and lot of
> the users will be at loss of functionality if this is not addressed.
> 
> I haven't used much time on the userspace interface, so my fb driver is
> just a copy of the old omapfb. It sounds my implementation is somewhat
> similar to yours. The DSS driver is not tied to fb or v4l interface, and
> offers ways to configure the displays and planes however you want.
> 
We have the implementation for the V4L2 as well as the FBDEV driver on the DSS library.  Although FBDEV driver is not in the shape to be posted to open source lists.

> I concentrated more on the the lower part than to fbdev or v4l, and more
> specifically I needed DSI support and multiple display support, while
DSS library is easily extendible to add DSI, RFBI, SDI support.

> still retaining the old functionality. And with multiple displays I
> don't mean just an LCD and a TV-out, but, for example, two LCD's and
> tv-out. Configurations like one LCD connected to parallel output,
> updated with DISPC, and the other one connected to DSI and updated with
> CPU or system DMA. Or two displays connected to DSI.
> 
DSS library gives the flexibility to change to add the as many overlay managers or as many encoder on the overlay manager.

> I also wanted to be able to change the configuration on the fly,
> changing where DISPC output is going and which displays are updated with
> CPU or sDMA.
> 
> This is why I have the display-concept in my design.
> 
> I haven't made support for multiple users of the displays (like separate
> fb and v4l drivers), but I don't immediately see why it couldn't be
> done.
> 
> However, there are some questions regarding that, as the planes do not
> represent displays, but just overlay planes. What happens when both fb
> and v4l drivers want to change the resolution or timings of the display?
> 
The controls of the display library which are shared between the pipelines like the timing parameters, panel width, panel height can be configured through the sysfs entries.  It will be something like  "echo ntsc_m > /sys/class/display_control/standard".  DSS library maintains the data structures and individual userspace drivers can query these controls for setting their parameters dependent on these controls.

> Also I still don't quite know how to present displays to user space.
> Currently my omapfb just uses the first display, and that's it. I think
> in the end the user (be it X server, or perhaps some entity over it),
> needs to have some understanding of what OMAP offers and how it can use
> the displays. And there probably needs to be some product spesific
> configuration regarding this in userspace.
> 
Most of the open source applications are not aware of the hardware capabilities.  So it should be transparently handled by the low level drivers/libraries.
> > Thanks and Regards,
> > Hardik
> 
>  Tomi
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
