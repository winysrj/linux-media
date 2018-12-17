Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3CFC43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F26206A2
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 11:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="sIXklN1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbeLQL4j (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:56:39 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39341 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732415AbeLQL4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 06:56:38 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id B70A925B781;
        Mon, 17 Dec 2018 22:56:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1545047796; bh=g0jTqRS2boOGanJFfbr7smdRwESdv2eaCF3QN75Uz3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIXklN1MY+SLOfDfZXU0Or+nFURbL8k97DOU0lYRcLz5LS0T5ACeI8yP77hbELdhr
         dNKapmCKSrEA0ILDd5pMwgUrGFXKVSgItKNuBO6IgIoa/0Pjx10fzqiNou+Wq69mqB
         7r8eRI2VwtLo6632iz3nrqcQtp+L0awPdWPTyzU0=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 1E39A94048A; Mon, 17 Dec 2018 12:56:34 +0100 (CET)
Date:   Mon, 17 Dec 2018 12:56:34 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] [media] v4l: vsp1: Add RZ/G support
Message-ID: <20181217115633.bt2da7mwktz2tds4@verge.net.au>
References: <1544732424-6498-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544732424-6498-1-git-send-email-fabrizio.castro@bp.renesas.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 13, 2018 at 08:20:24PM +0000, Fabrizio Castro wrote:
> Document RZ/G1 and RZ/G2 support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

