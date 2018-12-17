Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D105BC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1615206A2
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="q3VyqLU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732519AbeLQLz1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:55:27 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39244 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeLQLz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 06:55:26 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id CE0B225B781;
        Mon, 17 Dec 2018 22:55:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1545047724; bh=FEAV32ZyremSmhIDzd38il8icc+NdgNEI+0tlEH7p5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3VyqLU7Rz+rQ9JkKGTAyC7YMSAwtIaRBdt07tYz37G6SHn/cKXnJ49pUW7//YbtI
         92QV9t1zZC2EH0K93RdtJbEyyhqrs5f0Co1pmVAFiqEQusPVNFBayBnihdt2mJKHq8
         6r4IzPeaLp5LwVN+NlGBb4TXFTpOu+/flc0LDLw4=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 334DD94048A; Mon, 17 Dec 2018 12:55:22 +0100 (CET)
Date:   Mon, 17 Dec 2018 12:55:22 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] media: dt-bindings: rcar-vin: Add R8A774C0 support
Message-ID: <20181217115521.3zwxnrqj2eeqykqf@verge.net.au>
References: <1544732519-6956-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544732519-6956-1-git-send-email-fabrizio.castro@bp.renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 08:21:59PM +0000, Fabrizio Castro wrote:
> Add the compatible string for RZ/G2E (a.k.a. R8A774C0) to the list
> of SoCs supported by rcar-vin driver.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

