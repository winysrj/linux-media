Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78EnAoZ019146
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:49:10 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78EleNi014918
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:47:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Fri, 8 Aug 2008 16:47:19 +0200
References: <200808081635.39745.hverkuil@xs4all.nl>
	<alpine.LFD.1.10.0808081038520.8762@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0808081038520.8762@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081647.19765.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFC: removal of the miroSOUND PCM20 radio module
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

On Friday 08 August 2008 16:41:59 you wrote:
> On Fri, 8 Aug 2008, Hans Verkuil wrote:
> > Hi all,
> >
> > I noticed that the miroSOUND PCM20 radio module is no longer
> > compiled in the kernel. After some digging I discovered that the
> > ACI mixer module this driver depends on was removed in 2.6.23 and
> > it's config section was removed from the Kconfig starting with
> > 2.6.20. So it can't be built in any kernels from 2.6.20 onwards.
> >
> > Since nobody complained in all that time, and since the ACI stuff
> > this driver depends on has been removed completely (so no easy fix
> > for this), I propose that this module is removed as well, together
> > with the aci.[ch] files that were copied to v4l-dvb, apparently to
> > allow this driver to be compiled from v4l-dvb.
> >
> > If there are no objections, then I'll try to contact the original
> > author(s) to see if they are OK with it.
>
> not sure if you noticed this, but adrian bunk already submitted a
> patch for that:
>
> http://marc.info/?l=linux-kernel&m=121795939208337&w=2

Obviously I didn't notice that :-)

Never mind about this then. Mauro, I assume you will remove it from 
v4l-dvb as well when you backport Adrian's patch?

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
