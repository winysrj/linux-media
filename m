Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647A8C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 03:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A12321855
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 03:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DVcLpxU2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfAYDt1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 22:49:27 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:38351 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfAYDt1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 22:49:27 -0500
Received: by mail-oi1-f170.google.com with SMTP id a77so6739867oii.5
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 19:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WePBlCqzunKd5puSTDx1THJ7fWsRbdAn/c/0X7bdcJU=;
        b=DVcLpxU2k02mDb5Lp7JPMuf0k2ZweB7gndF1hgp8Tvh5eqeJUq/h4sn3KpJkYF4V+A
         /Bt8N/R0kXE6EdPXMHbJZkMdhXbJWwrl3FtncPWiOpFy5vRsBfLFNjyVHshh6KQ3I8B2
         JUvs2RRq8a68AMPNEzXNF1ZMFbcvhub5bLbXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WePBlCqzunKd5puSTDx1THJ7fWsRbdAn/c/0X7bdcJU=;
        b=UQ7JgD6JiWYvFmjXUN1olb+wP4IMGRQCj3L67B2gBaqLay0i7JWYB9XhpmMCl9DI+W
         qL6M/3NTVKo3w1El6MJkVFv8bS1hmmcCSBryUYcMO8U0EJltxmWGEGKtwKRPcos7DTR3
         QcYIQASEPIxFuUVZAD36Q3SPldnFqjF4R4KhNz0PhipseZB1TCwoCJ2KS70ckE9yHnpQ
         pDkQkaDo9J+4LD4YvQGOQxGjYsq9YQyg5bqCNfM+bXSRT8Y7FafDM2SWVztccO42LkRF
         qbJXX6NDhfWKYSVaMD+NcLeN9IfXMYUkmrK4veapJphT1xEi+gaHa6xHqkKbktEX72CY
         IGSg==
X-Gm-Message-State: AHQUAuaD1n4TdGQuHNvuYVFQ+karPAWBaeHxEjU9xL5nhuZN5minx4Av
        CvHksjZBMqdDGHk2gUeUCFHcEgGlzkN1PA==
X-Google-Smtp-Source: ALg8bN4BOffsi7lag+Afz+E7m5poawwnV9uKi+mHYA6hucDCOg5QoMBjNd61r4hTDpNa4p9El3C7Xg==
X-Received: by 2002:aca:220b:: with SMTP id b11mr224323oic.87.1548386965482;
        Thu, 24 Jan 2019 19:29:25 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id u136sm763143oie.38.2019.01.24.19.29.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 19:29:23 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id w25so7277004otm.13
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 19:29:22 -0800 (PST)
X-Received: by 2002:a9d:4687:: with SMTP id z7mr6692294ote.350.1548386962460;
 Thu, 24 Jan 2019 19:29:22 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-3-tfiga@chromium.org>
 <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl> <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
 <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl> <CAAFQd5COddN-YosKyfBJ7n=qt40ONP=YEjBo5HQBOPGhs19h+g@mail.gmail.com>
 <fcad4ca0-cfdd-d0fb-4b18-808426584755@xs4all.nl> <ea1b39bf1a14f73b74d17c925f67ea3613ea6eae.camel@ndufresne.ca>
In-Reply-To: <ea1b39bf1a14f73b74d17c925f67ea3613ea6eae.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 12:29:11 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DXWc1mBYZ=2zH0fPitLc=L2UGem85wokB6oht4CxVrsQ@mail.gmail.com>
Message-ID: <CAAFQd5DXWc1mBYZ=2zH0fPitLc=L2UGem85wokB6oht4CxVrsQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
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

On Fri, Jan 25, 2019 at 5:04 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le mercredi 23 janvier 2019 =C3=A0 12:28 +0100, Hans Verkuil a =C3=A9crit=
 :
> > On 01/23/19 11:00, Tomasz Figa wrote:
> > > On Sat, Nov 17, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wro=
te:
> > > > On 11/17/2018 05:18 AM, Nicolas Dufresne wrote:
> > > > > Le lundi 12 novembre 2018 =C3=A0 14:23 +0100, Hans Verkuil a =C3=
=A9crit :
> > > > > > On 10/22/2018 04:49 PM, Tomasz Figa wrote:
> > > [snip]
> > > > > > > +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag sho=
uld be used
> > > > > > > +      instead.
> > > > > >
> > > > > > Question: should new codec drivers still implement the EOS even=
t?
> > > > >
> > > > > I'm been asking around, but I think here is a good place. Do we r=
eally
> > > > > need the FLAG_LAST in userspace ? Userspace can also wait for the=
 first
> > > > > EPIPE return from DQBUF.
> > > >
> > > > I'm interested in hearing Tomasz' opinion. This flag is used alread=
y, so there
> > > > definitely is a backwards compatibility issue here.
> > > >
> > >
> > > FWIW, it would add the overhead of 1 more system call, although I
> > > don't think it's of our concern.
> > >
> > > My personal feeling is that using error codes for signaling normal
> > > conditions isn't very elegant, though.
> >
> > I agree. Let's keep this flag.
>
> Agreed, though a reminder of the initial question, "do we keep the EOS
> event ?", and I think the event can be dropped.
>

I would happily drop it, if we know that it wouldn't break any
userspace. Chromium doesn't use it either.

Best regards,
Tomasz

> >
> > Regards,
> >
> >       Hans
> >
> > > > > > > +
> > > > > > > +3. Once all ``OUTPUT`` buffers queued before the ``V4L2_ENC_=
CMD_STOP`` call and
> > > > > > > +   the last ``CAPTURE`` buffer are dequeued, the encoder is =
stopped and it will
> > > > > > > +   accept, but not process any newly queued ``OUTPUT`` buffe=
rs until the client
> > > > > > > +   issues any of the following operations:
> > > > > > > +
> > > > > > > +   * ``V4L2_ENC_CMD_START`` - the encoder will resume operat=
ion normally,
> > > > > >
> > > > > > Perhaps mention that this does not reset the encoder? It's not =
immediately clear
> > > > > > when reading this.
> > > > >
> > > > > Which drivers supports this ? I believe I tried with Exynos in th=
e
> > > > > past, and that didn't work. How do we know if a driver supports t=
his or
> > > > > not. Do we make it mandatory ? When it's not supported, it basica=
lly
> > > > > mean userspace need to cache and resend the header in userspace, =
and
> > > > > also need to skip to some sync point.
> > > >
> > > > Once we agree on the spec, then the next step will be to add good c=
ompliance
> > > > checks and update drivers that fail the tests.
> > > >
> > > > To check if the driver support this ioctl you can call VIDIOC_TRY_E=
NCODER_CMD
> > > > to see if the functionality is supported.
> > >
> > > There is nothing here for the hardware to support. It's an entirely
> > > driver thing, since it just needs to wait for the encoder to complete
> > > all the pending frames and stop enqueuing more frames to the decoder
> > > until V4L2_ENC_CMD_START is called. Any driver that can't do it must
> > > be fixed, since otherwise you have no way to ensure that you got all
> > > the encoded output.
> > >
> > > Best regards,
> > > Tomasz
> > >
>
