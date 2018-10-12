Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39258 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbeJLSwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 14:52:18 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes
Message-ID: <d2f68e50-07e6-c403-443c-32e8524a35da@xs4all.nl>
Date: Fri, 12 Oct 2018 13:20:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8caec72e8cbff65afa38928197bea5a393b67975:

  media: vivid: Support 480p for webcam capture (2018-10-09 10:37:54 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.20h

for you to fetch changes up to 4c6d2269ad271ceae049e7e13c3754982cd694bb:

  cec: increase debug level for 'queue full' (2018-10-12 13:13:35 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (3):
      vicodec: lower minimum height to 360
      cec: check for non-OK/NACK conditions while claiming a LA
      cec: increase debug level for 'queue full'

Nathan Chancellor (1):
      media: tc358743: Remove unnecessary self assignment

 drivers/media/cec/cec-adap.c                  | 49 ++++++++++++++++++++++++++++++++++++++-----------
 drivers/media/i2c/tc358743.c                  |  1 -
 drivers/media/platform/vicodec/vicodec-core.c |  2 +-
 3 files changed, 39 insertions(+), 13 deletions(-)
