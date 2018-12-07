Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23547C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 15:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD60F20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 15:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZEFo5zEa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD60F20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbeLGPZR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 10:25:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeLGPZR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 10:25:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vSfOKpHUC2Ivi5hb8oXdbjEysrJR9O6imxEbw4vC+p4=; b=ZEFo5zEaNmQ7a+ExidH1/FiL/
        LkMDIGD/jlkMbFVlcehtKFpwdwYGByKNSTsq12cshwKkQYkudMoW00CLjYhpMjxpgVBC1m0vvKNSG
        k3G3v84Ar7maNKYfOoTQ6TnoHlkHM98PKL0XFPMBMzGMhy6VmLzlXxMTiO9gkpkXKL4/ym10FHeou
        VBRKsTthzc4ODbwFhirfQ4AMRBXebjeTcAyLtKMmmOJzNhcUt0yQ4yq9yySZvZlF+J0ywss7mFntc
        T3K/T0FzolJRow2belsRO3jG3g4Q27l2qd4ZTM+v9Gh4tIOqfOyGm11SdT9rou17Q78oceKY8g0ym
        We9Ps9Lbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVHzz-0002fj-1n; Fri, 07 Dec 2018 15:25:03 +0000
Date:   Fri, 7 Dec 2018 07:25:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        matwey.kornilov@gmail.com, tfiga@chromium.org,
        stern@rowland.harvard.edu, ezequiel@collabora.com,
        hdegoede@redhat.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181207152502.GA30455@infradead.org>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
 <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2213616.rQm4DhIJ7U@avalon>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Folks, can you take a look at this tree and see if this is useful
for USB:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-noncoherent-allocator

The idea is that you use dma_alloc_attrs with the DMA_ATTR_NON_CONSISTENT
now that I've made sure it is avaiable everywhere [1], and we can use
dma_sync_single_* on it.

The only special case USB will need are the HCD_LOCAL_MEM devices, for
which we must use dma_alloc_coherent (or dma_alloc_attrs without
DMA_ATTR_NON_CONSISTENT) and must skip the dma_sync_single_* calls,
so we'll probably need USB subsystem wrappers for those calls.

[1] except powerpc in this tree - I have another series to make powerpc
use the generic dma noncoherent code, which would cover it.
