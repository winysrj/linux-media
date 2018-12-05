Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CED5C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E7592064D
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXhCbD0m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E7592064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbeLEKbk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:31:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:54500 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeLEKbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 05:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4KqDWiP1GGJKYnL+84+zo9iBjKZH0iNJw4HXyUC5u9Y=; b=sXhCbD0mTJXyWG5P81ZORGWRxG
        hrD1/I4aacvXHy9QTvdO5l0gDpKOtFd6FHOInohqYMb0AUtraQnVhN8nhwpYTNTDBIRLouKLZUSI3
        RsXNw3qTjy7h9DszNu14RBF29F1p2/uSkhZxvzqbHfpxhDwUydTqx58DfIVvn6bT3E/ElcARbRGl1
        Lem/tfID6/H+ERKkxPLRUu7T+U1LcKUcWhQJVWuR3H6uowOnzDR+hoIHya8/7LSJDiv4xpXSLrDHM
        RXIP3TLEbUcI78wv5bTbRDuaW7S0Dn/AJO+6XymqggDXFG4phTdfX12uCMSaUzg8yO71RjslVsLqH
        BYdPgLQQ==;
Received: from [191.33.148.129] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUUSt-0001Ou-EM; Wed, 05 Dec 2018 10:31:35 +0000
Date:   Wed, 5 Dec 2018 08:31:29 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, linux-spi@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 7/8] media: sti/bdisp: don't pass GFP_DMA32 to
 dma_alloc_attrs
Message-ID: <20181205083129.20b6b0be@coco.lan>
In-Reply-To: <CA+M3ks5ebGDgFtMS5mSYz38AnyrTMQr8C_JkbFEzp=k+izJjUQ@mail.gmail.com>
References: <20181013151707.32210-1-hch@lst.de>
        <20181013151707.32210-8-hch@lst.de>
        <CA+M3ks5KO-Yr_PEczaENhTfirthFz2gW1uv4bwZe5mjy3-jZyg@mail.gmail.com>
        <20181017072020.GD23407@lst.de>
        <CA+M3ks5ebGDgFtMS5mSYz38AnyrTMQr8C_JkbFEzp=k+izJjUQ@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 18 Oct 2018 14:00:40 +0200
Benjamin Gaignard <benjamin.gaignard@linaro.org> escreveu:

> Le mer. 17 oct. 2018 =C3=A0 09:20, Christoph Hellwig <hch@lst.de> a =C3=
=A9crit :
> >
> > On Mon, Oct 15, 2018 at 11:12:55AM +0200, Benjamin Gaignard wrote: =20
> > > Le sam. 13 oct. 2018 =C3=A0 17:18, Christoph Hellwig <hch@lst.de> a =
=C3=A9crit : =20
> > > >
> > > > The DMA API does its own zone decisions based on the coherent_dma_m=
ask.
> > > >
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de> =20
> > >
> > > Reviewed-by: Benjamin Gaignard <benjamin.gaignard@linaro.org> =20
> >
> > Can you pick it up through the media tree? =20
>=20
> No but Mauros or Hans (in CC) can add it.

I'm adding it. Sorry for the delay. All those trips for MS/KS made
harder to handle it earlier.

Thanks,
Mauro
