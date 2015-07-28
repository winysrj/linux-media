Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33337 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400AbbG1KT2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 06:19:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F2C232A0089
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 12:19:19 +0200 (CEST)
Message-ID: <55B75727.2040705@xs4all.nl>
Date: Tue, 28 Jul 2015 12:19:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v4.2] Fix vb2 compilation breakage when !CONFIG_BUG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:

  [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2a

for you to fetch changes up to 900ac77d06e648f5a284d96023e4b9e9fcd88422:

  vb2: Fix compilation breakage when !CONFIG_BUG (2015-07-28 11:41:11 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      vb2: Fix compilation breakage when !CONFIG_BUG

 drivers/media/v4l2-core/videobuf2-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
