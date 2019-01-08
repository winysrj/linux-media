Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5CAC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A3220827
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="WT6J6cUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfAHPy1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:54:27 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58728 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfAHPy1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:54:27 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EDABD586;
        Tue,  8 Jan 2019 16:54:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546962865;
        bh=Zbuw8jbdrrdtIcrnGcvQEd9ncbg78aaqska0TQlRBTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WT6J6cUOY27RXAp087PYTWotnV08Bchrsd7LKvHm2PfJCifgeS53sAU1B5D3Z/xqm
         cKeRg/p/awaUDZmHD401UXZfidkh/DuNY9FYFhtNa0Aw/LW6vcRqPovuInyxOk04lq
         KQ7kfKgnMzFvY9jyjmShT5X5cK5fK6ZTylPy3gPg=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I start capture video
Date:   Tue, 08 Jan 2019 17:55:33 +0200
Message-ID: <14736242.P0ZrnmSNTt@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190108131621.59a825b7@coco.lan>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com> <386743082.UsI2JZZ8BA@avalon> <20190108131621.59a825b7@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tuesday, 8 January 2019 17:16:21 EET Mauro Carvalho Chehab wrote:
> Em Tue, 08 Jan 2019 16:54:41 +0200 Laurent Pinchart escreveu:
> > On Tuesday, 8 January 2019 16:45:37 EET Mauro Carvalho Chehab wrote:
> >> Em Sun, 6 Jan 2019 01:05:16 +0500 Mikhail Gavrilov escreveu:
> >>> Hi folks!
> >>> Every time when I start capture video from external capture card
> >>> Avermedia Live Gamer ULTRA GC553
> >>> (https://www.avermedia.com/gaming/product/game_capture/live_gamer_ultr
> >>> a_gc553)
> >>=20
> >> What's the driver used by this device?
> >>=20
> >> A quick browsing at the Avermedia page you pointed, it indicates that
> >> this should be using the UVC driver:
> >>=20
> >> 	"The LGU takes full advantage of UVC technology, which
> >> 	 basically standardizes video drivers across Windows and Mac.
> >> 	 In other words, all you need to do is plug your LGU to
> >> 	 your PC or Mac and it=E2=80=99s ready to record and stream."
> >>=20
> >> So, I *suspect* that it uses the uvcvideo driver, but better to
> >> double check.
> >=20
> > Given the full kernel log part of the original message,
> >=20
> > [    5.184850] uvcvideo: Unknown video format
> > 30313050-0000-0010-8000-00aa00389b71
>=20
> Hmm... according with:
> 	https://gix.github.io/media-types/
>=20
> It seems to be this one ('P010'):
>=20
> {30313050-0000-0010-8000-00AA00389B71} (MFVideoFormat_P010)MFMS
> {30313050-0000-0010-8000-00AA00389B71} (MEDIASUBTYPE_P010)DSMS
>=20
> YUV planar 4:2:0 10 bits.
>=20
> If so, there's a description here:
>=20
> 	https://docs.microsoft.com/en-us/windows/desktop/medfound/10-bit-and-16-=
bit
> -yuv-video-formats

That seems to match. The problem should then be easy to fix, but we need to=
=20
add a corresponding fourcc to the V4L2 API, and matching documentation. Any=
=20
volunteer ? :-)

=2D-=20
Regards,

Laurent Pinchart



