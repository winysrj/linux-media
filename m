Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45425 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbeKPOTJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 09:19:09 -0500
Received: by mail-yb1-f193.google.com with SMTP id 131-v6so9263298ybe.12
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 20:08:25 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id o1-v6sm2558151ywf.81.2018.11.15.20.08.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Nov 2018 20:08:23 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id l200so4024652ywe.10
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 20:08:22 -0800 (PST)
MIME-Version: 1.0
References: <20181113093048.236201-1-acourbot@chromium.org>
 <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
 <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com> <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
In-Reply-To: <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Nov 2018 13:08:10 +0900
Message-ID: <CAAFQd5Cw2jmNwHCWYriw4H0TK0uWhVFbgs_RgxXV5npZLWvLbg@mail.gmail.com>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
To: nicolas@ndufresne.ca
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 16, 2018 at 1:50 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
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

It was never the case with the MFC (firmware/driver) we were using on
Chrome OS and it doesn't seem to be the case for the current upstream
s5p-mfc driver.

> Sending buffers with payload size to 0 just for the sake of setting the
> V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
> every polls should return EPIPE. So in the end, we decided the it
> should just unblock the userspace and return EPIPE.
>
> If you look at the related GStreamer code, it completely ignores the
> LAST flag. With fake buffer of size 0, userspace will endup dequeuing
> and throwing away. This is not useful to the process of terminating the
> decoding. To me, this LAST flag is not useful in this context.

Except that -EPIPE is actually signaled by the vb2 core and it happens
after the user space dequeues a buffer with the LAST flag set:
https://elixir.bootlin.com/linux/v4.20-rc2/source/drivers/media/common/vide=
obuf2/videobuf2-core.c#L1634
https://elixir.bootlin.com/linux/v4.20-rc2/source/drivers/media/common/vide=
obuf2/videobuf2-v4l2.c#L555

Best regards,
Tomasz
