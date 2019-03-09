Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EB1C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 23:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DC120836
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552173304;
	bh=ZIUe67urjoMoOYYLOICWn3hVqLkdu1u3IdUbLNIX4is=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IbP+0DQjSgQ9x4ycR5IPVtJ67ZZ467+TuvSDXls3a4yknqNnoqQdxbXZN9XB4QsR5
	 m85CwNbnaN2nrB6GKD3KynCOPCS4/0G9O5sXPGudA8hcaSQqTu3IuidZGKok021Vqn
	 3AMsvRXC4DgKAVNKDnB7e5N0Z+1Waez3jgU4DxTM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfCIXPD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 18:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfCIXPD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Mar 2019 18:15:03 -0500
Subject: Re: [GIT PULL for v5.1-rc1] media updates
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552173302;
        bh=ZIUe67urjoMoOYYLOICWn3hVqLkdu1u3IdUbLNIX4is=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=l5oa5lvBeP4cN6QiqM/z3AEDGUOLkIavRXNcpW773VaglnAo+L+EtDzDItIp9taf3
         BygmlYGpfM3HIbxkeqSyz21naSrZX4bRbYcH7zQPokviQjgG8JKlMIlEM//ISDGBPY
         DNxR2Ty04BKfK86sjdC90IwZDbDFBvXl5eI5wTm4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190307132408.4ed36d21@coco.lan>
References: <20190307132408.4ed36d21@coco.lan>
X-PR-Tracked-List-Id: <linux-media.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190307132408.4ed36d21@coco.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
 media/v5.1-1
X-PR-Tracked-Commit-Id: 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 96a6de1a541c86e9e67b9c310c14db4099bd1cbc
Message-Id: <155217330289.3273.13236251891131795934.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Mar 2019 23:15:02 +0000
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

The pull request you sent on Thu, 7 Mar 2019 13:24:08 -0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v5.1-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/96a6de1a541c86e9e67b9c310c14db4099bd1cbc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
