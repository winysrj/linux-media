Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EAEC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B55CC206A2
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="Aj285EGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbeLQLzu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:55:50 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39267 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeLQLzu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 06:55:50 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 8C75025B781;
        Mon, 17 Dec 2018 22:55:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1545047747; bh=vq8NldczZVWLMHFqhcjbvbskunLZIu+ZtZ2sgIAy2e8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Aj285EGYcu3Pm/k2WhC826970j1gZv9Kz2FQSIRMOmbd/lDvp4Pz6sQNbSUuwDoMB
         nBs1FFa0ElHaOF8shIIF8akq3D40JKTSvhtL3z+4PDr3sbOz/q447TbjlDX9IXBYjX
         SKZI9TEKeru4VggmrE/0WT48LVA6jjKsQC0MgZvU=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id F0B6194048A; Mon, 17 Dec 2018 12:55:45 +0100 (CET)
Date:   Mon, 17 Dec 2018 12:55:45 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] media: rcar-vin: Add support for RZ/G2E
Message-ID: <20181217115545.j3f32qwy2cn63ve5@verge.net.au>
References: <1544732644-7414-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544732644-7414-1-git-send-email-fabrizio.castro@bp.renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 08:24:04PM +0000, Fabrizio Castro wrote:
> According to the RZ/G2 User's manual, RZ/G2E and R-Car E3 VIN
> blocks are identical, therefore use R-Car E3 definitions to add
> RZ/G2E support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

