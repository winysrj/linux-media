Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A291C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A259214C6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547054902;
	bh=gRh02/4xl3cQYO8LgM9okKVsTc4C2eqlMOaOECZr5L4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Ufwm8FV3x4lVAMP9Ou/yfLUeem/WfW71jmuBjmH+Ct0i6sx+Bt73kk5ejvRhiMD0P
	 jCXSk2QOrSAYrZyPPkItunsyaxeLl61XXYtN0+/EbPUPSTD6S+aoIcKORu/BSj1a8C
	 Cm4SP97cWKLEE4th7WEms36lcG4ta9QvoErzi7GA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfAIR2V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:28:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:59500 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfAIR2V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 12:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gRh02/4xl3cQYO8LgM9okKVsTc4C2eqlMOaOECZr5L4=; b=UNVqb/OMdgvlKX6FAnBh45vurM
        Dva+2WeGy3xCtCo0Awl8djjXYid7IHGG6h0u691tfn5JRWYHPiH85d5/yTcKUTDyOypjf8cShs7u/
        CDxlUOFxQabECBER1Amz1QXgpumvYzrd3Tq7VtqkjD2l6+g9s48l+cyJWoyXfGEN355djFF09ekXM
        nXvCivQm5aRdMovo+IedZjuq9algxE63aStZJ77XUq9fQc2Wl3RVW9sGW9uhXWiSx944ZEdWxLmkZ
        rCZ/S/YW7ntw+saRqZS/dlaZ06/kWMFuTkSeaGFSf3MywsWEUAoxjuE14BWoRZ9hjhYozHED3KPsL
        6q5MFGkg==;
Received: from 177.18.27.52.dynamic.adsl.gvt.net.br ([177.18.27.52] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghHeH-0006EK-1B; Wed, 09 Jan 2019 17:28:13 +0000
Date:   Wed, 9 Jan 2019 15:28:08 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Ayaka <ayaka@soulik.info>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: P010 fourcc format support - Was: Re: Kernel error "Unknown
 pixelformat 0x00000000" occurs when I start capture video
Message-ID: <20190109152808.5ce020ca@coco.lan>
In-Reply-To: <d4b982820d870f20908e129afce635ea7c9dea5d.camel@ndufresne.ca>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <386743082.UsI2JZZ8BA@avalon>
        <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
        <32231660.SI74LuYRbz@avalon>
        <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
        <20190108164916.55aa9b93@coco.lan>
        <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
        <20190109110155.39a185de@coco.lan>
        <0F13FA85-843C-43A6-ADFA-03C789D60120@soulik.info>
        <d4b982820d870f20908e129afce635ea7c9dea5d.camel@ndufresne.ca>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 09 Jan 2019 11:52:45 -0500
Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:

> Le jeudi 10 janvier 2019 =C3=A0 00:42 +0800, Ayaka a =C3=A9crit :
> > > There is a UVC media device that supports P010 device. We're discussi=
ng
> > > about adding support for it on media. The full thread is at:
> > >=20
> > > https://lore.kernel.org/linux-media/20190109121900.hbrpttmxz3gaotwx@v=
alkosipuli.retiisi.org.uk/T/#m8c395156ca0e898e4c8b1e2c6309d912bc414804
> > >=20
> > > We've seen that you tried to submit a patch series for DRM adding
> > > support for it at the rockship driver. What's the status of such
> > > series? =20
> > Rockchip would use another 10bit variant of NV12, which is merged as NV=
12LE40 at Gstreamer and I sent another patch for it, but I didn=E2=80=99t r=
eceive any feedback from that. =20

Hmm... We have already NV12 format at media subsystem side:
Documentation/media/uapi/v4l/pixfmt-nv12.rst

Did we miss some patch from you?

>=20
> For extra detail, the Rockchip variant is fully packed, with no padding
> bits, while the Microsoft variant uses 16bits per pixels, with 6bits
> padding. It was a mistake to use P010 initially for the Rockchip
> format.

Yeah, P010 format seems to be a waste of bandwidth. Yet, as we're
now having devices using it (via uvcdriver), it would make sense to
merge the single plane format for it. I would merge the P016 too, as
P010 seems to be just a degradation of it.

Ayaka,

Would it be possible for you to re-send the P010/P016 documentation
for single plane, fixing the typo (simliar -> similar)?

Let's not merge the dual plane formats, as we don't need them
yet at the Kernel.

Thanks,
Mauro
