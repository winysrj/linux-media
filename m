Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB34foSh010964
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 23:41:50 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB34fYBq021150
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 23:41:35 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Trilok Soni <soni.trilok@gmail.com>
Date: Wed, 3 Dec 2008 10:11:13 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E90E6D27@dbde02.ent.ti.com>
In-Reply-To: <200812011357.09474.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Sakari Ailus <sakari.ailus@nokia.com>, "linux-omap@vger.kernel.org
	Mailing List" <linux-omap@vger.kernel.org>,
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
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Hans Verkuil
> Sent: Monday, December 01, 2008 6:27 PM
> To: Trilok Soni
> Cc: Sakari Ailus; linux-omap@vger.kernel.org Mailing List;
> video4linux-list@redhat.com
> Subject: Re: [PATCH] Add OMAP2 camera driver
> 
> On Friday 28 November 2008 11:07:15 Trilok Soni wrote:
> > Hi Hans
> >
> > > I'm in if the aim is to get this back to linux-omap. :-)
> (Waiting
> > > for the next patch from Trilok.)
> >
> > Attached the updated patch for OMAP2 camera driver.
> 
> Hi Trilok, Sakari,
> 
> I've merged it in my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-
> dvb
> 
> Is it OK for me to issue a pull request for that it can be merged in
> the
> v4l-dvb master?
> 

[Hiremath, Vaibhav] How about making a separate directory for OMAP, which will contain OMAP1/2/3 specific drivers?

> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
