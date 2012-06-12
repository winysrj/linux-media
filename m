Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2FLLfe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 07:35:34 -0400
Message-ID: <4FD7296E.9080400@redhat.com>
Date: Tue, 12 Jun 2012 08:35:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 PATCH 00/32] Core and vb2 enhancements
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <4FD4CF7C.3020000@redhat.com> <201206101932.36886.hverkuil@xs4all.nl> <201206102127.12029.hverkuil@xs4all.nl>
In-Reply-To: <201206102127.12029.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 10-06-2012 16:27, Hans Verkuil escreveu:
> On Sun June 10 2012 19:32:36 Hans Verkuil wrote:
>> On Sun June 10 2012 18:46:52 Mauro Carvalho Chehab wrote:
>>> 3) it would be interesting if you could benchmark the previous code and the new
>>> one, to see what gains this change introduced, in terms of v4l2-core footprint and
>>> performance.
>>
>> I'll try that, should be interesting. Actually, my prediction is that I won't notice any
>> difference. Todays CPUs are so fast that the overhead of the switch is probably hard to
>> measure.
> 
> I did some tests, calling various ioctls 100,000,000 times. The actual call into the
> driver was disabled so that I only measure the time spent in v4l2-ioctl.c.
> 
> I ran the test program with 'time ./t' and measured the sys time.
> 
> For each ioctl I tested 5 times and averaged the results. Times are in seconds.
> 
> 					Old		New
> QUERYCAP			24.86	24.37
> UNSUBSCRIBE_EVENT	23.40	23.10
> LOG_STATUS			18.84	18.76
> ENUMINPUT			28.82	28.90
> 
> Particularly for QUERYCAP and UNSUBSCRIBE_EVENT I found a small but reproducible
> improvement in speed. The results for LOG_STATUS and ENUMINPUT are too close to
> call.
> 
> After looking at the assembly code that the old code produces I suspect (but it
> is hard to be sure) that LOG_STATUS and ENUMINPUT are tested quite early on, whereas
> QUERYCAP and UNSUBSCRIBE_EVENT are tested quite late. The order in which the compiler
> tests definitely has no relationship with the order of the case statements in the
> switch.

The ioctl's are reordered, as gcc optimizes them in order to do a tree search and to avoid
cache flush. The worse case is likely converted into 7 CMP asm calls (log2(128)).

On your code, gcc may not be able to predict the JMP's, so it may actually have cache flushes,
depending on the cache size, and if the caller functions are before of after the video_ioctl2
handler.

I suspect that, if you compare the code with debug enabled, the new code can actually be worse
than the previous one.

It would be good if you could test what happens with QBUF/DQBUF.

> This would certainly explain what I am seeing. I'm actually a bit surprised that
> this is measurable at all.

The timing difference is not significant, especially because those ioctl's aren't the ones
used inside the streaming loop. The only ioctl's that are more time-sensitive are the streaming
ones, especially QBUF/DQBUF.

Regards,
Mauro
