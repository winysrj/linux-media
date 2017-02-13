Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36549 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752188AbdBMLPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 06:15:01 -0500
Subject: Re: [PATCH v2] [media] vivid: support for contiguous DMA buffers
To: Vincent ABRIOU <vincent.abriou@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
 <2996e55c-b014-ac75-5cb0-c4706a7b5f37@xs4all.nl>
 <642a56d2-1a0b-ad39-70b4-68e01a12b71f@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d72266c8-60bc-394c-a7fc-cc14f00b657d@xs4all.nl>
Date: Mon, 13 Feb 2017 12:14:55 +0100
MIME-Version: 1.0
In-Reply-To: <642a56d2-1a0b-ad39-70b4-68e01a12b71f@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2017 12:10 PM, Vincent ABRIOU wrote:
> 
> 
> On 01/09/2017 04:10 PM, Hans Verkuil wrote:
>> On 09/12/2016 10:47 AM, Vincent Abriou wrote:
>>> It allows to simulate the behavior of hardware with such limitations or
>>> to connect vivid to real hardware with such limitations.
>>>
>>> Add the "allocators" module parameter option to let vivid use the
>>> dma-contig instead of vmalloc.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>>>
>>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>>  Documentation/media/v4l-drivers/vivid.rst |  8 ++++++++
>>>  drivers/media/platform/vivid/Kconfig      |  2 ++
>>>  drivers/media/platform/vivid/vivid-core.c | 32 ++++++++++++++++++++++++++-----
>>>  3 files changed, 37 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
>>> index c8cf371..3e44b22 100644
>>> --- a/Documentation/media/v4l-drivers/vivid.rst
>>> +++ b/Documentation/media/v4l-drivers/vivid.rst
>>> @@ -263,6 +263,14 @@ all configurable using the following module options:
>>>  	removed. Unless overridden by ccs_cap_mode and/or ccs_out_mode the
>>>  	will default to enabling crop, compose and scaling.
>>>
>>> +- allocators:
>>> +
>>> +	memory allocator selection, default is 0. It specifies the way buffers
>>> +	will be allocated.
>>> +
>>> +		- 0: vmalloc
>>> +		- 1: dma-contig
>>
>> Could you add support for dma-sg as well? I think that would be fairly trivial (unless
>> I missed something).
>>
>> Once that's added (or it's clear dma-sg won't work for some reason), then I'll merge this.
>>
>> Regards,
>>
>> 	Hans
>>
> 
> Hi Hans,
> 
> What is the difference between a vmalloc allocation exported in DMABUF 
> that will populate the sg and dma-sg allocation?

True. That wouldn't matter.

I'm merging this for 4.12.

Thanks!

	Hans
