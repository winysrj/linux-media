Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52200 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbcHMJ34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 05:29:56 -0400
Subject: Re: [PATCH v3 05/14] media: platform: pxa_camera: convert to vb2
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
 <1470684652-16295-6-git-send-email-robert.jarzmik@free.fr>
 <87zioht3zi.fsf@belgarion.home>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c682efee-3e92-27c8-9c58-5df70bc5c1ea@xs4all.nl>
Date: Sat, 13 Aug 2016 11:29:49 +0200
MIME-Version: 1.0
In-Reply-To: <87zioht3zi.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/13/2016 11:25 AM, Robert Jarzmik wrote:
> Hi Hans,
> 
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
>> Convert pxa_camera from videobuf to videobuf2.
> ...zip...
> 
>> +static int pxac_vb2_queue_setup(struct vb2_queue *vq,
>> +				unsigned int *nbufs,
>> +				unsigned int *num_planes, unsigned int sizes[],
>> +				void *alloc_ctxs[])
> 
> There is an API change here that happened since I wrote this code, ie. void
> *alloc_ctxs became struct device *alloc_devs.
> 
> I made the incremental patch in [1] accrodingly to prepare the v4 iteration, but
> it triggers new errors in v4l2-compliance -s :
> Streaming ioctls:
> 	test read/write: OK (Not Supported)
> 		fail: v4l2-test-buffers.cpp(293): !(g_flags() & V4L2_BUF_FLAG_DONE)
> 		fail: v4l2-test-buffers.cpp(703): buf.check(q, last_seq)
> 		fail: v4l2-test-buffers.cpp(976): captureBufs(node, q, m2m_q, frame_count, false)
> 	test MMAP: FAIL
> 		fail: v4l2-test-buffers.cpp(1075): can_stream && ret != EINVAL
> 	test USERPTR: FAIL
> 	test DMABUF: Cannot test, specify --expbuf-device
> Total: 45, Succeeded: 43, Failed: 2, Warnings: 6
> 
> I'm a bit puzzled how this change brought this in, so in case you've already
> encountered this, it could save me investigating more. If nothing obvious
> appears to you, I'll dig in.

Make sure you have the latest v4l2-compliance code as well. A fix went into vb2
that corrected a bug relating to the V4L2_BUF_FLAG_DONE, but that required a fix for
v4l2-compliance as well. I'd say that's what you are seeing here.

Regards,

	Hans
