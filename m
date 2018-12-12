Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC21C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF28820849
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hl3KljdR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF28820849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbeLLJJc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:09:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbeLLJJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MEuYYn3BaHHXkDWWKQAaU7ww1MsDEvyrrWt5TN+W4o8=; b=Hl3KljdRZsYgBumVPEtjQwwjy
        sTQwVLYUOc5dJWFbFGPIqiUNdFxzmENBAfbrZHbOliwAGFkSaCGGjEUoRY/FI19mP5nchlk5oOkCy
        0XW/Kv7LAsCDdYIEe88mWuoEJb7h23yo0KP1guVuxK2z92/VFfIGbfWochRU7nhswZUzGToPFWync
        8Hq5VLwlvTk1vYYpAo6Tn5mUFo2MtPiHDRaYOMevV3wsZHUT9hsgnVKMbQXZ6Vs3V5/xUWZ/Dq9SD
        lXVx/lJulafcv+9I4vAcMVdq/kg/oNqf1fX23zydTQSf2dZrKSL/v50z4WXKqzVCw7ioXy8oytTFc
        NZFscB8bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX0W5-00085H-6f; Wed, 12 Dec 2018 09:09:17 +0000
Date:   Wed, 12 Dec 2018 01:09:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Subject: Re: [PATCH v5 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181212090917.GA30598@infradead.org>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
 <20180821170629.18408-3-matwey@sai.msu.ru>
 <2213616.rQm4DhIJ7U@avalon>
 <20181207152502.GA30455@infradead.org>
 <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5C6gUvg8p0+Gtk22Z-dmeMPytdF4HujL9evYAew15bUmA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Dec 12, 2018 at 05:57:02PM +0900, Tomasz Figa wrote:
> How about dma_sync_sg_*()? I'd expect some drivers to export/import
> such memory via sg, since that's the typical way of describing memory
> in DMA-buf.

The way it is implemented dma_sync_sg_* would just work, however there
really should be no need to have sglists for buffers created by this
API.

> Sounds good to me. Thanks for working on this. I'd be happy to be on
> CC and help with review when you post the patches later.

The patches were already posted here:

https://lists.linuxfoundation.org/pipermail/iommu/2018-December/031982.html
