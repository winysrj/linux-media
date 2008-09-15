Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8F8fCM0027470
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 04:41:13 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8F8eLDr018827
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 04:40:21 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 15 Sep 2008 14:10:02 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02C4347B9B@dbde02.ent.ti.com>
In-Reply-To: <yw1xbpyr3egz.fsf@thrashbarg.mansr.com>
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
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Måns
> Rullgård
> Sent: Sunday, September 14, 2008 3:18 AM
> To: linux-omap@vger.kernel.org
> Cc: video4linux-list@redhat.com
> Subject: Re: [PREVIEW] New display subsystem for OMAP2/3
> 
> Koen Kooi <k.kooi@student.utwente.nl> writes:
> 
> > Op 12 sep 2008, om 17:29 heeft Daniel Stone het volgende geschreven:
> >
> >> On Fri, Sep 12, 2008 at 07:59:44PM +0530, ext Shah, Hardik wrote:
> >>> It's time to re-design DSS frame buffer driver for the OMAP2/3.
> >>> Current frame buffer driver is not covering the most of the
> >>> functionality of the OMAP2/3 DSS Hardware like multiple outputs and
> >>> multiple overlay managers supported by OMAP2/3 class of SoC. Again
> >>> there is no V4L2 interface exposed by the DSS drivers for
> >>> controlling the video pipelines of the DSS which is highly
> >>> desirable feature as the video pipelines of the DSS hardware is a
> >>> natural fit to the V4L2 architecture.
> >>
> >> If you want to use v4l for video output, don't let me stop you, but I
> >> don't see that it has much actual wide use beyond TI PowerPoint
> >> presentations about their graphical architecture.
> >
> > That was my thought as well, but I've encountered at least 2 products
> > this weekend at IBC using the v4l way on omap3. One of the engineers
> > was complaining about the lack of synchronous updates if you move
> > various videoplanes around (think resizing video windows) which makes
> > the video picture end up outside your nice cairo-drawn borders. So
> > yes, it is getting used outside of TI :)
> 
> I'm thinking the best solution is probably to have a low-level
> internal driver providing access to various planes, exposing as much
> functionality as is practical.  Various user-space interfaces, such as
> fbdev and v4l, could then be implemented on top of this with very
> little code.  If I've understood things correctly, this is essentially
> what the patch in this thread is doing.  This approach should let the
> TI people and Koen's mythical friends from IBC use the v4l2 interface,
> while still allowing the less masochistic among us to use a simpler
> interface.
> 
> What I don't like about the patch posted is its size.  I'm sure the
> transition could be done in a sequence of smaller patches.  At the
> very least, it should be possible to move existing functionality to
> the new architecture, then add the new parts afterwards.  I also see
> little value in keeping the old model around, as is done in the patch.

Our DSS library is inline with the above model suggested by you.  Following is the link containing DSS library code and small design document, which currently handles only video pipeline.  The next immediate goal is to add the support for graphics pipeline functionality.  

https://omapzoom.org/gf/project/omapkernel/docman/?subdir=10

 

Thanks and Regards,
Hardik Shah

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
