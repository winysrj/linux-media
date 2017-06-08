Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35621 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750752AbdFHH0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 03:26:38 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.12] cec: fix race condition between poll and
 CEC_RECEIVE
Message-ID: <0165f498-15e4-ee2d-4f0e-fcd62c318a9b@xs4all.nl>
Date: Thu, 8 Jun 2017 09:26:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This bug fix should go to 4.12 (and has a CC to stable to get it in for
4.10 and 4.11 as well).

It fixes a race condition that can cause an application to loop forever, which
is how we (Cisco) discovered it.

Regards,

	Hans

The following changes since commit 47b586f66a9e78c91586b9c363603a52c75840d7:

  [media] pvrusb2: remove redundant check on cnt > 8 (2017-06-07 13:52:41 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-race-fix

for you to fetch changes up to bfafcd0557a8d963b05d4974a077e6a8306b164a:

  cec: race fix: don't return -ENONET in cec_receive() (2017-06-08 09:21:04 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cec: race fix: don't return -ENONET in cec_receive()

 drivers/media/cec/cec-api.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)
