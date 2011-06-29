Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:8279 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab1F2L06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:26:58 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-3.cisco.com (8.14.3/8.14.3) with ESMTP id p5TBQuhS027955
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 11:26:56 GMT
Received: from cobaltpc1.localnet ([10.54.77.72])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p5TBQtXd029434
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 13:26:55 +0200
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: RFC: poll behavior
Date: Wed, 29 Jun 2011 13:26:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291326.47527.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

This RFC is based on recent discussions with regards to how the poll function 
in a V4L2 driver should behave. 

Some relevant documents:

POSIX:

http://pubs.opengroup.org/onlinepubs/009695399/functions/select.html
http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html
http://pubs.opengroup.org/onlinepubs/009695399/functions/read.html

V4L2 Spec:

http://linuxtv.org/downloads/v4l-dvb-apis/func-poll.html

I've copied some descriptions from the POSIX poll document below:

POLLIN
Data other than high-priority data may be read without blocking.

POLLERR
An error has occurred on the device or stream. This flag is only valid in the 
revents bitmask; it shall be ignored in the events member.

POLLHUP
The device has been disconnected. This event and POLLOUT are mutually-
exclusive; a stream can never be writable if a hangup has occurred. However, 
this event and POLLIN, POLLRDNORM, POLLRDBAND, or POLLPRI are not mutually-
exclusive. This flag is only valid in the revents bitmask; it shall be ignored 
in the events member.



1) How *should* it work?

Suppose we could redesign the way V4L2 handles poll(), how should it work?

There are three cases:

a) poll() called when streaming is in progress.

This is easy: if a buffer is available, then return POLLIN (or POLLOUT for 
output). If an event has arrived, then OR with POLLPRI.

b) poll() called when no streaming has started and the driver does not support 
the read/write API.

In this case poll() should return POLLERR, since calling poll() when no 
streaming is in progress makes no sense. POLLHUP seems an interesting 
alternative, but other than for end-of-file or end-of-stream conditions it's 
meaning is very fuzzy. Linux also has a POLLRDHUP to make things even more 
confusing. So I would just stick with POLLERR.

c) poll() called when no streaming has started and the driver supports the 
read/write API.

I see no reason why we would do anything different from b). Calling poll() 
when there is no streaming in progress clearly means that there is no data 
available and that there won't be any data either until streaming starts 
somehow.


2) How does it work today?

a) poll() called when streaming is in progress.

We follow the procedure outlined above. So this is fine.

b) poll() called when no streaming has started and the driver does not support 
the read/write API.

In this case POLLERR is returned. So this is also fine.

c) poll() called when no streaming has started and the driver supports the 
read/write API.

Here things are different. poll() will in this case start streaming 
automatically and either return POLLERR if there was an error when starting 
streaming, or return 0 so it will wait until the first buffer arrives.

The main problem is that it will also do this if the application only wants to 
poll for exceptions (POLLPRI). Unfortunately there is no reliable way in the 
kernel to discover whether the application wanted to poll for POLLIN or just 
for POLLPRI. This behavior simply kills applications that want to wait for 
e.g. changes in controls without actually starting streaming. An example is 
qv4l2.

Another problem is that starting streaming from within poll can take a long 
time depending on the hardware. And poll isn't supposed to take a long time 
(exceptions are calling poll for userspace file systems). Actually, until 
2.6.29 sleeping inside poll() wasn't even supported.

In my opinion poll should never start the capture process. There is nothing in 
the poll POSIX document that says that it should. It complicates drivers and 
it is an ugly side-effect.


3) What are the consequences if we changed the behavior of c?

Suppose we just changed the current behavior to the desired behavior. What 
would change for applications?

Obviously, nothing will change for drivers that do not support read/write.

For the others there will be a difference depending on whether the 
applications uses select(2) or poll(2). The select() function hides the exact 
event masked returned by the driver, so POLLERR will not show up as such, 
instead select() will just return and set the input or output mask of the 
corresponding fd. So there is no difference between POLLERR and POLLIN or 
POLLOUT as seen by the application.

What will change is when read() is called: if it is in non-blocking mode, then 
it will start the streaming and return -EAGAIN. If it is in blocking mode, 
then there is no visible change in behavior. So drivers must be able to handle 
that error code.

However, all applications must be able to handle that error anyway. It's part 
of the POSIX specification of a non-blocking read().

For applications that call poll(2) there will be a difference depending on 
what they do when they see a POLLERR: if they just ignore it and call read, 
then it is effectively identical to the select() case.

If they actually test for POLLERR and return an error, then this change will 
break such an application.

So the only time that a well-written application would break is when it uses 
poll(2) and read(2), and returns an error if POLLERR was set instead of just 
calling read().


4) Proposal to change the poll behavior

For the short term I propose that condition c is handled as follows:

If for the filehandle passed to poll() no events have been subscribed, then 
keep the old behavior (i.e. start streaming). If events have been subscribed, 
however, then implement the new behavior (return POLLERR).

Since events are new I think this is a safe change that will not affect 
existing applications.

In the long term I propose that we put this in the feature-removal-schedule 
for v3.3 or so and stop poll from starting streaming altogether.

Comments?

	Hans
