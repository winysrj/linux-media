Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:45739 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeEYEPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 00:15:40 -0400
Received: by mail-vk0-f47.google.com with SMTP id n134-v6so2370369vke.12
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 21:15:40 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com. [209.85.213.42])
        by smtp.gmail.com with ESMTPSA id 48-v6sm538980uak.48.2018.05.24.21.15.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 May 2018 21:15:38 -0700 (PDT)
Received: by mail-vk0-f42.google.com with SMTP id i185-v6so2381481vkg.3
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 21:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
In-Reply-To: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 25 May 2018 13:15:25 +0900
Message-ID: <CAAFQd5C4+dHEm+XQ+CUU0LYkRjd=uX-wuYL11JYXUyNZKxJi4A@mail.gmail.com>
Subject: Re: RFC: Request API and memory-to-memory devices
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        nicolas@ndufresne.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 24, 2018 at 5:44 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Memory-to-memory devices have one video node, one internal control handler
> but two vb2_queues (DMA engines). While often there is one buffer produced
> for every buffer consumed, but this is by no means standard. E.g.
deinterlacers
> will produce on buffer for every two buffers consumed. Codecs that receive
> a bit stream and can parse it to discover the framing may have no relation
> between the number of buffers consumed and the number of buffers produced.

> This poses a few problems for the Request API. Requiring that a request
> contains the buffers for both output and capture queue will be difficult
> to implement, especially in the latter case where there is no relationship
> between the number of consumed and produced buffers.

> In addition, userspace can make two requests: one for the capture queue,
> one for the output queue, each with associated controls. But since the
> controls are shared between capture and output there is an issue of
> what to do when the same control is set in both requests.

> I propose to restrict the usage of requests for m2m drivers to the output
> queue only. This keeps things simple for both kernel and userspace and
> avoids complex solutions.

> Requests only make sense if there is actually configuration you can apply
> for each buffer, and while that's true for the output queue, on the
capture
> queue you just capture the result of whatever the device delivers. I don't
> believe there is much if anything you can or want to control per-buffer.

> Am I missing something? Comments?

That sounds fair to me, should make kernel code simpler (no 2 requests per
job, as we saw in vim2m in some earlier RFC) and shouldn't complicate
userspace (it has to dequeue requests and buffers anyway, so it always
knows which buffer belongs to which request for the real 1:1 M2M cases).

Best regards,
Tomasz
