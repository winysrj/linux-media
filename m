Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD2FC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F9C20672
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F9C20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbeLJVKU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 16:10:20 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59350 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727143AbeLJVKU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 16:10:20 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id F1E4D634C7F
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 23:10:14 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gWSog-0000MA-Vz
        for linux-media@vger.kernel.org; Mon, 10 Dec 2018 23:10:15 +0200
Date:   Mon, 10 Dec 2018 23:10:14 +0200
From:   sakari.ailus@iki.fi
To:     linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.20] META_OUTPUT buffer type and the ipu3 staging
 driver
Message-ID: <20181210211014.vphdcxetrxzv3kds@valkosipuli.retiisi.org.uk>
References: <20181210210843.wsh5y2l6g5f462cz@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210210843.wsh5y2l6g5f462cz@valkosipuli.retiisi.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 11:08:43PM +0200, sakari.ailus@iki.fi wrote:
> Hi Mauro,
> 
> Here's the ipu3 staging driver plus the META_OUTPUT buffer type needed to
> pass the parameters for the device. If you think this there's still time to
> get this to 4.20, then please pull. The non-staging patches have been
> around for more than half a year and they're relatively simple.

s/4\.20/4.21/g

-- 
Sakari Ailus
