Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:64778 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2FLNVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 09:21:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 00/32] Core and vb2 enhancements
Date: Tue, 12 Jun 2012 15:21:38 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <201206102127.12029.hverkuil@xs4all.nl> <4FD7296E.9080400@redhat.com>
In-Reply-To: <4FD7296E.9080400@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206121521.38453.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 12 June 2012 13:35:10 Mauro Carvalho Chehab wrote:
> Em 10-06-2012 16:27, Hans Verkuil escreveu:
> > On Sun June 10 2012 19:32:36 Hans Verkuil wrote:
> >> On Sun June 10 2012 18:46:52 Mauro Carvalho Chehab wrote:
> >>> 3) it would be interesting if you could benchmark the previous code and the new
> >>> one, to see what gains this change introduced, in terms of v4l2-core footprint and
> >>> performance.
> >>
> >> I'll try that, should be interesting. Actually, my prediction is that I won't notice any
> >> difference. Todays CPUs are so fast that the overhead of the switch is probably hard to
> >> measure.
> > 
> > I did some tests, calling various ioctls 100,000,000 times. The actual call into the
> > driver was disabled so that I only measure the time spent in v4l2-ioctl.c.
> > 
> > I ran the test program with 'time ./t' and measured the sys time.
> > 
> > For each ioctl I tested 5 times and averaged the results. Times are in seconds.
> > 
> > 					Old		New
> > QUERYCAP			24.86	24.37
> > UNSUBSCRIBE_EVENT	23.40	23.10
> > LOG_STATUS			18.84	18.76
> > ENUMINPUT			28.82	28.90
> > 
> > Particularly for QUERYCAP and UNSUBSCRIBE_EVENT I found a small but reproducible
> > improvement in speed. The results for LOG_STATUS and ENUMINPUT are too close to
> > call.
> > 
> > After looking at the assembly code that the old code produces I suspect (but it
> > is hard to be sure) that LOG_STATUS and ENUMINPUT are tested quite early on, whereas
> > QUERYCAP and UNSUBSCRIBE_EVENT are tested quite late. The order in which the compiler
> > tests definitely has no relationship with the order of the case statements in the
> > switch.
> 
> The ioctl's are reordered, as gcc optimizes them in order to do a tree search and to avoid
> cache flush. The worse case is likely converted into 7 CMP asm calls (log2(128)).
> 
> On your code, gcc may not be able to predict the JMP's, so it may actually have cache flushes,
> depending on the cache size, and if the caller functions are before of after the video_ioctl2
> handler.
> 
> I suspect that, if you compare the code with debug enabled, the new code can actually be worse
> than the previous one.
> 
> It would be good if you could test what happens with QBUF/DQBUF.

Again, I'm averaging 5 runs of 100,000,000 calls with the actual (d)qbuf driver operation disabled.

QBUF old: 28.95s
QBUF new: 28.31s

DQBUF old: 28.89s
DQBUF new: 28.40s

The new code is faster by 1-3%.

The timings were very consistent with little variation.

BTW, just to put this in perspective: if you are streaming 60 frames per second, then that is
120 ioctl calls. With the old code those would take 34.704 usecs, with the new code 34.026 usecs.

So you win 0.678 usecs per second, which is about 2.5 milliseconds per hour.

I did this table conversion because it improves the code and because it makes it easy to have ioctl
annotations in the form of flags in the table that allowed me to do some fancy ioctl-specific
stuff. The speed increase is completely negligible. It is falls away compared to the much, much
more CPU intensive work of displaying or processing the image data. Only by artificial tests
as I did can you even measure it.

There are no performance issues in V4L2. There are code complexity, readability and maintainability
issues that are much more important and real. Our focus should be on those issues, not on
performance at this low level.

Regards,

	Hans

> > This would certainly explain what I am seeing. I'm actually a bit surprised that
> > this is measurable at all.
> 
> The timing difference is not significant, especially because those ioctl's aren't the ones
> used inside the streaming loop. The only ioctl's that are more time-sensitive are the streaming
> ones, especially QBUF/DQBUF.
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
