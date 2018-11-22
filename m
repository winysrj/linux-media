Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35673 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393078AbeKVTKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 14:10:21 -0500
Received: by mail-ot1-f65.google.com with SMTP id 81so7400512otj.2
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 00:31:56 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id b18sm2280819otl.33.2018.11.22.00.31.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Nov 2018 00:31:55 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id i20so7423154otl.0
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 00:31:54 -0800 (PST)
MIME-Version: 1.0
References: <20181113093048.236201-1-acourbot@chromium.org>
 <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
 <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com> <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
In-Reply-To: <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Thu, 22 Nov 2018 17:31:43 +0900
Message-ID: <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 16, 2018 at 1:49 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le mercredi 14 novembre 2018 =C3=A0 13:12 +0900, Alexandre Courbot a =C3=
=A9crit :
> > On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne.ca>=
 wrote:
> > >
> > >
> > > Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromium.or=
g> a =C3=A9crit :
> > > > The last buffer is often signaled by an empty buffer with the
> > > > V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
> > > > bytesused field set to the full size of the OPB, which leads
> > > > user-space to believe that the buffer actually contains useful data=
. Fix
> > > > this by passing the number of bytes reported used by the firmware.
> > >
> > > That means the driver does not know on time which one is last. Why no=
t just returned EPIPE to userspace on DQBUF and ovoid this useless roundtri=
p ?
> >
> > Sorry, I don't understand what you mean. EPIPE is supposed to be
> > returned after a buffer with V4L2_BUF_FLAG_LAST is made available for
> > dequeue. This patch amends the code that prepares this LAST-flagged
> > buffer. How could we avoid a roundtrip in this case?
>
> Maybe it has changed, but when this was introduced, we found that some
> firmware (Exynos MFC) could not know which one is last. Instead, it
> gets an event saying there will be no more buffers.
>
> Sending buffers with payload size to 0 just for the sake of setting the
> V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
> every polls should return EPIPE. So in the end, we decided the it
> should just unblock the userspace and return EPIPE.
>
> If you look at the related GStreamer code, it completely ignores the
> LAST flag. With fake buffer of size 0, userspace will endup dequeuing
> and throwing away. This is not useful to the process of terminating the
> decoding. To me, this LAST flag is not useful in this context.

Note that this patch does not interfere with DQBUF returning -EPIPE
after the last buffer has been dequeued. It just fixes an invalid size
that was returned for the last buffer.

Note also that if I understand the doc properly, the kernel driver
*must* set the V4L2_BUF_FLAG_LAST on the last buffer. With Venus the
last buffer is signaled by the firmware with an empty buffer. That's
not something we can change or predict earlier, so in order to respect
the specification we need to return that empty buffer. After that
DQBUF will behave as expected (returning -EPIPE), so GStreamer should
be happy as well.

Without the proposed fix however, GStreamer would receive the last
buffer with an incorrect size, and thus interpret random data as a
frame.

So to me this fix seems to be both correct, and needed. Isn't it?

Cheers,
Alex.
