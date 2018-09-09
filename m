Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44469 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbeIIOHN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 10:07:13 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.19] Fix wrong staging Kconfig
Message-ID: <02ebedde-095f-eecc-b7d9-91251ac81f6c@xs4all.nl>
Date: Sun, 9 Sep 2018 11:18:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19a

for you to fetch changes up to feeb75bb65f0af69cf4108c78c2a0076393ce036:

  staging/media/mt9t031/Kconfig: remove bogus entry (2018-09-09 11:17:13 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      staging/media/mt9t031/Kconfig: remove bogus entry

 drivers/staging/media/mt9t031/Kconfig | 6 ------
 1 file changed, 6 deletions(-)
