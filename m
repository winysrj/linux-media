Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8F1C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C94E20880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfBTVdN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:33:13 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45944 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbfBTVdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 16:33:13 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 54769634C7B;
        Wed, 20 Feb 2019 23:33:03 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gwZUG-0000Uf-1t; Wed, 20 Feb 2019 23:33:04 +0200
Date:   Wed, 20 Feb 2019 23:33:03 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 0/7] Compound controls and controls reset support
Message-ID: <20190220213303.xg6ecvlxvbevdouj@valkosipuli.retiisi.org.uk>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Feb 20, 2019 at 02:51:16PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> This patch series implements support for compound controls in yavta,
> including the ability to reset controls to their default value. Only
> array compound controls are supported for now, other types may be added
> later.
> 
> The patches have lived out of the master branch for long enough, it's
> time to get them merged.
> 
> Kieran Bingham (1):
>   Add support to reset device controls
> 
> Laurent Pinchart (6):
>   yavta: Refactor video_list_controls()
>   Implement VIDIOC_QUERY_EXT_CTRL support
>   Implement compound control get support
>   Implement compound control set support
>   Support setting control from values stored in a file
>   Remove unneeded conditional compilation for old V4L2 API versions
> 
>  yavta.c | 602 +++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 464 insertions(+), 138 deletions(-)
> 

After ruminating the review comments which may lead to changes in the
patches, please add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
