Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E11C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62EC020685
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546960588;
	bh=dNaYcdX+is990TjVlPw0V13wvBgfZ9Qf4sCtJx1UE6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=gxoDI36OpgpFsxUYVgRtXy27PG/RpokuwTUXOP1Ajw874nrjPkpjYM+bwb2rmEEft
	 6sC6D6JTns1qWBcOG0F2c8tucZhDphI0WIDRqr+wQy+EdyYPbbg7XB3nZE0oSyiBBd
	 93VgGWxaL5yXdovX+e4cGcmgxeenWYbt6nL8e31k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfAHPQ1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:16:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:34992 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHPQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:16:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cQaenRLsC6eHC6sfKOBvQZR3ZNr9KdGv8DklPZfKFzk=; b=dNWfS2DYaP5ibZT8gKl8a3xwXG
        gSbcGKyjAVNLKDv64vGro1wWxAwBJfDbPRPUTrfTgNo+H5S30u/JJuEKMi7AKHPuh+uYxVPr7LJ2/
        +86A9Va9YphwBwCbqIh3fY23Q0X6pj/V9yl/euaVRP+jQ0mo628WQltIpMUJKx7Yz4oU+ULSqOhm5
        Nu5BqWhtZmLG31lJu15dH/beyilwtz+ZhcIo/dQVWRMV/c5YmwiqlWtwAShP3r5Dss28LcasE5aTA
        AJ0Qf3CLEltCFB3IJrtOJcMZN3IjiWKzIp82naY1Bn2Ab3/TUew6lljFLic7y+bsokMQBmfrROeZL
        9blo+Qiw==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggt7B-0001O8-6X; Tue, 08 Jan 2019 15:16:25 +0000
Date:   Tue, 8 Jan 2019 13:16:21 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190108131621.59a825b7@coco.lan>
In-Reply-To: <386743082.UsI2JZZ8BA@avalon>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <20190108124532.5159b90a@coco.lan>
        <386743082.UsI2JZZ8BA@avalon>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 08 Jan 2019 16:54:41 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
>=20
> On Tuesday, 8 January 2019 16:45:37 EET Mauro Carvalho Chehab wrote:
> > Em Sun, 6 Jan 2019 01:05:16 +0500 Mikhail Gavrilov escreveu: =20
> > > Hi folks!
> > > Every time when I start capture video from external capture card
> > > Avermedia Live Gamer ULTRA GC553
> > > (https://www.avermedia.com/gaming/product/game_capture/live_gamer_ult=
ra_gc
> > > 553) =20
> >=20
> > What's the driver used by this device?
> >=20
> > A quick browsing at the Avermedia page you pointed, it indicates that t=
his
> > should be using the UVC driver:
> >=20
> > 	"The LGU takes full advantage of UVC technology, which
> > 	 basically standardizes video drivers across Windows and Mac.
> > 	 In other words, all you need to do is plug your LGU to
> > 	 your PC or Mac and it=E2=80=99s ready to record and stream."
> >=20
> > So, I *suspect* that it uses the uvcvideo driver, but better to
> > double check. =20
>=20
> Given the full kernel log part of the original message,
>=20
> [    5.184850] uvcvideo: Unknown video format=20
> 30313050-0000-0010-8000-00aa00389b71

Hmm... according with:
	https://gix.github.io/media-types/

It seems to be this one ('P010'):

{30313050-0000-0010-8000-00AA00389B71} (MFVideoFormat_P010)MFMS
{30313050-0000-0010-8000-00AA00389B71} (MEDIASUBTYPE_P010)DSMS

YUV planar 4:2:0 10 bits.

If so, there's a description here:

	https://docs.microsoft.com/en-us/windows/desktop/medfound/10-bit-and-16-bi=
t-yuv-video-formats

Thanks,
Mauro
