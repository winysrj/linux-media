Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41607 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1DEPMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 11:12:51 -0400
Received: by vws1 with SMTP id 1so333909vws.19
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 08:12:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104041227.30262.laurent.pinchart@ideasonboard.com>
References: <1301874670-14833-1-git-send-email-pawel@osciak.com> <201104041227.30262.laurent.pinchart@ideasonboard.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 5 Apr 2011 08:12:29 -0700
Message-ID: <BANLkTikBhDkmngtmjfz=Ze2c8Rj6zeVKvg@mail.gmail.com>
Subject: Re: vb2: stop_streaming() callback redesign
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On Mon, Apr 4, 2011 at 03:27, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Pawel,
>
> On Monday 04 April 2011 01:51:05 Pawel Osciak wrote:
>> Hi,
>>
>> This series implements a slight redesign of the stop_streaming() callback
>> in vb2. The callback has been made obligatory. The drivers are expected to
>> finish all hardware operations and cede ownership of all buffers before
>> returning, but are not required to call vb2_buffer_done() for any of them.
>> The return value from this callback has also been removed.
>
> What's the rationale behind this patch set ? I've always been against vb2
> controlling the stream state (vb2 should handle buffer management only in my
> opinion) and I'd like to understand why you want to make it required.
>

I might have overstated the intention saying it was a 'redesign'. It
actually doesn't change the overall stop_streaming callback idea, I am
just simplifying it with this patch, while also emphasizing its role
by making it obligatory. Drivers were always required to finish
everything they were doing with the buffers before returning from
stop_streaming. But until now, stop_streaming was expecting the driver
to call vb2_buffer_done for all buffers it received via buf_queue.
We've decided it's superfluous, so I am removing this requirement.
Also, I didn't see any use for the return value from stop_streaming so
I removed it as well. Apart from the above, nothing has really
changed.

> I plan to use vb2 in the uvcvideo driver (when vb2 will provide a way to
> handle device disconnection), and uvcvideo will stop the stream before calling
> vb2_queue_release() and vb2_streamoff(). Would will I need a stop_stream
> operation ?

I actually just yesterday noticed your response from a couple of weeks
ago to my comments to your original buf_queue proposal in my ever
growing pile of mail, sorry about that, I will reply to that as soon
as I have time to properly read it and think about it. Nevertheless, I
have the same question as Marek here, would there be anything
preventing you from doing that in stop_streaming?

-- 
Best regards,
Pawel Osciak
