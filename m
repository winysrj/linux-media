Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A927FC282C2
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 05:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78A4A2080A
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 05:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JjgzroOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfBFFn0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 00:43:26 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40594 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfBFFn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 00:43:26 -0500
Received: by mail-ot1-f65.google.com with SMTP id s5so10012675oth.7
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 21:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GzL1/yoVnlK9gzmhGqxtVB2GrivOTPBo3lckvKCTeZ8=;
        b=JjgzroOfUjmMNmeYVUeD9IDXmZ6HWFiyFh42PinbNTGsYAR2msHrPRHjRDI1fyMan8
         FYRlBwB+RLsBBSocMRZLRYq8+97zbth9eq85ONHdzarotXDFQ29cvLCU7cuIbSlIskhV
         ZpfRAleQJaOY7P3Vyds9QEvnMdQ9TyalxkOwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GzL1/yoVnlK9gzmhGqxtVB2GrivOTPBo3lckvKCTeZ8=;
        b=FmvKEnJ03a03cQNg5aDPAMym4pOKUfMaWR2KH9CGnRndLvs9rFQIPNL5/mma3Vrh1n
         PLPdhI0VSUjeBBo62C2lBOTqOWvgA0MRKxmHyQWVKuHuFP9bP5NEdRpNpXck3wQ8p2JO
         byuF0DhgmRvHOkvs9mvRBbYt/U82jnuw2rDakrw0GGJw/B5/Ay0VfshvesTqOBCIJ2Se
         5oCsYroZkmBLvL55KLrmeVqnwsTBLcCTyT3Fnkj9Tv76mmOp9YWsRysyhWj/A0vvaM3I
         g49WHMFSElP9GCl9ayY3Gn95tRdA08LKvZSkZ290i844CzSdVfNNMTbSygAZRUvO8pXI
         TDrQ==
X-Gm-Message-State: AHQUAuaYl8nwurBrRKsj9ExNiMYO/qrb1GdaW41UYVJ7OTvu0xNHra0H
        6rfvL0UFjndf5jkdDKfAL8wKTnCXyvK8HA==
X-Google-Smtp-Source: AHgI3IZT29tv05u354NztoNMa+y9NaOxmQTehPRoSHyoFX3HRwTKBKoqUGiKLudEQindK6gGUYR2Sw==
X-Received: by 2002:a05:6830:1414:: with SMTP id v20mr4813926otp.125.1549431804524;
        Tue, 05 Feb 2019 21:43:24 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id t25sm1177839otj.71.2019.02.05.21.43.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 21:43:24 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id u16so9997394otk.8
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 21:43:24 -0800 (PST)
X-Received: by 2002:a54:468b:: with SMTP id k11mr1698100oic.346.1549431363551;
 Tue, 05 Feb 2019 21:36:03 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl> <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
 <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl> <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
 <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
 <3ea3bf5bf9904ce877142c41f595207752172d27.camel@ndufresne.ca>
 <CAAFQd5C_OD=bvAxG0B_G+T6bnWddPHuiVZApj_8_+4xpMjH9+g@mail.gmail.com> <c145fbf21301d03bdfdd8bf6613f0f68576e66be.camel@ndufresne.ca>
In-Reply-To: <c145fbf21301d03bdfdd8bf6613f0f68576e66be.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 6 Feb 2019 14:35:51 +0900
X-Gmail-Original-Message-ID: <CAAFQd5D4AP+xj_EkcsB84UqxCLBBEGComqGaMCm2zHSMnpqOKw@mail.gmail.com>
Message-ID: <CAAFQd5D4AP+xj_EkcsB84UqxCLBBEGComqGaMCm2zHSMnpqOKw@mail.gmail.com>
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

On Wed, Jan 30, 2019 at 1:02 PM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le vendredi 25 janvier 2019 =C3=A0 12:27 +0900, Tomasz Figa a =C3=A9crit =
:
> > On Fri, Jan 25, 2019 at 4:55 AM Nicolas Dufresne <nicolas@ndufresne.ca>=
 wrote:
> > > Le jeudi 24 janvier 2019 =C3=A0 18:06 +0900, Tomasz Figa a =C3=A9crit=
 :
> > > > > Actually I just realized the last point might not even be achieva=
ble
> > > > > for some of the decoders (s5p-mfc, mtk-vcodec), as they don't rep=
ort
> > > > > which frame originates from which bitstream buffer and the driver=
 just
> > > > > picks the most recently consumed OUTPUT buffer to copy the timest=
amp
> > > > > from. (s5p-mfc actually "forgets" to set the timestamp in some ca=
ses
> > > > > too...)
> > > > >
> > > > > I need to think a bit more about this.
> > > >
> > > > Actually I misread the code. Both s5p-mfc and mtk-vcodec seem to
> > > > correctly match the buffers.
> > >
> > > Ok good, since otherwise it would have been a regression in MFC drive=
r.
> > > This timestamp passing thing could in theory be made optional though,
> > > it lives under some COPY_TIMESTAMP kind of flag. What that means thou=
gh
> > > is that a driver without such a capability would need to signal dropp=
ed
> > > frames using some other mean.
> > >
> > > In userspace, the main use is to match the produced frame against a
> > > userspace specific list of frames. At least this seems to be the case
> > > in Gst and Chromium, since the userspace list contains a superset of
> > > the metadata found in the v4l2_buffer.
> > >
> > > Now, using the produced timestamp, userspace can deduce frame that th=
e
> > > driver should have produced but didn't (could be a deadline case code=
c,
> > > or simply the frames where corrupted). It's quite normal for a codec =
to
> > > just keep parsing until it finally find something it can decode.
> > >
> > > That's at least one way to do it, but there is other possible
> > > mechanism. The sequence number could be used, or even producing buffe=
rs
> > > with the ERROR flag set. What matters is just to give userspace a way
> > > to clear these frames, which would simply grow userspace memory usage
> > > over time.
> >
> > Is it just me or we were missing some consistent error handling then?
> >
> > I feel like the drivers should definitely return the bitstream buffers
> > with the ERROR flag, if there is a decode failure of data in the
> > buffer. Still, that could become more complicated if there is more
> > than 1 frame in that piece of bitstream, but only 1 frame is corrupted
> > (or whatever).
>
> I agree, but it might be more difficult then it looks (even FFMPEG does
> not do that). I believe the code that is processing the bitstream in
> stateful codecs is mostly unrelated from the code actually doing the
> decoding. So what might happen is that the decoding part will never
> actually allocate a buffer for the skipped / corrupted part of the
> bitstream. Also, the notion of a skipped frame is not always evident in
> when parsing H264 or HEVC NALs. There is still a full page of text just
> to explain how to detect that start of a new frame.

Right. I don't think we can guarantee that we can always correlate the
errors with exact buffers and so I phrased the paragraph about errors
in v3 in a bit more conservative way:

See the snapshot hosted by Hans (thanks!):
https://hverkuil.home.xs4all.nl/codec-api/uapi/v4l/dev-decoder.html#decodin=
g

>
> Yet, it would be interesting to study the firmwares we have and see
> what they provide that would help making decode errors more explicit.
>

Agreed.

> >
> > Another case is when the bitstream, even if corrupted, is still enough
> > to produce some output. My intuition tells me that such CAPTURE buffer
> > should be then returned with the ERROR flag. That wouldn't still be
> > enough for any more sophisticated userspace error concealment, but
> > could still let the userspace know to perhaps drop the frame.
>
> You mean if a frame was concealed (typically the frame was decoded from
> a closed by reference instead of the expected reference). That is
> something signalled by FFPEG. We should document this possibility. I
> actually have something implemented in GStreamer. Basically if we have
> the ERROR flag with a payload size smaller then expected, I drop the
> frame and produce a drop event message, while if I have a frame with
> ERROR flag but of the right payload size, I assume it is corrupted, and
> simply flag it as corrupted, leaving to the application the decision to
> display it or not. This is a case that used to happen with some UVC
> cameras (though some have been fixed, and the UVC camera should drop
> smaller payload size buffers now).

I think it's a behavior that makes the most sense indeed.

Technically one could also consider the case of 0 < bytesused <
sizeimage, which could mean that only a part of the frame is in the
buffer. An application could try to blend it with previous frame using
some concealing algorithms. I haven't seen an app that could do such
thing, though.

Best regards,
Tomasz
