Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625D5C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D06A2145D
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="hJmJ2ARm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbeLQL4Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:56:25 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39318 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeLQL4Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 06:56:24 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id AC08225B781;
        Mon, 17 Dec 2018 22:56:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1545047782; bh=TTtvlQrUUfhzqjLxPFnFnAyi/cZyM4/Puz7aY3i+YIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJmJ2ARm7GEVAt74tTbABu4VNX02gSxk9sJIJdqpPWjTqKdbrpoj1b61v+CeP7XxG
         W9s7U62Pyy8enGbQ0dVbZwbnpY9hTs90Cpong2xDpHzx2E/fjMkbmiorC/Om0MtJqD
         CuTHOyh/G3yIuq1hGpowh3uN7YSdFB6/MHwpa2Mo=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 0F6B194048A; Mon, 17 Dec 2018 12:56:20 +0100 (CET)
Date:   Mon, 17 Dec 2018 12:56:20 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] dt-bindings: media: renesas-fcp: Add RZ/G2 support
Message-ID: <20181217115619.4vtyrz46dpkug4bw@verge.net.au>
References: <1544732433-6543-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544732433-6543-1-git-send-email-fabrizio.castro@bp.renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 08:20:33PM +0000, Fabrizio Castro wrote:
> Document RZ/G2 support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

