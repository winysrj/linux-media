Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50258 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab1F1XN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 19:13:58 -0400
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to
 the first read().
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 28 Jun 2011 19:14:11 -0400
In-Reply-To: <4E09CC6A.8080900@redhat.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
	 <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>
	 <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl>
	 <4E09B919.9040100@redhat.com>
	 <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>
	 <4E09CC6A.8080900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1309302853.2377.21.camel@palomino.walls.org>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-06-28 at 09:43 -0300, Mauro Carvalho Chehab wrote:
> Em 28-06-2011 09:21, Andy Walls escreveu:

> > It is also the case that a driver's poll method should never sleep.
> 
> True.

> > One issue is how to start streaming with apps that:
> > - Open /dev/video/ in a nonblocking mode, and
> > - Use the read() method
> > 
> > while doing it in a way that is POSIX compliant and doesn't break existing apps.  
> 
> Well, a first call for poll() may rise a thread that will prepare the buffers, and
> return with 0 while there's no data available.

Sure, but that doesn't solve the problem of an app only select()-ing or
poll()-ing for exception fd's and not starting any IO.


> > The other constraint is to ensure when only poll()-ing for exception
> conditions, not having significant IO side effects.
> > 
> > I'm pretty sure sleeping in a driver's poll() method, or having
> significant side effects, is not ine the spirit of the POSIX select()
> and poll(), even if the letter of POSIX says nothing about it.
> > 
> > The method I suggested to Hans is completely POSIX compliant for
> apps using read() and select() and was checked against MythTV as
> having no bad side effects.  (And by thought experiment doesn't break
> any sensible app using nonblocking IO with select() and read().)
> > 
> > I did not do analysis for apps that use mmap(), which I guess is the
> current concern.
> 
> The concern is that it is pointing that there are available data, even
> when there is an error.
> This looks like a POSIX violation for me.

It isn't.

>From the specification for select():
http://pubs.opengroup.org/onlinepubs/009695399/functions/select.html

"A descriptor shall be considered ready for reading when a call to an
input function with O_NONBLOCK clear would not block, whether or not the
function would transfer data successfully. (The function might return
data, an end-of-file indication, or an error other than one indicating
that it is blocked, and in each of these cases the descriptor shall be
considered ready for reading.)"

To a userspace app, a non-blocking read() can always return an error,
regarless of the previous select() or poll() result.  And all
applications that use select() or poll() folowed by a nonblocking read()
should be prepared to handle an errno from the read().

However, that excerpt from the select() specification does imply, that
perhaps, the driver should probably start streaming using a work item
and one of the CMWQ workers, so that the read() doesn't block.

Regards,
Andy


