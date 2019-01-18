Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBEEC5AC81
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E93120883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547840418;
	bh=A9XRN1LCXBbOdkRSu7vhn6YKOXqzDlg0P9y9NKUTBco=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=OuOe9m2zgjTUWpxgtqCfXk/jpGGOujdJff3/yL/1SoVpnbOPR6c6RsP7C6D03t2xs
	 EDkK5aoo6py29CWJBEeb+wevVGI2Zfo9yG9lCYUpRCwoneiKpZqh9ZtEpyZ5/nKmpY
	 GE7ZZw9aQgn2bNrBhsiSVyH9ZIJxqKx4vIBFJrX4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfARTkC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbfARTkC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 14:40:02 -0500
Subject: Re: [GIT PULL for v5.0-rc3] media fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547840401;
        bh=A9XRN1LCXBbOdkRSu7vhn6YKOXqzDlg0P9y9NKUTBco=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=NcvS2sn4O47Wvo/truoQwKVr5F2fu8WUX5zGY+XRz80IcAqLGQH/6OoVlrbiBpNYG
         DHztSmY6Q7G82ePm3POkkT+jZEIuGe+hfnpYmnWcsPkNnaNbYD0GPnPKCpTsvQG3oi
         5uMTwErhKmiKPguvGmLcB88hsaWoMiQ4c/rWjXcQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190118154058.12fda86a@coco.lan>
References: <20190118154058.12fda86a@coco.lan>
X-PR-Tracked-List-Id: <linux-media.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190118154058.12fda86a@coco.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
 tags/media/v5.0-1
X-PR-Tracked-Commit-Id: 240809ef6630a4ce57c273c2d79ffb657cd361eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2339e91d0e6609e17943a0ab3c3c8c4044760c05
Message-Id: <154784040181.4383.16580329241740474447.pr-tracker-bot@kernel.org>
Date:   Fri, 18 Jan 2019 19:40:01 +0000
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The pull request you sent on Fri, 18 Jan 2019 15:40:58 -0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v5.0-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2339e91d0e6609e17943a0ab3c3c8c4044760c05

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
