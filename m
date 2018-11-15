Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45940 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbeKOSHO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 13:07:14 -0500
Subject: Re: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <20181113150621.22276-1-p.zabel@pengutronix.de>
 <9523489.9cJbcbEQpD@avalon> <b15a6672-3775-510a-76c1-5bb9badae705@xs4all.nl>
 <2262278.mVXA2cJYNm@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d47245a-bdd3-3efa-df43-59d59e620cf6@xs4all.nl>
Date: Thu, 15 Nov 2018 09:00:23 +0100
MIME-Version: 1.0
In-Reply-To: <2262278.mVXA2cJYNm@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2018 08:49 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> 
> On Thursday, 15 November 2018 09:30:55 EET Hans Verkuil wrote:
>> On 11/14/2018 08:52 PM, Laurent Pinchart wrote:
>>> On Tuesday, 13 November 2018 17:43:48 EET Hans Verkuil wrote:
>>>> On 11/13/18 16:06, Philipp Zabel wrote:
>>>>> From: John Sheu <sheu@chromium.org>
>>>>>
>>>>> Videobuf2 presently does not allow VIDIOC_REQBUFS to destroy outstanding
>>>>> buffers if the queue is of type V4L2_MEMORY_MMAP, and if the buffers are
>>>>> considered "in use".  This is different behavior than for other memory
>>>>> types and prevents us from deallocating buffers in following two cases:
>>>>>
>>>>> 1) There are outstanding mmap()ed views on the buffer. However even if
>>>>>    we put the buffer in reqbufs(0), there will be remaining references,
>>>>>    due to vma .open/close() adjusting vb2 buffer refcount appropriately.
>>>>>    This means that the buffer will be in fact freed only when the last
>>>>>    mmap()ed view is unmapped.
>>>>>
>>>>> 2) Buffer has been exported as a DMABUF. Refcount of the vb2 buffer
>>>>>    is managed properly by VB2 DMABUF ops, i.e. incremented on DMABUF
>>>>>    get and decremented on DMABUF release. This means that the buffer
>>>>>    will be alive until all importers release it.
>>>>>
>>>>> Considering both cases above, there does not seem to be any need to
>>>>> prevent reqbufs(0) operation, because buffer lifetime is already
>>>>> properly managed by both mmap() and DMABUF code paths. Let's remove it
>>>>> and allow userspace freeing the queue (and potentially allocating a new
>>>>> one) even though old buffers might be still in processing.
>>>>>
>>>>> To let userspace know that the kernel now supports orphaning buffers
>>>>> that are still in use, add a new V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
>>>>> to be set by reqbufs and create_bufs.
>>>>
>>>> Looks good, but I have some questions:
>>>>
>>>> 1) does v4l2-compliance together with vivid (easiest to test) still work?
>>>>    I don't think I have a proper test for this in v4l2-compliance, but
>>>>    I'm not 100% certain. If it fails with this patch, then please provide
>>>>    a fix for v4l2-compliance as well.
>>>>
>>>> 2) I would like to see a new test in v4l2-compliance for this: i.e. if
>>>>    the capability is set, then check that you can call REQBUFS(0) before
>>>>    unmapping all buffers. Ditto with dmabuffers.
>>>>
>>>> I said during the media summit that I wanted to be more strict about
>>>> requiring compliance tests before adding new features, so you're the
>>>> unlucky victim of that :-)
>>>
>>> Do you have plans to refactor and document the v4l2-compliance internals
>>> to make it easier ?
>>
>> Yes. I hope to be able to set aside one or two days for that in the next two
>> weeks.
> 
> That would be great ! Let me know if you would like to discuss how the code 
> base could be refactored.
> 

I'm happy to hear your ideas, but I only have one day for refactoring, so it is
very limited what can be done.

Frankly, it is mainly v4l2-test-buffers.cpp that I would like to split up in
two parts: one for the tests that do not require actual streaming and one part
for all the streaming tests.

Documentation (esp. cv4l-helpers.h which is used a lot) is much more important
and I wanted to spend the second day on that.

Regards,

	Hans
