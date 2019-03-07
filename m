Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE959C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 17:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8048220854
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 17:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="OMgajgEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfCGRLj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:11:39 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45375 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCGRLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 12:11:39 -0500
Received: by mail-qk1-f193.google.com with SMTP id v139so9441392qkb.12
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2019 09:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=SZe/0COWyof84Mvy66wR1nGxIWp8wcexlgWhamEmWj0=;
        b=OMgajgEckaCIe4hdCAhXVvsgYIm76VUpehQqabBzZN1bmQSt3SV6+EjmgzvfJnTE71
         a1sr/w7VD4yxiW7ERcMP0/II+I8UoR4HDEWopjL76pWFLRV1wd/M7k27qsRX31Be+ugt
         S7YU/UJtbS8vkqaxEBt+LvLqsHyTcYbiVbRscdk7UM++/xo2hip85hDQXLQXFkjW6Qww
         Dakh3O6uwx2u3fMaNBiW5fXuf75lcYDyNxxq6cG301AQHqBk8Bh4jxUrrk0MwJQHTvmN
         5l42ONzvAy8jhfGt/KyYx7QSUlpRj4bXYQuQxbh2eIvlP74V9gVwb2wa9Yz8YGmMRlCX
         h6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=SZe/0COWyof84Mvy66wR1nGxIWp8wcexlgWhamEmWj0=;
        b=hlx7BVfwvWVJa7VAW0CaJCAxIMSVVLitHxV2ej5qrSQOVlufKgQpEeG2Y0JaurXvko
         MDPOxxBHe3EkLfk1UQcJY78lDP4AZhCh0v/HSLFxTQbm6Xuhh2IyblEbyc1VAvyWOAAj
         Vq2Wd+kKXm/OnR23sZSc8yNg4rOGgMfk3e5O7gTPIdpRm74cdcaTKLy7J9loGP+dZ39w
         33az2SxAi1/IR3Pg8u64/Bgzb6mJcOInWUc+rMX0fHbLpKxehqnIDFNjUHQTbZIdHrzd
         k6gpql825KjGUWoLFWuwMJyhx3P6O7ZlOJ9ArTiWG6FzgCfghs8RSsgIK7tR4+PuA6R+
         ckKg==
X-Gm-Message-State: APjAAAU5nNmXke1rNpByh25xQuBhhxHATiT0liTAzeGVJxJVtUt9iFbf
        HEQhdafVTLC+02t/sBoJGvWh7w==
X-Google-Smtp-Source: APXvYqwfp2VSdPmL6cGAEohJkvPshVmqiVvJNjm+J1YIobfkCPJhL3S7JBk3yk2y+1c94XUN3UIt8g==
X-Received: by 2002:a37:5786:: with SMTP id l128mr10638845qkb.263.1551978697436;
        Thu, 07 Mar 2019 09:11:37 -0800 (PST)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id k64sm1172029qkd.55.2019.03.07.09.11.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Mar 2019 09:11:36 -0800 (PST)
Message-ID: <198322d47ff7c6e00e5a5a5145f66c22d21e456a.camel@ndufresne.ca>
Subject: Re: [PATCH v2 0/6] [WIP]: rockchip mpp for v4l2 video deocder
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Randy Li <randy.li@rock-chips.com>, linux-media@vger.kernel.org
Cc:     ayaka@soulik.info, hverkuil@xs4all.nl, maxime.ripard@bootlin.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        jernej.skrabec@gmail.com, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org
Date:   Thu, 07 Mar 2019 12:11:33 -0500
In-Reply-To: <20190307100316.925-1-randy.li@rock-chips.com>
References: <20190307100316.925-1-randy.li@rock-chips.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-QlC4T/nWYIDZtJzGLfGL"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-QlC4T/nWYIDZtJzGLfGL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 07 mars 2019 =C3=A0 18:03 +0800, Randy Li a =C3=A9crit :
> Although I really want to push those work after I added more codec
> supports, but I found it is more urge to do those in v4l2 core framework =
and
> userspace.
>=20
> I would use this driver to present the current problems, write down a
> summary here and I would reply to those threads later to push forward.
>=20
> 1. Slice construction is a bad idea. I think I have said my reason in
> the IRC and mail before, vp9 is always good example.
>=20
> And it would request the driver to update QP table/CABAC table every
> slice.
>=20
> I would make something to describe a buffer with some addtional meta
> data.
>=20
> But the current request API limit a buffer with associated with
> an request buffer, which prevent sharing some sequence data, but it=20
> still can solve some problems.

I guess you are trying to make some argument here, but I don't really
understand what you are referring to. Right now there is two concurrent
drivers for the Rockchip, yours and Ezequiel. Ezequiel does not seem to
have raised any blockers around any of this (yet).

>=20
> 2. Advantage DMA memory control.
> I think I need to do some work at v4l2 core.
>=20
> 2.1 The DMA address of each planes. I have sent a mail before talked
> about why multiple planes is necessary for the rockchip platform. And
> it maybe required by the other platforms.
>=20
> 2.2 IOMMU resume
> The most effective way to restore the decoder from critical error is
> doing a restting  by reset controller.
> Which would leading its slave IOMMU reset at the same time. Then none of
> those v4l2 buffers are mapping in the IOMMU.

You can't invalidate application memory mapping in V4L2, this is
generic to V4L2 interface. If you still need to do this, you'll have to
tell user-space through the SRC_CHANGE event, forcing a reconfiguration
hence a reallocation of the buffers. Then your driver would be
responsible for caching the allocation in order to not introduce
delays. The framework does not prevent you from doing so, but yet, this
is likely difficult.

>=20
> 3. H.264 and HEVC header
> I still think those structure have some not necessary fileds in dpb or
> reference part, which I don't think hardware decoder would care about
> that or can be predict from the other information.

This was discussed during the review, but all the information in there
exist in the in the slice headers bitstream. There is no reason some
information should not be made available to the driver, used or not.=20

This is the only way we can guaranty that we won't prevent other HW to
be integrated in the future. This is specially needed for
H264_SLICE_RAW format used by Allwinner. In Ezequiel H264 decoder
patchset for Rockchip HW, the format is H264_SLICE_ANNEX_B, of course
in this format one could always do a bit of parsing in the kernel, but
we don't want that really.

That being said, I'd like to remind that we don't expose the control
publicly yet, these are still unstable. We will freeze these after
drivers get added to mainline and are considered stable.

>=20
> I would join to talk later.
>=20
> 4. The work flow of V4L2
> I need a method to prepare the register set before the device acutally
> begin the transaction. Which is necessary for those high frame rate useca=
se.

Can't you just increase the buffer queue size ? Then prepare the
buffers on application thread, and process on another or something.
This seems like driver specific, not an API thing.

>=20
> Also it is useful for those device would share some hardware resources
> with the other device and it can save more power.
>=20
> I think I need to do some work at v4l2 core.

Seems all possible to optimize, imho, we should aim at getting a
working driver into mainline first and then progressively tweak it to
gain best performance. The driver and userspace need complete re-
implementation, and it won't happen all in one pass. I'm sure there is
multiple years of effort, and multiple iterations on the vendor kernel
and userspace. We can learn from that, but my point is that we are not
yet at a stage where we should focus on driver specific optimization.

=46rom what you have said so far, I haven't found anything for which the
kernel interface that is being merged would prevent doing the suggested
optimization. Instead I read you as some of the interface decision will
require a bit more work for this specific driver. This is often the
tradeoff we have to do to make sure we can expose generically usable
interface. And that's likely why mainline drivers are often a tad more
complex then their vendor equivalent.

>=20
> Randy Li (6):
>   arm64: dts: rockchip: add power domain to iommu
>   staging: video: rockchip: add v4l2 decoder
>   [TEST]: rockchip: mpp: support qptable
>   staging: video: rockchip: add video codec
>   arm64: dts: rockchip: boost clocks for rk3328
>   arm64: dts: rockchip: add video codec for rk3328
>=20
>  .../arm64/boot/dts/rockchip/rk3328-rock64.dts |   32 +
>  arch/arm64/boot/dts/rockchip/rk3328.dtsi      |  116 +-
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi      |    2 +
>  drivers/staging/Kconfig                       |    2 +
>  drivers/staging/Makefile                      |    1 +
>  drivers/staging/rockchip-mpp/Kconfig          |   34 +
>  drivers/staging/rockchip-mpp/Makefile         |   10 +
>  drivers/staging/rockchip-mpp/mpp_debug.h      |   87 ++
>  drivers/staging/rockchip-mpp/mpp_dev_common.c | 1367 +++++++++++++++++
>  drivers/staging/rockchip-mpp/mpp_dev_common.h |  212 +++
>  drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c |  997 ++++++++++++
>  drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  |  619 ++++++++
>  drivers/staging/rockchip-mpp/mpp_service.c    |  197 +++
>  drivers/staging/rockchip-mpp/mpp_service.h    |   38 +
>  drivers/staging/rockchip-mpp/rkvdec/hal.h     |   63 +
>  drivers/staging/rockchip-mpp/rkvdec/hevc.c    |  166 ++
>  drivers/staging/rockchip-mpp/rkvdec/regs.h    |  608 ++++++++
>  drivers/staging/rockchip-mpp/vdpu2/hal.h      |   52 +
>  drivers/staging/rockchip-mpp/vdpu2/mpeg2.c    |  277 ++++
>  drivers/staging/rockchip-mpp/vdpu2/regs.h     |  699 +++++++++
>  20 files changed, 5575 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/staging/rockchip-mpp/Kconfig
>  create mode 100644 drivers/staging/rockchip-mpp/Makefile
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_debug.h
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.c
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.h
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_service.c
>  create mode 100644 drivers/staging/rockchip-mpp/mpp_service.h
>  create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hal.h
>  create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hevc.c
>  create mode 100644 drivers/staging/rockchip-mpp/rkvdec/regs.h
>  create mode 100644 drivers/staging/rockchip-mpp/vdpu2/hal.h
>  create mode 100644 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
>  create mode 100644 drivers/staging/rockchip-mpp/vdpu2/regs.h
>=20

--=-QlC4T/nWYIDZtJzGLfGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXIFQxgAKCRBxUwItrAao
HDG8AJ9VZZla34BdsxjVAkiCy4Ymbz+QDgCgy1q6L28rm2phIoLSjwmh9Tla0Fs=
=DR6J
-----END PGP SIGNATURE-----

--=-QlC4T/nWYIDZtJzGLfGL--

