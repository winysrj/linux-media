Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87942C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5458E206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547035401;
	bh=3rGF4V3N4GrM2EsCPktc68tbpAHsaIF7fos0lKtA4Vc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=0p+858wp0oLNKQk/XvEga3oqBCoMEW6VefA0ILHJxi32jduDEd0J3g9XNgnLzfzSI
	 M5wz6qKTY7uKS6Rj1IMVLFRXGUw+OK1M6nLL1LCEYPGxCmh8dWfkIv3N+7y0I1m/95
	 l80kL3Ij6Rv3QcOLVo/wJG0zqUWXzjM1+JqRwwq0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbfAIMDU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:03:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:58108 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfAIMDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 07:03:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZdWWBSHqh0jbPWAShrvUD9yvhBrjveQ3nwu+L37Vkxo=; b=DUvJjUSV22sOSoq/B7UQZOQEiG
        As5TgvMYqHkh7p71RgRJRWZIYGfKObOLj+Zxf+BPa+mGzSiH8lMxLPBSNdrKj1lctJCpSSm30xO0N
        1atINlFNxU2kKjXdy9p4eXs/vkab9KxaRxz2AwEKAdOYWgpLo1rzCH8zwuHPn5PTVr+r0diIskcCL
        LIKuuRIoN88nBITSGwUkDcIzvdb9Ms5J/h7Gduv4P2KjBVCOSqXVOQxwfJ23V2kMAkTQOFBc9y2Et
        +IjFe/+rIzJ9BeSTjFDMIJI3wIQM8QMQtJz/ORTdkyWLBP+qiPua8/mwWAyaNsF1RsV4FY+JoW39E
        gBc96qWA==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghCZo-0008Rf-Rv; Wed, 09 Jan 2019 12:03:17 +0000
Date:   Wed, 9 Jan 2019 10:03:12 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I
 start capture video
Message-ID: <20190109100312.02a725d8@coco.lan>
In-Reply-To: <CABXGCsPJJfu7fwVnx3ovHTDF-rBFrUqmc7dqF+R-Q-NE2vmn5w@mail.gmail.com>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
        <386743082.UsI2JZZ8BA@avalon>
        <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
        <32231660.SI74LuYRbz@avalon>
        <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
        <20190108164916.55aa9b93@coco.lan>
        <20190108170000.4f0d6e6d@coco.lan>
        <CABXGCsPJJfu7fwVnx3ovHTDF-rBFrUqmc7dqF+R-Q-NE2vmn5w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 9 Jan 2019 08:51:29 +0500
Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> escreveu:

> I upgraded kernel to 5.0 rc1 and the error message  "Unknown
> pixelformat 0x00000000" are disappeared.
>=20
> Instead I see not obvious message "uvcvideo: Non-zero status (-71) in
> video completion handler."

This is unrelated. Usually, you get -71 errors when there's a problem
with usb cabling. This is what it means:

	#define	EPROTO		71	/* Protocol error */

=46rom Documentation/driver-api/usb/error-codes.rst:

``-EPROTO`` [#f1]_, [#f2]_	a) bitstuff error
				b) no response packet received within the
				   prescribed bus turn-around time
				c) unknown USB error

> Maybe in this case better to write "Video format XXX not supported" ?

The message about the lack of support for P010 is still there:

	[    5.218031] uvcvideo: Unknown video format 30313050-0000-0010-8000-00aa=
00389b71

The best solution would be to really convert this into something that
applications can benefit, e. g. exporting the P010 format to userspace.

> It would help quickly understand that is culprit here.
>=20
>=20
> --
> Best Regards,
> Mike Gavrilov.



Thanks,
Mauro
