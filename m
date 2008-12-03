Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB375ZA3025380
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 02:05:35 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB375Ob3009925
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 02:05:24 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Trilok Soni <soni.trilok@gmail.com>
Date: Wed, 3 Dec 2008 12:35:08 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E90E6E06@dbde02.ent.ti.com>
In-Reply-To: <5d5443650812022248p28f42ce4n513dceb18adadeab@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
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
> From: Trilok Soni [mailto:soni.trilok@gmail.com]
> Sent: Wednesday, December 03, 2008 12:18 PM
> To: Hiremath, Vaibhav
> Cc: Hans Verkuil; Sakari Ailus; linux-omap@vger.kernel.org Mailing
> List; video4linux-list@redhat.com
> Subject: Re: [PATCH] Add OMAP2 camera driver
> 
> Hi Vaibhav,
> 
> >
> > [Hiremath, Vaibhav] How about making a separate directory for
> OMAP, which will contain OMAP1/2/3 specific drivers?
> >
> 
> I really don't want omap directory for OMAP1 and OMAP2 atleast. Even
> in my next patches for OMAP1 camera controller I am going to  remove
> "omap/" directory existing on linux-omap git history. For omap1 it
> is
> just two files camera_core.c and omap16xxcam.c, so no need of
> directory here. Even going further I am going to merge camera_core
> and
> omap16xxcam into one file, as I don't see code for any other omap1
> platform like omap15xxcam.
> 
> I don't know about OMAP3 ISP code, some one from TI should refresh
> those patches.
> 
[Hiremath, Vaibhav] I can tell you that for OMAP3 we do have lot of files coming in, and it really brings more confusion if we have OMAP1 and OMAP2 lying outside and OMAP3 code (Display + capture) say under omap/ or omap3/.

It makes sense to have omap/ directory, and all the versions/devices of OMAP get handled from omap/Kconfig and omap/Makefile. Even if they have single file it would be nice to follow directory layers.

Hans, Sakari or Mauro can provide their opinion on this, and decide how to handle this. 

I am just providing details, so that it would be easy to take decision - 

OMAP1 - (I have listed names from old O-L tree)
	- omap16xxcam.c
	- camera_core.c
	- camera_hw_if.h
	- omap16xxcam.h
	- camera_core.h

OMAP2 - (I have listed names from old O-L tree)
	- omap24xxcam.c
	- omap24xxcam-dma.c
	- omap24xxcam.h

In future may be display will add here.

OMAP3 - 
	Display - (Posted twice with old DSS library)
		- omap_vout.c
		- omap_voutlib.c
		- omap_voutlib.h
		- omap_voutdef.h
	Camera - (Will come soon)
		- omap34xxcam.c
		- omap34xxcam.h
	ISP - (Will come soon)
		- Here definitely we will plenty number of files.

> 
> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
