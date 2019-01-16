Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840E8C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 21:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4700720675
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 21:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547672888;
	bh=JnhI2kRI6a3h2TPGoO3yFz46WlXijkjKTcON88NSSVU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=19dfPEOIneC0Se40H5sWacHgRfMMMcope+fjtXCbr4jRRTGkki5kXFAH4+O9om7tZ
	 auiuFL6byzBpaXu7/oFQHecPnlOUm8pzoAoRf8z2OZ4MkDL9OIKDPGr455vs13WqH/
	 j5uXXO0pfkjkjdudy3LQ/0aTp8PjoIWzbUAfRIpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfAPVIH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 16:08:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:53152 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfAPVIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 16:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UH3L1kN3UUplQwxEjb9uhd09L+0/+8111jylKGL0RMo=; b=WffmOYWVOYXxCZUFEmmt9JiX6j
        hs8iWqKbzINSibZSeFm7ucHCNNADuQ2J5JtGZeHnLq7unYVtLfrVVTAoguFgqRryp6NIo4JJR1Cfo
        KnAF+lXxzakszj7de/9BjWEPLtK/1kxAOiv4SzkT4YOJC4AwTuDHEkMHn4+ki4hxglPcu4iLKs3tU
        n05U+CywihcvwuA8nQE3T94wrhwPDx8JaxUqhjWKzq9dmh9XP6h3cdIcatoQEj/NCxv9NlpqVWrAg
        3F7cfYm75vuvQWft8vrbI5kavH33cJ1VYd9wV3JWVYN2t/UMYm9xh43N4gb4BSQogvZoysBOXp64w
        /YXikrVA==;
Received: from [186.213.247.186] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjsPt-0007cd-SO; Wed, 16 Jan 2019 21:08:06 +0000
Date:   Wed, 16 Jan 2019 19:08:02 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: [PATCH zbar 1/1] v4l2: add fallback for systems without
 V4L2_CTRL_WHICH_CUR_VAL
Message-ID: <20190116190802.05dbffa5@coco.lan>
In-Reply-To: <CADvTj4q=6mYR0Fo3e2Met9yNxmyy8z_a7bbzxfgPMY63ZF4g1A@mail.gmail.com>
References: <1547616190-24085-1-git-send-email-james.hilliard1@gmail.com>
        <20190116122409.0968a154@coco.lan>
        <CADvTj4q=6mYR0Fo3e2Met9yNxmyy8z_a7bbzxfgPMY63ZF4g1A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 16 Jan 2019 13:34:29 -0700
James Hilliard <james.hilliard1@gmail.com> escreveu:

> > See the enclosed patch. I tested it here with Kernel 4.20 and works
> > fine.  
> I'll test it on the system I had which needed the fallback.

Ok. Please let me know once you test it.


Thanks,
Mauro
