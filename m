Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34652 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbeKZTQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:16:50 -0500
Received: by mail-ot1-f65.google.com with SMTP id t5so15833015otk.1
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 00:23:28 -0800 (PST)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id d124-v6sm20543168oia.29.2018.11.26.00.23.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 00:23:27 -0800 (PST)
Received: by mail-ot1-f53.google.com with SMTP id e12so11481341otl.5
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 00:23:26 -0800 (PST)
MIME-Version: 1.0
References: <20181113093048.236201-1-acourbot@chromium.org>
 <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
 <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
 <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
 <CAPBb6MVzqqgUD5faN06=s-UNA9obxjiBQdMDNDK7m=m3=Utk3w@mail.gmail.com> <cce537955998a62d4fa36e466940fb3b5a9f21cf.camel@ndufresne.ca>
In-Reply-To: <cce537955998a62d4fa36e466940fb3b5a9f21cf.camel@ndufresne.ca>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 26 Nov 2018 17:23:15 +0900
Message-ID: <CAPBb6MVnS6Bvx77PYRjxanCfYXpUzcK84DDAmZwhJsmhvCV26Q@mail.gmail.com>
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

On Fri, Nov 23, 2018 at 8:53 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le jeudi 22 novembre 2018 =C3=A0 17:31 +0900, Alexandre Courbot a =C3=A9c=
rit :
> > On Fri, Nov 16, 2018 at 1:49 AM Nicolas Dufresne <nicolas@ndufresne.ca>=
 wrote:
> > > Le mercredi 14 novembre 2018 =C3=A0 13:12 +0900, Alexandre Courbot a =
=C3=A9crit :
> > > > On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne=
.ca> wrote:
> > > > >
> > > > > Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromiu=
m.org> a =C3=A9crit :
> > > > > > The last buffer is often signaled by an empty buffer with the
> > > > > > V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with th=
e
> > > > > > bytesused field set to the full size of the OPB, which leads
> > > > > > user-space to believe that the buffer actually contains useful =
data. Fix
> > > > > > this by passing the number of bytes reported used by the firmwa=
re.
> > > > >
> > > > > That means the driver does not know on time which one is last. Wh=
y not just returned EPIPE to userspace on DQBUF and ovoid this useless roun=
dtrip ?
> > > >
> > > > Sorry, I don't understand what you mean. EPIPE is supposed to be
> > > > returned after a buffer with V4L2_BUF_FLAG_LAST is made available f=
or
> > > > dequeue. This patch amends the code that prepares this LAST-flagged
> > > > buffer. How could we avoid a roundtrip in this case?
> > >
> > > Maybe it has changed, but when this was introduced, we found that som=
e
> > > firmware (Exynos MFC) could not know which one is last. Instead, it
> > > gets an event saying there will be no more buffers.
> > >
> > > Sending buffers with payload size to 0 just for the sake of setting t=
he
> > > V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
> > > every polls should return EPIPE. So in the end, we decided the it
> > > should just unblock the userspace and return EPIPE.
> > >
> > > If you look at the related GStreamer code, it completely ignores the
> > > LAST flag. With fake buffer of size 0, userspace will endup dequeuing
> > > and throwing away. This is not useful to the process of terminating t=
he
> > > decoding. To me, this LAST flag is not useful in this context.
> >
> > Note that this patch does not interfere with DQBUF returning -EPIPE
> > after the last buffer has been dequeued. It just fixes an invalid size
> > that was returned for the last buffer.
> >
> > Note also that if I understand the doc properly, the kernel driver
> > *must* set the V4L2_BUF_FLAG_LAST on the last buffer. With Venus the
> > last buffer is signaled by the firmware with an empty buffer. That's
> > not something we can change or predict earlier, so in order to respect
> > the specification we need to return that empty buffer. After that
> > DQBUF will behave as expected (returning -EPIPE), so GStreamer should
> > be happy as well.
> >
> > Without the proposed fix however, GStreamer would receive the last
> > buffer with an incorrect size, and thus interpret random data as a
> > frame.
> >
> > So to me this fix seems to be both correct, and needed. Isn't it?
>
> Totally, thanks for the extra clarification.

Awesome, thanks for confirming!

Stanimir, can we have your thoughts about this change?
