Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D2EC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0069B20578
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 13:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547038925;
	bh=kS6+euzIiHqMktenUcGJuYIlLz1OwFORd/3Iippi1DQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=YBcShXN0/q+Id0CLm65ARYA7S+up1/lTcaGPp5o5nlfjiX5h/m7nNsBkeQxVcJ5Z0
	 mVxb6bh1pk0juxk9pcJA0Z7DWg2PhQpxbuYAfVkwiPXYOWhymLswO9goA4ro4T82YG
	 60ByqnY2Pmp26SOqi9mfAL+7tEsS55gI94BRgDps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfAINCE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 08:02:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:34668 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfAINCE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 08:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i8gDjMpTWsDnpEZRhVAejhFmP4qF3zWpejr4JYJu00o=; b=W/HFZDktIwOMLsMvJ2ycmpMoI1
        a3+bQDBKgLxxOn5TngO7cN5+a1DGkazm3vOUjmPT2WZ0MJjEXrKvLzP6rK/5Qq10EXUuK99aUk2/O
        NpqBDCgVCpau6bJI6aUiCLxE/e3yMU3GaQJeVR3TK0zJjB/jGExHwIu5QZFHaN4KY1LtKNcUGJRFf
        XjQYDa7LrrgcgLpXuXXDXhYvNsWQCsaegPphDAArSRDytiB9X2KzNKEa+PFyg55f1SU1yl2mxyiUq
        /MQHhDEN3u9FsOCTx7li82s9HqZf8A5HFNCGaaTX/stDDDQ1b8p+dgHmVSeovCkyZ3+BAw3d6mwgv
        K18FF6jA==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghDUd-0002Lo-SJ; Wed, 09 Jan 2019 13:02:00 +0000
Date:   Wed, 9 Jan 2019 11:01:55 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@iki.fi>, Ayaka <ayaka@soulik.info>
Cc:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: P010 fourcc format support - Was: Re: Kernel error "Unknown
 pixelformat 0x00000000" occurs when I start capture video
Message-ID: <20190109110155.39a185de@coco.lan>
In-Reply-To: <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <386743082.UsI2JZZ8BA@avalon>
        <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
        <32231660.SI74LuYRbz@avalon>
        <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
        <20190108164916.55aa9b93@coco.lan>
        <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 9 Jan 2019 14:19:00 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Tue, Jan 08, 2019 at 04:49:16PM -0200, Mauro Carvalho Chehab wrote:
> > Em Tue, 8 Jan 2019 21:11:41 +0500
> > Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:
> >  =20
> > > On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart
> > > <laurent.pinchart@ideasonboard.com> wrote: =20
> > > >
> > > > Thank you.
> > > >
> > > > Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12,=
 P010 and
> > > > BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo drive=
r except
> > > > for the P010 format. This would be easy to fix in the uvcvideo driv=
er if it
> > > > wasn't for the fact that the P010 format isn't support by V4L2. Add=
ing support
> > > > for it isn't difficult, but I don't have time to do this myself at =
the moment.
> > > > Would you consider volunteering if I guide you ? :-)
> > > >   =20
> > >=20
> > > Sure, I'd be happy to help. What is required of me? =20
> >=20
> > It shouldn't be hard.=20
> >=20
> > First, you need to add the new format at include/uapi/linux/videodev2.h,
> > like this one:
> >=20
> > 	#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YU=
V420 planar */
> >=20
> > Please put it together with the other YUV formats.
> >=20
> > As the fourcc "P010" was not used on Linux yet, you could use it,
> > e. g., something like:
> >=20
> > 	#define V4L2_PIX_FMT_YUV_P10 v4l2_fourcc('P', '0', '1', '0') /* 10  YU=
V420 planar */
> >=20
> > You need then to document it. Each V4L2 format should have a descriptio=
n,=20
> > like this:
> >=20
> > 	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-yuv420m=
.html
> >=20
> > This is generated via a text file (using ReST syntax). On the above exa=
mple,
> > it is produced by this file:
> >=20
> > 	https://git.linuxtv.org/media_tree.git/tree/Documentation/media/uapi/v=
4l/pixfmt-yuv420m.rst
> >=20
> > Writing it would take a little more time, but, provided that you don't=
=20
> > copy what's written from external docs, you could take a look at the
> > Internet for the P010 descriptions, and use the pixfmt-yuy420m.rst file
> > as the basis for a new pixfmt-p010.rst file. =20
>=20
> There is some work done on this but it's not finished; searching "P010" in
> Patchwork yields this:
>=20
> <URL:https://patchwork.linuxtv.org/patch/39752/>

Good point! I'm c/c the author of it.

The actual patch for media is this one:

	https://patchwork.linuxtv.org/patch/39753/

It sounds that the author didn't sent any version after that.

The goal seemed to be to add P010 support at DRM for the rockchip driver.

specifically with regards to patch 2/3, the issues seemed to be:

	- some naming issues with the multiplane format variants;
	- a typo: simliar -> similar;
	- a comment about the usage of 1/2 UTF code (=C2=BD). Not sure if
	  Sphinx will handle it well for both html and pdf outputs.
	  It should, but better to double check.

Ayaka,

There is a UVC media device that supports P010 device. We're discussing
about adding support for it on media. The full thread is at:

https://lore.kernel.org/linux-media/20190109121900.hbrpttmxz3gaotwx@valkosi=
puli.retiisi.org.uk/T/#m8c395156ca0e898e4c8b1e2c6309d912bc414804

We've seen that you tried to submit a patch series for DRM adding
support for it at the rockship driver. What's the status of such
series?

Thanks,
Mauro
