Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab1F2AAf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 20:00:35 -0400
Message-ID: <4E0A6B18.8030407@redhat.com>
Date: Tue, 28 Jun 2011 21:00:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to
 the first read().
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>	 <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>	 <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl>	 <4E09B919.9040100@redhat.com>	 <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>	 <4E09CC6A.8080900@redhat.com> <1309302853.2377.21.camel@palomino.walls.org>
In-Reply-To: <1309302853.2377.21.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-06-2011 20:14, Andy Walls escreveu:
> On Tue, 2011-06-28 at 09:43 -0300, Mauro Carvalho Chehab wrote:
>> Em 28-06-2011 09:21, Andy Walls escreveu:
> 
>>> It is also the case that a driver's poll method should never sleep.
>>
>> True.
> 
>>> One issue is how to start streaming with apps that:
>>> - Open /dev/video/ in a nonblocking mode, and
>>> - Use the read() method
>>>
>>> while doing it in a way that is POSIX compliant and doesn't break existing apps.  
>>
>> Well, a first call for poll() may rise a thread that will prepare the buffers, and
>> return with 0 while there's no data available.
> 
> Sure, but that doesn't solve the problem of an app only select()-ing or
> poll()-ing for exception fd's and not starting any IO.

Well, a file descriptor can be used only for one thing: or it is a stream file
descriptor, or it is an event descriptor. You can't have both for the same
file descriptor. If an application need to check for both, the standard Unix way is:

	fd_set set;

	FD_ZERO (&set);
	FD_SET (fd_stream, &set);
	FD_SET (fd_event, &set);

	select (FD_SETSIZE, &set, NULL, NULL, &timeout);

In other words, or the events nodes need to be different, or an ioctl is needed
in order to tell the Kernel that the associated file descriptor will be used
for an event, and that vb2 should not bother with it.

>>> The other constraint is to ensure when only poll()-ing for exception
>> conditions, not having significant IO side effects.
>>>
>>> I'm pretty sure sleeping in a driver's poll() method, or having
>> significant side effects, is not ine the spirit of the POSIX select()
>> and poll(), even if the letter of POSIX says nothing about it.
>>>
>>> The method I suggested to Hans is completely POSIX compliant for
>> apps using read() and select() and was checked against MythTV as
>> having no bad side effects.  (And by thought experiment doesn't break
>> any sensible app using nonblocking IO with select() and read().)
>>>
>>> I did not do analysis for apps that use mmap(), which I guess is the
>> current concern.
>>
>> The concern is that it is pointing that there are available data, even
>> when there is an error.
>> This looks like a POSIX violation for me.
> 
> It isn't.
> 
> From the specification for select():
> http://pubs.opengroup.org/onlinepubs/009695399/functions/select.html
> 
> "A descriptor shall be considered ready for reading when a call to an
> input function with O_NONBLOCK clear would not block, whether or not the
> function would transfer data successfully. (The function might return
> data, an end-of-file indication, or an error other than one indicating
> that it is blocked, and in each of these cases the descriptor shall be
> considered ready for reading.)"

My understanding from the above is that "ready" means:
	- data;
	- EOF;
	- error.

if POLLIN (or POLLOUT) is returned, it should mean one of the above, e. g.
the device is ready to provide data or some error occurred.

Btw, we're talking about poll(), and not select(). The poll() doc is clearer
(http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html):

POLLIN
    Data other than high-priority data may be read without blocking. 

POLLOUT
    Normal data may be written without blocking. 

Saying that a -EAGAIN means that data is "ready" is an API abuse. This
can actually work, but it will effectively mean that poll or select won't
do anything, except for wasting a some CPU cycles.

> To a userspace app, a non-blocking read() can always return an error,
> regarless of the previous select() or poll() result.  And all
> applications that use select() or poll() folowed by a nonblocking read()
> should be prepared to handle an errno from the read().
> 
> However, that excerpt from the select() specification does imply, that
> perhaps, the driver should probably start streaming using a work item
> and one of the CMWQ workers, so that the read() doesn't block.

Cheers,
Mauro.
