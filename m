Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARDoQd6021950
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 08:50:26 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARDoPCX019585
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 08:50:25 -0500
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>
References: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 08:52:03 -0500
Message-Id: <1227793923.3147.45.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Thu, 2008-11-27 at 11:23 +0100, Hans Verkuil wrote:
> > On Thu, 27 Nov 2008 08:32:22 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> >> Hi all,
> >>
> >> It been my opinion for quite some time now that we are too generous in
> >> the number of kernel versions we support. I think that the benefits no
> >> longer outweight the effort we have to put in.
> >>
> >> This is true in particular for the i2c support since that changed a lot
> >> over time. Kernel 2.6.22 is a major milestone for that since it
> >> introduced the new-style i2c API.
> >
> > I prefer to keep backward compat with older kernels. Enterprise distros
> > like
> > RHEL is shipped with older kernels (for example RHEL5 uses kernel 2.6.18).
> > We
> > should support those kernels.
> 
> Is RHEL (or anyone else for that matter) actually using our tree? I never
> see any postings about problems or requests for these old kernels on the
> v4l list.

And from those working on or using surveillance/security systems, I
suspect you might never hear anything.


> Do you know if and how other subsystems handle this?
> 
> >
> >> In order to keep the #ifdefs to a minimum I introduced the
> >> v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h headers. These make sense when
> >> used in the v4l-dvb tree context, but when they are stripped and used
> >> in the actual kernel source they look very weird.


"Looks very weird" in newer kernels is likely not a weighty criteria for
elimination of support of older kernels, if I were to put myself in the
place of someone using an older kernel that still needed v4l-dvb.

The question is how large is that subset of users?


> > We may use a different approach for the above files. For example, we may
> > include the headers just for older kernels, like we did in the past with
> > i2c
> > backward compat with kernel 2.4. gentree can easily remove a #include line
> > from
> > the upstream patch.
> 
> You either using these headers, or you start using lots of #ifdefs in each
> i2c driver. There is unfortunately no easy solution to this (I really
> tried at the time). Dropping pre-2.6.22 support will make it feasible to
> drop these headers. There would still be a few #ifdefs, but it will be
> acceptable.
> 
> If you know of a distro or big customer that is actually using v4l-dvb on
> old kernels, then I think we should keep it, but otherwise it is my
> opinion that it is not worth the (substantial) hassle. I also have my
> doubts about people using enterprise distros together with v4l. Doesn't
> seem very likely to me.

Does the following pass the plausibility test?

1. Large businesses or organizations, or their commercial suppliers, use
enterprise distributions to gain paid support and an OS that can get
through security accreditation processes.

2. Once a system has gone through an accreditation process, it is costly
to repeat the entire process - which a wholesale OS distribution upgrade
may force.  Accreditation of smaller changes may be less costly.

3. Large businesses and organizations are often interested in
surveillance applications, especially for security systems which require
some sort of accreditation.

4. Suppliers and users of security and surveillance systems won't likely
broadcast to large audiences what configurations their systems use.  

Regards,
Andy


> Regards,
> 
>        Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
