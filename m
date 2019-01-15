Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265E9C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 10:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F064C20651
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 10:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfAOKly (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 05:41:54 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41670 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728949AbfAOKly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 05:41:54 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 25EE8634C88;
        Tue, 15 Jan 2019 12:40:12 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gjM8h-0004LR-Go; Tue, 15 Jan 2019 12:40:11 +0200
Date:   Tue, 15 Jan 2019 12:40:11 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] ov7670 fixes
Message-ID: <20190115104011.irtgbp6iaw6cocgq@valkosipuli.retiisi.org.uk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 09:54:43AM +0100, Lubomir Rintel wrote:
> Hi,
> 
> here are the ov7670 patches originally from the "media: make Marvell camera
> work on DT-based OLPC XO-1.75" updated to apply cleanly on top of
> <git://linuxtv.org/sailus/media_tree.git> master as requested.
> 
> I've also added "ov7670: Remove useless use of a ret variable" with my Ack
> slapped on it.

Hi Lubomir,

It seems the end result compiles but the intermedia patches do not. Could
you resend, please? I'll replace the patches in my tree with a new version
then...

Thanks.

-- 
Sakari Ailus
