Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56887 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751822AbeAaIr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 03:47:59 -0500
Subject: Re: [RFC PATCH 0/8] [media] Request API, take three
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20180126060216.147918-1-acourbot@chromium.org>
 <ced425a2-8b66-05c6-367d-46a0a40b1873@xs4all.nl>
 <CAPBb6MU5Ph=_rH_TOQi5mstujAPMTWqC_1d-8_TcuGx25sOJvg@mail.gmail.com>
 <307f58dd-ce7e-b6f5-092a-f8679349be73@xs4all.nl>
 <CAAFQd5AbdAGteHOfKH4EoHUNSmsfCYtExVX9TSK8aWsQZ4HVJg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e75c24da-4856-ae50-6dc9-604c885e4040@xs4all.nl>
Date: Wed, 31 Jan 2018 09:47:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AbdAGteHOfKH4EoHUNSmsfCYtExVX9TSK8aWsQZ4HVJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/2018 09:10 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> Sorry for joining the party late.
> 
> On Wed, Jan 31, 2018 at 4:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 01/30/2018 07:31 AM, Alexandre Courbot wrote:
>>> Hi Hans,
>>>
>>> On Mon, Jan 29, 2018 at 8:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 01/26/2018 07:02 AM, Alexandre Courbot wrote:
>>>>> Howdy. Here is your bi-weekly request API redesign! ;)
>>>>>
>>>>> Again, this is a simple version that only implements the flow of requests,
>>>>> without applying controls. The intent is to get an agreement on a base to work
>>>>> on, since the previous versions went straight back to the redesign board.
>>>>>
>>>>> Highlights of this version:
>>>>>
>>>>> * As requested by Hans, request-bound buffers are now passed earlier to drivers,
>>>>> as early as the request itself is submitted. Doing it earlier is not be useful
>>>>> since the driver would not know the state of the request, and thus cannot do
>>>>> anything with the buffer. Drivers are now responsible for applying request
>>>>> parameters themselves.
>>>>>
>>>>> * As a consequence, there is no such thing as a "request queue" anymore. The
>>>>> flow of buffers decides the order in which requests are processed. Individual
>>>>> devices of the same pipeline can implement synchronization if needed, but this
>>>>> is beyond this first version.
>>>>>
>>>>> * VB2 code is still a bit shady. Some of it will interfere with the fences
>>>>> series, so I am waiting for the latter to land to do it properly.
>>>>>
>>>>> * Requests that are not yet submitted effectively act as fences on the buffers
>>>>> they own, resulting in the buffer queue being blocked until the request is
>>>>> submitted. An alternate design would be to only block the
>>>>> not-submitted-request's buffer and let further buffers pass before it, but since
>>>>> buffer order is becoming increasingly important I have decided to just block the
>>>>> queue. This is open to discussion though.
>>>>
>>>> I don't think we should mess with the order.
>>>
>>> Agreed, let's keep it that way then.
>>>
> 
> I'm not sure I'm following here. Does it mean (quoting Alex):
> 
> a) "Requests that are not yet submitted effectively act as fences on the buffers
>     they own, resulting in the buffer queue being blocked until the request is
>     submitted."
> 
> b) "block the not-submitted-request's buffer and let further buffers
> pass before it"
> 
> or neither?
> 
> Hans, could you clarify what you think is the right behavior here?

I think I misread the text. Alexandre, buffers in not-yet-submitted requests
should not act as fences. They are similar to buffers that are prepared
through the VIDIOC_PREPARE_BUF call. They are just sitting there and won't
be in the queue until someone calls QBUF.

It's the same for not-yet-submitted requests: the buffers don't act as
fences until the request is submitted.

Interesting related questions: how does VIDIOC_PREPARE_BUF interact with
a request? What happens if a buffer is added to a non-yet-submitted request
and userspace calls VIDIOC_QBUF with that same buffer but with no request?

This all needs to be defined.

> 
>>>>> * For the codec usecase, I have experimented a bit marking CAPTURE buffers with
>>>>> the request FD that produced them (vim2m acts that way). This seems to work
>>>>> well, however FDs are process-local and could be closed before the CAPTURE
>>>>> buffer is dequeued, rendering that information less meaningful, if not
>>>>> dangerous.
>>>>
>>>> I don't follow this. Once the fd is passed to the kernel its refcount should be
>>>> increased so the data it represents won't be released if userspace closes the fd.
>>>
>>> The refcount of the request is increased. The refcount of the FD is
>>> not, since it is only a userspace reference to the request.
>>
>> I don't think that's right. Looking at how dma-buf does this (dma_buf_get in
>> dma-buf.c) it calls fget(fd) which increases the fd refcount. In fact, as far as
>> I can see the struct dma_buf doesn't have a refcount, it is solely refcounted
>> through the fd. That's probably the model you want to follow.
> 
> As far as I can see from the code, fget() on an fd increases a
> reference count on the struct file backing the fd. I don't think there
> is another level of reference counting of fds themselves - that's why
> dup(fd) gives you another fd and you can't call close(fd) on the same
> fd two times.
> 
>>
>>>
>>>>
>>>> Obviously if userspace closes the fd it cannot do anything with it anymore, but
>>>> it shouldn't be 'dangerous' AFAICT.
>>>
>>> It userspace later gets that closed FD back from a DQBUF call, and
>>> decides to use it again, then we would have a problem. I agree that it
>>> is userspace responsibility to be careful here, but making things
>>> foolproof never hurts.
>>
>> I think all the issues will go away if you refcount the fd instead of the
>> request. It worked well for dma-buf for years.
> 
> I'm confused here. The kernel never returns the same FD for the same
> DMA-buf twice. Every time an ioctl is called, which returns a DMA-buf
> FD, it creates a new FD.

Sorry, where I say 'refcount the fd' I indeed meant 'refcount the file struct'.

Looking at the code in the patch series I see:

+struct media_request *
+media_request_get_from_fd(int fd)
+{
+	struct file *f;
+	struct media_request *req;
+
+	f = fget(fd);
+	if (!f)
+		return NULL;
+
+	/* Not a request FD? */
+	if (f->f_op != &request_fops) {
+		fput(f);
+		return NULL;
+	}
+
+	req = f->private_data;
+	media_request_get(req);
+	fput(f);
+
+	return req;
+}
+EXPORT_SYMBOL_GPL(media_request_get_from_fd);

So this does not refcount the file struct but the request struct, and I think
that's wrong. The file struct represents the request struct, and it is the
file struct that should be refcounted. So when you give a request_fd to
VIDIOC_QBUF, then the refcount should be increased since vb2 now needs to
hold on to it. It's what dma-buf does.

Now, I agree that if userspace closes the fd before kernelspace is finished
with it, then the request_fd returned by VIDIOC_DQBUF is no longer valid.
But so what? It's the same with the dma-buf fd. I don't think this is a problem
at all.

Regards,

	Hans
