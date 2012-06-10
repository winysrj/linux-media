Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1791 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2FJT11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 15:27:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 00/32] Core and vb2 enhancements
Date: Sun, 10 Jun 2012 21:27:11 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <4FD4CF7C.3020000@redhat.com> <201206101932.36886.hverkuil@xs4all.nl>
In-Reply-To: <201206101932.36886.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206102127.12029.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun June 10 2012 19:32:36 Hans Verkuil wrote:
> On Sun June 10 2012 18:46:52 Mauro Carvalho Chehab wrote:
> > 3) it would be interesting if you could benchmark the previous code and the new
> > one, to see what gains this change introduced, in terms of v4l2-core footprint and
> > performance.
> 
> I'll try that, should be interesting. Actually, my prediction is that I won't notice any
> difference. Todays CPUs are so fast that the overhead of the switch is probably hard to
> measure.

I did some tests, calling various ioctls 100,000,000 times. The actual call into the
driver was disabled so that I only measure the time spent in v4l2-ioctl.c.

I ran the test program with 'time ./t' and measured the sys time.

For each ioctl I tested 5 times and averaged the results. Times are in seconds.

					Old		New
QUERYCAP			24.86	24.37
UNSUBSCRIBE_EVENT	23.40	23.10
LOG_STATUS			18.84	18.76
ENUMINPUT			28.82	28.90

Particularly for QUERYCAP and UNSUBSCRIBE_EVENT I found a small but reproducible
improvement in speed. The results for LOG_STATUS and ENUMINPUT are too close to
call.

After looking at the assembly code that the old code produces I suspect (but it
is hard to be sure) that LOG_STATUS and ENUMINPUT are tested quite early on, whereas
QUERYCAP and UNSUBSCRIBE_EVENT are tested quite late. The order in which the compiler
tests definitely has no relationship with the order of the case statements in the
switch.

This would certainly explain what I am seeing. I'm actually a bit surprised that
this is measurable at all.

Regards,

	Hans
