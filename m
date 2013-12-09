Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2449 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3LILnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 06:43:53 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id rB9Bhnf6031987
	for <linux-media@vger.kernel.org>; Mon, 9 Dec 2013 12:43:51 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 874A82A2223
	for <linux-media@vger.kernel.org>; Mon,  9 Dec 2013 12:43:45 +0100 (CET)
Message-ID: <52A5ACF1.8010307@xs4all.nl>
Date: Mon, 09 Dec 2013 12:43:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.13] vb2: regression fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please queue these regression fixes for 3.13.

This supersedes my previous earlier 3.13 pull request of today, since I realized that
the 'fix possible memory leak' patch should also go to 3.13.

Regards,

	Hans

The following changes since commit 3f823e094b935c1882605f8720336ee23433a16d:

  [media] exynos4-is: Simplify fimc-is hardware polling helpers (2013-12-04 15:54:19 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2fix

for you to fetch changes up to 891e9e548afe4aea0152f958ff468798a4b76735:

  videobuf2-dma-sg: fix possible memory leak (2013-12-09 12:40:02 +0100)

----------------------------------------------------------------
Geyslan G. Bem (1):
      videobuf2-dma-sg: fix possible memory leak

Hans Verkuil (1):
      vb2: regression fix: always set length field.

 drivers/media/v4l2-core/videobuf2-core.c   | 21 ++++++++++++++++++++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c |  3 ++-
 2 files changed, 22 insertions(+), 2 deletions(-)
