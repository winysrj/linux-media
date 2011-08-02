Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44377 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1HBPpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 11:45:20 -0400
Message-ID: <4E381B73.8050706@codeaurora.org>
Date: Tue, 02 Aug 2011 09:44:51 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
References: <4E37C7D7.40301@samsung.com>
In-Reply-To: <4E37C7D7.40301@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2011 03:48 AM, Marek Szyprowski wrote:
> Hello Everyone,
>
> This patchset introduces the proof-of-concept infrastructure for buffer sharing between multiple devices using file descriptors. The infrastructure has been integrated with V4L2 framework, more specifically videobuf2 and two S5P drivers FIMC (capture interface) and TV drivers, but it can be easily used by other kernel subsystems, like DRI.
>
> In this patch the buffer object has been simplified to absolute minimum - it contains only the buffer physical address (only physically contiguous buffers are supported), but this can be easily extended to complete scatter list in the future.
>
> Best regards

Looks like a good start.  I'm not sure what has already been discussed
at the meetings, so please forgive me if any of these comments have
already been added to the to-do list and/or discounted.

I would definitely consider adding lock and unlock functions. It would
be great to have sane fencing built right into the sharing mechanism.
Deferred unlock would be nice too, but that is probably hard to do in
a generic way.

The owner of the buffer should be able to attach a private information
structure to the object and the consumer should be able to get it. This
is key for sharing buffer information and out of band data, especially
for video buffers (width, height, fourcc, alignment, pitch, start
of U buffer, start of V buffer, UV pitch, etc)

Thinking back to anything that could be salvaged from PMEM, about the only
thing of value that wouldn't otherwise be implemented here is the idea of
revoking a buffer. The thought is that when the master is was done with
the buffer, it could revoke it so that the client couldn't hang on to it
forever and possibly use it for nefarious purposes.  The client still has
it mapped, but the range is remapped to garbage. I've never been very
clear on how useful this was from a security standpoint because the master
has to implicitly share the fd in the first place but it seems to be a
feature that has survived several years of pmem hacking.

I look forward to seeing the session notes from the meetings and seeing
what the other ideas are.  Thanks for your hard work.

Jordan
