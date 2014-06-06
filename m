Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4420 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaFFJcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 05:32:20 -0400
Message-ID: <53918A8B.1040308@xs4all.nl>
Date: Fri, 06 Jun 2014 11:31:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 2/2] v4l: vb2: Add fatal error condition flag
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401970991-4421-3-git-send-email-laurent.pinchart@ideasonboard.com> <CAMm-=zCQsPP4k1RDtVfHxk4AWhLESUMDT=+aHnM3nReBtpa8qA@mail.gmail.com> <2013428.7yG2aMynBj@avalon>
In-Reply-To: <2013428.7yG2aMynBj@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2014 11:19 AM, Laurent Pinchart wrote:
> Hi Pawel,
> 
> On Friday 06 June 2014 14:31:15 Pawel Osciak wrote:
>> Hi Laurent,
>> Thanks for the patch. Did you test this to work in fileio mode? Looks
>> like it should, but would like to make sure.
> 
> No, I haven't tested it. The OMAP4 ISS driver, which is my test target for 
> this patch, doesn't support fileio mode. Adding VB2_READ would be easy, but 
> the driver requires configuring the format on the file handle used for 
> streaming, so I can't just run cat /dev/video*.

Just test with vivi.

Regards,

	Hans

> 
>> On Thu, Jun 5, 2014 at 9:23 PM, Laurent Pinchart wrote:
>>> When a fatal error occurs that render the device unusable, the only
>>> options for a driver to signal the error condition to userspace is to
>>> set the V4L2_BUF_FLAG_ERROR flag when dequeuing buffers and to return an
>>> error from the buffer prepare handler when queuing buffers.
>>>
>>> The buffer error flag indicates a transient error and can't be used by
>>> applications to detect fatal errors. Returning an error from vb2_qbuf()
>>> is thus the only real indication that a fatal error occurred. However,
>>> this is difficult to handle for multithreaded applications that requeue
>>> buffers from a thread other than the control thread. In particular the
>>> poll() call in the control thread will not notify userspace of the
>>> error.
>>>
>>> This patch adds an explicit mechanism to report fatal errors to
>>> userspace. Applications can call the vb2_queue_error() function to
>>> signal a fatal error. From this moment on, buffer preparation will
>>> return -EIO to userspace, and vb2_poll() will set the POLLERR flag and
>>> return immediately. The error flag is cleared when cancelling the queue,
>>> either at stream off time (through vb2_streamoff) or when releasing the
>>> queue with vb2_queue_release().
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

