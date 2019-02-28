Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6EAC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 16:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18594218C3
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 16:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="Sz1z6JzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfB1QVe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:21:34 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39496 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfB1QVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 11:21:34 -0500
Received: by mail-qk1-f194.google.com with SMTP id x6so12414567qki.6
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2019 08:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=mQIvswBe6Vx6YrH7usShueQQvL86fi1wZQxLsM1oyf0=;
        b=Sz1z6JzXlTJ4RSXvAoPAPdBYL5pltykRYmlzG+ZQjcEzcy6bIveYd1DShe8aNUhtIc
         wqHYVi8/3rlmgfTEmPMoPfbBVTFuBPzEvT93+XkKHLywO56unWC9VU5Xys15Lld5jtC5
         7EsVx51DsnUZWo4xvPO7V4otuR1LouZM5zPHXme2EV50yN03al4w4OhJYUcVHodnVjmj
         /TrqJcLPL/XYY5KYT/cPVOtl0yalfbnakn5YVifqwaXdVcf6/OZTpahhJN3x8XAkbSfd
         x7wJphh3yGOaFJzRNFOW/2rOyLEdtvFKZR4EcYoMuyulrNlxioRK1YVbPavyD5KupobZ
         MNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=mQIvswBe6Vx6YrH7usShueQQvL86fi1wZQxLsM1oyf0=;
        b=B0rTsX1YElg81Y88tXtdMTBS0pzoDoQlyQcbk7LNRoK0/ComnWXxA/8W14GD7gWSCA
         NrDzGm2v+f1LaYA2tbEp6qoc0aMteFq6cAZb82N9vkkzgwUp8b2lXp1Ba1DtKSlSdM+q
         Ex7QYGJl5V6RXrqn43mgo46DG5GfFnPrrZnB87LEunnZRjdB+kjTlNFwlm0moNebyJ6D
         k68FIYNk5CclGQSf19IJhImSdsALNZZv16GSPZ/pVkEZXb3/E4kvu/W/d7ToE04Q1sZw
         QjWOAFc417tozubNez/YTRsORMNZxwWjFcLg30tj6KvULlpuBhi/uU8YcjktmS908YOE
         kDmw==
X-Gm-Message-State: APjAAAVZFQqD9XQ/b8xyjbWhgykIwIOkOQTmSjYDuVwUMAhzx/q+0vMc
        GTJfjcVxVL8qVhJ5j/rZcObkVw==
X-Google-Smtp-Source: APXvYqymZ63CSltZd43S4saV1m+kRrX7wAYXpUAZRLVwgx+wsTABxUz8ZTopmJPdgJ6UPHz7Q17faQ==
X-Received: by 2002:a37:47cb:: with SMTP id u194mr217546qka.296.1551370892620;
        Thu, 28 Feb 2019 08:21:32 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id a133sm10140716qkg.66.2019.02.28.08.21.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 08:21:31 -0800 (PST)
Message-ID: <035fb03f524d58d3749ebad6ceaad10ff73ee911.camel@ndufresne.ca>
Subject: Re: media: rockchip: the memory layout of multiplanes buffer for
 DMA address
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ayaka <ayaka@soulik.info>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, myy@miouyouyou.fr,
        ezequiel@collabora.com, tfiga@chromium.org
Date:   Thu, 28 Feb 2019 11:21:30 -0500
In-Reply-To: <1313497D-BE61-421C-93FA-0228F77F7FC5@soulik.info>
References: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
         <647793c24801de4fd464bac3414cff091c30facf.camel@ndufresne.ca>
         <1313497D-BE61-421C-93FA-0228F77F7FC5@soulik.info>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-QAABMri/x3iyMqZxX2Wq"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-QAABMri/x3iyMqZxX2Wq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 28 f=C3=A9vrier 2019 =C3=A0 09:12 +0800, Ayaka a =C3=A9crit :
> > On Feb 28, 2019, at 5:07 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
> >=20
> > Hi Ayaka,
> >=20
> > > Le mercredi 27 f=C3=A9vrier 2019 =C3=A0 23:13 +0800, Ayaka a =C3=A9cr=
it :
> > > Last time in FOSDEM, kwiboo and I talk some problems of the request
> > > API and stateless decoder, I say the a method to describe a buffer
> > > with many offsets as the buffer meta data would solve the most of=20
> > > problems we talked, but I have no idea on how to implement it. And I
> > > think a buffer meta describing a buffer with many offsets would solve
> > > this problem as well.
> >=20
> > for single allocation case, the only supported in-between plane padding
> > is an evenly distributed padding. This padding is communicated to
> > userspace through S_FMT, by extending the width and height. Userspace
> > then reads the display width/height through G_SELECTION API.
> It can solve the partly problem, it is hard to use only width and height =
to describe a buffer. For hevc and rkvdec decoder in 128bytes mode, it is a=
ligned with 128 bytes plus 128bytes. Sometimes, the padding data may. just =
less than a component. In that case, only offset would solve this problem.
> > For anything else, the MPLANE structure with one of the multi-plane
> > format can "express" such buffer, though from userspace they are
> > exposed as two memory pointer or DMABuf FDs (which make importation
> The video output(VOP) supports two address for luma and chroma and the ne=
w generation of rkvdec supports that as well. But for the general situation=
, we should think we can only set one DMA address to the device.
> > complicated if the buffer should initially be within a single
> > allocation). I'll leave to kernel dev the task to explain what is
> > feasible there (e.g. sub-buffering, etc.)
> I think it can use the same fd but with a different data_offset in struct=
 v4l2_plane(with a larger number of byteused in the second plane).

I think Hans said there is problem (something against the spec) in
using data_offset that way. The GStreamer implementation assumes that,
but got told recently that this might not be correct. I'd like Hans to
comment, since I haven't understood the reason yet.

>=20
> If I can find a solution to solve this problem, it would be hard to futur=
e develop on the stateless media device. Please help on this problem.

I don't think this is specific to state less CODEC. While more complex,
when dealing with CMA, the kernel can do that math to figure-out if two
memory pointers are from the same allocation. It quite easy if you know
in advance the spacing.

Without being identical, the framework does similar things when trying
to import USERPTR in a CMA based V4L2 driver.

> > Nicolas
> >=20

--=-QAABMri/x3iyMqZxX2Wq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXHgKigAKCRBxUwItrAao
HNgiAJ4hg1BpNcXzNIXl6VdyjJ+Bfpfm3QCcDS0BF0k+vqh9ZUIwbvimaz5Rv60=
=h+Eo
-----END PGP SIGNATURE-----

--=-QAABMri/x3iyMqZxX2Wq--

