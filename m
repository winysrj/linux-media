Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51438 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab1F2FH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 01:07:58 -0400
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to
 the first read().
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 29 Jun 2011 01:08:08 -0400
In-Reply-To: <4E0A6B18.8030407@redhat.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
	 <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>
	 <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl>
	 <4E09B919.9040100@redhat.com>
	 <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>
	 <4E09CC6A.8080900@redhat.com> <1309302853.2377.21.camel@palomino.walls.org>
	 <4E0A6B18.8030407@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1309324089.2359.89.camel@palomino.walls.org>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-06-28 at 21:00 -0300, Mauro Carvalho Chehab wrote:
> Em 28-06-2011 20:14, Andy Walls escreveu:
> > On Tue, 2011-06-28 at 09:43 -0300, Mauro Carvalho Chehab wrote:
> >> Em 28-06-2011 09:21, Andy Walls escreveu:
> > 
> >>> It is also the case that a driver's poll method should never sleep.
> >>
> >> True.
> > 
> >>> One issue is how to start streaming with apps that:
> >>> - Open /dev/video/ in a nonblocking mode, and
> >>> - Use the read() method
> >>>
> >>> while doing it in a way that is POSIX compliant and doesn't break existing apps.  
> >>
> >> Well, a first call for poll() may rise a thread that will prepare the buffers, and
> >> return with 0 while there's no data available.
> > 
> > Sure, but that doesn't solve the problem of an app only select()-ing or
> > poll()-ing for exception fd's and not starting any IO.
> 
> Well, a file descriptor can be used only for one thing: or it is a stream file
> descriptor, or it is an event descriptor. You can't have both for the same
> file descriptor. If an application need to check for both, the standard Unix way is:
> 
> 	fd_set set;
> 
> 	FD_ZERO (&set);
> 	FD_SET (fd_stream, &set);
> 	FD_SET (fd_event, &set);
> 
> 	select (FD_SETSIZE, &set, NULL, NULL, &timeout);
> 
> In other words, or the events nodes need to be different, or an ioctl is needed
> in order to tell the Kernel that the associated file descriptor will be used
> for an event, and that vb2 should not bother with it.

Um, no, that is not correct for Unix fd's and socket descriptors in
general.  I realize that v4l2 events need to be enabled with an ioctl(),
but do we have a restriction that that can't happen on the same fd as
the one used for streaming?

Back in the days before threads were commonly available on Unix systems,
a process would use a single thread calling select() to handle I/O on a
serial port:

	fd_set rfds, wfds;
	int ttyfd;
	...
	FD_ZERO(&rfds);
	FD_SET(ttyfd, &rfds);
	FD_ZERO(&wfds);
	FD_SET(ttyfd, &wfds);

	n = select(ttyfd+1, &rfds, &wfds, NULL, NULL);

Or TCP socket

	fd_set rfds, wfds, efds;
	int sockd;
	...
	FD_ZERO(&rfds);
	FD_SET(sockd, &rfds);
	FD_ZERO(&wfds);
	FD_SET(sockd, &wfds);
	FD_ZERO(&efds);
	FD_SET(sockd, &efds);

	n = select(sockd+1, &rfds, &wfds, &efds, NULL);



> >>> The other constraint is to ensure when only poll()-ing for exception
> >> conditions, not having significant IO side effects.
> >>>
> >>> I'm pretty sure sleeping in a driver's poll() method, or having
> >> significant side effects, is not ine the spirit of the POSIX select()
> >> and poll(), even if the letter of POSIX says nothing about it.
> >>>
> >>> The method I suggested to Hans is completely POSIX compliant for
> >> apps using read() and select() and was checked against MythTV as
> >> having no bad side effects.  (And by thought experiment doesn't break
> >> any sensible app using nonblocking IO with select() and read().)
> >>>
> >>> I did not do analysis for apps that use mmap(), which I guess is the
> >> current concern.
> >>
> >> The concern is that it is pointing that there are available data, even
> >> when there is an error.
> >> This looks like a POSIX violation for me.
> > 
> > It isn't.
> > 
> > From the specification for select():
> > http://pubs.opengroup.org/onlinepubs/009695399/functions/select.html
> > 
> > "A descriptor shall be considered ready for reading when a call to an
> > input function with O_NONBLOCK clear would not block, whether or not the
> > function would transfer data successfully. (The function might return
> > data, an end-of-file indication, or an error other than one indicating
> > that it is blocked, and in each of these cases the descriptor shall be
> > considered ready for reading.)"
> 
> My understanding from the above is that "ready" means:
> 	- data;
> 	- EOF;
> 	- error.

Waiting for data to arrive on an fd, while not streaming is an error
condition for select() should return.  Something has to be done about
that fd in that case, or select()-ing on it is futile.


> if POLLIN (or POLLOUT) is returned, it should mean one of the above, e. g.
> the device is ready to provide data or some error occurred.
> 
> Btw, we're talking about poll(), and not select(). The poll() doc is clearer
> (http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html):
> 
> POLLIN
>     Data other than high-priority data may be read without blocking. 
> 
> POLLOUT
>     Normal data may be written without blocking. 
> 
> Saying that a -EAGAIN means that data is "ready" is an API abuse.

EAGAIN is the correct errno fo the read that returns no data.  The abuse
is the revent value returned from poll().  However, for any application
that open()s a device node that supports mutliple open()s, it is a valid
circumstance that can happen with POSIX.

One way to avoid abusing the revent value returned by poll(), for the
initial poll() call where streaming has not started, is to modify the
kernel infrastructure that calls the driver poll() methods.  If the
kernel passes down to the driver for what the caller is polling, the
driver poll() method could know that only the exception set for an fd
was being poll()-ed.  In that case, the driver would know not to start
streaming and use a return value that made sense.

That solution seems like a lot of work and a large perturbation to the
kernel.

The only other solution I can think of is to do nothing.  Then
v4l2-event monitoring will always have the unfortunate side effect of
starting the stream.


>  This
> can actually work, but it will effectively mean that poll or select won't
> do anything, except for wasting a some CPU cycles.

The wasted CPU cycles are an insignificant, one-time penalty during the
first iteration of a loop that will use several orders of magnitude more
CPU cycles to fetch and process video data. 

It avoids unecessarily prohibiting modification of v4l2 controls or
other resources that cannot be modified while streaming, for an
application that is in a phase where it only wishes to poll() for v4l2
events without starting a stream.

It mainatins backward compatability with existing programs.  Those
existing programs *must* handle read() errors after select() or poll()
indicates that the fd won't block on the next read(), and the call to
read() will start the stream.

Regards,
Andy

> Cheers,
> Mauro.


