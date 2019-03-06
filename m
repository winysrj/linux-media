Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D083C10F0C
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 12:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E827F20652
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 12:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="KLQUdtXN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfCFMwa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 07:52:30 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:53303 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729116AbfCFMw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 07:52:29 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 36CEB25B7D0;
        Wed,  6 Mar 2019 23:52:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1551876747; bh=x43/I+7YySGKIP/4BpstXlNy3c8IDVOz3kcXyItBhKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLQUdtXNzPKy9WCkfq5cD3tEKYLMNgpzaHvHqtmBYbpuPK6a2Wf+2oaFrlPHaSAMQ
         VLsUAPxCTzLQ+GQJcmWvnYAppYAch7oxNH4giZTuqJpc4anL9rWAJ8cMRJCAwKpV2V
         akftHzLCWlFn0tbGf8dHRuuYaIKmFYB6NJQXaQf4=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id A60F194030D; Wed,  6 Mar 2019 13:52:25 +0100 (CET)
Date:   Wed, 6 Mar 2019 13:52:25 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: rcar_drif: Remove devm_ioremap_resource()
 error printing
Message-ID: <20190306125225.grmx6vn262d5wck4@verge.net.au>
References: <20190301093831.11106-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301093831.11106-1-geert+renesas@glider.be>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 01, 2019 at 10:38:31AM +0100, Geert Uytterhoeven wrote:
> devm_ioremap_resource() already prints an error message on failure, so
> there is no need to repeat that.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Drop assignment to ret.

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

