Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79184C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 06:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3210E21773
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 06:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ei3wn2Zb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbeLTGc3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 01:32:29 -0500
Received: from mail-yw1-f44.google.com ([209.85.161.44]:44498 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbeLTGc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 01:32:29 -0500
Received: by mail-yw1-f44.google.com with SMTP id i22so245715ywa.11
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 22:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mwbOAGUpkp2kGshh/awyWyj7V59cWzA+o2D0KmFeSyg=;
        b=Ei3wn2Zbt2OiD1/0Mif1ve96Vdrnxb4Zfxb5lxMpPMV25qcrFpu+iDOHgpqCTLKizP
         csA1mju5sT2wkn4AdqHAw4tC9wpmPYyoDN+tG/8z3CTw8pInU7gMXyhjuvv1G+KDDGlu
         2r+8dpRmq2dTrdHqYE7AH+R6LPnnagtZzQI+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mwbOAGUpkp2kGshh/awyWyj7V59cWzA+o2D0KmFeSyg=;
        b=iXgkL1mvA0R2eulctaOtBzVUkmFRxk2zXCaQ62AgN+0afLqPLsvaNutB3S8mdEiROK
         QWfrlP6po4IuPi1bE1aHpo1B1iee+kG3AbANkC/Uaj9RVFQg+7a5sq884JO3j/RJO8GE
         4s0/WAvFLjPkqkBND8U31oBsRqIbmqzf0meH9vyeVsNiMfJJe+I9Juzj/70DIRwLqNNl
         /6yTA1aTgI+DZepGPDPXmOUBDgUhb0MSZscYB51JTLbx28W6YYsxAxQSjIrlqiblI83k
         R4UkpfZ0CCg7kMpd0YpZIDUocQsGR8us8fNBNde5strYkrrcy0M6uVPqljKsx5L/S9W4
         nl9Q==
X-Gm-Message-State: AA+aEWaYAV4Y6sd8n9trDZBlcQAeELGex5bDhrs+4Xr5p1iuEd75LKV9
        R7pk6nGLZkol3eZrdkom1aVb4e2lPN4=
X-Google-Smtp-Source: AFSGD/Xl5TiIQyvv5/8XYIleorK4IeZHyqEfSdqbSy+tiask/XrRCrbqOO5w2sRa5XIc8eHYpalP2A==
X-Received: by 2002:a81:a355:: with SMTP id a82mr24130547ywh.445.1545287547286;
        Wed, 19 Dec 2018 22:32:27 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id l140sm6304259ywe.77.2018.12.19.22.32.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Dec 2018 22:32:26 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id i22so245682ywa.11
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2018 22:32:25 -0800 (PST)
X-Received: by 2002:a0d:eb06:: with SMTP id u6mr21358487ywe.443.1545287545580;
 Wed, 19 Dec 2018 22:32:25 -0800 (PST)
MIME-Version: 1.0
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl> <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl> <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
 <AM0PR03MB467606D6C482F06F4E401767ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <CAAFQd5AJ4NYfHyWSW7N+a8DtTfKKEkHOmaY8fNpwQrkjzrA7Ng@mail.gmail.com> <AM0PR03MB4676A22D94B1B528895185F1ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
In-Reply-To: <AM0PR03MB4676A22D94B1B528895185F1ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 20 Dec 2018 15:32:14 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CWmtaBoKGJHmcv0RLgv98nL1Erb5jz8r8Rwohyk_w1TQ@mail.gmail.com>
Message-ID: <CAAFQd5CWmtaBoKGJHmcv0RLgv98nL1Erb5jz8r8Rwohyk_w1TQ@mail.gmail.com>
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
To:     jonas@kwiboo.se
Cc:     hverkuil-cisco@xs4all.nl,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        nicolas@ndufresne.ca, Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 19, 2018 at 6:18 PM Jonas Karlman <jonas@kwiboo.se> wrote:
>
> On 2018-12-19 08:16, Tomasz Figa wrote:
> > On Wed, Dec 19, 2018 at 4:04 PM Jonas Karlman <jonas@kwiboo.se> wrote:
> >> On 2018-12-19 06:10, Tomasz Figa wrote:
> >>> On Thu, Dec 13, 2018 at 9:28 PM Hans Verkuil <hverkuil-cisco@xs4all.n=
l> wrote:
> >>>> On 12/12/18 7:28 PM, Jonas Karlman wrote:
> >>>>> Hi Hans,
> >>>>>
> >>>>> Since this function only return DEQUEUED and DONE buffers,
> >>>>> it cannot be used to find a capture buffer that is both used for
> >>>>> frame output and is part of the frame reference list.
> >>>>> E.g. a bottom field referencing a top field that is already
> >>>>> part of the capture buffer being used for frame output.
> >>>>> (top and bottom field is output in same buffer)
> >>>>>
> >>>>> Jernej =C5=A0krabec and me have worked around this issue in cedrus =
driver by
> >>>>> first checking
> >>>>> the tag/timestamp of the current buffer being used for output frame=
.
> >>>>>
> >>>>>
> >>>>> // field pictures may reference current capture buffer and is not
> >>>>> returned by vb2_find_tag
> >>>>> if (v4l2_buf->tag =3D=3D dpb->tag)
> >>>>>     buf_idx =3D v4l2_buf->vb2_buf.index;
> >>>>> else
> >>>>>     buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> >>>>>
> >>>>>
> >>>>> What is the recommended way to handle such case?
> >>>> That is the right approach for this. Interesting corner case, I hadn=
't
> >>>> considered that.
> >>>>
> >>>>> Could vb2_find_timestamp be extended to allow QUEUED buffers to be =
returned?
> >>>> No, because only the driver knows what the current buffer is.
> >>>>
> >>>> Buffers that are queued to the driver are in state ACTIVE. But there=
 may be
> >>>> multiple ACTIVE buffers and vb2 doesn't know which buffer is current=
ly
> >>>> being processed by the driver.
> >>>>
> >>>> So this will have to be checked by the driver itself.
> >>> Hold on, it's a perfectly valid use case to have the buffer queued bu=
t
> >>> still used as a reference for previously queued buffers, e.g.
> >>>
> >>> QBUF(O, 0)
> >>> QBUF(C, 0)
> >>> REF(ref0, out_timestamp(0))
> >>> QBUF(O, 1)
> >>> QBUF(C, 1)
> >>> REF(ref0, out_timestamp(0))
> >>> QBUF(O, 2)
> >>> QBUF(C, 2)
> >>> <- driver returns O(0) and C(0) here
> >>> <- userspace also knows that any next frame will not reference C(0) a=
nymore
> >>> REF(ref0, out_timestamp(2))
> >>> QBUF(O, 0)
> >>> QBUF(C, 0)
> >>> <- driver may pick O(1)+C(1) or O(2)+C(2) to decode here, but C(0)
> >>> which is the reference for it is already QUEUED.
> >>>
> >>> It's a perfectly fine scenario and optimal from pipelining point of
> >>> view, but if I'm not missing something, the current patch wouldn't
> >>> allow it.
> >> This scenario should never happen with FFmpeg + v4l2request hwaccel +
> >> Kodi userspace.
> >> FFmpeg would only QBUF O(0)+C(0) again after it has been presented on
> >> screen and Kodi have released the last reference to the AVFrame.
> >>
> > I skipped the display in the example indeed, but we can easily add it:
> >
> > QBUF(O, 0)
> > QBUF(C, 0)
> > REF(ref0, out_timestamp(0))
> > QBUF(O, 1)
> > QBUF(C, 1)
> > <- driver returns O(0) and C(0) here
> > <- userspace displays C(0)
> > REF(ref0, out_timestamp(0))
> > QBUF(O, 2)
> > QBUF(C, 2)
> > REF(ref0, out_timestamp(0))
> > QBUF(O, 3)
> > QBUF(C, 3)
> > <- driver returns O(1) and C(1) here
> > <- userspace displays C(1) and reclaims C(0)
> > <- userspace also knows that any next frame will not reference C(0) any=
more
> > REF(ref0, out_timestamp(3))
> > QBUF(O, 0)
> > QBUF(C, 0)
> > <- driver may pick O(3)+C(3) to decode here, but C(0)
> > which is the reference for it is already QUEUED.
> >
> > Also the fact that FFmpeg wouldn't trigger such case doesn't mean that
> > it's an invalid one. If I remember correctly, Chromium would actually
> > trigger such, since we attempt to pipeline things as much as possible.
> I still think this may be an invalid use-case or otherwise bad handling
> from userspace. Since userspace knows that C(0) won't be referenced in
> next frame it should also know that it still has two frames queued for
> decoding that references C(0) frame and still have not been returned
> from decoder.
> And if the driver have not started decoding the requests/frames that
> reference C(0) how would it know that it cannot pick the now queued C(0)
> as output for next frame it decodes?

Because the application has queued 2 other CAPTURE buffers before
C(0), but indeed, if we assume that the driver can skip buffers (due
to some errors that I don't see how could happen in any real life
scenario), then that could fail.

> In FFmpeg case we only re-queue the buffer once all frames that
> references that buffer/frame have been output from decoder, I guess the
> main difference is that FFmpeg currently only keep one request in flight
> at the time (wait on request to finish before queue next), this may
> change in future as we continue to improve the v4l2request hwaccel.
>
> Regards,
> Jonas
> >
> >> The v4l2request hwaccel will keep a AVFrame pool with preallocated
> >> frames, AVFrame(x) is keeping userspace ref to O(x)+C(x).
> >> An AVFrame will not be released back to the pool until FFmpeg have
> >> removed it from DPB and Kodi have released it after it no longer is
> >> being presented on screen.
> >>
> >> E.g. an IPBIPB sequense with display order 0 2 1 3 5 4
> >>
> >> FFmpeg: AVFrame(0)
> >> QBUF: O(0)+C(0)
> >> DQBUF: O(0)+C(0)
> >> Kodi: AVFrame(0) returned from FFmpeg and presented on screen
> >> FFmpeg: AVFrame(1) with ref to AVFrame(0)
> >> QBUF: O(1)+C(1) with ref to timestamp(0)
> >> DQBUF: O(1)+C(1)
> >> FFmpeg: AVFrame(2) with ref to AVFrame(0)+AVFrame(1)
> >> QBUF: O(2)+C(2) with ref to timestamp(0)+timestamp(1)
> >> DQBUF: O(2)+C(2)
> >> Kodi: AVFrame(2) returned from FFmpeg and presented on screen
> >> Kodi: AVFrame(0) released (no longer presented)
> >> FFmpeg: AVFrame(3)
> >> QBUF: O(3)+C(3)
> >> DQBUF: O(3)+C(3)
> >> Kodi: AVFrame(1) returned from FFmpeg and presented on screen
> >> Kodi: AVFrame(2) released (no longer presented)
> >> FFmpeg: AVFrame(2) returned to pool
> >> FFmpeg: AVFrame(2) with ref to AVFrame(3)
> >> QBUF: O(2)+C(2) with ref to timestamp(3)
> >> DQBUF: O(2)+C(2)
> >> Kodi: AVFrame(3) returned from FFmpeg and presented on screen
> >> Kodi: AVFrame(1) released (no longer presented)
> >> FFmpeg: AVFrame(0)+AVFrame(1) returned to pool (no longer referenced)
> >> FFmpeg: AVFrame(0) with ref to AVFrame(3)+AVFrame(2)
> >> QBUF: O(0)+C(0) with ref to timestamp(3)+timestamp(2)
> >> DQBUF: O(0)+C(0)
> >> Kodi: AVFrame(0) returned from FFmpeg and presented on screen
> >> Kodi: AVFrame(3) released (no longer presented)
> >> and so on
> >>
> >> Here we can see that O(0)+C(0) will not be QBUF until after FFmpeg +
> >> Kodi have released all userspace refs to AVFrame(0).
> >> Above example was simplified, Kodi will normally keep a few decoded
> >> frames in buffer before being presented and FFmpeg will CREATE_BUF
> >> anytime the pool is empty and new O/C buffers is needed.
> >>
> >> Regards,
> >> Jonas
> >>
> >>> Best regards,
> >>> Tomasz
