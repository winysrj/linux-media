Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08E5C282CC
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7266218FE
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PQq0BYlJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfBGIvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 03:51:48 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43090 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfBGIvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 03:51:48 -0500
Received: by mail-ot1-f67.google.com with SMTP id a11so16905818otr.10
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 00:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=67TqqQt2cMAQmgp7V/k3Hdqs/WwIh1qTEk8gB70lbIc=;
        b=PQq0BYlJLY3tKUKboY4AsqTP74D06T1ebfDhMRI6scT73OZEYw5dxxNsVAioNYkONS
         vf6OCiQxorR5o0UeAlerno/P1IY2Zf5l6m+VdN7iae9ToBUfpnr5A2pTQvDCJRS66tO3
         PzEl2vMr5HEbIY2w9YWrwVRHaKkTa9obJr1nA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=67TqqQt2cMAQmgp7V/k3Hdqs/WwIh1qTEk8gB70lbIc=;
        b=MTzwQXPBAH7iiHN2ZjlE28tMx6lmOqv2OmqxXazvzcP5r0OoNj6SsjyRiOEBKFhRS9
         ZNHe3IC6ba56m7ciB2S4nwVZUG9Yd75S7VNpKidt8dcXFBwd3mAh62O8nMIyKINj2cZF
         Dp/CqgjBt1nzMHB8/jenqUcZkd2PT6Gtp/8/5uRDnPcCEMTYo71VJWRmmcr0l/S+R1yN
         3EqFrquOP5AERZzhA6AEiq4UgggHQOHj/2DnxSM3+1dGIstznV/9apdcmbZ8mXVqRQ8O
         VgEHVia/IIz5u5FvDs1AJOfhU2asqRHwHwQUUCI/B44O88pagN2fuOWasSeopAVSAxJa
         upqQ==
X-Gm-Message-State: AHQUAuaO50avRi3iEj4LsCceedwQ6MhFzHxOzGn4Pwl/mDxkAyiNVt4j
        KYLCkHUprn49IGh7iz/s7VnPLHyLL/lYDQ==
X-Google-Smtp-Source: AHgI3IYwqBZIANK+Hoifn/3r4E8PDdlo1CKp/jPdMCO7iw9fiJ9idX9+TtjtnqsD3/1JiOs9aIM3Hw==
X-Received: by 2002:a9d:3e16:: with SMTP id a22mr8665308otd.43.1549529507269;
        Thu, 07 Feb 2019 00:51:47 -0800 (PST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id 21sm11405325oie.24.2019.02.07.00.51.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 00:51:45 -0800 (PST)
Received: by mail-ot1-f52.google.com with SMTP id s13so16975676otq.4
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 00:51:44 -0800 (PST)
X-Received: by 2002:a9d:1b67:: with SMTP id l94mr430687otl.147.1549529504330;
 Thu, 07 Feb 2019 00:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20190124100419.26492-1-tfiga@chromium.org> <20190124100419.26492-2-tfiga@chromium.org>
 <a3b1b650-94d7-bb84-41ef-dc4cab0cdae1@xs4all.nl> <54430438-33a3-2c52-b6c8-4000a4088906@xs4all.nl>
 <1548938648.4585.3.camel@pengutronix.de> <6aa88094-068a-089d-2d52-3f9ade5a396c@xs4all.nl>
In-Reply-To: <6aa88094-068a-089d-2d52-3f9ade5a396c@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 7 Feb 2019 17:51:33 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CU6YQsfTeZS68RdFSme_6YstcvVYOSdZyWMgnSejpdyQ@mail.gmail.com>
Message-ID: <CAAFQd5CU6YQsfTeZS68RdFSme_6YstcvVYOSdZyWMgnSejpdyQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 31, 2019 at 10:19 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 1/31/19 1:44 PM, Philipp Zabel wrote:
> > On Thu, 2019-01-31 at 13:30 +0100, Hans Verkuil wrote:
> >> On 1/31/19 11:45 AM, Hans Verkuil wrote:
> >>> On 1/24/19 11:04 AM, Tomasz Figa wrote:
> >>>> Due to complexity of the video decoding process, the V4L2 drivers of
> >>>> stateful decoder hardware require specific sequences of V4L2 API cal=
ls
> >>>> to be followed. These include capability enumeration, initialization=
,
> >>>> decoding, seek, pause, dynamic resolution change, drain and end of
> >>>> stream.
> >>>>
> >>>> Specifics of the above have been discussed during Media Workshops at
> >>>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> >>>> Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API th=
at
> >>>> originated at those events was later implemented by the drivers we a=
lready
> >>>> have merged in mainline, such as s5p-mfc or coda.
> >>>>
> >>>> The only thing missing was the real specification included as a part=
 of
> >>>> Linux Media documentation. Fix it now and document the decoder part =
of
> >>>> the Codec API.
> >>>>
> >>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> >>>> ---
> >>>>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 ++++++++++++++=
+++
> >>>>  Documentation/media/uapi/v4l/dev-mem2mem.rst  |    5 +
> >>>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
> >>>>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
> >>>>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
> >>>>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
> >>>>  6 files changed, 1135 insertions(+), 15 deletions(-)
> >>>>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> >>>>
> >>>
> >>> <snip>
> >>>
> >>>> +4.  **This step only applies to coded formats that contain resoluti=
on information
> >>>> +    in the stream.** Continue queuing/dequeuing bitstream buffers t=
o/from the
> >>>> +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_=
DQBUF`. The
> >>>> +    buffers will be processed and returned to the client in order, =
until
> >>>> +    required metadata to configure the ``CAPTURE`` queue are found.=
 This is
> >>>> +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE``=
 event with
> >>>> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
> >>>> +
> >>>> +    * It is not an error if the first buffer does not contain enoug=
h data for
> >>>> +      this to occur. Processing of the buffers will continue as lon=
g as more
> >>>> +      data is needed.
> >>>> +
> >>>> +    * If data in a buffer that triggers the event is required to de=
code the
> >>>> +      first frame, it will not be returned to the client, until the
> >>>> +      initialization sequence completes and the frame is decoded.
> >>>> +
> >>>> +    * If the client sets width and height of the ``OUTPUT`` format =
to 0,
> >>>> +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT`,
> >>>> +      :c:func:`VIDIOC_TRY_FMT` or :c:func:`VIDIOC_REQBUFS` on the `=
`CAPTURE``
> >>>> +      queue will return the ``-EACCES`` error code, until the decod=
er
> >>>> +      configures ``CAPTURE`` format according to stream metadata.
> >>>
> >>> I think this should also include the G/S_SELECTION ioctls, right?
> >>
> >> I've started work on adding compliance tests for codecs to v4l2-compli=
ance and
> >> I quickly discovered that this 'EACCES' error code is not nice at all.
> >>
> >> The problem is that it is really inconsistent with V4L2 behavior: the =
basic
> >> rule is that there always is a format defined, i.e. G_FMT will always =
return
> >> a format.
> >>
> >> Suddenly returning an error is actually quite painful to handle becaus=
e it is
> >> a weird exception just for the capture queue of a stateful decoder if =
no
> >> output resolution is known.
> >>
> >> Just writing that sentence is painful.
> >>
> >> Why not just return some default driver defined format? It will automa=
tically
> >> be updated once the decoder parsed the bitstream and knows the new res=
olution.
> >>
> >> It really is just the same behavior as with a resolution change.
> >>
> >> It is also perfectly fine to request buffers for the capture queue for=
 that
> >> default format. It's pointless, but not a bug.
> >>
> >> Unless I am missing something I strongly recommend changing this behav=
ior.
> >
> > I just wrote the same in my reply to Nicolas, the CODA driver currently
> > sets the capture queue width/height to the output queue's crop rectangl=
e
> > (rounded to macroblock size) without ever having seen the SPS.
>
> And thinking about the initial 0x0 width/height for the output queue:
>
> that too is an exception, although less of a problem than the EACCES beha=
vior.
>
> It should be fine for an application to set width/height to 0 when callin=
g
> S_FMT for the output queue of the decoder, but I would also prefer that i=
t is
> just replaced by the driver with some default resolution. It really doesn=
't
> matter in practice, since you will wait for the SOURCE_CHANGE event regar=
dless.
>
> Only then do you start to configure the CAPTURE queue.
>
> Using 0x0 and EACCES looks good on paper, but in the code it is a hassle =
and
> I'm not convinced there is any benefit.
>
> I like generic APIs and no where else do we ever return a 0 value for wid=
th
> or height, except in this corner case. It's just awkward.

Agreed, although with some caveats I mentioned in my reply to the venus pat=
ch.

Best regards,
Tomasz
