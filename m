Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF59C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 04:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0212186A
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 04:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e0SnTOtw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbfCOESc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:18:32 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39425 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfCOESc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 00:18:32 -0400
Received: by mail-ot1-f68.google.com with SMTP id e15so7241746otk.6
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 21:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LssM8K3Nuk/CQHuSShuW2R2gV3ZVu4UdpIwaNVwonuY=;
        b=e0SnTOtwQpUh4RASyujYv+ICiAoxc6Ma+GeRE2TzFItsi8A5pAAWC2OSMvUFq9TB8H
         bzBcV8MK9SGIxoVgv2xBA1KTZqDHfbZCTxqwY6mblBy1il8yZrRieVqUWHu6OUFU6MPZ
         oR5jiJJMJGXrJcpU49Ge08nIbkkXZpP2oVGHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LssM8K3Nuk/CQHuSShuW2R2gV3ZVu4UdpIwaNVwonuY=;
        b=Ym2eME+aQidmPkcntc+fWqxdBXxjX6OMlWgNGKmQi3kswPc5RE3ARjOslVwEkUZnk9
         RJGRkCqjmCrozEVarNrcihukBm3xp0v642zFt983WoD3e3yaMPwFI0eC/x4ZmcKp/Gc7
         FYa1oOHPssxoNDFyoGL2arhpmd6Hez73qPWJZSU9WT19Czu0JTD/9C1fX7pB1PZbVRab
         10yUedQz7rKetJtW8GcS3m9vTZSyTKcp1ZuZYQ77PD9CU4QlqziLWTjFNAxQ7Xbob6N4
         PPzO2Lzqoss4RMnEww4HdalwNC+6VS/pr4gZJwfiEXgZ1pConvcpBPfPTY0/PPH6+yZO
         /yVg==
X-Gm-Message-State: APjAAAVvxy4HZmRq4tMf/RPi1g4Gi1gxleoYZlimY7kpSUO1d4XVF5A8
        WnBLCRaZZMtaMqa4JNNun9Ip9UfnXo8=
X-Google-Smtp-Source: APXvYqy/1x8PrXmu21uYRQ//oSh0VmSpeXjZFM8jrgTYHyigUJHUFkD5Oxvh4JyfOl4kaPcGQf+Zsw==
X-Received: by 2002:a9d:5e8e:: with SMTP id f14mr899980otl.19.1552623510412;
        Thu, 14 Mar 2019 21:18:30 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id n25sm453874otj.76.2019.03.14.21.18.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 21:18:29 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id d22so6249696otk.10
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 21:18:28 -0700 (PDT)
X-Received: by 2002:a9d:760a:: with SMTP id k10mr925506otl.367.1552623508168;
 Thu, 14 Mar 2019 21:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <CAAFQd5COSecRGOSUyQGAe0ob-do0C5=FqhQZoq-d1EULhMiWHg@mail.gmail.com> <2004464.r89rQTy7OA@avalon>
In-Reply-To: <2004464.r89rQTy7OA@avalon>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 15 Mar 2019 13:18:17 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
Message-ID: <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
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

On Fri, Oct 26, 2018 at 10:42 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> On Friday, 26 October 2018 14:41:26 EEST Tomasz Figa wrote:
> > On Thu, Sep 20, 2018 at 11:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > Some parts of the V4L2 API are awkward to use and I think it would be
> > > a good idea to look at possible candidates for that.
> > >
> > > Examples are the ioctls that use struct v4l2_buffer: the multiplanar
> > > support is really horrible, and writing code to support both single and
> > > multiplanar is hard. We are also running out of fields and the timeval
> > > isn't y2038 compliant.
> > >
> > > A proof-of-concept is here:
> > >
> > > https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a
> > > 95549df06d9900f3559afdbb9da06bd4b22d1f3
> > >
> > > It's a bit old, but it gives a good impression of what I have in mind.
> >
> > On a related, but slightly different note, I'm wondering how we should
> > handle a case where we have an M format (e.g. NV12M with 2 memory
> > planes), but only 1 DMA-buf with all planes to import. That generally
> > means that we have to use the same DMA-buf FD with an offset for each
> > plane. In theory, v4l2_plane::data_offset could be used for this, but
> > the documentation says that it should be set by the application only
> > for OUTPUT planes. Moreover, existing drivers tend to just ignore
> > it...
>
> The following patches may be of interest.
>
> https://patchwork.linuxtv.org/patch/29177/
> https://patchwork.linuxtv.org/patch/29178/

[+CC Boris]

Thanks Laurent for pointing me to those patches.

Repurposing the data_offset field may sound like a plausible way to do
it, but it's not, for several reasons:

1) The relation between data_offset and other fields in v4l2_buffer
makes it hard to use in drivers and userspace.

2) It is not handled by vb2, so each driver would have to
explicitly add data_offset to the plane address and subtract it from
plane size and/or bytesused (since data_offset counts into plane size
and bytesused),

3) For CAPTURE buffers, it's actually defined as set-by-driver
(https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#struct-v4l2-plane),
so anything userspace sets there is bound to be ignored. I'm not sure
if we can change this now, as it would be a compatibility issue.

(There are actually real use cases for it, i.e. the venus driver
outputs VPx encoded frames prepended with the IVF header, but that's
not what the V4L2 VPx formats expect, so the data_offset is set by the
driver to point to the raw bitstream data.)

Best regards,
Tomasz

>
> > There is also the opposite problem. Sometimes the application is given
> > 3 different FDs but pointing to the same buffer. If it has to work
> > with a video device that only supports non-M formats, it can either
> > fail, making it unusable, or blindly assume that they all point to the
> > same buffer and just give the first FD to the video device (we do it
> > in Chromium, since our allocator is guaranteed to keep all planes of
> > planar formats in one buffer, if to be used with V4L2).
> >
> > Something that we could do is allowing the QBUF semantics of M formats
> > for non-M formats, where the application would fill the planes[] array
> > for all planes with all the FDs it has and the kernel could then
> > figure out if they point to the same buffer (i.e. resolve to the same
> > dma_buf struct) or fail if not.
> >
> > [...]
> >
> > > Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps,
> > > again in order to improve single vs multiplanar handling.
> >
> > I'd definitely be more than happy to see the plane handling unified
> > between non-M and M formats, in general. The list of problems with
> > current interface:
> >
> > 1) The userspace has to hardcode the computations of bytesperline for
> > chroma planes of non-M formats (while they are reported for M
> > formats).
> >
> > 2) Similarly, offsets of the planes in the buffer for non-M formats
> > must be explicitly calculated in the application,
> >
> > 3) Drivers have to explicitly handle both non-M and M formats or
> > otherwise they would suffer from issues with application compatibility
> > or sharing buffers with other devices (one supporting only M and the
> > other only non-M),
> >
> > 4) Inconsistency in the meaning of planes[0].sizeimage for non-M
> > formats and M formats, making it impossible to use planes[0].sizeimage
> > to set the luma plane size in the hardware for non-M formats (since
> > it's the total size of all planes).
> >
> > I might have probably forgotten about something, but generally fixing
> > the 4 above, would be a really big step forward.
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
