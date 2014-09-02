Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4206 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaIBJaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 05:30:07 -0400
Message-ID: <54058DEC.6050302@xs4all.nl>
Date: Tue, 02 Sep 2014 11:29:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	"'Nicolas Dufresne'" <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Subject: Re: s5p-mfc should allow multiple call to REQBUFS before we start
 streaming
References: <5400844A.5030603@collabora.com> <06ac01cfc5c9$248443e0$6d8ccba0$%debski@samsung.com> <5404949A.5060006@collabora.com> <086701cfc68c$9d69a020$d83ce060$%debski@samsung.com>
In-Reply-To: <086701cfc68c$9d69a020$d83ce060$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/14 11:02, Kamil Debski wrote:
> Hi Hans, Nicolas,
> 
> Hans, would you mind commenting on this?
> 
>> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
>> Sent: Monday, September 01, 2014 5:46 PM
>>
>>
>> Le 2014-09-01 05:43, Kamil Debski a écrit :
>>> Hi Nicolas,
>>>
>>>
>>>> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
>>>> Sent: Friday, August 29, 2014 3:47 PM
>>>>
>>>> Hi Kamil,
>>>>
>>>> after a discussion on IRC, we concluded that s5p-mfc have this bug
>>>> that disallow multiple reqbufs calls before streaming. This has the
>>>> impact that it forces to call REQBUFS(0) before setting the new
>>>> number of buffers during re-negotiation, and is against the spec too.
>>> I was out of office last week. Could you shed more light on this
>> subject?
>>> Do you have the irc log?
>>
>> Sorry I didn't record this one, but feel free to ping Hans V.
>>>> As an example, in reqbufs_output() REQBUFS is only allowed in
>>>> QUEUE_FREE state, and setting buffers exits this state. We think
>> that
>>>> the call to
>>>> <http://lxr.free-
>>>> electrons.com/ident?i=reqbufs_output>s5p_mfc_open_mfc_inst()
>>>> should be post-poned until STREAMON is called.
>>>> <http://lxr.free-electrons.com/ident?i=reqbufs_output>
>>> How is this connected to the renegotiation scenario?
>>> Are you sure you wanted to mention s5p_mfc_open_mfc_inst?
>> This limitation in MFC causes an important conflict between old
>> videobuf and new videobuf2 drivers. Old videobuf driver (before Hans G.
>> proposed
>> patch) refuse REQBUFS(0). As MFC code has this bug that refuse
>> REBBUFS(N) if buffers are already allocated, it makes all this
>> completely incompatible. This open_mfc call seems to be the only reason
>> REQBUFS() cannot be called multiple time, though I must say you are
>> better placed then me to figure this out.
> 
> After MFCs decoding is initialized it has a fixed number of buffers.
> Changing
> this can be done when the stream changes its properties and resolution
> change is initiated. Even then all buffers have to be
> unmapped/reallocated/mapped.
> 
> There is a single hardware call that is a part of hardware initialization
> that sets the buffers' addresses.

But is reqbufs the right place to initial MFC decoding? Wouldn't start_streaming
be a much more logical place for this? Until start_streaming is called apps
are free to request more buffers (with CREATE_BUFS), or request a new set of
buffers (REQBUFS(N)). Only once start_streaming is called does everything
have to be locked down and changes are no longer allowed until after
stop_streaming() (or as long as buffers are still mapped).

I see no reason why REQBUFS should be doing anything other than requesting
buffers.

Regards,

	Hans

> 
> Changing the number of buffers during decoding without explicit reason to do
> so (resolution change/stream properties change) would be problematic. For 
> hardware it is very close to reinitiating decoding - it needs to be done on
> an I-frame, the header needs to be present. Otherwise some buffers would be
> lost and corruption would be introduced (lack of reference frames).
> 
> I think you mentioned negotiating the number of buffers? Did you use the
> V4L2_CID_MIN_BUFFERS_FOR_CAPTURE control?
> 
> I understand that before calling REQBUFS(N) with the new N value you
> properly
> unmap the buffers just like the documentation is telling?
> 
> "Applications can call VIDIOC_REQBUFS again to change the number of buffers,
> however this cannot succeed when any buffers are still mapped. A count value
> of zero frees all buffers, after aborting or finishing any DMA in progress,
> an implicit VIDIOC_STREAMOFF." [1]
> 
> Could you tell me what is the scenario where you want to use the REQBUFS(N)
> to change number of buffers? Maybe I could understand better the problem.
> 
>>
>> cheers,
>> Nicolas
> 
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html
> 
> Best wishes,
> 

