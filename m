Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4554 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaCJMdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 08:33:47 -0400
Message-ID: <531DB11B.8080407@xs4all.nl>
Date: Mon, 10 Mar 2014 13:33:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 7/7] v4l: ti-vpe: Add selection API in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393922965-15967-1-git-send-email-archit@ti.com> <1393922965-15967-8-git-send-email-archit@ti.com> <53159F7D.8020707@xs4all.nl> <5315B822.7010005@ti.com> <5315BA83.5080500@xs4all.nl> <5319B26B.8050900@ti.com> <5319C2A7.6090805@xs4all.nl> <5319C813.5030508@ti.com> <5319CA53.9020101@xs4all.nl> <5319CDF1.4030405@ti.com> <531DAC20.1000200@ti.com>
In-Reply-To: <531DAC20.1000200@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2014 01:12 PM, Archit Taneja wrote:
> Hi Hans,
> 
> On Friday 07 March 2014 07:17 PM, Archit Taneja wrote:
>> On Friday 07 March 2014 07:02 PM, Hans Verkuil wrote:
>>> On 03/07/2014 02:22 PM, Archit Taneja wrote:
> 
>>>
>>> Disregard what I said, it's OK to upstream it. But if you could just
>>> spend
>>> some hours fixing the problems, that would really be best.
>>
>> Sure, I'll try to fix these issues and then post a v3.
> 
> I fixed most of the compliance errors. There were some things I needed 
> to change in .utils/v4l2-compliance/v4l2-test-buffers.cpp'. I added 
> those with some questions in the comments:
> 
> diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp 
> b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> index 6576d11..532a5b6 100644
> --- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
> +++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
> @@ -219,7 +219,13 @@ static int checkQueryBuf(struct node *node, const 
> struct v4l2_buffer &buf,
>   		fail_on_test(!(buf.flags & (V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR)));
>   		if (node->is_video) {
>   			fail_on_test(buf.field == V4L2_FIELD_ALTERNATE);
> -			fail_on_test(buf.field == V4L2_FIELD_ANY);
> +			/*
> +			 * the OUTPUT buffers are queued with V4L2_FIELD_ANY
> +			 * field type by the application. Is it the driver's
> +			 * job to change this to NONE in buf_prepare?

Yes, it is. Applications may pass in FIELD_ANY, but the driver must never return
it, it should always be replaced by what the driver actually uses.

> +			 */
> +
> +			/* fail_on_test(buf.field == V4L2_FIELD_ANY); */
>   			if (cur_fmt.fmt.pix.field == V4L2_FIELD_ALTERNATE) {
>   				fail_on_test(buf.field != V4L2_FIELD_BOTTOM &&
>   						buf.field != V4L2_FIELD_TOP);
> @@ -651,9 +657,17 @@ static int captureBufs(struct node *node, const 
> struct v4l2_requestbuffers &bufs
>   			} else if (node->is_m2m && timestamp == V4L2_BUF_FLAG_TIMESTAMP_COPY) {
>   				fail_on_test(buffer_info.find(buf.timestamp) == buffer_info.end());
>   				struct v4l2_buffer &orig_buf = buffer_info[buf.timestamp];
> -				fail_on_test(buf.field != orig_buf.field);
> -				fail_on_test((buf.flags & valid_output_flags) !=
> -					     (orig_buf.flags & valid_output_flags));
> +				/* same issue as as in checkQueryBuf */
> +				/* fail_on_test(buf.field != orig_buf.field); */
> +
> +				/*
> +				 * the queued buffers are filled with flags like
> +				 * V4L2_BUF_FLAG_KEYFRAME, these are lost when
> +				 * the captured buffers are dequed. How do we
> +				 * fix this?

Well, the driver has to copy them :-)

Note that v4l2-compliance assumes that there is a 1 to 1 mapping between buffers
coming into the codec and buffers coming out of the codec. If that's not the
case, then copying such flags does not make any sense. On the other hand, in
that case using V4L2_BUF_FLAG_TIMESTAMP_COPY probably makes no sense either.

Regards,

	Hans

> +				 */
> +				/*fail_on_test((buf.flags & valid_output_flags) !=
> +					     (orig_buf.flags & valid_output_flags)); */
>   				if (buf.flags & V4L2_BUF_FLAG_TIMECODE)
>   					fail_on_test(memcmp(&buf.timecode, &orig_buf.timecode,
>   								sizeof(buf.timecode)));
> 
> 
> Thanks,
> Archit
> 

