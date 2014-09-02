Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51238 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaIBMDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 08:03:03 -0400
Message-ID: <5405B1F1.7080308@collabora.com>
Date: Tue, 02 Sep 2014 08:02:57 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: 'Hans Verkuil' <hverkuil@xs4all.nl>
Subject: Re: s5p-mfc should allow multiple call to REQBUFS before we start
 streaming
References: <5400844A.5030603@collabora.com> <06ac01cfc5c9$248443e0$6d8ccba0$%debski@samsung.com> <5404949A.5060006@collabora.com> <086701cfc68c$9d69a020$d83ce060$%debski@samsung.com>
In-Reply-To: <086701cfc68c$9d69a020$d83ce060$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-02 05:02, Kamil Debski a écrit
>> This limitation in MFC causes an important conflict between old
>> videobuf and new videobuf2 drivers. Old videobuf driver (before Hans G.
>> proposed
>> patch) refuse REQBUFS(0). As MFC code has this bug that refuse
>> REBBUFS(N) if buffers are already allocated, it makes all this
>> completely incompatible. This open_mfc call seems to be the only reason
>> REQBUFS() cannot be called multiple time, though I must say you are
>> better placed then me to figure this out.
> After MFCs decoding is initialized it has a fixed number of buffers.
> Changing
> this can be done when the stream changes its properties and resolution
> change is initiated. Even then all buffers have to be
> unmapped/reallocated/mapped.
>
> There is a single hardware call that is a part of hardware initialization
> that sets the buffers' addresses.
>
> Changing the number of buffers during decoding without explicit reason to do
> so (resolution change/stream properties change) would be problematic. For
> hardware it is very close to reinitiating decoding - it needs to be done on
> an I-frame, the header needs to be present. Otherwise some buffers would be
> lost and corruption would be introduced (lack of reference frames).
>
> I think you mentioned negotiating the number of buffers? Did you use the
> V4L2_CID_MIN_BUFFERS_FOR_CAPTURE control?
That is true, though the issue isn't there. Let's say you haven't 
started decoding yet. You do REQBUFS(2). because the hardware need that. 
Then  before you start anything else, the topology of your display path 
is change, and the application need an extra 2 buffers to work properly. 
With all other drivers, all we'd have to do is REQBUFS(5), with MFC we 
would need to do REQBUFS(0) and then REQBUFS(5). This is a bug, there is 
no reason to force this extra step.
>
> I understand that before calling REQBUFS(N) with the new N value you
> properly
> unmap the buffers just like the documentation is telling?
As describe in the scenario, nothing has been mapped yet.
>
> "Applications can call VIDIOC_REQBUFS again to change the number of buffers,
> however this cannot succeed when any buffers are still mapped. A count value
> of zero frees all buffers, after aborting or finishing any DMA in progress,
> an implicit VIDIOC_STREAMOFF." [1]
As you can see, the spec says it can be changed, having this extra step 
to change it does not seems compliant to me, at least it's not consistent.


cheers,
Nicolas
