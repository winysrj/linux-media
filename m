Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1997C43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB60218D4
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545780121;
	bh=I0qb+lRWnkGc3cVigpRknHkag/q2dHz6WOogLTd2ETI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=OIdXIzEFvYc1QXcsw4n80dsMq8mrwbRbxvUL4S7ZMZJhe7xgCH6wGgxy4/A3AComK
	 RzIOfLbZnVjy2BvKxApOOuTnWE+mRpCITy3VVvvLXQ/aqOugh5o782WfU6Z2T2tjWp
	 fBmDKO+eMcNWDtE/yyFLuaR2143scdCExA0mnOFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbeLYXVx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 18:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbeLYXUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 18:20:04 -0500
Subject: Re: [GIT PULL for v4.21] second set of media patches: ipu3 driver
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545780004;
        bh=I0qb+lRWnkGc3cVigpRknHkag/q2dHz6WOogLTd2ETI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=rOP88Tq+rw61GwPShjlQ6IRtqTT/dJGcc7ey39ZjTElWpNH0VOaNOCPb4gvscvFQQ
         4/NKjZk8I3UWgAxe1R4zmVFf/Ftc0S1PaUeSm5ktbUNY6opV5Zei+o2ck7JXzoUA3n
         U9jycplKE/iy6i8iIup7G71J4UPxe8H+mUxxOfFk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20181220104544.72ee9203@coco.lan>
References: <20181220104544.72ee9203@coco.lan>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20181220104544.72ee9203@coco.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
 tags/media/v4.20-7
X-PR-Tracked-Commit-Id: 38b11beb73c52bd6fb3920775887fdd1004f2a68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 996680d461f8f759082e64f2395c1f7c25d9d549
Message-Id: <20181225232004.23808.64372.pr-tracker-bot@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Tue, 25 Dec 2018 23:20:04 +0000
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The pull request you sent on Thu, 20 Dec 2018 10:45:44 -0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/996680d461f8f759082e64f2395c1f7c25d9d549

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
