Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBB6C07EBF
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 17:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB1620883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547833273;
	bh=EneCs9KTwSjiBYmTIPk0sZ/bWAPfYpTjLgRgW/oX4lM=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=d9RBjbP0lV3xvuEDdvNvRZrHpH8kT0T0TXMzXe5cjV6YifxX7VtIx9CPABaWIjCvV
	 8Y5aXL7p+Mtk4krNiRJmFTtlo+KnKjiuy17WWhunF83p8VnV3wUscyMXgC7MS2KgNO
	 LOgkDO33orwGZRV6ReEf5Ye7spWj79DNuwlIcTJc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfARRlH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:41:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:53844 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbfARRlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 12:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ck+8stJAPuL59pFfoIZ5YFiXrfWVwKJM8M57fNVuv1g=; b=esrUyl2QOJl+vRYqlODGkjsclk
        vgISMLeMYS0eSTqT5bXCebM+hq7Q8zk4E6gpjc/Ovp7jOXOlItysuNjGFGSrTtwa37TR6e649QFUE
        WpIq1v/HYr5bpzWm3oYYb8+YosZzhiUvC0w6SsddE9XUoKhoEGDTbF6JYntPZyAlAy04eYy6B+J9c
        RiEPunxGxTHbu7Tnxw1wjGF6frXACfFa5bOE0OrBYqUps2Su5/Tj1saoVeZD7Ywf9X8Y6viy7QIAT
        r6G2ppBzxONJo/uMssWyDKKGk6ZGhuZ+aPLqz4ph9p0bLBMqlOLbvput3r/4lziC78sSF0MtHvEh1
        FxGbuV2Q==;
Received: from 189.27.24.74.dynamic.adsl.gvt.net.br ([189.27.24.74] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkY8e-0007iB-HB; Fri, 18 Jan 2019 17:41:05 +0000
Date:   Fri, 18 Jan 2019 15:40:58 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v5.0-rc3] media fixes
Message-ID: <20190118154058.12fda86a@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v5.0-1

for:

- A regression fix at v4l2 core, with affects multi-plane streams;
- a fix at vim2m driver.

Thanks!
Mauro


The following changes since commit 1c7fc5cbc33980acd13d668f1c8f0313d6ae9fd8:

  Linux 5.0-rc2 (2019-01-14 10:41:12 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v5.0-1

for you to fetch changes up to 240809ef6630a4ce57c273c2d79ffb657cd361eb:

  media: vim2m: only cancel work if it is for right context (2019-01-16 11:13:25 -0500)

----------------------------------------------------------------
media fixes for v5.0-rc3

----------------------------------------------------------------
Hans Verkuil (1):
      media: vim2m: only cancel work if it is for right context

Sakari Ailus (2):
      media: v4l: ioctl: Validate num_planes before using it
      media: v4l: ioctl: Validate num_planes for debug messages

Thierry Reding (1):
      media: v4l2-ioctl: Clear only per-plane reserved fields

 drivers/media/platform/vim2m.c       |  4 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c | 24 +++++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

