Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F711C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 05:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB1521871
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 05:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IXhtV/KY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbeLSFKT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 00:10:19 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37368 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbeLSFKT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 00:10:19 -0500
Received: by mail-yb1-f196.google.com with SMTP id s66so1541705ybc.4
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 21:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s8bc9qoKtiSWkzhF0t2yTDdaPIyaz7LGQC8BFv4QKEI=;
        b=IXhtV/KYfxdVnkvhl3C2Pzkyf5LNH1bhHkxf+V/j8k4BmVgsDEi55tgDVasdRTF93j
         TSrzuuQ9lKiFyJFlCXrBIZtsRjpliSG1UbTmh/cVIdArEQLo5iXWdBUDpKpyOMwnPYU4
         ll4DcpRDS4O00EaiD2eLwS3hxMEuoQoMypxX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s8bc9qoKtiSWkzhF0t2yTDdaPIyaz7LGQC8BFv4QKEI=;
        b=PMjj1nbLK/RkhwNP1lARpyDro6AqCEEOHlcu1DLBB8hYhX1oK8u1hpO2XZlGXjPXke
         xTKeTk2ZVUTH8JZufjXvZZ4C2JCnl8ngDrum948pM6uUZHMqLWXFV+il07mMytewpnNP
         POo7ABCnRix0wbqm/blZZOQi1YHbyJpFz97CPRbJ3OTT4caVkSqjJKQvcqSeWZ6Xgre8
         wRr1ClpX2OS9pao75iMoFdnRBCy+QK9hfFrNDVTDOvF6hlVcW8tREfKF9yJIR64xFgo6
         +dPqyekgRg00FnqPBPXKkZXczWA+ASkeTj3No5P0hXmZgZOi3VRwoH0Ok377opSSl8XT
         GJIQ==
X-Gm-Message-State: AA+aEWYWd5C4SRYNsD2zqIIkqjHkW8kXzpphDOzfbnywWSLBn5vfhCUs
        bLNAvvfc/ggBix4wdZEzZ1LaCWyi1w2jnA==
X-Google-Smtp-Source: AFSGD/UaOLZm8fcAIHPJBz6dC0ZcxANHJ+P0sNebX8MNoly4ptXL/cf+9Hw+3aKbvyWTEQr66AOqHw==
X-Received: by 2002:a25:f304:: with SMTP id c4mr19156295ybs.11.1545196217799;
        Tue, 18 Dec 2018 21:10:17 -0800 (PST)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id w63sm5537549ywc.46.2018.12.18.21.10.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 21:10:16 -0800 (PST)
Received: by mail-yw1-f51.google.com with SMTP id x2so7659839ywc.9
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 21:10:16 -0800 (PST)
X-Received: by 2002:a0d:eb06:: with SMTP id u6mr17183343ywe.443.1545196215776;
 Tue, 18 Dec 2018 21:10:15 -0800 (PST)
MIME-Version: 1.0
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl> <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
In-Reply-To: <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 19 Dec 2018 14:10:04 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
Message-ID: <CAAFQd5BKizq20x+kyeH1nE1RUs9S2O7coQEXkPu6bCw8EAhmHA@mail.gmail.com>
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
To:     hverkuil-cisco@xs4all.nl
Cc:     jonas@kwiboo.se,
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

On Thu, Dec 13, 2018 at 9:28 PM Hans Verkuil <hverkuil-cisco@xs4all.nl> wro=
te:
>
> On 12/12/18 7:28 PM, Jonas Karlman wrote:
> > Hi Hans,
> >
> > Since this function only return DEQUEUED and DONE buffers,
> > it cannot be used to find a capture buffer that is both used for
> > frame output and is part of the frame reference list.
> > E.g. a bottom field referencing a top field that is already
> > part of the capture buffer being used for frame output.
> > (top and bottom field is output in same buffer)
> >
> > Jernej =C5=A0krabec and me have worked around this issue in cedrus driv=
er by
> > first checking
> > the tag/timestamp of the current buffer being used for output frame.
> >
> >
> > // field pictures may reference current capture buffer and is not
> > returned by vb2_find_tag
> > if (v4l2_buf->tag =3D=3D dpb->tag)
> >     buf_idx =3D v4l2_buf->vb2_buf.index;
> > else
> >     buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> >
> >
> > What is the recommended way to handle such case?
>
> That is the right approach for this. Interesting corner case, I hadn't
> considered that.
>
> > Could vb2_find_timestamp be extended to allow QUEUED buffers to be retu=
rned?
>
> No, because only the driver knows what the current buffer is.
>
> Buffers that are queued to the driver are in state ACTIVE. But there may =
be
> multiple ACTIVE buffers and vb2 doesn't know which buffer is currently
> being processed by the driver.
>
> So this will have to be checked by the driver itself.

Hold on, it's a perfectly valid use case to have the buffer queued but
still used as a reference for previously queued buffers, e.g.

QBUF(O, 0)
QBUF(C, 0)
REF(ref0, out_timestamp(0))
QBUF(O, 1)
QBUF(C, 1)
REF(ref0, out_timestamp(0))
QBUF(O, 2)
QBUF(C, 2)
<- driver returns O(0) and C(0) here
<- userspace also knows that any next frame will not reference C(0) anymore
REF(ref0, out_timestamp(2))
QBUF(O, 0)
QBUF(C, 0)
<- driver may pick O(1)+C(1) or O(2)+C(2) to decode here, but C(0)
which is the reference for it is already QUEUED.

It's a perfectly fine scenario and optimal from pipelining point of
view, but if I'm not missing something, the current patch wouldn't
allow it.

Best regards,
Tomasz
