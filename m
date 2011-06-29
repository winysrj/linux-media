Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1F2Lhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:37:37 -0400
Message-ID: <4E0B0E75.5030505@redhat.com>
Date: Wed, 29 Jun 2011 08:37:25 -0300
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
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>	 <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>	 <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl>	 <4E09B919.9040100@redhat.com>	 <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>	 <4E09CC6A.8080900@redhat.com> <1309302853.2377.21.camel@palomino.walls.org>	 <4E0A6B18.8030407@redhat.com> <1309324089.2359.89.camel@palomino.walls.org>
In-Reply-To: <1309324089.2359.89.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-06-2011 02:08, Andy Walls escreveu:
> On Tue, 2011-06-28 at 21:00 -0300, Mauro Carvalho Chehab wrote:
>> Em 28-06-2011 20:14, Andy Walls escreveu:
>>> On Tue, 2011-06-28 at 09:43 -0300, Mauro Carvalho Chehab wrote:
>>>> Em 28-06-2011 09:21, Andy Walls escreveu:
>>>
>>>>> It is also the case that a driver's poll method should never sleep.
>>>>
>>>> True.
>>>
>>>>> One issue is how to start streaming with apps that:
>>>>> - Open /dev/video/ in a nonblocking mode, and
>>>>> - Use the read() method
>>>>>
>>>>> while doing it in a way that is POSIX compliant and doesn't break existing apps.  
>>>>
>>>> Well, a first call for poll() may rise a thread that will prepare the buffers, and
>>>> return with 0 while there's no data available.
>>>
>>> Sure, but that doesn't solve the problem of an app only select()-ing or
>>> poll()-ing for exception fd's and not starting any IO.
>>
>> Well, a file descriptor can be used only for one thing: or it is a stream file
>> descriptor, or it is an event descriptor. You can't have both for the same
>> file descriptor. If an application need to check for both, the standard Unix way is:
>>
>> 	fd_set set;
>>
>> 	FD_ZERO (&set);
>> 	FD_SET (fd_stream, &set);
>> 	FD_SET (fd_event, &set);
>>
>> 	select (FD_SETSIZE, &set, NULL, NULL, &timeout);
>>
>> In other words, or the events nodes need to be different, or an ioctl is needed
>> in order to tell the Kernel that the associated file descriptor will be used
>> for an event, and that vb2 should not bother with it.
> 
> Um, no, that is not correct for Unix fd's and socket descriptors in
> general.  I realize that v4l2 events need to be enabled with an ioctl(),
> but do we have a restriction that that can't happen on the same fd as
> the one used for streaming?
> 
> Back in the days before threads were commonly available on Unix systems,
> a process would use a single thread calling select() to handle I/O on a
> serial port:
> 
> 	fd_set rfds, wfds;
> 	int ttyfd;
> 	...
> 	FD_ZERO(&rfds);
> 	FD_SET(ttyfd, &rfds);
> 	FD_ZERO(&wfds);
> 	FD_SET(ttyfd, &wfds);
> 
> 	n = select(ttyfd+1, &rfds, &wfds, NULL, NULL);
> 
> Or TCP socket
> 
> 	fd_set rfds, wfds, efds;
> 	int sockd;
> 	...
> 	FD_ZERO(&rfds);
> 	FD_SET(sockd, &rfds);
> 	FD_ZERO(&wfds);
> 	FD_SET(sockd, &wfds);
> 	FD_ZERO(&efds);
> 	FD_SET(sockd, &efds);
> 
> 	n = select(sockd+1, &rfds, &wfds, &efds, NULL);

On both serial and socket devices, if select returns a file descriptor,
the data is there or the device/socket got disconnected.

> Waiting for data to arrive on an fd, while not streaming is an error
> condition for select() should return. 

Yes, but poll() starts the streaming, if the mmap mode were not started, 
according with the V4L2 spec:
	http://linuxtv.org/downloads/v4l-dvb-apis/func-poll.html

Thanks,
Mauro.
