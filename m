Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752F0C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 19:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44232206B7
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546888975;
	bh=Y5ZyZXNGTfo1ShUnlqO7DpRMWny3zxbC7w9mgnf8JDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=vi+FF85J1dm9eTvCMOAYxZCWTTQu87jgwY5BODVx9TiYVwRbBPedc3NHi9nQlHOW+
	 vIp2mS23v6VaEUZIWrRfFZk0/ZWTFd7o31BZra0yO4f9IpQ3BFK7zzFakXBvHDMPBH
	 kWFmeBcLUDbMxPc2f6nI6IG6tVh75jIDL4LuRdfI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfAGTWu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 14:22:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:53060 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfAGTWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 14:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mwyvS9cqn7ZB0uWlHM0yyy2cALvoq6rpMi4xORDK6Qg=; b=Lx4SnL7IX5fTfVVePhaL71km6R
        u8m5rav4apiQj7APLkmFPbpEyK1j6FCLixk5fnCtPBqArUbfXZFRA5aacvofYozb5j3GnyW7+OXyN
        pJ7TA3zVTA++yGpXl4ZOosTw6X/ueNGodlOSIT91HyKTSLbdywV3dq+I1tcxNNsXhPnqL0qRUmvhZ
        tVIC1p7+yh9VPLz1a1MEWqMWA/arFCJkraXTQ+pDlcFGOR0M9yI1zyhHAgf1LI2TIDqLrn3Mf0aQM
        0dt4Ed7UYNsY7f0c2uuZH6MZMqPBkzHNPOUjWg0TH6m+qIhw21jEzC707yMx/npeUHx9gFMsZJW2+
        uUx3K0Gg==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggaTr-00023B-Kq; Mon, 07 Jan 2019 19:22:36 +0000
Date:   Mon, 7 Jan 2019 17:22:31 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: drx: fix a missing check of return value
Message-ID: <20190107172231.49b549db@coco.lan>
In-Reply-To: <20181220065747.40379-1-kjlu@umn.edu>
References: <20181220065747.40379-1-kjlu@umn.edu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 20 Dec 2018 00:57:44 -0600
Kangjie Lu <kjlu@umn.edu> escreveu:

> Function drxj_dap_write_reg16(), which writes data to buffer, may fail.
> We need to check if it fails, and if so, we should goto error.

Did you test this on a real hardware? This kind of patch has a potential 
of breaking things, as, on some drivers, some writes may return error.

For example, when called on early stages, a write may fail because
the firmware was not loaded yet. So, a change like that should be
carefully tested with real hardware.

> Otherwise, the buffer will have incorrect data.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/dvb-frontends/drx39xyj/drxj.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> index 551b7d65fa66..d105125bc1c3 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
> +++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> @@ -2136,9 +2136,13 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
>  
>  			word = ((u16) data[2 * i]);
>  			word += (((u16) data[(2 * i) + 1]) << 8);
> -			drxj_dap_write_reg16(dev_addr,
> +			rc = drxj_dap_write_reg16(dev_addr,
>  					     (DRXJ_HI_ATOMIC_BUF_START + i),
>  					    word, 0);
> +			if (rc) {
> +				pr_err("error %d\n", rc);
> +				goto rw_error;
> +			}
>  		}
>  	}
>  



Thanks,
Mauro
