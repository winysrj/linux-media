Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FABC43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 11:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4FC520657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 11:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfAOLZ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:25:57 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41940 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727626AbfAOLZ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 06:25:57 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3CD4B634C88;
        Tue, 15 Jan 2019 13:24:14 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gjMpJ-0004Lb-Di; Tue, 15 Jan 2019 13:24:13 +0200
Date:   Tue, 15 Jan 2019 13:24:13 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] ov7670 fixes
Message-ID: <20190115112413.yvwikkeoiynmsuh7@valkosipuli.retiisi.org.uk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
 <20190115104011.irtgbp6iaw6cocgq@valkosipuli.retiisi.org.uk>
 <23ea680af226991402a30dd02bacb1dce0c998f8.camel@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23ea680af226991402a30dd02bacb1dce0c998f8.camel@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 15, 2019 at 12:12:56PM +0100, Lubomir Rintel wrote:
> On Tue, 2019-01-15 at 12:40 +0200, Sakari Ailus wrote:
> > On Tue, Jan 15, 2019 at 09:54:43AM +0100, Lubomir Rintel wrote:
> > > Hi,
> > > 
> > > here are the ov7670 patches originally from the "media: make Marvell camera
> > > work on DT-based OLPC XO-1.75" updated to apply cleanly on top of
> > > <git://linuxtv.org/sailus/media_tree.git> master as requested.
> > > 
> > > I've also added "ov7670: Remove useless use of a ret variable" with my Ack
> > > slapped on it.
> > 
> > Hi Lubomir,
> > 
> > It seems the end result compiles but the intermedia patches do not. Could
> > you resend, please? I'll replace the patches in my tree with a new version
> > then...
> 
> Seems like the order got messed up. It should be sufficient to reorder
> the patches like this:
> 
> pick f42ae764598a ov7670: Remove useless use of a ret variable
> pick 5be2efe0e5bb media: ov7670: split register setting from set_fmt() logic
> pick 38eed963866e media: ov7670: split register setting from set_framerate() logic
> pick 97be3c31de46 media: ov7670: hook s_power onto v4l2 core
> pick 56c292d92642 media: ov7670: control clock along with power
> 
> (With "git rebase -i 87680151c22eee5b3bb6361fb8d18d765a9d8aff")

Oh well. Done; let's see if that works better...

-- 
Sakari Ailus
