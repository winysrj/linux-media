Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:45889 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbdJCPAI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 11:00:08 -0400
Received: by mail-qt0-f169.google.com with SMTP id k1so2465547qti.2
        for <linux-media@vger.kernel.org>; Tue, 03 Oct 2017 08:00:07 -0700 (PDT)
Message-ID: <1507042804.27175.12.camel@ndufresne.ca>
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kazunori Kobayashi <kkobayas@igel.co.jp>
Cc: linux-media@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date: Tue, 03 Oct 2017 11:00:04 -0400
In-Reply-To: <f0518dd3-ae01-2da1-12ac-1fb041aaa709@xs4all.nl>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp>
         <2220172.K033cFnpL3@avalon>
         <f0518dd3-ae01-2da1-12ac-1fb041aaa709@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd like to revive this discussion.

Le lundi 01 août 2016 à 12:56 +0200, Hans Verkuil a écrit :
> > 
> > Hans, Marek, any opinion on this ?
> 
> What is the use-case for this? What you are doing here is to either free all
> existing buffers or reallocate buffers. We can decide to rely on refcounting,
> but then you would create a second set of buffers (when re-allocating) or
> leave a lot of unfreed memory behind. That's pretty hard on the memory usage.
> 
> I think the EBUSY is there to protect the user against him/herself: i.e. don't
> call this unless you know all refs are closed.
> 
> Given the typical large buffersizes we're talking about, I think that EBUSY
> makes sense.

This is a userspace hell for the use case of seamless resolution
change. Let's say I'm rendering buffers from a V4L2 camera toward my
display KMS driver. While I'm streaming, the KMS driver will hold on
the last frame. This is required when your display is sourcing data
directly from your DMABuf, because the KMS render are not synchronized
with the V4L2 camera (you could have 24fps camera over a 60fps
display).

When its time to change the resolution, the fact that we can't let go
the DMABuf means that we need to reclaim the memory from KMS first. We
can't just take it back, we need to allocate a new buffer, copy using
the CPU that buffer data, setupe the DMABuf reference. that new buffer
for redraw and then releas

This operation is extremely slow, since it requires an allocation and a
CPU copy of the data. This is only needed because V4L2 is trying to
prevent over allocation. In this case, userspace is only holding on 1
of the frames, this is far from the dramatic memory waste that we are
describing here.

regards,
Nicolas
