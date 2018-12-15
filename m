Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5949BC43612
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 06:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34CAD2171F
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 06:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OG1noszi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbeLOGaW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 01:30:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43558 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbeLOGaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 01:30:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so3847473pfk.10;
        Fri, 14 Dec 2018 22:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tzH4fhsUhl3IHK4OwnrkxhHc5sZa4QDSuGx19nV84pA=;
        b=OG1noszi4jduCQPyVDpRUMYFu2te2FPgwot9XYZiN5/eDaGOxMFEojzMNaAt5mSdKA
         tNk7O3NdwHNKfSHuHkMaYrq8jG586rtmpBPrP7TS8vjXM8PAenMoAK4gA+rwytQTTvhl
         4xkIX4aotww17wQzUpnyllXZd0RPs8cubWs2Xs4qrUOndRo9OC+KFOsLxUzVbnn0S2qc
         Gb7J2YATK+/BWv65uwcCG+Hh8bHvXGstt7+1c37iq8LUNAiEyCZTsUmFzdGOhNcfFxOn
         7kgYQS/Z7IiGrmq6nnJQW7qQjMu09NiK6Ow35vuzzgS+eC2D01wrMycAtXi3GVMxE+Lq
         dsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tzH4fhsUhl3IHK4OwnrkxhHc5sZa4QDSuGx19nV84pA=;
        b=SG9TFJFO2gCKAK4auFkCG7oFppDcBfHjeLfAcAf5UBkZzKStmkQv+8axgwzXNwdIWJ
         vVCHMLEYMMYyh595UpKXzZ9TiPj+hvlLODSwfZ3WpBtWb3kKTPYvzedUN04f+GOerBL4
         w5ePM6Lbx8PvE2/GQ5VBksgwHvbyhEYmr1cgct0rAObm0LL2o+iRDSeQ4TGf6YBDWo4f
         1SX5FF3PndWYnu1Rj1dlyino6Fixi/e0EvU4We+MGXdMurAMAoV+xlTLwVIGUUb4mLhS
         qKUd6ycWTb3XrKv6oRNtBxxXxCcsVjx/1Asg2hw42N4Xx8HTQkyrUrIwjU+wBdFZ4kyE
         lUEA==
X-Gm-Message-State: AA+aEWY6Jc/6lCVBJuAnbqftfHcXNc0Mncc/UYTZo4C+bGeyp3tUjlyL
        sCpdi3j8Q91gWi2Kul7PBy0=
X-Google-Smtp-Source: AFSGD/WPuSk6zoP0Mr2OLxGWbsOkqyn/5QK4fc98MSYr3w5jWtgC9IbRRuriXdklsgERbhS+kp96dw==
X-Received: by 2002:a62:5a03:: with SMTP id o3mr5474571pfb.19.1544855420740;
        Fri, 14 Dec 2018 22:30:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m76sm9175311pfi.102.2018.12.14.22.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 22:30:19 -0800 (PST)
Date:   Fri, 14 Dec 2018 22:30:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Christoph Hellwig <hch@lst.de>
Cc:     iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 3/6] sparc: remove the sparc32_dma_ops indirection
Message-ID: <20181215063018.GA11415@roeck-us.net>
References: <20181208174115.16237-1-hch@lst.de>
 <20181208174115.16237-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181208174115.16237-4-hch@lst.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Dec 08, 2018 at 09:41:12AM -0800, Christoph Hellwig wrote:
> There is no good reason to have a double indirection for the sparc32
> dma ops, so remove the sparc32_dma_ops and define separate dma_map_ops
> instance for the different IOMMU types.
> 

Except maybe this:

scsi host0: esp
scsi host0: Data transfer overflow.
scsi host0: cur_residue[0] tot_residue[-36] len[36]
scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
scsi target0:0:0: Beginning Domain Validation
scsi host0: Data transfer overflow.
scsi host0: cur_residue[0] tot_residue[-36] len[36]
scsi host0: Data transfer overflow.
scsi host0: cur_residue[0] tot_residue[-36] len[36]
scsi host0: Data transfer overflow.
scsi host0: cur_residue[0] tot_residue[-36] len[36]
scsi host0: Data transfer overflow.
scsi host0: cur_residue[0] tot_residue[-36] len[36]

and so on, until qemu is terminated. This is seen with all sparc32
qemu emulations. Reverting the patch fixes the problem.

Guenter
