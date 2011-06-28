Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55362 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526Ab1F1MV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 08:21:59 -0400
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com> <4E08FBA5.5080006@redhat.com> <201106280933.57364.hverkuil@xs4all.nl> <4E09B919.9040100@redhat.com>
In-Reply-To: <4E09B919.9040100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to the first read().
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 28 Jun 2011 08:21:51 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <cd2c9732-aee5-492b-ade2-bee084f79739@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>Em 28-06-2011 04:33, Hans Verkuil escreveu:
>> On Monday, June 27, 2011 23:52:37 Mauro Carvalho Chehab wrote:
>>> Em 07-06-2011 12:05, Hans Verkuil escreveu:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> The vb2_poll function would start read-DMA if called without any
>streaming
>>>> in progress. This unfortunately does not work if the application
>just wants
>>>> to poll for exceptions. This information of what the application is
>polling
>>>> for is sadly unavailable in the driver.
>>>>
>>>> Andy Walls suggested to just return POLLIN | POLLRDNORM and let the
>first
>>>> call to read() start the DMA. This initial read() call will return
>EAGAIN
>>>> since no actual data is available yet, but it does start the DMA.
>>>>
>>>> Applications must handle EAGAIN in any case since there can be
>other reasons
>>>> for EAGAIN as well.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/video/videobuf2-core.c |   17 +++--------------
>>>>  1 files changed, 3 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/videobuf2-core.c
>b/drivers/media/video/videobuf2-core.c
>>>> index 6ba1461..ad75c95 100644
>>>> --- a/drivers/media/video/videobuf2-core.c
>>>> +++ b/drivers/media/video/videobuf2-core.c
>>>> @@ -1372,27 +1372,16 @@ static int __vb2_cleanup_fileio(struct
>vb2_queue *q);
>>>>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file,
>poll_table *wait)
>>>>  {
>>>>  	unsigned long flags;
>>>> -	unsigned int ret;
>>>>  	struct vb2_buffer *vb = NULL;
>>>>  
>>>>  	/*
>>>>  	 * Start file I/O emulator only if streaming API has not been
>used yet.
>>>>  	 */
>>>>  	if (q->num_buffers == 0 && q->fileio == NULL) {
>>>> -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
>>>> -			ret = __vb2_init_fileio(q, 1);
>>>> -			if (ret)
>>>> -				return POLLERR;
>>>> -		}
>>>> -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
>>>> -			ret = __vb2_init_fileio(q, 0);
>>>> -			if (ret)
>>>> -				return POLLERR;
>>>> -			/*
>>>> -			 * Write to OUTPUT queue can be done immediately.
>>>> -			 */
>>>> +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
>>>> +			return POLLIN | POLLRDNORM;
>>>> +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
>>>>  			return POLLOUT | POLLWRNORM;
>>>> -		}
>>>>  	}
>>>
>>> There is one behavior change on this patchset:  __vb2_init_fileio()
>checks for some
>>> troubles that may happen during device streaming initialization,
>returning POLLERR
>>> if there is a problem there.
>>>
>>> By moving this code to be called only at read, it means the poll()
>will not fail
>>> anymore, but the first read() will fail. The man page for read()
>doesn't tell that
>>> -EBUSY or -ENOMEM could happen there. The same happens with V4L2
>specs. So, it is
>>> clearly violating kernel ABI.
>>>
>>> NACK.
>> 
>> Actually, almost nothing changes in the ABI. It's counterintuitive,
>but
>> this is what happens:
>> 
>> 1) The poll() function in a driver does not actually return any error
>codes.
>> It never did. It returns a poll mask, which is expected to be POLLERR
>in case
>> of any error. All that it does is that select() returns if it waits
>for reading
>> or writing. Any actual error codes are never propagated. 
>
>Yes, but POLLERR will return error on the vb2 cases that return -EBUSY
>or -ENOMEM.
>This doesn't violate the ioctl ABI.
>
>> This means BTW that
>> our poll manual page is wrong (what a surprise), most of those error
>codes can
>> never be returned.
>
>True. The DocBook needs a fix. Posix describes it as:
>	http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html
>
>> 
>> 2) Suppose we try to start streaming in poll. If this works, then
>poll returns,
>> with POLLIN set, and the next read() will succeed (actually, it can
>return an
>> error as well, but for other error conditions in case of e.g.
>hardware errors).
>> 
>> The problem with this is of course that this will also start the
>streaming if
>> all we wanted to wait for was an exception. That's not what we want
>at all.
>> Ideally we could inspect in the driver what the caller wanted to wait
>for, but
>> that information is not available, unfortunately.
>> 
>> 3) The other case is that we try to start streaming in poll and it
>fails.
>> In that case any errors are lost and poll returns POLLERR (note that
>the poll(2)
>> manual page says that POLLERR is for output only, but clearly in the
>linux
>> kernel it is accepted both input and output).
>
>Posix doesn't impose such restriction.
>
>> But for the select() call this POLLERR information is lost as well
>and the
>> application will call read() anyway, which now will attempt to start
>the
>> streaming (again after poll() tried it the first time) and this time
>it
>> returns the actual error code.
>
>The posix list of acceptable errors are:
>	http://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
>On that list, ENOMEM seems to be acceptable, but EBUSY doesn't.
>
>We should not use anything outside the acceptable error codes there, as
>otherwise,
>applications like cat, more, less, etc may not work. The read interface
>should
>be simple enough to allow applications that are not aware of the V4L2
>api to
>work. So, it should follow whatever supported by standard files.
>
>> Just try this with capture-example: start it in mmap mode, then try
>to run
>> it in read mode from a second console. The EBUSY error comes from the
>read()
>> command, not from select(). With or without this patch,
>capture-example
>> behaves exactly the same.
>> 
>> The only ABI change I see is with poll(2) and epoll(7) where POLLERR
>is no
>> longer returned. Since this isn't documented at all anyway (and the
>poll(2)
>> manual page is actually unclear about whether you can expect it), 
>
>Posix seems clear enough to me.
>
>> I am
>> actually quite happy with this change. After this analysis I realized
>it is
>> even better than expected.
>
>> I never liked that poll starts streaming, poll should be a fast
>function,
>> not something that does a lot of other things.
>> 
>> It's actually a very nice change, but I admit that it is tricky to
>analyze.
>
>I'm not very comfortable with vb2 returning unexpected errors there.
>Also,
>for me it is clear that, if read will fail, POLLERR should be rised.
>
>Mauro. 
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

It is also the case that a driver's poll method should never sleep.

I will try to find the conversation I had with laurent on interpreting the POSIX spec on error returns from select() and poll().  I will also try to find links to previos discussion with Hans on this.

One issue is how to start streaming with apps that:
- Open /dev/video/ in a nonblocking mode, and
- Use the read() method

while doing it in a way that is POSIX compliant and doesn't break existing apps.  

The other constraint is to ensure when only poll()-ing for exception conditions, not having significant IO side effects.


I'm pretty sure sleeping in a driver's poll() method, or having significant side effects, is not ine the spirit of the POSIX select() and poll(), even if the letter of POSIX says nothing about it.

The method I suggested to Hans is completely POSIX compliant for apps using read() and select() and was checked against MythTV as having no bad side effects.  (And by thought experiment doesn't break any sensible app using nonblocking IO with select() and read().)

I did not do analysis for apps that use mmap(), which I guess is the current concern.
Regards,
Andy
