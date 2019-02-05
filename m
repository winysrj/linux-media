Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0E4C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D849120844
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ESCnBO/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfBEJbY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:31:24 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37803 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbfBEJbY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 04:31:24 -0500
Received: by mail-ot1-f65.google.com with SMTP id s13so4611300otq.4
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 01:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y3Fskt2XhqRwwZ3I75pV2vnFeqIEbmjsQA1acACaMZc=;
        b=ESCnBO/zKgq7VBgH232re5qG9lXHcuk/qVUT7yClEEpcuJaBvJB9XSHRgMQvtn+TZO
         6WoBFh/qWuNhgjxYbEDdu4G2K/obAGHSG1GgLe+iv5q1rsaiWxNpRNQ5QYuoR4WpGYpz
         zW80jkRjTGg/wwJG5dRBYWpKl8O1CFIMtv40s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y3Fskt2XhqRwwZ3I75pV2vnFeqIEbmjsQA1acACaMZc=;
        b=Uvz2p4j3CsGzRw1szBZC7lm4OX/NUGfHiaEC/0EJkxOfHcy1pO8sK27Fb/lSVq3nEE
         E4Fy1E2Sb6aJOmeEB1hBVBYStDuc4mUXgx4rGg08zYzmSwSpboC0sOz83MYdsVALl46H
         IgPmUF+JbTbatqad4/UTlO5R3qHiHqQ/XpQVH1uvCNBQtczIM/NMCvKvoNEhJpaDJ5on
         /TGOGLxxM1cUYku1xWoKlZuYOxVAo2dRxAaW2q64LJVgFZ6HSTrZG9AIyoY27u+QGyhT
         4zx7EjMInwrT/o3M8fFTFs4BUwQEKYo0+Eq6MbKcCNhXSPdpZyzUIqtDN+G7raMnDh69
         almg==
X-Gm-Message-State: AHQUAuad9jKgTnL7zTMDPyZy6CAqi9YnH3k6NUd6OAwcwPkg+Knv6QfY
        eVBNIIzSaa3mOBINtG1TnpWebYYZek8=
X-Google-Smtp-Source: AHgI3IbL5qFdJLHZohA0X1k1wIUfCZnRfYABL1oy1xzD+fKXYBOn4aQg0oDm5abxbmY8cERevx08Hw==
X-Received: by 2002:a05:6808:21a:: with SMTP id l26mr1935931oie.312.1549359082128;
        Tue, 05 Feb 2019 01:31:22 -0800 (PST)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id w15sm9395056oie.43.2019.02.05.01.31.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 01:31:19 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id s5so4579628oth.7
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 01:31:18 -0800 (PST)
X-Received: by 2002:aca:b882:: with SMTP id i124mr2083341oif.127.1549359078264;
 Tue, 05 Feb 2019 01:31:18 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
 <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
 <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
 <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
 <1548938556.4585.1.camel@pengutronix.de> <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
 <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
 <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com> <f1e9dc99-4fcb-dee1-4279-ac0cf1d1fd6e@xs4all.nl>
In-Reply-To: <f1e9dc99-4fcb-dee1-4279-ac0cf1d1fd6e@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 5 Feb 2019 18:31:06 +0900
X-Gmail-Original-Message-ID: <CAAFQd5B+bt3SV_WRw1=2agZk=Q+Enbkv=nXCrbXX=+MNpeSpCg@mail.gmail.com>
Message-ID: <CAAFQd5B+bt3SV_WRw1=2agZk=Q+Enbkv=nXCrbXX=+MNpeSpCg@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 5, 2019 at 6:00 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 2/5/19 7:26 AM, Tomasz Figa wrote:
> > On Fri, Feb 1, 2019 at 12:18 AM Nicolas Dufresne <nicolas@ndufresne.ca>=
 wrote:
> >>
> >> Le jeudi 31 janvier 2019 =C3=A0 22:34 +0900, Tomasz Figa a =C3=A9crit =
:
> >>> On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.de=
> wrote:
> >>>> Hi Nicolas,
> >>>>
> >>>> On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> >>>>> Le mercredi 30 janvier 2019 =C3=A0 15:17 +0900, Tomasz Figa a =C3=
=A9crit :
> >>>>>>> I don't remember saying that, maybe I meant to say there might be=
 a
> >>>>>>> workaround ?
> >>>>>>>
> >>>>>>> For the fact, here we queue the headers (or first frame):
> >>>>>>>
> >>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2videodec.c#L624
> >>>>>>>
> >>>>>>> Then few line below this helper does G_FMT internally:
> >>>>>>>
> >>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2videodec.c#L634
> >>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2object.c#L3907
> >>>>>>>
> >>>>>>> And just plainly fails if G_FMT returns an error of any type. Thi=
s was
> >>>>>>> how Kamil designed it initially for MFC driver. There was no othe=
r
> >>>>>>> alternative back then (no EAGAIN yet either).
> >>>>>>
> >>>>>> Hmm, was that ffmpeg then?
> >>>>>>
> >>>>>> So would it just set the OUTPUT width and height to 0? Does it mea=
n
> >>>>>> that gstreamer doesn't work with coda and mtk-vcodec, which don't =
have
> >>>>>> such wait in their g_fmt implementations?
> >>>>>
> >>>>> I don't know for MTK, I don't have the hardware and didn't integrat=
e
> >>>>> their vendor pixel format. For the CODA, I know it works, if there =
is
> >>>>> no wait in the G_FMT, then I suppose we are being really lucky with=
 the
> >>>>> timing (it would be that the drivers process the SPS/PPS synchronou=
sly,
> >>>>> and a simple lock in the G_FMT call is enough to wait). Adding Phil=
ipp
> >>>>> in CC, he could explain how this works, I know they use GStreamer i=
n
> >>>>> production, and he would have fixed GStreamer already if that was
> >>>>> causing important issue.
> >>>>
> >>>> CODA predates the width/height=3D0 rule on the coded/OUTPUT queue.
> >>>> It currently behaves more like a traditional mem2mem device.
> >>>
> >>> The rule in the latest spec is that if width/height is 0 then CAPTURE
> >>> format is determined only after the stream is parsed. Otherwise it's
> >>> instantly deduced from the OUTPUT resolution.
> >>>
> >>>> When width/height is set via S_FMT(OUT) or output crop selection, th=
e
> >>>> driver will believe it and set the same (rounded up to macroblock
> >>>> alignment) on the capture queue without ever having seen the SPS.
> >>>
> >>> That's why I asked whether gstreamer sets width and height of OUTPUT
> >>> to non-zero values. If so, there is no regression, as the specs mimic
> >>> the coda behavior.
> >>
> >> I see, with Philipp's answer it explains why it works. Note that
> >> GStreamer sets the display size on the OUTPUT format (in fact we pass
> >> as much information as we have, because a) it's generic code and b) it
> >> will be needed someday when we enable pre-allocation (REQBUFS before
> >> SPS/PPS is passed, to avoid the setup delay introduce by allocation,
> >> mostly seen with CMA base decoder). In any case, the driver reported
> >> display size should always be ignored in GStreamer, the only
> >> information we look at is the G_SELECTION for the case the x/y or the
> >> cropping rectangle is non-zero.
> >>
> >> Note this can only work if the capture queue is not affected by the
> >> coded size, or if the round-up made by the driver is bigger or equal t=
o
> >> that coded size. I believe CODA falls into the first category, since
> >> the decoding happens in a separate set of buffers and are then de-tile=
d
> >> into the capture buffers (if understood correctly).
> >
> > Sounds like it would work only if coded size is equal to the visible
> > size (that GStreamer sets) rounded up to full macroblocks. Non-zero x
> > or y in the crop could be problematic too.
> >
> > Hans, what's your view on this? Should we require G_FMT(CAPTURE) to
> > wait until a format becomes available or the OUTPUT queue runs out of
>
> You mean CAPTURE queue? If not, then I don't understand that part.

No, I exactly meant the OUTPUT queue. The behavior of s5p-mfc in case
of the format not being detected yet is to waits for any pending
bitstream buffers to be processed by the decoder before returning an
error.

See https://elixir.bootlin.com/linux/v5.0-rc5/source/drivers/media/platform=
/s5p-mfc/s5p_mfc_dec.c#L329
.

>
> > buffers?
>
> First see my comment here regarding G_FMT returning an error:
>
> https://www.spinics.net/lists/linux-media/msg146505.html
>
> In my view that is a bad idea.

I don't like it either, but it seemed to be the most consistent and
compatible behavior, but I'm not sure anymore.

>
> What G_FMT should return between the time a resolution change was
> detected and the CAPTURE queue being drained (i.e. the old or the new
> resolution?) is something I am not sure about.

Note that we're talking here about the initial stream information
detection, when the driver doesn't have any information needed to
determine the CAPTURE format yet.

>
> On the one hand it is desirable to have the new resolution asap, on
> the other hand, returning the new resolution would mean that the
> returned format is inconsistent with the capture buffer sizes.
>
> I'm leaning towards either returning the new resolution.

Is the "or ..." part of the sentence missing?

One of the major concerns was that we needed to completely stall the
pipeline in case of a resolution change, which made it hard to deliver
a seamless transition to the users. An idea that comes to my mind
would be extending the source change event to actually include the
v4l2_format struct describing the new format. Then the CAPTURE queue
could keep the old format until it is drained, which should work fine
for existing applications, while the new ones could use the new event
data to determine if the buffers need to be reallocated.

<pipe dream>Ideally we would have all the metadata, including formats,
unified into a single property (or control) -like interface and tied
to buffers using Request API...</pipe dream>

Best regards,
Tomasz
