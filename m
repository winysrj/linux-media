Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:61022 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3LJUyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 15:54:05 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXL00AKRZE46W00@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Dec 2013 15:54:04 -0500 (EST)
Date: Tue, 10 Dec 2013 18:53:59 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Wade Farnsworth <wade_farnsworth@mentor.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
Message-id: <20131210185359.49f3f020@samsung.com>
In-reply-to: <5290DDD8.7070305@xs4all.nl>
References: <52614DB9.8090908@mentor.com> <528FB50C.6060909@mentor.com>
 <529090A9.7030505@xs4all.nl> <5290D826.5080308@gmail.com>
 <5290DDD8.7070305@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 Nov 2013 17:54:48 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/23/2013 05:30 PM, Sylwester Nawrocki wrote:
> > Hi,
> > 
> > On 11/23/2013 12:25 PM, Hans Verkuil wrote:
> >> Hi Wade,
> >>
> >> On 11/22/2013 08:48 PM, Wade Farnsworth wrote:
> >>> Add tracepoints to the QBUF and DQBUF ioctls to enable rudimentary
> >>> performance measurements using standard kernel tracers.
> >>>
> >>> Signed-off-by: Wade Farnsworth<wade_farnsworth@mentor.com>
> >>> ---
> >>>
> >>> This is the update to the RFC patch I posted a few weeks back.  I've added
> >>> several bits of metadata to the tracepoint output per Mauro's suggestion.
> >>
> >> I don't like this. All v4l2 ioctls can already be traced by doing e.g.
> >> echo 1 (or echo 2)>/sys/class/video4linux/video0/debug.
> >>
> >> So this code basically duplicates that functionality. It would be nice to be able
> >> to tie in the existing tracing code (v4l2-ioctl.c) into tracepoints.
> > 
> > I think it would be really nice to have this kind of support for standard
> > traces at the v4l2 subsystem. Presumably it could even gradually replace
> > the v4l2 custom debug infrastructure.
> > 
> > If I understand things correctly, the current tracing/profiling 
> > infrastructure
> > is much less invasive than inserting printks all over, which may cause 
> > changes
> > in control flow. I doubt the system could be reliably profiled by 
> > enabling all
> > those debug prints.
> > 
> > So my vote would be to add support for standard tracers, like in other
> > subsystems in the kernel.
> 
> The reason for the current system is to trace which ioctls are called in
> what order by a misbehaving application. It's very useful for that,
> especially when trying to debug user problems.
> 
> I don't mind switching to tracepoints as long as this functionality is
> kept one way or another.

I agree with Sylwester: we should move to tracepoints, and this is a good
start.

Regards,
Mauro
