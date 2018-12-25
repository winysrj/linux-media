Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E402EC43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0EB2218D4
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545780132;
	bh=jF+lFl1UQ9Tadveyg0x4e4wsY9qfwFEaDafHmOEm578=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=LSQYfXXV8t+AgsSfBLRQUdjzRdM7Xso4AtRba4kfvfrw7J5xPjmlr6g2q98+U87jl
	 HIM5tgzr/TZleST34Vuk3GHxtLqi0pIxo94S7ESeFgor+SwH+MeCiXKccyW0YGpeVy
	 5J8I7DDbeoAZ39/ZlABb8GnGuT6DSMbDVCen2+Mk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeLYXWE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 18:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbeLYXUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 18:20:04 -0500
Subject: Re: [GIT PULL for v4.21] First part of media patches
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545780004;
        bh=jF+lFl1UQ9Tadveyg0x4e4wsY9qfwFEaDafHmOEm578=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tIhlibb3sq/wJtNsKKY8h2sN+5eAl0u4J1FVdltJw91fPQobdduu+3XzVJtt2Yiqq
         bICxxBaioERPQHbQEHvSa5QiA5XaDnjk9s8bEh5r/penQqKDgxcUDowgCr4Aix3qqn
         jvHhG7QwZ2mLu81KN+9I5Pt+rP7xi3CmCah78iPg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20181220103223.3b5c64da@coco.lan>
References: <20181220103223.3b5c64da@coco.lan>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20181220103223.3b5c64da@coco.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
 tags/media/v4.20-6
X-PR-Tracked-Commit-Id: 4bd46aa0353e022c2401a258e93b107880a66533
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5813540b584c3b1a507d1c61896bec164cad0905
Message-Id: <20181225232003.23808.13653.pr-tracker-bot@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Tue, 25 Dec 2018 23:20:03 +0000
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

The pull request you sent on Thu, 20 Dec 2018 10:32:23 -0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5813540b584c3b1a507d1c61896bec164cad0905

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
