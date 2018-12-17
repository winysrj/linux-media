Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22749C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C9B206A2
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="mRSx/MXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbeLQL4C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:56:02 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39285 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeLQL4C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 06:56:02 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 0D86225B7CF;
        Mon, 17 Dec 2018 22:55:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1545047759; bh=PRrWZDKx4hoaXwnpVH2TcG4h2UydBHkTjmgKDuN4QNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mRSx/MXDtdWr1PVENur18wU6cVymv1zlYJsbCGSDxZ/J8lRZEEZUiLwuPtP2YQfy1
         noIDy7up0DPpyzrffDiT98guSvHVckxKQae4UHRTuyKCAt6VrE3eNGz1HuDmtOKgCr
         C9dmiCrVR9Ocm1itSP6Dq/eDqgV9WqhD3M74jxhE=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 6AB8094048A; Mon, 17 Dec 2018 12:55:57 +0100 (CET)
Date:   Mon, 17 Dec 2018 12:55:57 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] media: rcar-csi2: Add support for RZ/G2E
Message-ID: <20181217115557.rx64uqsb4bc4t53p@verge.net.au>
References: <1544732652-7459-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544732652-7459-1-git-send-email-fabrizio.castro@bp.renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 08:24:12PM +0000, Fabrizio Castro wrote:
> According to the RZ/G2 User's manual, RZ/G2E and R-Car E3 CSI-2
> blocks are identical, therefore use R-Car E3 definitions to add
> RZ/G2E support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

