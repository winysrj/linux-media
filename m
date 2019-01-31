Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF143C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 15:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EE620863
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 15:18:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="tfIfzcqu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfAaPSV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:18:21 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40771 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfAaPSU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 10:18:20 -0500
Received: by mail-qt1-f196.google.com with SMTP id k12so3803763qtf.7
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2019 07:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=u31s4R5VEIifuxZ4zMHmYpHmJ4AQzbiw8WoCEfXIgXQ=;
        b=tfIfzcqu3RxDnZF/vMSJMdrJEPsANB1yIPQTTyhptLVgJri2jQZG1PT8O3TBi3Hi6G
         mdB0N70K0gjd6pLFlIw77hOhcG0/gr8eY3RGzwozcbv3ggprqsb7vMIjCJWqqJDQQopH
         CFhz+QaYtWJ88cdzmcntbmPRH/CoQYFlN+JyMoWi4jzyZLv94dutoL1fMj2Jg4fSvcLF
         ztnIhM4Qw9e0wgyX17lEYIRMxjYlEe3xD9sT6YDjIIo0g/WQsmzAXAZmi1wRzDEnQAL9
         IVlNvSMkmJHQkKNDwLRGCRf0KSudHTVFI7y3JQV7n4TbqUnCAFUObfEQOQjZ9WM+Qyrb
         PIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=u31s4R5VEIifuxZ4zMHmYpHmJ4AQzbiw8WoCEfXIgXQ=;
        b=WOp5LG3Te+uayggK/E8AHcksyE9P5284Rqgpvhj2CS6SNfxWypZWMh7shpkJpB3DeC
         dblarlRWNpeTGR4T9YSlle2latPPHvB6B8NJD3OVq8ONT8j9ptypRFSQ0J8MQ+m2py+T
         Z6Wzy7BBgbojPQ1lgaRyphdC9iZ6cVrDSpdAYP/iXdAJFImZor1zJt61hcpdu6Xi/rBx
         8bxlZFRxXChi31yaRPwC28Q24RWrOWJ+MZm3eeGPA3iif21VOu1pYuYrYS6rHfGoGeNh
         yNdU9j70OXXrZoR/TEqrajw+ZWYOogyojUYr3xWf6lf4DzU3o6sL4TvhFSuzoMwRzdHr
         hXQw==
X-Gm-Message-State: AJcUukdq0oee4E+dY21nwh27O11GPAjD32AKPL4tIqdeuV4IxZ0eCVp/
        Krw4Q4OboV4OAxJazxgSzJH8yg==
X-Google-Smtp-Source: ALg8bN4OeotJm0AmACjCP74ax5aPp+V1xkT0tCRtFqDyUH20zHIArX8QX7TtSAcAQO1Z55bSgUfQKA==
X-Received: by 2002:aed:2249:: with SMTP id o9mr35022550qtc.13.1548947899246;
        Thu, 31 Jan 2019 07:18:19 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id c17sm6136806qtb.14.2019.01.31.07.18.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 07:18:18 -0800 (PST)
Message-ID: <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Thu, 31 Jan 2019 10:18:17 -0500
In-Reply-To: <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
         <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
         <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
         <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
         <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
         <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
         <1548938556.4585.1.camel@pengutronix.de>
         <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-FzoxvhNtcf6eebpqy6W3"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-FzoxvhNtcf6eebpqy6W3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 31 janvier 2019 =C3=A0 22:34 +0900, Tomasz Figa a =C3=A9crit :
> On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.de> wr=
ote:
> > Hi Nicolas,
> >=20
> > On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> > > Le mercredi 30 janvier 2019 =C3=A0 15:17 +0900, Tomasz Figa a =C3=A9c=
rit :
> > > > > I don't remember saying that, maybe I meant to say there might be=
 a
> > > > > workaround ?
> > > > >=20
> > > > > For the fact, here we queue the headers (or first frame):
> > > > >=20
> > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2videodec.c#L624
> > > > >=20
> > > > > Then few line below this helper does G_FMT internally:
> > > > >=20
> > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2videodec.c#L634
> > > > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/ma=
ster/sys/v4l2/gstv4l2object.c#L3907
> > > > >=20
> > > > > And just plainly fails if G_FMT returns an error of any type. Thi=
s was
> > > > > how Kamil designed it initially for MFC driver. There was no othe=
r
> > > > > alternative back then (no EAGAIN yet either).
> > > >=20
> > > > Hmm, was that ffmpeg then?
> > > >=20
> > > > So would it just set the OUTPUT width and height to 0? Does it mean
> > > > that gstreamer doesn't work with coda and mtk-vcodec, which don't h=
ave
> > > > such wait in their g_fmt implementations?
> > >=20
> > > I don't know for MTK, I don't have the hardware and didn't integrate
> > > their vendor pixel format. For the CODA, I know it works, if there is
> > > no wait in the G_FMT, then I suppose we are being really lucky with t=
he
> > > timing (it would be that the drivers process the SPS/PPS synchronousl=
y,
> > > and a simple lock in the G_FMT call is enough to wait). Adding Philip=
p
> > > in CC, he could explain how this works, I know they use GStreamer in
> > > production, and he would have fixed GStreamer already if that was
> > > causing important issue.
> >=20
> > CODA predates the width/height=3D0 rule on the coded/OUTPUT queue.
> > It currently behaves more like a traditional mem2mem device.
>=20
> The rule in the latest spec is that if width/height is 0 then CAPTURE
> format is determined only after the stream is parsed. Otherwise it's
> instantly deduced from the OUTPUT resolution.
>=20
> > When width/height is set via S_FMT(OUT) or output crop selection, the
> > driver will believe it and set the same (rounded up to macroblock
> > alignment) on the capture queue without ever having seen the SPS.
>=20
> That's why I asked whether gstreamer sets width and height of OUTPUT
> to non-zero values. If so, there is no regression, as the specs mimic
> the coda behavior.

I see, with Philipp's answer it explains why it works. Note that
GStreamer sets the display size on the OUTPUT format (in fact we pass
as much information as we have, because a) it's generic code and b) it
will be needed someday when we enable pre-allocation (REQBUFS before
SPS/PPS is passed, to avoid the setup delay introduce by allocation,
mostly seen with CMA base decoder). In any case, the driver reported
display size should always be ignored in GStreamer, the only
information we look at is the G_SELECTION for the case the x/y or the
cropping rectangle is non-zero.

Note this can only work if the capture queue is not affected by the
coded size, or if the round-up made by the driver is bigger or equal to
that coded size. I believe CODA falls into the first category, since
the decoding happens in a separate set of buffers and are then de-tiled=20
into the capture buffers (if understood correctly).

I would say, best is just to test the updated Venus driver, which is in
my queue.

>=20
> > The source change event after SPS parsing that the spec requires isn't
> > even implemented yet.

Just to make sure, if I try and register that event on CODA with the
current driver, it will simply fail immediately right ? I don't need
any other magic to detect that this isn't supported ?

> >=20
> > regards
> > Philipp

--=-FzoxvhNtcf6eebpqy6W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXFMRuQAKCRBxUwItrAao
HNHrAJ44pwdbaPbPYPgDWNbhxMRrBAqkQACfeSfsnTuENX53E5nD9wBJl+8UJS4=
=seHL
-----END PGP SIGNATURE-----

--=-FzoxvhNtcf6eebpqy6W3--

