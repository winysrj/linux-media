Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CFFC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93CE520821
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 11:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="BcoIZH/Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93CE520821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=verge.net.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbeLJLzB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:55:01 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41422 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbeLJLzA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 06:55:00 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 05C9A25BE5E;
        Mon, 10 Dec 2018 22:54:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1544442898; bh=mZcT670a1SIliLzOl42VJtYF4g5CB/NCNvcLwtUbS2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BcoIZH/ZCVmBrIZ2f2hw8S/GSbUHb/XTNUJfO/Z5ZKCCapWJKds52oqcH1suFd7ck
         4yoobQNP+0mXFRd5flOzz4zODbIBP1qyD9PoOejE0BkZK//r4BJhJRlNYLWZ9ftvDj
         0I6oj/eYKQir9d5ADhnC8Dfg3csY7J72SwBBgxKQ=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 7F9279402E1; Mon, 10 Dec 2018 12:54:56 +0100 (CET)
Date:   Mon, 10 Dec 2018 12:54:56 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: vsp1: Fix trivial documentation
Message-ID: <20181210115456.wiiox5wr4ju2w4iw@verge.net.au>
References: <20181207163134.14279-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181207163134.14279-1-kieran.bingham+renesas@ideasonboard.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 07, 2018 at 04:31:34PM +0000, Kieran Bingham wrote:
> In the partition sizing the term 'prevents' is inappropriately
> pluralized.  Simplify to 'prevent'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
