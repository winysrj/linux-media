Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F86C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279CF20659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547463922;
	bh=DA43DrCga1+kMrjbjyY9/nOgAyJBFSlx3SXWinXAXKw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=dsQkzT3Xj/mQHVrJkRqcCiOt/hf5aX9EuiIYJTgqW7NfbEQIibBsop704CFGZoVRf
	 zYhjNLVxQEoHMK1bMGsdM8MGu+IxhsxmvW1f+tF7eVB08Vt2bQktspTEfyQrFGcj2U
	 l55w8nbmXN6om2BYTA749l5sf2tuNhPjWKZFjBzg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfANLFR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:05:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:38948 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbfANLFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 06:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vMIgTuKKtjeiDRvyisN/1zQmyYHGWpE9oXgEtAvunPw=; b=g2KOODKJo8FnKXhxc42a5Ea3oJ
        NcxK/4jRIyBQE98o2P/5NBUQQXUII2nO/hRansi6I8MGq0etHQbFXWEqO9LSaZ7AQI6j3ULs/13Zh
        QXZUYtRMvs60vZWq07f81AaOmyS1+taKMnAv9urQTc2eiZRKpWDTwLnDuNkucY8N8XVYtgPpiDDik
        mrNTL54fQ+EVcquLSuPLQoS0KF/poZCANuxSfoiiR2uuI2/ddIc8I061vLd9SlInwNTD8hweOG8E3
        xbQ3Vv1jExEzRnmafDUfl+nYhCJTo8q5JJahLaH/ge9+SsIbYShX0s9hHgmdJLQq7qxxXxBpPwkEw
        Q/QDzjkA==;
Received: from [177.159.251.133] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gj03C-00032s-7F; Mon, 14 Jan 2019 11:05:02 +0000
Date:   Mon, 14 Jan 2019 09:04:56 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Russell King <linux@armlinux.org.uk>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] videobuf2: replace a layering violation with
 dma_map_resource
Message-ID: <20190114090456.03071201@coco.lan>
In-Reply-To: <20190114103139.GA31005@lst.de>
References: <20190111181731.11782-1-hch@lst.de>
        <20190111181731.11782-4-hch@lst.de>
        <20190111175416.7d291e25@coco.lan>
        <20190114103139.GA31005@lst.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 14 Jan 2019 11:31:39 +0100
Christoph Hellwig <hch@lst.de> escreveu:

> On Fri, Jan 11, 2019 at 05:54:16PM -0200, Mauro Carvalho Chehab wrote:
> > Em Fri, 11 Jan 2019 19:17:31 +0100
> > Christoph Hellwig <hch@lst.de> escreveu:
> >   
> > > vb2_dc_get_userptr pokes into arm direct mapping details to get the
> > > resemblance of a dma address for a a physical address that does is
> > > not backed by a page struct.  Not only is this not portable to other
> > > architectures with dma direct mapping offsets, but also not to uses
> > > of IOMMUs of any kind.  Switch to the proper dma_map_resource /
> > > dma_unmap_resource interface instead.  
> > 
> > Makes sense to me. I'm assuming that you'll be pushing it together
> > with other mm patches, so:  
> 
> Not really mm, but rather DMA mapping, but yes, I'd love to take it
> all together.

Ah, OK! Anyway, feel free to place it altogether. 

It would be good if you could later send us a stable branch where
you merged, in order to allow us to run some tests with the new
DMA mapping patchset and be sure that it won't cause regressions
to videobuf2.

Thank you!

Mauro
