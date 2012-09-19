Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22402 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2ISQys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 12:54:48 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAL006C8WBYUH20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Sep 2012 17:55:10 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAL006F9WB9FI40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 19 Sep 2012 17:54:46 +0100 (BST)
Message-id: <5059F8D5.5050807@samsung.com>
Date: Wed, 19 Sep 2012 18:54:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/6] videobuf2-core: move num_planes from vb2_buffer
 to vb2_queue.
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
 <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
 <5059E233.4030006@samsung.com> <201209191728.38722.hverkuil@xs4all.nl>
In-reply-to: <201209191728.38722.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2012 05:28 PM, Hans Verkuil wrote:
> On Wed September 19 2012 17:18:11 Sylwester Nawrocki wrote:
>> Hi Hans,
>>
>> On 09/19/2012 04:37 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> It's a queue-global value, so keep it there rather than with the
>>> buffer struct.
>>
>> I would prefer not doing this. It makes the path to variable
>> number of per buffer planes more difficult.
> 
> You can't have a variable number of planes per buffer. You can decide not to
> fill certain planes (e.g. set bytesused to 0 or something), but that's a
> different thing.
> 
> So applications will always need to set up q->num_planes elements of the array.
> And in the MMAP case all planes need to be mmap()ed. You can't have one buffer
> that's setup with only 2 planes while all others are setup with 3 planes.

You're right, all planes would need to be prepared anyway. Reporting that
some planes are unused by setting bytesused is probably going to be enough.
And your subsequent patches depend on this one. FWIW,

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
