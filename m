Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C77C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF17217D9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550510599;
	bh=OyQDA5NrtdUhFCdzDQIInGlvQ441/PahjDBAPm+luAI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=z74kWfEIEt84KCGpp5Dx1VSSnBFQ8T+GtPkSYH7RhCCe6eVT8OEypdsGyr4xKnx7u
	 P08/8QEur+p69Gdmc44QCvyS5H4WxLmmsx6kNNaVlzKgIcfFGqJWRnWVwjje3KWla0
	 L6BPF9fReLuzd7FT1wxEsCoLxTgrWct7XmKaIOp0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391184AbfBRRW7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:22:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391167AbfBRRW6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 12:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2+ajaRb3OSfNq3Z7Jf+0SIZMG/9OHrTYChljbPphj6Y=; b=qS0oEPROpdtd30j4wt/sWt5JJ
        JIVyqpXqJuYhPkSKPrEeNnqDwKnSKGkfKI3NGRLRmY0aM+qoqWOFziQ4h0akMFFQEVxqGUTesJ13v
        Pv7mOoascFQElvfKuowCL80LRlxqodIk7PErJ2VSSBmI7ltncfTn7/n9kqReTPZv9f92l/BOyZvKz
        KlE3jbB1/xJdhRKvE+ANa1PS6mASvptBGoSD5MKGmXO/4yrJMdLB0UNsJTvKuRFH+IyOjJhszUBRh
        bMlPYmwhx/SkzAKgxMsR1jc5poZAxMMR4bQlnAReFR9pyYwUG3lwRgLgJhv7cCpH0pEeLkCHm9L2f
        ZU1pVlPOA==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvmd5-0006Sf-9b; Mon, 18 Feb 2019 17:22:55 +0000
Date:   Mon, 18 Feb 2019 14:22:52 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sean Young <sean@mess.org>
Cc:     linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v5.1] RC fixes
Message-ID: <20190218142244.0021a263@coco.lan>
In-Reply-To: <20190208221521.77vwne4szl4f4qp3@gofer.mess.org>
References: <20190208221521.77vwne4szl4f4qp3@gofer.mess.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 8 Feb 2019 22:15:22 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> Here are the last RC fixes for 5.1.
> 
> Thanks,
> 
> Sean
> 
> The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:
> 
>   media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/syoung/media_tree.git for-v5.1b
> 
> for you to fetch changes up to a82c3d00eaee0b18d3fe8e62bdde7e349d72ec97:
> 
>   media: smipcie: add universal ir capability (2019-02-08 21:56:54 +0000)
> 
> ----------------------------------------------------------------
> Matthias Reichl (1):
>       media: rc: ir-rc6-decoder: enable toggle bit for Zotac remotes
> 
> Patrick Lerda (2):
>       media: rc: rcmm decoder and encoder

It is now producing a lot documentation warnings:

$ make SPHINXOPTS="-j5" DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm12 (if the link has no caption the label must precede a section header)      
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm24 (if the link has no caption the label must precede a section header)
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm32 (if the link has no caption the label must precede a section header)
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm12 (if the link has no caption the label must precede a section header)
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm24 (if the link has no caption the label must precede a section header)
Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-proto-rcmm32 (if the link has no caption the label must precede a section header)

Please fix.

Regards,
Mauro


Thanks,
Mauro
