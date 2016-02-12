Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57945 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbcBLIm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 03:42:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DAE0A180DD6
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2016 09:42:51 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] adv7604: fix tx 5v detect regression
Message-ID: <56BD9B0B.2080604@xs4all.nl>
Date: Fri, 12 Feb 2016 09:42:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f7b4b54e63643b740c598e044874c4bffa0f04f2:

  [media] tvp5150: add HW input connectors support (2016-02-11 11:11:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.5a

for you to fetch changes up to 402d07c7fa3819c4f3a5acbcd74b5b2768014912:

  adv7604: fix tx 5v detect regression (2016-02-12 09:40:42 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      adv7604: fix tx 5v detect regression

 drivers/media/i2c/adv7604.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
