Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A2FC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3944F20870
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="g0mxfGP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfAWKIg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:08:36 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:42777 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfAWKIg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:08:36 -0500
Received: by mail-oi1-f170.google.com with SMTP id w13so1301960oiw.9
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=77ZCzo2w78BSCMOdjec45OEgqSB0KV/7zPbxJ74wWS8=;
        b=g0mxfGP0Vyphud4v6VrkINWLF1dLCn4/LZtTU+dsUzEP2cSzjgt4/6ZvvuYoiujKUK
         HPiaBBBcahzq1Yt2laxH4z165FV1CjP+qdeDJWMw7ezntFW44H3QZca53qVKYiVQ3qlY
         z9/4IqO50PuRfHVnKYWDtqAtPea5rj3kkd0ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=77ZCzo2w78BSCMOdjec45OEgqSB0KV/7zPbxJ74wWS8=;
        b=cRxRJygzs77FzNdbIbt9nyrl6X7CmglK9G4A3sYUk93hMKzu6OQyK+nASGeOUZsT3z
         K/ZVA79j4flzOl4V5tWgppDZbOzqke76UFs1yLdsYj4g6s7qBL0P6sZ5j/q4SPWhUqI8
         zJH/uQpIvFghXFDsV4LbWgAtzxN6VN47wHSHe67G0GMlDCc4Gp3K3ncEs+uYWeD8PLRM
         MFY6x3XhFLdAS1gdbXJJ3a3j7WiZyyk97Hw2Xts8pD7C5T8T9K2NWu0DKu/VO62RE/Ua
         TrRSqGdPy3C0/c7HyS+NzbF/ABmN5QsXvTWcXyhtjxVtEIIPCI+VkqFDfB4+I3XzITyW
         7jVQ==
X-Gm-Message-State: AJcUukdEKku4u8SC7rqrnHPAGn/ASsoGmHktP1r6dqmVNmEzNIHty6+r
        76GA8WhbGAFD7ALyqUT7oXdzdaeL8AM=
X-Google-Smtp-Source: ALg8bN64QniFI2ub6MwrLIEjvJ0vUpug3bV6uZqUTr6h2pjjokAY0Cvya2HtU6wlbjkluHZ/z8bxiA==
X-Received: by 2002:aca:fc43:: with SMTP id a64mr1033396oii.288.1548238115006;
        Wed, 23 Jan 2019 02:08:35 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id l5sm8244408oil.15.2019.01.23.02.08.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:08:34 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id n8so1409803otl.6
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:08:34 -0800 (PST)
X-Received: by 2002:a9d:4687:: with SMTP id z7mr1080754ote.350.1548237665228;
 Wed, 23 Jan 2019 02:01:05 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-3-tfiga@chromium.org>
 <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl> <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
 <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
In-Reply-To: <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 19:00:54 +0900
X-Gmail-Original-Message-ID: <CAAFQd5COddN-YosKyfBJ7n=qt40ONP=YEjBo5HQBOPGhs19h+g@mail.gmail.com>
Message-ID: <CAAFQd5COddN-YosKyfBJ7n=qt40ONP=YEjBo5HQBOPGhs19h+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
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

On Sat, Nov 17, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 11/17/2018 05:18 AM, Nicolas Dufresne wrote:
> > Le lundi 12 novembre 2018 =C3=A0 14:23 +0100, Hans Verkuil a =C3=A9crit=
 :
> >> On 10/22/2018 04:49 PM, Tomasz Figa wrote:
[snip]
> >>> +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag should be u=
sed
> >>> +      instead.
> >>
> >> Question: should new codec drivers still implement the EOS event?
> >
> > I'm been asking around, but I think here is a good place. Do we really
> > need the FLAG_LAST in userspace ? Userspace can also wait for the first
> > EPIPE return from DQBUF.
>
> I'm interested in hearing Tomasz' opinion. This flag is used already, so =
there
> definitely is a backwards compatibility issue here.
>

FWIW, it would add the overhead of 1 more system call, although I
don't think it's of our concern.

My personal feeling is that using error codes for signaling normal
conditions isn't very elegant, though.

> >
> >>
> >>> +
> >>> +3. Once all ``OUTPUT`` buffers queued before the ``V4L2_ENC_CMD_STOP=
`` call and
> >>> +   the last ``CAPTURE`` buffer are dequeued, the encoder is stopped =
and it will
> >>> +   accept, but not process any newly queued ``OUTPUT`` buffers until=
 the client
> >>> +   issues any of the following operations:
> >>> +
> >>> +   * ``V4L2_ENC_CMD_START`` - the encoder will resume operation norm=
ally,
> >>
> >> Perhaps mention that this does not reset the encoder? It's not immedia=
tely clear
> >> when reading this.
> >
> > Which drivers supports this ? I believe I tried with Exynos in the
> > past, and that didn't work. How do we know if a driver supports this or
> > not. Do we make it mandatory ? When it's not supported, it basically
> > mean userspace need to cache and resend the header in userspace, and
> > also need to skip to some sync point.
>
> Once we agree on the spec, then the next step will be to add good complia=
nce
> checks and update drivers that fail the tests.
>
> To check if the driver support this ioctl you can call VIDIOC_TRY_ENCODER=
_CMD
> to see if the functionality is supported.

There is nothing here for the hardware to support. It's an entirely
driver thing, since it just needs to wait for the encoder to complete
all the pending frames and stop enqueuing more frames to the decoder
until V4L2_ENC_CMD_START is called. Any driver that can't do it must
be fixed, since otherwise you have no way to ensure that you got all
the encoded output.

Best regards,
Tomasz
