Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABE4C37122
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0CA82085A
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548118171;
	bh=/JjBKEIbRxncMOTLRkJnucHjbJzuiTUBp0mnbToRkgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jUlUuScC4+lZmUy8bkTNIxSq/QKKQXyRjKl1MlnzskShBN1wcLr6fg8XZ6I2EF65C
	 9mfETxlMEowW1kUCAcIla8cr3giKi9hNZvzWTWY0TdNYPTcyqoCIyOBkDtBCEkTnLy
	 rz8UmwGwCPAbKfiF3chC0QT+L9WvrJmw9AT4ImLQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfAVAtb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 19:49:31 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36964 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfAVAta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 19:49:30 -0500
Received: by mail-oi1-f193.google.com with SMTP id y23so16044791oia.4;
        Mon, 21 Jan 2019 16:49:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GK1M7ZLRzfjVuxsLvZ27kbQ7/+tFZcSW6FfgmMIT5ZU=;
        b=iK4z2aif0RyaK62n9sDczHUvY5ugdIBacKUq6v1gIeeHne7GXa1vcMXzrPMDmyHjDR
         MfYV2PlHigKWG2DzqgHLvzFq0lD5VaPuxtrK3wcVTVxnZS3Zwy2hgiUQgotH0TpenpFf
         92gJcaN69AM1T4smnVS5NQY4fgdOashQVCsiW2oMfsGm/LYuiCD3/wZG9K8OTJo5yJjO
         WqmbF6ERNwulK2Mc/F7XPisb4FrDOow1F+46BlsFRhgHIBDzet2icqIVtCHXbnThtzo1
         qrLE2gPhzITSW5h1BvotgyDN0TQdedJ/AnBQG1FLV+PN85igQ4H6APg0hto9evPweA/m
         t6Pw==
X-Gm-Message-State: AJcUuke3EUUvvrAlPMN0EjqxJ8x8v0DuIbgcz0sFMHqBY2uYVHdYKhIv
        nWrUDUx0wRSq9Uq5ZhoHgQ==
X-Google-Smtp-Source: ALg8bN6EJF7NDc2qizWaNYDm7ZLZulkbSKUk3l5f4HKVmQ6Eie3LMys6CtdjbPwKJRyrxHAeFPun+w==
X-Received: by 2002:aca:401:: with SMTP id 1mr6791963oie.335.1548118170007;
        Mon, 21 Jan 2019 16:49:30 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x4sm6160207otk.37.2019.01.21.16.49.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Jan 2019 16:49:29 -0800 (PST)
Date:   Mon, 21 Jan 2019 18:49:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     frowand.list@gmail.com, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH RESEND] media: s5p-mfc: Fix memdev DMA configuration
Message-ID: <20190122004928.GA26160@bogus>
References: <4235afdd39766f11a3bf4c8daa0d1f4e6a1cd6dc.1547476835.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4235afdd39766f11a3bf4c8daa0d1f4e6a1cd6dc.1547476835.git.robin.murphy@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 14, 2019 at 03:14:14PM +0000, Robin Murphy wrote:
> Having of_reserved_mem_device_init() forcibly reconfigure DMA for all
> callers, potentially overriding the work done by a bus-specific
> .dma_configure method earlier, is at best a bad idea and at worst
> actively harmful. If drivers really need virtual devices to own
> dma-coherent memory, they should explicitly configure those devices
> based on the appropriate firmware node as they create them.
> 
> It looks like the only driver not passing in a proper OF platform device
> is s5p-mfc, so move the rogue of_dma_configure() call into that driver
> where it logically belongs.
> 
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
> 
> Hi Rob, Frank,
> 
> Bit of an old one bit it's rebased cleanly - Mauro reckoned[1] this
> would suit the OF tree better than media, are you happy to pick it up?

Applied.

Rob
