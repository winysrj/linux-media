Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAREL1Ao004181
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:21:01 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAREKf5o003060
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:20:41 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 27 Nov 2008 15:20:48 +0100
References: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>
	<20081127120814.14f25c1b@pedra.chehab.org>
In-Reply-To: <20081127120814.14f25c1b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271520.48202.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFC: drop support for kernels < 2.6.22
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

On Thursday 27 November 2008, Mauro Carvalho Chehab wrote:
> On Thu, 27 Nov 2008 11:23:12 +0100 (CET)
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> > > On Thu, 27 Nov 2008 08:32:22 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >> Hi all,
> > >>
> > >> It been my opinion for quite some time now that we are too generous in
> > >> the number of kernel versions we support. I think that the benefits no
> > >> longer outweight the effort we have to put in.
> > >>
> > >> This is true in particular for the i2c support since that changed a
> > >> lot over time. Kernel 2.6.22 is a major milestone for that since it
> > >> introduced the new-style i2c API.
> > >
> > > I prefer to keep backward compat with older kernels. Enterprise distros
> > > like RHEL is shipped with older kernels (for example RHEL5 uses kernel
> > > 2.6.18). We should support those kernels.
> >
> > Is RHEL (or anyone else for that matter) actually using our tree? I never
> > see any postings about problems or requests for these old kernels on the
> > v4l list.
>
> RHEL bugs come to redhat bugzilla. Generated patches there should be tested
> against the latest version and applied upstream.
>
> > If you know of a distro or big customer that is actually using v4l-dvb on
> > old kernels, then I think we should keep it, but otherwise it is my
> > opinion that it is not worth the (substantial) hassle. I also have my
> > doubts about people using enterprise distros together with v4l. Doesn't
> > seem very likely to me.
>
> Yes, there are customers with enterprise distros using V4L drivers.
>
> Also, I am using V4L/DVB tree with a 2.6.18 kernel on some machines.
> Removing support for 2.6.18 will be a pain for me.
>
> I suspect that Laurent is also using RHEL (or some uvc users), since he
> sent some patches fixing compilation with RHEL.

Before moving to linuxtv.org the UVC driver was backward compatible with all 
kernels starting at 2.6.15 out of the box. With a minor patch applied this 
even extended to 2.6.10. While I have no statistics regarding kernel versions 
on which the UVC driver is used, the driver seems to be popular with embedded 
users who usually run "old" vendor-supplied kernels on their systems.

As such, at least for the UVC driver, I'd hate to see compatibility with 
2.6.16-2.6.21 going away anytime soon.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
