Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F09C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E34E7208E7
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 18:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544119317;
	bh=d2ZKRZI8+k3vh1Y2JSwaebR12r65Awahzu1cXQtlmN4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Tau/O7x6VbtNeh/Bp0PQRz9f8XWiRXksU1AfBSzYeADl9SgjZHYslPr+P0E+IN25A
	 vfaOxbJTPC/d/L9zhSlW126qELBTBPqW46oKLxYi0/PaOPCgIDwKtLiqFsMWzrULuA
	 YDYakQspc996/ISsSyeheiiXbAkaK3sAJIZxjPpA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E34E7208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbeLFSB4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:01:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:45320 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbeLFSBz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 13:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dZNhpv21+AnQj5uFzauB4VVPAAFlxHyvcsGxaUHIACU=; b=vaPhFD5WMsVvGddX/Vlm4QeUlB
        XwIRogxjKhCWJ17WLyYVaz8AErd7n8vguNH2Wn5OwRoFqJBrf4uPaiH6Qw3XPUoZlAZrjU1Ms4foR
        mRNYM12dNmQ207r5FX6V3vL0QmnV5N9YclHUhqYEU/ph4/5pjAI/8TULQOHZvYFcfv0u0HgiYzkLY
        iXlhrQ44mUhtea0gWNUREfb5DJe5BCL3T7zVGZGABoirPtAAZ4wiqR9SPMMPU0Vvr9q8i0QqHG5kW
        tv4mb9lc59AL5yUaDrHU3RaAdPmsLzCIsopTcXbH13rV/rYYskjE80g40S7j0UKhdIs7+1PT9wkQ0
        EQQjIFOw==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUxyB-0000ZC-EY; Thu, 06 Dec 2018 18:01:51 +0000
Date:   Thu, 6 Dec 2018 16:01:45 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Markus Dobel <markus.dobel@gmx.de>
Cc:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall
 fixes
Message-ID: <20181206160145.2d23ac0e@coco.lan>
In-Reply-To: <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
        <20181205090721.43e7f36c@coco.lan>
        <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
        <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 06 Dec 2018 18:18:23 +0100
Markus Dobel <markus.dobel@gmx.de> escreveu:

> Hi everyone,
> 
> I will try if the hack mentioned fixes the issue for me on the weekend (but I assume, as if effectively removes the function).

It should, but it keeps a few changes. Just want to be sure that what
would be left won't cause issues. If this works, the logic that would
solve Ryzen DMA fixes will be contained into a single point, making
easier to maintain it.

> 
> Just in case this is of interest, I neither have Ryzen nor Intel, but an HP Microserver G7 with an AMD Turion II Neo  N54L, so the machine is more on the slow side. 

Good to know. It would probably worth to check if this Ryzen
bug occors with all versions of it or with just a subset.
I mean: maybe it is only at the first gen or Ryzen and doesn't
affect Ryzen 2 (or vice versa).

The PCI quirks logic will likely need to detect the PCI ID of
the memory controllers found at the buggy CPUs, in order to enable
the quirk only for the affected ones.

It could be worth talking with AMD people in order to be sure about
the differences at the DMA engine side.

Thanks,
Mauro
