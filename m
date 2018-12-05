Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A09C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CCF120661
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q5xsxagW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CCF120661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLELH1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:07:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:57128 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbeLELH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 06:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7MDYh0sR8WnT47ofWA6ycdZUj4Avp7efKxtqc6ee2jA=; b=Q5xsxagW+b4ghx5xX3wZvM9d5b
        HFJcXJsYZi/xMCjuWomBqj6eFbiikEqerhGSnmvPZrtccqUAeJi1drRMsc9Ave+82SoTPsCBVtlzo
        qYrh07IWPOG2M7Gyr6P2bhLdR3kWSZlUFvAyStmHJ1qp/ld5m0KujGXbC+vl1GDDsWCQ/8z3U1Mzj
        bRAB9cIXtINd5z8C+MosR7ZpXrSmctbieBLAMdqGtc+OU8mUXG/mGRu0htNF1Lzwkf1tzBuExsARl
        NaWXMprBTldztSUmWHDlFkICB0HDIV2Yl3ko7JlMMRN13om1JLaOPLcVc/CiMUwQnmoYcclvP1/2y
        vZ51DY9A==;
Received: from [191.33.148.129] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUV1Y-0002io-VZ; Wed, 05 Dec 2018 11:07:25 +0000
Date:   Wed, 5 Dec 2018 09:07:21 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Markus Dobel <markus.dobel@gmx.de>,
        Brad Love <brad@nextdimension.cc>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall
 fixes
Message-ID: <20181205090721.43e7f36c@coco.lan>
In-Reply-To: <3d7393a6287db137a69c4d05785522d5@gmx.de>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sun, 21 Oct 2018 15:45:39 +0200
Markus Dobel <markus.dobel@gmx.de> escreveu:

> The original commit (the one reverted in this patch) introduced a 
> regression,
> making a previously flawless adapter unresponsive after running a few 
> hours
> to days. Since I never experienced the problems that the original commit 
> is
> supposed to fix, I propose to revert the change until a regression-free
> variant is found.
> 
> Before submitting this, I've been running a system 24x7 with this revert 
> for
> several weeks now, and it's running stable again.
> 
> It's not a pure revert, as the original commit does not revert cleanly
> anymore due to other changes, but content-wise it is.
> 
> Signed-off-by: Markus Dobel <markus.dobel@gmx.de>
> ---
>   drivers/media/pci/cx23885/cx23885-core.c | 60 ------------------------
>   drivers/media/pci/cx23885/cx23885-reg.h  | 14 ------
>   2 files changed, 74 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c 
> b/drivers/media/pci/cx23885/cx23885-core.c
> index 39804d830305..606f6fc0e68b 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -601,25 +601,6 @@ static void cx23885_risc_disasm(struct 
> cx23885_tsport *port,

Patch was mangled by your e-mailer: it broke longer lines, causing
it to not apply.

Also, before just reverting the entire thing, could you please check
if the enclosed hack would solve it?

If so, it should be easy to add a quirk at drivers/pci/quirks.c
in order to detect the Ryzen models with a bad DMA engine that
require periodic resets, and then make cx23885 to use it.

We did similar tricks before with some broken DMA engines, at
the time we had overlay support on drivers and AMD controllers
didn't support PCI2PCI DMA transfers.

Brad,

Could you please address this issue?


diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 39804d830305..8b012bee6b32 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -603,8 +603,14 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 
 static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
 {
-	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
-	uint32_t reg2_val = cx_read(TC_REQ_SET);
+	uint32_t reg1_val, reg2_val;
+
+	/* TODO: check for Ryzen quirk */
+	if (1)
+		return;
+
+	reg1_val = cx_read(TC_REQ); /* read-only */
+	reg2_val = cx_read(TC_REQ_SET);
 
 	if (reg1_val && reg2_val) {
 		cx_write(TC_REQ, reg1_val);



Thanks,
Mauro
