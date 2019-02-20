Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A486DC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F98A2086C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfBTVeh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:34:37 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45956 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726070AbfBTVeh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 16:34:37 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id AC182634C7D;
        Wed, 20 Feb 2019 23:34:27 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gwZVc-0000Uo-Ds; Wed, 20 Feb 2019 23:34:28 +0200
Date:   Wed, 20 Feb 2019 23:34:28 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 0/3] Fixes for compound control support
Message-ID: <20190220213428.osyghernh5drqo7x@valkosipuli.retiisi.org.uk>
References: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 05:19:49PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> This small series fixes issues in yavta reported during the review of
> the compound control support patches.
> 
> Laurent Pinchart (3):
>   Fix emulation of old API for string controls
>   Print numerical control type for unsupported types
>   Fix control array parsing
> 
>  yavta.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 

Oh my. Aren't you planning to send v2 that would address the comments?

That said, the changes seem fine to me.

-- 
Sakari Ailus
