Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABCCC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410F920851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544735742;
	bh=mLHWUYRWpoHWdm/8c3vOvL9LCL11DSJwExaEP6BwDgg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=XCKqZLb5DuHa/zGnDQaAvDoRByYS13fy4rWucBHofX44hHd7kl4GBfBJpeZ/Z4xVq
	 dyJavXH3lSUjH0m8W9YSzVQXJs0OCAqLMvbDwAf7zYUbGPJh9UsnAzN0RVEG8If+/e
	 tmSm5JlxXNrVArdpzyxC90cYRmQOvcE1JAAQAhiQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 410F920851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbeLMVPg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbeLMVPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 16:15:02 -0500
Subject: Re: [GIT PULL for v4.20-rc7] media fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544735702;
        bh=mLHWUYRWpoHWdm/8c3vOvL9LCL11DSJwExaEP6BwDgg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=k2hItOPtUB/EVtniyTU+yQdmHtmG9S2Noonur255p0h/bW+lDC+jQfA0c56ValOKj
         tuWlg5gDA+Tzo/dtLzR6WkFwhuZaQpbdWXibEhR7PgCcj4H9tB1WJM7Nbg0+yG0IiI
         +wTVWK7Cw+ah76OH8rr2pNr4eY+oqFM3XaGPbDmw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20181212135403.3ce9132a@coco.lan>
References: <20181212135403.3ce9132a@coco.lan>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20181212135403.3ce9132a@coco.lan>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
 tags/media/v4.20-5
X-PR-Tracked-Commit-Id: 078ab3ea2c3bb69cb989d52346fefa1246055e5b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 14a996c383129525e55bab07e4857d08f6b61dda
Message-Id: <20181213211502.3163.62324.pr-tracker-bot@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Thu, 13 Dec 2018 21:15:02 +0000
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

The pull request you sent on Wed, 12 Dec 2018 13:54:03 -0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.20-5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/14a996c383129525e55bab07e4857d08f6b61dda

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
