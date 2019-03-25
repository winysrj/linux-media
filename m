Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE41C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 09:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F1820870
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 09:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WI9Zz0Jh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfCYJmN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:42:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38554 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730243AbfCYJmN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 05:42:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id e80so7412289ote.5
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 02:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5F8z5ziX7M6ihQ8qI/e6EevQy+CCjoBAdOT6aPc7AQ=;
        b=WI9Zz0JhP97y4Jv97/dz2SOIUn7BYZms3/TQg3D2Lakb8BPMznkYe8tzOGPlUzwTQn
         wHHBrKaRCWPaoNY0Lgc8QZUdbB7iUu4AtJ97Bcl958OK822UU1ZHlVd0iLsOdTe6OSkL
         QfYCEHIQG2gjS8vBIYob5I5Kqy4FIuVM5eDZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5F8z5ziX7M6ihQ8qI/e6EevQy+CCjoBAdOT6aPc7AQ=;
        b=ieknC8b29qaE8EQ1zmU30yCqL5EtTmRpGc+nlsg8NPWthP0pR7ZjLJLuzKdbW2qFLZ
         xPvs+buuqMNx0AOJAK0ibVQlCkag2M9Fo2bl53Ot8naCozA1cRR39Fc9mkls4pA9P9NQ
         hfZmAW+wcuVFG91/K30Kx/31hMaTSQSxFH3Kvzw4i7IfLP1vr3ezFi74JiHuTNzOTzQE
         ZWxN7GE78ZEPqqDuDLX9TCi+W+MA133ajMnw+GwUV1o4kguJMBaPZVsij951xCCj4cEN
         Zc2gPgw0d8ilb5D0PGzAEqgNYOlj6ibSn7fVr2A+x6ZiVn4qvM758EAycZNjCLGqA+K1
         PtyQ==
X-Gm-Message-State: APjAAAU9s/fhrmC1V2nSJ0BYY3llTcfjBvOGbRyD1LORSp2aH3Opf+h/
        HL1S9gUml32URhYMIyOYeQGk3OR8Gl3YYA==
X-Google-Smtp-Source: APXvYqzDSPVkY6Uk1ScNuSRrV60AwK2Tapww5vmm6USDik3r3FxPTPTht+FOHSDkRD5h6/ZwRVnyJw==
X-Received: by 2002:a9d:754a:: with SMTP id b10mr17947678otl.44.1553506931717;
        Mon, 25 Mar 2019 02:42:11 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id s62sm5923583oib.36.2019.03.25.02.42.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 02:42:10 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id 67so6374889oif.10
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 02:42:10 -0700 (PDT)
X-Received: by 2002:aca:59d7:: with SMTP id n206mr11206292oib.26.1553506929989;
 Mon, 25 Mar 2019 02:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <CAAFQd5COSecRGOSUyQGAe0ob-do0C5=FqhQZoq-d1EULhMiWHg@mail.gmail.com>
 <2004464.r89rQTy7OA@avalon> <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
 <20190317161041.GC17898@pendragon.ideasonboard.com>
In-Reply-To: <20190317161041.GC17898@pendragon.ideasonboard.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 25 Mar 2019 18:41:57 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DSW0nYbsXehwQRS95xyty_S_LY5jVzg1yyzekpZVJNwQ@mail.gmail.com>
Message-ID: <CAAFQd5DSW0nYbsXehwQRS95xyty_S_LY5jVzg1yyzekpZVJNwQ@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 18, 2019 at 1:10 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Fri, Mar 15, 2019 at 01:18:17PM +0900, Tomasz Figa wrote:
> > On Fri, Oct 26, 2018 at 10:42 PM Laurent Pinchart wrote:
> > > On Friday, 26 October 2018 14:41:26 EEST Tomasz Figa wrote:
> > >> On Thu, Sep 20, 2018 at 11:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >>> Some parts of the V4L2 API are awkward to use and I think it would be
> > >>> a good idea to look at possible candidates for that.
> > >>>
> > >>> Examples are the ioctls that use struct v4l2_buffer: the multiplanar
> > >>> support is really horrible, and writing code to support both single and
> > >>> multiplanar is hard. We are also running out of fields and the timeval
> > >>> isn't y2038 compliant.
> > >>>
> > >>> A proof-of-concept is here:
> > >>>
> > >>> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a
> > >>> 95549df06d9900f3559afdbb9da06bd4b22d1f3
> > >>>
> > >>> It's a bit old, but it gives a good impression of what I have in mind.
> > >>
> > >> On a related, but slightly different note, I'm wondering how we should
> > >> handle a case where we have an M format (e.g. NV12M with 2 memory
> > >> planes), but only 1 DMA-buf with all planes to import. That generally
> > >> means that we have to use the same DMA-buf FD with an offset for each
> > >> plane. In theory, v4l2_plane::data_offset could be used for this, but
> > >> the documentation says that it should be set by the application only
> > >> for OUTPUT planes. Moreover, existing drivers tend to just ignore
> > >> it...
> > >
> > > The following patches may be of interest.
> > >
> > > https://patchwork.linuxtv.org/patch/29177/
> > > https://patchwork.linuxtv.org/patch/29178/
> >
> > [+CC Boris]
> >
> > Thanks Laurent for pointing me to those patches.
> >
> > Repurposing the data_offset field may sound like a plausible way to do
> > it, but it's not, for several reasons:
> >
> > 1) The relation between data_offset and other fields in v4l2_buffer
> > makes it hard to use in drivers and userspace.
>
> Could you elaborate on this ?

Well, it's not a critical issue, but having the application need to
always add data_offset to bytesused and length makes the code a bit
messy, because the values don't really relate to the plane anymore,
but the buffer (or not even, since length would be less than the
buffer length for planes other than the last).

>
> > 2) It is not handled by vb2, so each driver would have to
> > explicitly add data_offset to the plane address and subtract it from
> > plane size and/or bytesused (since data_offset counts into plane size
> > and bytesused),
>
> We should certainly handle that in the V4L2 core and/or in vb2. I think
> we should go one step further and handle the compose rectangle there
> too, as composing for capture devices is essentially offsetting the
> buffer and setting the correct stride. I wonder if it was a mistake to
> expose compose rectangle on capture video nodes, maybe stride + offset
> would be a better API.
>
> > 3) For CAPTURE buffers, it's actually defined as set-by-driver
> > (https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#struct-v4l2-plane),
> > so anything userspace sets there is bound to be ignored. I'm not sure
> > if we can change this now, as it would be a compatibility issue.
> >
> > (There are actually real use cases for it, i.e. the venus driver
> > outputs VPx encoded frames prepended with the IVF header, but that's
> > not what the V4L2 VPx formats expect, so the data_offset is set by the
> > driver to point to the raw bitstream data.)
>
> Doesn't that essentially create a custom format though ? Who consumes
> the IVF header ?

Nobody consumes it. I believe data_offset was made exactly for this
purpose, to skip useless headers and avoid format proliferation.

>
> Another use case is handling of embedded data with CSI-2.
>
> CSI-2 sensors can send multiple types of data multiplexed in a single
> virtual channels. Common use cases include sending a few lines of
> metadata, or sending optical black lines, in addition to the main image.
> A CSI-2 source could also send the same image in multiple formats, but I
> haven't seen that happening in practice. The CSI-2 standard tags each
> line with a data type in order to differentiate them on the receiver
> side. On the receiver side, some receivers allow capturing different
> data types in different buffers, while other support a single buffer
> only, with or without data type filtering. It may thus be that a sensor
> sending 2 lines of embedded data before the image to a CSI-2 receiver
> that supports a single buffer will leave the user with two options,
> capturing the image only or capturing both in the same buffer (really
> simple receivers may only offer the last option). Reporting to the user
> how data is organized in the buffer is needed, and the data_offset field
> is used for this.
>
> This being said, I don't think it's a valid use case fo data_offset. As
> mentioned above a sensor could send more than one data type in addition
> to the main image (embedded data + optical black is one example), so a
> single data_offset field wouldn't allow differentiating embedded data
> from optical black lines. I think a more powerful frame descriptor API
> would be needed for this. The fact that the buffer layout doesn't change
> between frames also hints that this should be supported at the format
> level, not the buffer level.

FYI, this topic was also brought in some threads about the stateless
video decoders, where it could be useful to still pass the full
bitstream to the decoder, but tag it with locations of particular
parts in the buffer (NAL headers, PPS, SPS, slice header, slice data,
etc.)

Best regards,
Tomasz
