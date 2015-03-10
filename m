Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:32892 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbbCJIJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 04:09:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 9ACBB2A0092
	for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 09:09:20 +0100 (CET)
Message-ID: <54FEA6B0.2090309@xs4all.nl>
Date: Tue, 10 Mar 2015 09:09:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v4.0] Two fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two bug fixes for 4.0. The sh_veu patch was actually posted in December, but
the git pull request I made had no subject and that was likely the reason it
was never picked up by patchwork. I only discovered that today when I was
cleaning up old branches in my git development tree.

Well, better late than never.

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.0a

for you to fetch changes up to 0031b9ce6fde58cfcd9dccb472a4d5affb2bf513:

  cx23885: fix querycap (2015-03-10 09:06:28 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      sh_veu: v4l2_dev wasn't set
      cx23885: fix querycap

 drivers/media/pci/cx23885/cx23885-417.c | 13 ++++++-------
 drivers/media/platform/sh_veu.c         |  1 +
 2 files changed, 7 insertions(+), 7 deletions(-)
