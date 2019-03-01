Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE77C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDAB620851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446678;
	bh=saFBwTqhbk9pVn1HNUl2nR1mPbLTr0Nr/E3694HxrN0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=unFX6hyLvjI9zTb9FgcOvwmLtfM8WrGM1E4Hj3qVaW/MBAvHh7ng+a9DhJEwXNZKx
	 0hhlxR814Z++mKwsccFj87xeYDyc31lxc0z2X7XSvDEG+A6IpVaEEiII4kLRbiJk2o
	 t9fLCZc/IacY5z9b8g0wdBHNGxyoN2xR7zxI2IZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfCANYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R4WBxYyJXpUZTmRjZaf6rQu0FsGZhnm3FGYgKX9JH5A=; b=tVC5EVk/Dj+1KZLu7///hKllq
        SddLnb0pMd2ec7RtVyvFyZv/NBb9dx4XKizybAZjn0w7BECxbzhKfdGEZzjnDnor6KI/wiTCMkCTw
        dgFw79kmQZqpgnrOd9Q3Sv7U5yD9V8XF3ixbRQr3Zvuffz9CbT7GvyIIG42jeViOxQfy/T7Q2bzY/
        T3U6eNqntWQjqK/k08IO03A+0GnqWwxkXCvrz0N40FTSaTuR8TY1rbKKqaGnnxBjCFqnt7d44bXDW
        rVcYQJYI1IHHb1z7D8L3SIGaa7C+2rHZ2+SkFpg+IS+w6AEqv1ARSFf5I2F2LKmbdXoETrNGMEkKH
        e3QJKoUBw==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003xv-P7; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002N0-NA; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 00/10] Improvements and fixups for vim2m driver
Date:   Fri,  1 Mar 2019 10:24:16 -0300
Message-Id: <cover.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vim2m was laking care for a long time. It had several issues. Several
were already fixed and are merged for Kernel 5.1, but there are still
some pending things.

This patch series complement the work, making it do the right thing with
regards to different resolutions at capture and output buffers.

Although it contains some improvements (like the addition of Bayer),
I'm tempted to do a late merge for it, in order for the entire set of changes
to go to Kernel 5.1, specially since:

a) It contains a fix at the buffer filling routine. At least this one should
go to 5.1 anyway;

b) while the other patches could eventually go to 5.2, they also do 
significant changes at the buffer handling logic;

c) It disables YUYV as output format (due to the horizontal scaler). It
would be good that such change would go together with the changes for
5.1 with actually implements YUYV support;

d) This is a test driver anyway and shouldn't affect systems in production.

e) As we're using it also to properly implement/fix Bayer support for M2M
transform drivers at Gstreamer, it would be better to have everything
altogether.

So, if nobody complains, I'll likely merge this series later today or along the
weekend for Kernel 5.1.


Mauro Carvalho Chehab (10):
  media: vim2m: add bayer capture formats
  media: vim2m: improve debug messages
  media: vim2m: ensure that width is multiple of two
  media: vim2m: add support for VIDIOC_ENUM_FRAMESIZES
  media: vim2m: use different framesizes for bayer formats
  media: vim2m: better handle cap/out buffers with different sizes
  media: vim2m: add vertical linear scaler
  media: vim2m: don't accept YUYV anymore as output format
  media: vim2m: add an horizontal scaler
  media: vim2m: speedup passthrough copy

 drivers/media/platform/vim2m.c | 415 +++++++++++++++++++++++----------
 1 file changed, 287 insertions(+), 128 deletions(-)

-- 
2.20.1


