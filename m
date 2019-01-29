Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB315C282D0
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BFE021874
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548777628;
	bh=Yd1ywdF13a8Ie2iQZSRwvkYs5RIRExxioMHU2Pv591U=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=U0rP5dCeZiu1cUGpwQTIYTvXpaQxPSGvEUggEp0+bIyRR4UZ7rEHeKTxWMtYhwszw
	 Xw7dRp2KIybsRDOkRppBvlU5/yfAvFj5gF0p+xCy+T6eWe0D/NFh0l+txuk+Zfbta1
	 mpzAi86P3KuXsYcjdSrgn9jlPLI+REeNK3qUkbSM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfA2QA1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53866 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfA2QA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ltMCFt0IChxo9BfX+Ar/RRAcv3z7Ot7U9ITKEPdwBm0=; b=c9yrPNci1gePQYTgJjqkHHh9Z
        x/2d4rOaNcUXlRzp+aIKRDHYS5HmOM3+V0MKzRE9SxfOx1zZ1Ey+da85EEv2VjvlTsHG9v+1rnhNn
        cQ8RaCNGsC/+l75OK4MhHG2rPGDrHWbAqyAFWg60a7ozplvGYR3wJ1gvdjdaNUCO+OFTO8crpyu6Z
        P+gsHM8U6i5pUxYV2qusFpQEvHhp9RyfeZ0Dh60YXV6f5GebQXDzZPsRxdmWxdTycw2m7w2mMgV48
        lfXTvLkRerBQw3RxeGsjVLrrALHjPW8j+bW4/z846oTyg716ho74AtLoui3ZGYJP2pZp/6zXG9ycv
        gxke0700g==;
Received: from 177.43.31.175.dynamic.adsl.gvt.net.br ([177.43.31.175] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1goVoI-0006o4-P5; Tue, 29 Jan 2019 16:00:26 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1goVoD-0006UK-7S; Tue, 29 Jan 2019 14:00:21 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Anton Leontiev <scileont@gmail.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/3] vim2m: make it work properly
Date:   Tue, 29 Jan 2019 14:00:14 -0200
Message-Id: <cover.1548776693.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vim2m driver has some issues... 

It currently fakes supporting two video formats, when in fact, it just
copies the data to the buffer;

It says it supports hflip, when, in fact, it does a 8 tiles flip...
that doesn't end well, though, due to the lack of proper video
format;

If more than one open() is called, it sometimes go to some dead lock,
preventing to stop all pipelines;

By default, it can be used only one instance, as it takes too long
to generate data (40 msecs). This is actually by purpose, as it
uses a delay work queue for that.

This patch series solve all the above issues. For the last one, a
new modprobe parameter was added, in order to allow changing the
default. For example, with this:

	# sudo modprobe vim2m default_transtime=1

the delay is reduced to 1 ms. On my tests with this pipeline:

$ gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2video0convert disable-passthrough=1 extra-controls="s,horizontal_flip=0,vertical_flip=0" ! video/x-raw,format=YUY2 ! videoconvert ! fpsdisplaysink

and a similar one:

$ gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2video0convert disable-passthrough=1 extra-controls="s,horizontal_flip=1,vertical_flip=1" ! video/x-raw,format=RGB16 ! videoconvert ! ximagesink

I was able to create 17 such pipelines keeping the frame rate at 30
frames per second, and up to 27 pipelines without losing frames, with
a framerate close to 20 fps.

My tests were done on a 3rd generation i7core machine (i7-3630QM).

So, it sounds good enough to be used for testing m2m, even on nowadays
CPUs with less performance.

I opted to keep the default time to 40 ms to 1 ms, in order to allow
multiple streams, but, in practice, I suspect that just one instance
should be enough for most usecases. So, I ended by keping the 40 ms
timing.

PS.: the first patch is identical to the one I submitted before,
except for a minor change on its description.

This patch series can be found on my development tree:

    https://git.linuxtv.org/mchehab/experimental.git/log/?h=vim2m

Mauro Carvalho Chehab (3):
  media: vim2m: fix driver for it to handle different fourcc formats
  media: vim2m: use per-file handler work queue
  media: vim2m: allow setting the default transaction time via parameter

 drivers/media/platform/vim2m.c | 434 ++++++++++++++++++++-------------
 1 file changed, 270 insertions(+), 164 deletions(-)

-- 
2.20.1


