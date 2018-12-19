Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E6DC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1948921841
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 07:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jX9CFNXf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbeLSHQX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:16:23 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:34007 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbeLSHQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 02:16:23 -0500
Received: by mail-yb1-f171.google.com with SMTP id k136so7537041ybk.1
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 23:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lXwtRYD1BSRsU1iXnJSw/gHyciAzp1fWg+8w81h540g=;
        b=jX9CFNXfyxr+x4yoWfWO+E3xHifhY5mg0LoTcOdaWMkoP0gsvZ6Kk5Z4+sVhxsRJPt
         7snIFA0FHq6nmtLSW7lEEK45y5+qnMfJvLjT9Z6uyxcLLmERvb6Rdmz9DJ1Lv19fe+lu
         S+f8Oq/QsZwSY15JlvDl1JUmJ+SMqaXYUGTBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lXwtRYD1BSRsU1iXnJSw/gHyciAzp1fWg+8w81h540g=;
        b=SeKGtPHWzslzZx+ghquZ7MimmJ6iF+PVp2cTBFuWKzq+BoOTsOnAQkpnDnCNkHtJhI
         f0fYJD/T/7MAugNN6LNo11nvrkxP4qFvhfZVxjT77tBCEBa2Lz9lSqlMWzaE3ESarxzJ
         wpZYMGEVZHtDVflcrWSd7+IzLPzTyoSwcUUdfhhG9oAzI5YGMnkT/Vcu5dd+gkkF/M3E
         e/TGzSWVMNw6PlwxZDDWOztAcFRqXTeJ0H4mVAIoN5Y2z7nXlDFGKAaVF6On6rXFBr4/
         3byzxoGpgkzOxvuUSlILagY6iGB33UWXu2GGMYw5vAWm0a1461M0Scag30wKwbzc29J7
         dpbA==
X-Gm-Message-State: AA+aEWab/M0330IYyNjZj0G3hD6w0npi2EKoaCxgd0p3OHf8dczZK+f1
        qjf1DqZBlNtivkjl67CirwATImUXXNQ=
X-Google-Smtp-Source: AFSGD/Wda2siuHGC4xDZ29RJABuH7bAVoYjWBSTQ7CZacUmilFseVRcE/HVk8puA6sGohvIO85aBag==
X-Received: by 2002:a25:b5ca:: with SMTP id d10-v6mr19678802ybg.375.1545203781840;
        Tue, 18 Dec 2018 23:16:21 -0800 (PST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id 77sm5284871ywb.54.2018.12.18.23.16.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 23:16:20 -0800 (PST)
Received: by mail-yb1-f178.google.com with SMTP id r11so7500382ybp.12
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 23:16:20 -0800 (PST)
X-Received: by 2002:a25:d644:: with SMTP id n65mr19758503ybg.204.1545203779694;
 Tue, 18 Dec 2018 23:16:19 -0800 (PST)
MIME-Version: 1.0
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl> <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl> <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
 <AM0PR03MB467606D6C482F06F4E401767ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
In-Reply-To: <AM0PR03MB467606D6C482F06F4E401767ACBE0@AM0PR03MB4676.eurprd03.prod.outlook.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 19 Dec 2018 16:16:08 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AJ4NYfHyWSW7N+a8DtTfKKEkHOmaY8fNpwQrkjzrA7Ng@mail.gmail.com>
Message-ID: <CAAFQd5AJ4NYfHyWSW7N+a8DtTfKKEkHOmaY8fNpwQrkjzrA7Ng@mail.gmail.com>
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

On Wed, Dec 19, 2018 at 4:04 PM Jonas Karlman <jonas@kwiboo.se> wrote:
>
> On 2018-12-19 06:10, Tomasz Figa wrote:
> > On Thu, Dec 13, 2018 at 9:28 PM Hans Verkuil <hverkuil-cisco@xs4all.nl>=
 wrote:
> >> On 12/12/18 7:28 PM, Jonas Karlman wrote:
> >>> Hi Hans,
> >>>
> >>> Since this function only return DEQUEUED and DONE buffers,
> >>> it cannot be used to find a capture buffer that is both used for
> >>> frame output and is part of the frame reference list.
> >>> E.g. a bottom field referencing a top field that is already
> >>> part of the capture buffer being used for frame output.
> >>> (top and bottom field is output in same buffer)
> >>>
> >>> Jernej =C5=A0krabec and me have worked around this issue in cedrus dr=
iver by
> >>> first checking
> >>> the tag/timestamp of the current buffer being used for output frame.
> >>>
> >>>
> >>> // field pictures may reference current capture buffer and is not
> >>> returned by vb2_find_tag
> >>> if (v4l2_buf->tag =3D=3D dpb->tag)
> >>>     buf_idx =3D v4l2_buf->vb2_buf.index;
> >>> else
> >>>     buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> >>>
> >>>
> >>> What is the recommended way to handle such case?
> >> That is the right approach for this. Interesting corner case, I hadn't
> >> considered that.
> >>
> >>> Could vb2_find_timestamp be extended to allow QUEUED buffers to be re=
turned?
> >> No, because only the driver knows what the current buffer is.
> >>
> >> Buffers that are queued to the driver are in state ACTIVE. But there m=
ay be
> >> multiple ACTIVE buffers and vb2 doesn't know which buffer is currently
> >> being processed by the driver.
> >>
> >> So this will have to be checked by the driver itself.
> > Hold on, it's a perfectly valid use case to have the buffer queued but
> > still used as a reference for previously queued buffers, e.g.
> >
> > QBUF(O, 0)
> > QBUF(C, 0)
> > REF(ref0, out_timestamp(0))
> > QBUF(O, 1)
> > QBUF(C, 1)
> > REF(ref0, out_timestamp(0))
> > QBUF(O, 2)
> > QBUF(C, 2)
> > <- driver returns O(0) and C(0) here
> > <- userspace also knows that any next frame will not reference C(0) any=
more
> > REF(ref0, out_timestamp(2))
> > QBUF(O, 0)
> > QBUF(C, 0)
> > <- driver may pick O(1)+C(1) or O(2)+C(2) to decode here, but C(0)
> > which is the reference for it is already QUEUED.
> >
> > It's a perfectly fine scenario and optimal from pipelining point of
> > view, but if I'm not missing something, the current patch wouldn't
> > allow it.
>
> This scenario should never happen with FFmpeg + v4l2request hwaccel +
> Kodi userspace.
> FFmpeg would only QBUF O(0)+C(0) again after it has been presented on
> screen and Kodi have released the last reference to the AVFrame.
>

I skipped the display in the example indeed, but we can easily add it:

QBUF(O, 0)
QBUF(C, 0)
REF(ref0, out_timestamp(0))
QBUF(O, 1)
QBUF(C, 1)
<- driver returns O(0) and C(0) here
<- userspace displays C(0)
REF(ref0, out_timestamp(0))
QBUF(O, 2)
QBUF(C, 2)
REF(ref0, out_timestamp(0))
QBUF(O, 3)
QBUF(C, 3)
<- driver returns O(1) and C(1) here
<- userspace displays C(1) and reclaims C(0)
<- userspace also knows that any next frame will not reference C(0) anymore
REF(ref0, out_timestamp(3))
QBUF(O, 0)
QBUF(C, 0)
<- driver may pick O(3)+C(3) to decode here, but C(0)
which is the reference for it is already QUEUED.

Also the fact that FFmpeg wouldn't trigger such case doesn't mean that
it's an invalid one. If I remember correctly, Chromium would actually
trigger such, since we attempt to pipeline things as much as possible.

> The v4l2request hwaccel will keep a AVFrame pool with preallocated
> frames, AVFrame(x) is keeping userspace ref to O(x)+C(x).
> An AVFrame will not be released back to the pool until FFmpeg have
> removed it from DPB and Kodi have released it after it no longer is
> being presented on screen.
>
> E.g. an IPBIPB sequense with display order 0 2 1 3 5 4
>
> FFmpeg: AVFrame(0)
> QBUF: O(0)+C(0)
> DQBUF: O(0)+C(0)
> Kodi: AVFrame(0) returned from FFmpeg and presented on screen
> FFmpeg: AVFrame(1) with ref to AVFrame(0)
> QBUF: O(1)+C(1) with ref to timestamp(0)
> DQBUF: O(1)+C(1)
> FFmpeg: AVFrame(2) with ref to AVFrame(0)+AVFrame(1)
> QBUF: O(2)+C(2) with ref to timestamp(0)+timestamp(1)
> DQBUF: O(2)+C(2)
> Kodi: AVFrame(2) returned from FFmpeg and presented on screen
> Kodi: AVFrame(0) released (no longer presented)
> FFmpeg: AVFrame(3)
> QBUF: O(3)+C(3)
> DQBUF: O(3)+C(3)
> Kodi: AVFrame(1) returned from FFmpeg and presented on screen
> Kodi: AVFrame(2) released (no longer presented)
> FFmpeg: AVFrame(2) returned to pool
> FFmpeg: AVFrame(2) with ref to AVFrame(3)
> QBUF: O(2)+C(2) with ref to timestamp(3)
> DQBUF: O(2)+C(2)
> Kodi: AVFrame(3) returned from FFmpeg and presented on screen
> Kodi: AVFrame(1) released (no longer presented)
> FFmpeg: AVFrame(0)+AVFrame(1) returned to pool (no longer referenced)
> FFmpeg: AVFrame(0) with ref to AVFrame(3)+AVFrame(2)
> QBUF: O(0)+C(0) with ref to timestamp(3)+timestamp(2)
> DQBUF: O(0)+C(0)
> Kodi: AVFrame(0) returned from FFmpeg and presented on screen
> Kodi: AVFrame(3) released (no longer presented)
> and so on
>
> Here we can see that O(0)+C(0) will not be QBUF until after FFmpeg +
> Kodi have released all userspace refs to AVFrame(0).
> Above example was simplified, Kodi will normally keep a few decoded
> frames in buffer before being presented and FFmpeg will CREATE_BUF
> anytime the pool is empty and new O/C buffers is needed.
>
> Regards,
> Jonas
>
> > Best regards,
> > Tomasz
