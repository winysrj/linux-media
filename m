Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55133 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1FTB2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 21:28:48 -0400
Received: by qwk3 with SMTP id 3so596271qwk.19
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 18:28:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110617125713.293f484d@bike.lwn.net>
References: <20110617125713.293f484d@bike.lwn.net>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 19 Jun 2011 18:28:27 -0700
Message-ID: <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
Subject: Re: vb2: holding buffers until after start_streaming()
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jon,

On Fri, Jun 17, 2011 at 11:57, Jonathan Corbet <corbet@lwn.net> wrote:
> Here's another videobuf2 question...I've been trying to track down some
> weird behavior, the roots of which were in the fact that start_streaming()
> gets called even though no buffers have been queued.  This behavior is
> quite explicit in the code:
>
>        /*
>         * Let driver notice that streaming state has been enabled.
>         */
>        ret = call_qop(q, start_streaming, q);
>        if (ret) {
>                dprintk(1, "streamon: driver refused to start streaming\n");
>                return ret;
>        }
>
>        q->streaming = 1;
>
>        /*
>         * If any buffers were queued before streamon,
>         * we can now pass them to driver for processing.
>         */
>        list_for_each_entry(vb, &q->queued_list, queued_entry)
>                __enqueue_in_driver(vb);
>
> Pretty much every v4l2 capture application I've ever encountered passes all
> of its buffers to VIDIOC_QBUF before starting streaming for a reason - it
> makes little sense to start if there's nothing to stream to.  It's really
> tempting to reorder that code, but...  it seems you must have done things
> this way for a reason.  Why did you need to reorder the operations in this
> way?
>

I don't see a reason why these couldn't be reordered (Marek should be
able to confirm, he wrote those lines). But this wouldn't fix
everything, as the V4L2 API permits streamon without queuing any
buffers first (for capture devices). So even reordered, it's possible
for start_streaming to be called without passing any buffers to the
driver first.

-- 
Best regards,
Pawel Osciak
