Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1F2MJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:09:44 -0400
Message-ID: <4E0B1644.5030809@redhat.com>
Date: Wed, 29 Jun 2011 14:10:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: RFC: poll behavior
References: <201106291326.47527.hansverk@cisco.com>
In-Reply-To: <201106291326.47527.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/29/2011 01:26 PM, Hans Verkuil wrote:
> Hi all,
>
> This RFC is based on recent discussions with regards to how the poll function
> in a V4L2 driver should behave.
>
> Some relevant documents:
>
> POSIX:
>
> http://pubs.opengroup.org/onlinepubs/009695399/functions/select.html
> http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html
> http://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
>
> V4L2 Spec:
>
> http://linuxtv.org/downloads/v4l-dvb-apis/func-poll.html
>
> I've copied some descriptions from the POSIX poll document below:
>
> POLLIN
> Data other than high-priority data may be read without blocking.
>
> POLLERR
> An error has occurred on the device or stream. This flag is only valid in the
> revents bitmask; it shall be ignored in the events member.
>
> POLLHUP
> The device has been disconnected. This event and POLLOUT are mutually-
> exclusive; a stream can never be writable if a hangup has occurred. However,
> this event and POLLIN, POLLRDNORM, POLLRDBAND, or POLLPRI are not mutually-
> exclusive. This flag is only valid in the revents bitmask; it shall be ignored
> in the events member.
>
>
>
> 1) How *should* it work?
>
> Suppose we could redesign the way V4L2 handles poll(), how should it work?
>
> There are three cases:
>
> a) poll() called when streaming is in progress.
>
> This is easy: if a buffer is available, then return POLLIN (or POLLOUT for
> output). If an event has arrived, then OR with POLLPRI.
>
> b) poll() called when no streaming has started and the driver does not support
> the read/write API.
>
> In this case poll() should return POLLERR, since calling poll() when no
> streaming is in progress makes no sense. POLLHUP seems an interesting
> alternative, but other than for end-of-file or end-of-stream conditions it's
> meaning is very fuzzy. Linux also has a POLLRDHUP to make things even more
> confusing. So I would just stick with POLLERR.
>
> c) poll() called when no streaming has started and the driver supports the
> read/write API.
>
> I see no reason why we would do anything different from b). Calling poll()
> when there is no streaming in progress clearly means that there is no data
> available and that there won't be any data either until streaming starts
> somehow.
>
>
> 2) How does it work today?
>
> a) poll() called when streaming is in progress.
>
> We follow the procedure outlined above. So this is fine.
>
> b) poll() called when no streaming has started and the driver does not support
> the read/write API.
>
> In this case POLLERR is returned. So this is also fine.
>
> c) poll() called when no streaming has started and the driver supports the
> read/write API.
>
> Here things are different. poll() will in this case start streaming
> automatically and either return POLLERR if there was an error when starting
> streaming, or return 0 so it will wait until the first buffer arrives.

Right, to clarify, in this case the drivers assume the app wants r/w mode and
streaming is started for r/w mode, not in mmap mode even if the drivers support
both.

> The main problem is that it will also do this if the application only wants to
> poll for exceptions (POLLPRI). Unfortunately there is no reliable way in the
> kernel to discover whether the application wanted to poll for POLLIN or just
> for POLLPRI. This behavior simply kills applications that want to wait for
> e.g. changes in controls without actually starting streaming. An example is
> qv4l2.
>
> Another problem is that starting streaming from within poll can take a long
> time depending on the hardware. And poll isn't supposed to take a long time
> (exceptions are calling poll for userspace file systems). Actually, until
> 2.6.29 sleeping inside poll() wasn't even supported.
>
> In my opinion poll should never start the capture process. There is nothing in
> the poll POSIX document that says that it should. It complicates drivers and
> it is an ugly side-effect.
>

Agreed, even more important then the timing issue, poll should simply not
have side effects, and starting the stream is a rather large side effect!

>
> 3) What are the consequences if we changed the behavior of c?
>
> Suppose we just changed the current behavior to the desired behavior. What
> would change for applications?
>
> Obviously, nothing will change for drivers that do not support read/write.
>
> For the others there will be a difference depending on whether the
> applications uses select(2) or poll(2). The select() function hides the exact
> event masked returned by the driver, so POLLERR will not show up as such,
> instead select() will just return and set the input or output mask of the
> corresponding fd. So there is no difference between POLLERR and POLLIN or
> POLLOUT as seen by the application.
>
> What will change is when read() is called: if it is in non-blocking mode, then
> it will start the streaming and return -EAGAIN. If it is in blocking mode,
> then there is no visible change in behavior. So drivers must be able to handle
> that error code.
>
> However, all applications must be able to handle that error anyway. It's part
> of the POSIX specification of a non-blocking read().

Note that the only app I know of which actually does a select() *before* its
first read() is:
http://v4l2spec.bytesex.org/spec/capture-example.html

I think this is the only one as libv4l did not handle this case
correctly for a long time, until someone complained that our example own
code did not work with libv4l. But someone may have copied our example
code somewhere ...

> For applications that call poll(2) there will be a difference depending on
> what they do when they see a POLLERR: if they just ignore it and call read,
> then it is effectively identical to the select() case.
>
> If they actually test for POLLERR and return an error, then this change will
> break such an application.
>
> So the only time that a well-written application would break is when it uses
> poll(2) and read(2), and returns an error if POLLERR was set instead of just
> calling read().

Right, I don't think such an application exists not even a proprietary one,
most apps tend to stick with select rather then use poll. and most v4l apps
tend to be a bit old anyways, so...

Hmm, then again this may bite gstreamer in the case of r/w
mode only devices.

> 4) Proposal to change the poll behavior
>
> For the short term I propose that condition c is handled as follows:
>
> If for the filehandle passed to poll() no events have been subscribed, then
> keep the old behavior (i.e. start streaming). If events have been subscribed,
> however, then implement the new behavior (return POLLERR).
>

If events have been subscribed and no events are pending then the right
behavior would be to return 0, not POLLERR, otherwise a waiting app
will return from the poll immediately, or am I missing something?

> Since events are new I think this is a safe change that will not affect
> existing applications.
>
> In the long term I propose that we put this in the feature-removal-schedule
> for v3.3 or so and stop poll from starting streaming altogether.

Alternative suggestion:

In scenario c + there are no events subscribed simply return POLL_IN /
POLL_OUT, iow signal the app, sure you're free to do a read / write to
start streaming, no need to wait with that :)

Advantages
-we stop starting the stream from poll *now*
-for select we only set an fd in read or write fds, depending
  on the devices capabilities + file rights, rather then both
-for poll we don't return POLL_ERR, potentially breaking apps
  (I highly doubt broken apps will be fixed as quickly as you
   want, skype has yet to move to libv4l ...)

Disadvantages:
-if an app falls in scenario c, and uses poll, and non blocking
  mode and does not handle EAGAIN from read, the app breaks

As said already not handling EAGAIN in non blocking mode is
against posix...

Regards,

Hans
