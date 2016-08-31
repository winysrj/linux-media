Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49441 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750980AbcHaGuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 02:50:22 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 2CC8018014C
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2016 08:50:17 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Two cec bug fixes
Message-ID: <c8b26179-2cac-af84-2113-4a0099ab5c29@xs4all.nl>
Date: Wed, 31 Aug 2016 08:50:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two CEC bug fixes that should go into 4.8.

Regards,

	Hans

The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

  [media] dvb_frontend: Use memdup_user() rather than duplicating its implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8c

for you to fetch changes up to 7f1d4c0bb422351f494fb276eeeea5457026800b:

  cec: fix ioctl return code when not registered (2016-08-31 08:47:28 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      cec: don't Feature Abort broadcast msgs when unregistered
      cec: fix ioctl return code when not registered

 drivers/staging/media/cec/cec-adap.c | 3 +--
 drivers/staging/media/cec/cec-api.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)
