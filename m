Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36528 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbbIKLUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:20:04 -0400
Message-ID: <55F2B89A.6050701@xs4all.nl>
Date: Fri, 11 Sep 2015 13:18:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 5/8] [media] videobuf2: Change queue_setup argument
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com> <1441797597-17389-6-git-send-email-jh1009.sung@samsung.com> <55F29648.6030303@xs4all.nl> <55F2B5FA.2010003@samsung.com>
In-Reply-To: <55F2B5FA.2010003@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:07 PM, Junghak Sung wrote:
> 
> Hello Hans,
> 
> First of all, thank you for your review.
> 
> 
> On 09/11/2015 05:52 PM, Hans Verkuil wrote:
>> On 09/09/2015 01:19 PM, Junghak Sung wrote:
>>> Replace struct v4l2_format * with void * to make queue_setup()
>>> for common use.
>>> And then, modify all device drivers related with this change.
>>>
>>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>
>> OK, so I never liked this void * change. After I thought about it some
>> more I came to the conclusion that this should be changed.
>>
>> For probably all drivers all that they do with the fmt argument is to
>> check the sizeimage field. So I would replace the v4l2_format pointer
>> by an 'unsigned int *req_sizes' argument. This contains the requested
>> per-plane sizes. That is also nicely generic and makes much more sense
>> in videobuf2-core.c.
>>
>> A vb2_v4l2_create_bufs helper function will just call the internal
>> vb2-core function with the correct requested sizes. Note: these sizes
>> will depend on the type of v4l2_format, so the helper will have to do
>> a bit more work.
>>
>> If a driver needs to do more checking for the format, then it can do
>> that before calling the vb2_v4l2_create_bufs helper.
>>
>> When called from reqbufs the req_sizes argument will be NULL, just like
>> fmt is NULL today.
>>
>> I believe this is a much better solution.
>>
>> Regards,
>>
>> 	Hans
>>
> 
> I'm afraid but it seems very hard to implement your idea.
> Some device drivers use not only the sizeimage field but also other
> fields.
> For example, type, fmt.pix_mp of v4l2_format are used by
> vid_out_queue_setup() function in vivid-vid-out.c
> And, fmt.vbi.samples_per_line and fmt.vbi.count are used by
> vbi_queue_setup() function in au0828-vbi.c.

If you look carefully in both cases these fields are used to determine
the size of each plane. So again, it is just the per-plane requested
size that is relevant here.

So the vb2_v4l2_create_bufs() helper function would look something like
this:

	unsigned req_sizes[VB2_MAX_PLANES];

	switch (fmt->type) {
	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
		req_sizes[0] = fmt->fmt.pix.sizeimage;
		break;
	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
		for (i = 0; i < fmt->fmt.pix_mp.length; i++)
			req_sizes[i] = fmt->fmt.pix_mp.plane_fmt[i].sizeimage;
		break;
	case V4L2_BUF_TYPE_VBI_CAPTURE:
	case V4L2_BUF_TYPE_VBI_OUTPUT:
		req_sizes[0] = fmt->fmt.vbi.samples_per_line *
			(fmt->fmt.vbi.count[0] + fmt->fmt.vbi.count[1]);
		break;
	// etc. For sliced vbi it is io_size, for sdr is it buffersize
	}

	vb2_core_create_bufs(...., req_sizes, ...)

> Even if you put that only these two example, it will be very
> hard to make vb2_v4l2_create_bufs helper function to use something
> common instead of v4l2_format, IMHO.

All queue_setup is interested in is the requested plane sizes obtained
from v4l2_format. So I don't think this is a problem at all.

Regards,

	Hans

> 
> Best regards,
> Junghak

