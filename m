Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9O9oiOT032744
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:50:44 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9O9oXdG020539
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:50:33 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>, Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Fri, 24 Oct 2008 15:20:16 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6297929@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403DC1A6A39@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
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
> From: Hiremath, Vaibhav
> Sent: Friday, October 03, 2008 7:46 PM
> To: Tony Lindgren; Tomi Valkeinen
> Cc: hverkuil@xs4all.nl; Shah, Hardik; linux-omap@vger.kernel.org; video4linux-
> list@redhat.com
> Subject: RE: [PREVIEW] New display subsystem for OMAP2/3
> 
> 
> 
> Thanks,
> Vaibhav Hiremath
> Senior Software Engg.
> Platform Support Products
> Texas Instruments Inc
> Ph: +91-80-25099927
> 
> > -----Original Message-----
> > From: Tony Lindgren [mailto:tony@atomide.com]
> > Sent: Friday, October 03, 2008 7:04 PM
> > To: Tomi Valkeinen
> > Cc: Hiremath, Vaibhav; hverkuil@xs4all.nl; Shah, Hardik; linux-
> > omap@vger.kernel.org; video4linux-list@redhat.com
> > Subject: Re: [PREVIEW] New display subsystem for OMAP2/3
> >
> > * Tomi Valkeinen <tomi.valkeinen@nokia.com> [081003 16:26]:
> > > Hi,
> > >
> > > > > -----Original Message-----
> > > > > From: Tomi Valkeinen [mailto:tomi.valkeinen@nokia.com]
> > > > > Sent: Thursday, October 02, 2008 1:55 PM
> > > > > To: Hiremath, Vaibhav
> > > > > Cc: Shah, Hardik; linux-omap@vger.kernel.org; video4linux-
> > list@redhat.com
> > > > > Subject: RE: [PREVIEW] New display subsystem for OMAP2/3
> > > > >
> > > > > Hi Vaibhav,
> > > > >
> > > > > On Wed, 2008-10-01 at 16:21 +0530, ext Hiremath, Vaibhav
> > wrote:
> > > > > > Tomi,
> > > > > >
> > > > > > Have you got a chance to review the DSS library and V4l2
> > driver which we have posted?
> > > > >
> > > > > Unfortunately not very much. I've been glancing the DSS side
> > of the
> > > > > driver, but not the v4l side as I don't know much about it.
> > > > >
> > > > > There seems to be awfully lot ifdefs for board/cpu types in
> > the code.
> > > >
> > > > As far as ifdefs are concerned, they are added to take care of
> > OMAP2/3 variants. Especially you will find many instances of
> > CONFIG_ARCH_OMAP3410 and the reason is obvious, OMAP3410 doesn't
> > have VENC. As I have mentioned before, DSS library is designed to
> > support both LCD, TV, and many more.
> > >
> > > They make the code unclear. I have divided the functionality to
> > separate
> > > files, that can easily be left out. So for OMAP3410 I would just
> > disable
> > > the VENC config option. And then I can test for CONFIG_DSS_VENC,
> > instead
> > > of OMAP3410 || OMAP2410 || OMAPwhatnot. Of course you can't do
> > this for
> > > all things, but at least VENC is not one of these.
> > >
> > > And all board specific code should, in my opinion, be in board
> > files. I
> > > don't have any board specific definitions in the DSS driver or the
> > > LCD/controller drivers. (well, ok, there is something in the DSI
> > driver,
> > > it's still quite raw).
> >
> > Yeah we should be able to compile in any combination of omap boards
> > with
> > whatever configuration from board-*.c files as platform_data.
> >
> > So ifdefs will totally break this.
> >
> 
> Point taken, we will try to avoid ifdefs as much as possible and will divide
> depending on the functionality.
> 
> > > > > My biased and superficial view of the differences between my
> > DSS and
> > > > > yours is that:
> > > >
> > > > Tomi, here I differ from you. There should not be biased
> > opinion. What we are looking here is a good design which will
> > fulfill all our requirements/use case, like LCD, DVI, HDMI and TV
> > for us and DSI, RFBI for you.
> > >
> > > Agreed. I was just pointing out that I haven't used enough time to
> > study
> > > your DSS to really comment on it, and that a coder tends to like
> > his own
> > > code =).
> > >
> > > > > - My implementation is cleaner, better organized and more
> > generic
> > > >
> > > > Again, here both of us will be having biased comments to support
> > our own design, so I would prefer not to comment on this. Lets
> > people on the community decide whose design is better.
> > > >
> > > > > - My implementation has support for DSI, SDI, RFBI, L4 updates
> > > >
> > > > DSI, SDI and RFBI are the modes, which we can add anytime to the
> > system depending as per our requirement.
> > > > It is again driven by use case; you have use cases for DSI, SDI
> > and RFBI. We have for TV, DVI, HDMI and LCD, so we strongly
> > concentrated on these.
> > > >
> > > > We can very well add these supports to DSS Library with minimal
> > effort.
> > >
> > > SDI is quite easy, but I wouldn't say adding RFBI and DSI is
> > minimal
> > > effort. DSI is quite complex in itself, and the manual update mode
> > > changes how the DSS has to handle things.
> > >
> > > > > - Your implementation has better support for "extra" things
> > like VRFB,
> > > > > color conversions, alpha etc.
> > > > > - Your implementation most likely has better power management
> > support.
> > > > > - And of course what is most visible to the user, my version
> > uses only
> > > > > framebuffers, and yours uses also v4l2 devices.
> > > > >
> > > >
> > > > You really can't deny the V4L2 framework advantages over
> > framebuffer, especially for streaming kind of applications. Looking
> > towards the hardware features OMAP supports; we would really require
> > to have such support/capabilities. Community is also in agreement
> > for the V4L2 interface on OMAP-DSS.
> > >
> > > Well, I'm not the best one to comment on V4L2 as I don't know much
> > about
> > > it. But I remember seeing quite negative comments about V4L2 a
> > while ago
> > > in this or related mail thread, so I'm not yet ready to change to
> > V4L2
> > > camp.
> > >
> > > The best option would be, of course, to have both =).
> > >
> > > > Tony/Hans,
> > > > Your comments would be helpful here.
> >
> > I'd rather not get too involved in the fb or v4l stuff, I already
> > have
> > enough things to look at. But I can certainly comment on stuff that
> > will
> > break booting multiple omaps the same time once the patches are
> > posted.
> >
> > > > > As for the future, I have no choice but to keep using my DSS
> > as we need
> > > > > the features it has. I feel it would be quite a big job to get
> > those in
> > > > > to your driver. And even if I had a choice, I (unsurprisingly
> > =) think
> > > > > that my version is better and would stick to it.
> > > > >
> > > >
> > > > It's your personal choice to stick to whichever code base you
> > want, I don't want to comment on that. But what I believe is, with
> > your design we are limiting ourselves from supporting most of the
> > features which hardware provides.
> > >
> > > Is the limiting factor here the missing V4L2 interface? Or
> > something in
> > > the core DSS driver? To my knowledge you can have all the HW
> > features
> > > supported with framebuffers, even though V4L2 device can perhaps
> > make
> > > the use easier for some applications.
> > >
> > > Well, one thing comes to my mind, and it's sharing the framebuffer
> > > memory between, for example, display and camera drivers. I believe
> > you
> > > can do that with V4L2. Something else?
> > >
> > > > We can work together to add more support to DSS library.
> > >
> > > Sure, I don't really care which version is accepted, as long as we
> > get
> > > all the features =). So if you see something usable in my code,
> > just
> > > take it and add to your version.

Hi All,
I will be posting the version 2 of the DSS library and V4L2 display driver 
with almost all the comments from the community taken care of.
It will be series of 4 patches containing

OMAP 2/3 DSS Library
OMAP3 EVM TV encoder Driver.
New IOCTLS added to V4L2 Framework (Already posted on V4L2 mailing list)
OMAP 2/3 V4L2 Display driver on the Video planes of DSS hardware.

We are enhancing the DSS library.  This is the first post containing the
features like power management, video pipeline, Digital overlay manager,
clock management support.

Further plan is to add graphics pipeline, LCD overlay manager, RFBI, DSI,
support and frame buffer interface for graphics pipeline

Please let us know your comments on further enhancements of the DSS Library
and V4L2 display driver.

Thanks and Regards,
Hardik Shah> > Regards,
> >
> > Tony


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
