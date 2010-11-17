Return-path: <mchehab@pedra>
Received: from [120.204.251.227] ([120.204.251.227]:40193 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933241Ab0KQBkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 20:40:40 -0500
Message-ID: <4CE3325E.6030008@leadcoretech.com>
Date: Wed, 17 Nov 2010 09:39:42 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"pawel@osciak.com" <pawel@osciak.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
References: <1289939083-27209-1-git-send-email-achew@nvidia.com> <4CE32B9D.1020705@leadcoretech.com> <643E69AA4436674C8F39DCC2C05F763816BB828A40@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BB828A40@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

于 11/17/2010 09:38 AM, Andrew Chew 写道:
>>> diff --git a/drivers/media/video/videobuf-dma-contig.c
>> b/drivers/media/video/videobuf-dma-contig.c
>>> index c969111..f7e0f86 100644
>>> --- a/drivers/media/video/videobuf-dma-contig.c
>>> +++ b/drivers/media/video/videobuf-dma-contig.c
>>> @@ -193,6 +193,8 @@ static struct videobuf_buffer
>> *__videobuf_alloc_vb(size_t size)
>>>    	if (vb) {
>>>    		mem = vb->priv = ((char *)vb) + size;
>>>    		mem->magic = MAGIC_DC_MEM;
>>> +		INIT_LIST_HEAD(&vb->stream);
>>> +		INIT_LIST_HEAD(&vb->queue);
>>
>> i think it no need to be init, it just a list-entry.
>
> Okay, if that's really the case, then sh_mobile_ceu_camera.c, pxa_camera.c, mx1_camera.c, mx2_camera.c, and omap1_camera.c needs to be fixed to remove that WARN_ON(!list_empty(&vb->queue)); in their videobuf_prepare() methods, because those WARN_ON's are assuming that vb->queue is properly initialized as a list head.
>
> Which will it be?

yes, i think those WARN_ONs are no need.
