Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5Ix35f029890
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 13:59:04 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5Iw1uG021879
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 13:58:02 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Tony Lindgren <tony@atomide.com>
Date: Sat, 6 Dec 2008 00:27:41 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E90E75B9@dbde02.ent.ti.com>
In-Reply-To: <20081204234534.GJ7054@atomide.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	Koen Kooi <k.kooi@student.utwente.nl>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] Add OMAP2 camera driver
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



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Friday, December 05, 2008 5:16 AM
> To: Hiremath, Vaibhav
> Cc: Koen Kooi; Trilok Soni; Hans Verkuil; Sakari Ailus; linux-
> omap@vger.kernel.org Mailing List; video4linux-list@redhat.com
> Subject: Re: [PATCH] Add OMAP2 camera driver
> 
> * Hiremath, Vaibhav <hvaibhav@ti.com> [081203 01:38]:
> >
> >
> > Thanks,
> > Vaibhav Hiremath
> >
> > > -----Original Message-----
> > > From: Koen Kooi [mailto:k.kooi@student.utwente.nl]
> > > Sent: Wednesday, December 03, 2008 3:04 PM
> > > To: Hiremath, Vaibhav
> > > Cc: Trilok Soni; Hans Verkuil; Sakari Ailus; linux-
> > > omap@vger.kernel.org Mailing List; video4linux-list@redhat.com
> > > Subject: Re: [PATCH] Add OMAP2 camera driver
> > >
> > >
> > > Op 3 dec 2008, om 08:05 heeft Hiremath, Vaibhav het volgende
> > > geschreven:
> > > > OMAP3 -
> > > > 	Display - (Posted twice with old DSS library)
> > > > 		- omap_vout.c
> > > > 		- omap_voutlib.c
> > > > 		- omap_voutlib.h
> > > > 		- omap_voutdef.h
> > > > 	Camera - (Will come soon)
> > > > 		- omap34xxcam.c
> > > > 		- omap34xxcam.h
> > > > 	ISP - (Will come soon)
> > > > 		- Here definitely we will plenty number of files.
> > >
> > > Isn't DSS2 supposed to work on omap2 (and perhaps omap1) as
> well?
> > >
> > [Hiremath, Vaibhav] yes, but the DSS2 library goes under
> arch/arm/plat-omap/dss/. The above files are belongs to the driver
> underneath.
> 
> Huh? Why would it need to be under plat-omap?
> 
[Hiremath, Vaibhav] This is low level library which will export Kernel API's to top level driver like, Frame buffer and V4L2 driver. So this has to be in some common directory, and both patches on DSS (from Tomi and from TI) aligned to the same thing.

> Tony


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
