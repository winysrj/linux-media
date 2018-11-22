Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41594 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407885AbeKWKfb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 05:35:31 -0500
Received: by mail-qt1-f195.google.com with SMTP id d18so8940357qto.8
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 15:53:41 -0800 (PST)
Message-ID: <cce537955998a62d4fa36e466940fb3b5a9f21cf.camel@ndufresne.ca>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Nov 2018 18:53:39 -0500
In-Reply-To: <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com>
References: <20181113093048.236201-1-acourbot@chromium.org>
         <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
         <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
         <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
         <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 22 novembre 2018 à 17:31 +0900, Alexandre Courbot a écrit :
> On Fri, Nov 16, 2018 at 1:49 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > Le mercredi 14 novembre 2018 à 13:12 +0900, Alexandre Courbot a écrit :
> > > On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > > > 
> > > > Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromium.org> a écrit :
> > > > > The last buffer is often signaled by an empty buffer with the
> > > > > V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
> > > > > bytesused field set to the full size of the OPB, which leads
> > > > > user-space to believe that the buffer actually contains useful data. Fix
> > > > > this by passing the number of bytes reported used by the firmware.
> > > > 
> > > > That means the driver does not know on time which one is last. Why not just returned EPIPE to userspace on DQBUF and ovoid this useless roundtrip ?
> > > 
> > > Sorry, I don't understand what you mean. EPIPE is supposed to be
> > > returned after a buffer with V4L2_BUF_FLAG_LAST is made available for
> > > dequeue. This patch amends the code that prepares this LAST-flagged
> > > buffer. How could we avoid a roundtrip in this case?
> > 
> > Maybe it has changed, but when this was introduced, we found that some
> > firmware (Exynos MFC) could not know which one is last. Instead, it
> > gets an event saying there will be no more buffers.
> > 
> > Sending buffers with payload size to 0 just for the sake of setting the
> > V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
> > every polls should return EPIPE. So in the end, we decided the it
> > should just unblock the userspace and return EPIPE.
> > 
> > If you look at the related GStreamer code, it completely ignores the
> > LAST flag. With fake buffer of size 0, userspace will endup dequeuing
> > and throwing away. This is not useful to the process of terminating the
> > decoding. To me, this LAST flag is not useful in this context.
> 
> Note that this patch does not interfere with DQBUF returning -EPIPE
> after the last buffer has been dequeued. It just fixes an invalid size
> that was returned for the last buffer.
> 
> Note also that if I understand the doc properly, the kernel driver
> *must* set the V4L2_BUF_FLAG_LAST on the last buffer. With Venus the
> last buffer is signaled by the firmware with an empty buffer. That's
> not something we can change or predict earlier, so in order to respect
> the specification we need to return that empty buffer. After that
> DQBUF will behave as expected (returning -EPIPE), so GStreamer should
> be happy as well.
> 
> Without the proposed fix however, GStreamer would receive the last
> buffer with an incorrect size, and thus interpret random data as a
> frame.
> 
> So to me this fix seems to be both correct, and needed. Isn't it?

Totally, thanks for the extra clarification.

> 
> Cheers,
> Alex.
