Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44027 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaETFqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 01:46:54 -0400
Message-ID: <537AEC4C.2060000@samsung.com>
Date: Tue, 20 May 2014 11:16:52 +0530
From: Arun Kumar K <arun.kk@samsung.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sachin.kamat@linaro.org, arunkk.samsung@gmail.com
Subject: Re: [PATCH v2] [media] s5p-mfc: Dequeue sequence header after STREAMON
References: <1400048996-726-1-git-send-email-arun.kk@samsung.com> <53731693.80002@xs4all.nl> <537324E5.3030704@samsung.com> <047d01cf7050$d1943780$74bca680$%debski@samsung.com>
In-Reply-To: <047d01cf7050$d1943780$74bca680$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 05/15/14 20:47, Kamil Debski wrote:
> Hi Arun,
> 
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Arun Kumar K
>> Sent: Wednesday, May 14, 2014 10:10 AM
>>
>> Hi Hans,
>>
>> On 05/14/14 12:39, Hans Verkuil wrote:
>>> On 05/14/2014 08:29 AM, Arun Kumar K wrote:
>>>> MFCv6 encoder needs specific minimum number of buffers to be queued
>>>> in the CAPTURE plane. This minimum number will be known only when
>> the
>>>> sequence header is generated.
>>>> So we used to allow STREAMON on the CAPTURE plane only after
>> sequence
>>>> header is generated and checked with the minimum buffer requirement.
>>>>
>>>> But this causes a problem that we call a vb2_buffer_done for the
>>>> sequence header buffer before doing a STREAON on the CAPTURE plane.
>>>
>>> How could this ever have worked? Buffers aren't queued to the driver
>>> until STREAMON is called, and calling vb2_buffer_done for a buffer
>>> that is not queued first to the driver will mess up internal data (q-
>>> queued_count for one).
>>>
>>
>> This worked till now because __enqueue_in_driver is called first and
>> then start_streaming qop is called. In MFCv6, the start_streaming
>> driver callback used to wait till sequence header interrupt is received
>> and it used to do vb2_buffer_done in that interrupt context. So it
>> happened after buffers are enqueued in driver and before completing the
>> vb2_streamon.
>>
>>>> This used to still work fine until this patch was merged -
>>>> b3379c6 : vb2: only call start_streaming if sufficient buffers are
>>>> queued
>>>
>>> Are you testing with CONFIG_VIDEO_ADV_DEBUG set? If not, you should
>> do
>>> so. That will check whether all the vb2 calls are balanced.
>>>
>>> BTW, that's a small typo in s5p_mfc_enc.c (search for 'inavlid').
>>>
>>
>> I got it. Will post a patch fixing them. Thanks for spotting this.
>>
>>>> This problem should also come in earlier MFC firmware versions if
>> the
>>>> application calls STREAMON on CAPTURE with some delay after doing
>>>> STREAMON on OUTPUT.
>>>
>>> You can also play around with the min_buffers_needed field. My
>>> rule-of-thumb is that when start_streaming is called everything
>> should
>>> be ready to stream. It is painful for drivers to have to keep track
>> of the 'do I have enough buffers' status.
>>>
>>> For that reason I introduced the min_buffers_needed field. What I
>>> believe you can do here is to set it initially to a large value,
>>> preventing start_streaming from being called, and once you really
>> know
>>> the minimum number of buffers that you need it can be updated again
>> to the actual value.
>>
>> If a large value is kept in min_buffers_needed, there will be some
>> unnecessary memory initialization needed for say 16 full HD raw YUV
>> buffers when actual needed is only 4. And once the encoding is started,
>> updating the min_buffers_needed to actual value doesnt give any
>> advantage as nobody checks for it after that.
>> So the whole idea is to not enforce a worst case buffer allocation
>> requirement beforehand itself. I hope the current scheme of things
>> works well for the requirement.
> 
> I was looking in the code of the MFC encoder and handling of this situation
> seems wrong to me.
> 
> You say that a minimum number of buffers has to be queued for MFC encoder to
> work. But this number is not checked in s5p_mfc_ctx_ready in s5p_mfc_enc.c.
> 

The situation is bit tricky here. The s5p_mfc_ctx_ready has to be true
for giving the first frame to encode which generates the sequence
header. So this condition still holds good -
        /* context is ready to make header */
        if (ctx->state == MFCINST_GOT_INST && ctx->dst_queue_cnt >= 1)
                return 1;

So at this moment, atleast 1 buffer has to be queued in CAPTURE plane so
as to generate sequence header. But once that is generated, then only
the total buffer requirement will be known as per the v6+ firmware.
So if we make ctx_ready only after STREAMON on CAPTURE is done, then
there is no way to check for min. buffer requirement and the application
will start the encoding and will fail during runtime.

> It is only checked during reqbufs. This way it does not ensure that there is
> a minimum number of buffers queued.
> 
> Also there is a control V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, maybe it could be
> used
> in this context?
> 

We had a discussion on this sometime back when a sequence change was
proposed for encoding.
http://www.mail-archive.com/linux-media%40vger.kernel.org/msg60400.html

But we kept the old sequence for backward compatibility with old
applications. If the application had requested buffers & streamon on
CAPTURE plane first, then this issue will not come as the minimum OUTPUT
buffer requirement is checked in the REQBUF for OUTPUT.
So the best sequence would be
1) REQBUF on CAPTURE
2) QBUF and STREAMON on CAPTURE
3) REQBUF on OUTPUT (Will know at this time the minimum OUTPUT buffer
requirement)

But if an application follows the following sequence:
1) REQBUF on OUTPUT (we dont know the min. number yet)
2) REQBUF on CAPTURE
3) STREAMON on OUTPUT (header generated)
4) STREAMON on CAPTURE (check for min. OUTPUT buffers here)

So due to this check, a wait is introduced in start_streaming for the
header generation. And due to this wait, a header is generated after
buffers are enqueued in driver and before completing the STREAMON.

> Another thing - you say that header is generated to a CAPTURE buffer before
> STREAMON on CAPTURE was done. Is this correct? Can the hardware/driver write
> to a queued buffer without streaming enabled? Hans, Sylwester?
> 

The reason is as I mentioned above. The vb2_streamon function is called
which first call __enqueue_in_driver after which it calls the
start_streaming qop. There it waits in our driver which gives the issue.
The patch posted actually solves all these problems, without affecting
any other functionality I feel.

> Arun, is there a way to guess the needed number of buffers from controls?
> Isn't this
> related with number of B frames? I understand how this affects the number of
> buffers for OUTPUT, but I thought that a single CAPTURE buffer is always
> enough.

It should be possible, but there is no interface given by the firmware
for this. We need to know the internal logic of firmware for correctly
arriving at a number beforehand.

Regards
Arun

> I understood that a generated compressed stream is no longer used after it
> was
> created and its processing is finished.
> 
> I think we need some discussion on this patch.
>  
> Best wishes,
> 
