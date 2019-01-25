Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24991C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 03:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3B7021855
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 03:48:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="duzGE7In"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfAYDsJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 22:48:09 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40070 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfAYDsJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 22:48:09 -0500
Received: by mail-oi1-f196.google.com with SMTP id t204so6721327oie.7
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 19:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qsc9q74JTnTMEkINAi3mNMqG0l7CnnnP36GPHL0KDdc=;
        b=duzGE7InW77eiL4+Ivtvk9p+lwQMfuLk51gKZbkiVA8qByrVANKQl/jcSouC2pKQoZ
         T116IehUsIYmRfXDdriXTMD/iQGZSfkncUA4HPNw1WpY9GSGgyj39/wKwFY6MNm4xZ4l
         Lv9Zl0/3XdM5CsAAxJfB+S6pc9vtgkeBKk77s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qsc9q74JTnTMEkINAi3mNMqG0l7CnnnP36GPHL0KDdc=;
        b=nqnEFXn5BqU7rwmHGLdFb6DItoAP9F7HaQegQNLrX7cEjXGrejmkZKLKbKw9lkvTXO
         avK9Ifq//EByxOEMmWdi367dboV1H/q/ENedVLnqhgjBseZLMc8ccnV8nRdmyfn605To
         51KKwEsY2bgpl1WOB1HYSi49w7DAXVWLEWImJSGSU/gbX2VqNJzUgd0MPAwzitQ/hZYe
         6mKW89l5p1tSkvdhDSdIhNKoIEiqXz8yabTINXNYowzOqHHaD8FKYrnbpVcHwOvSlXCD
         Q5XMKxBbMZ45fTKJJXV+CwuI1dl0V66k96E7xpN0z7ZlOtimRAeywDqtMxqMvXbpxaev
         AX7w==
X-Gm-Message-State: AHQUAuY7DjildH4E1FFU6iFP80XSgTpe1afD4bRSIO7CJ7PYQ5mlxFSa
        zbMNOA5+HBwELpkzqWPdBNB4RCTsvaSVgg==
X-Google-Smtp-Source: ALg8bN452R0HcKaU6oXe4K2xazA0DM/AXwgt7FNnf3ZcaxZAfEB39EY33Rk1gaVRdlrnKkEe0pkAQQ==
X-Received: by 2002:aca:b404:: with SMTP id d4mr238497oif.167.1548386886929;
        Thu, 24 Jan 2019 19:28:06 -0800 (PST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id 96sm746669ota.28.2019.01.24.19.28.05
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 19:28:05 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id y23so6712770oia.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 19:28:05 -0800 (PST)
X-Received: by 2002:aca:4586:: with SMTP id s128mr256649oia.182.1548386884807;
 Thu, 24 Jan 2019 19:28:04 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl> <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
 <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl> <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
 <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com> <3ea3bf5bf9904ce877142c41f595207752172d27.camel@ndufresne.ca>
In-Reply-To: <3ea3bf5bf9904ce877142c41f595207752172d27.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 12:27:52 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C_OD=bvAxG0B_G+T6bnWddPHuiVZApj_8_+4xpMjH9+g@mail.gmail.com>
Message-ID: <CAAFQd5C_OD=bvAxG0B_G+T6bnWddPHuiVZApj_8_+4xpMjH9+g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
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

On Fri, Jan 25, 2019 at 4:55 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le jeudi 24 janvier 2019 =C3=A0 18:06 +0900, Tomasz Figa a =C3=A9crit :
> > > Actually I just realized the last point might not even be achievable
> > > for some of the decoders (s5p-mfc, mtk-vcodec), as they don't report
> > > which frame originates from which bitstream buffer and the driver jus=
t
> > > picks the most recently consumed OUTPUT buffer to copy the timestamp
> > > from. (s5p-mfc actually "forgets" to set the timestamp in some cases
> > > too...)
> > >
> > > I need to think a bit more about this.
> >
> > Actually I misread the code. Both s5p-mfc and mtk-vcodec seem to
> > correctly match the buffers.
>
> Ok good, since otherwise it would have been a regression in MFC driver.
> This timestamp passing thing could in theory be made optional though,
> it lives under some COPY_TIMESTAMP kind of flag. What that means though
> is that a driver without such a capability would need to signal dropped
> frames using some other mean.
>
> In userspace, the main use is to match the produced frame against a
> userspace specific list of frames. At least this seems to be the case
> in Gst and Chromium, since the userspace list contains a superset of
> the metadata found in the v4l2_buffer.
>
> Now, using the produced timestamp, userspace can deduce frame that the
> driver should have produced but didn't (could be a deadline case codec,
> or simply the frames where corrupted). It's quite normal for a codec to
> just keep parsing until it finally find something it can decode.
>
> That's at least one way to do it, but there is other possible
> mechanism. The sequence number could be used, or even producing buffers
> with the ERROR flag set. What matters is just to give userspace a way
> to clear these frames, which would simply grow userspace memory usage
> over time.

Is it just me or we were missing some consistent error handling then?

I feel like the drivers should definitely return the bitstream buffers
with the ERROR flag, if there is a decode failure of data in the
buffer. Still, that could become more complicated if there is more
than 1 frame in that piece of bitstream, but only 1 frame is corrupted
(or whatever).

Another case is when the bitstream, even if corrupted, is still enough
to produce some output. My intuition tells me that such CAPTURE buffer
should be then returned with the ERROR flag. That wouldn't still be
enough for any more sophisticated userspace error concealment, but
could still let the userspace know to perhaps drop the frame.

Best regards,
Tomasz
