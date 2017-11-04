Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58803 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751805AbdKDCCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 22:02:04 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Fix s5p-mfc lock contention in request firmware paths
Date: Fri,  3 Nov 2017 20:01:56 -0600
Message-Id: <cover.1509760483.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes inefficiencies and lock contention in the request
firmware paths.

Changes since v2:
- Addressed Andre's review comments. Removed fw_buf->virt null check
  as it is not needed. Removed handling s5p_mfc_load_firmware() from
  probe routine. Simply try loading in case it works.

Shuah Khan (2):
  media: s5p-mfc: remove firmware buf null check in
    s5p_mfc_load_firmware()
  media: s5p-mfc: fix lock confection - request_firmware() once and keep
    state

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 10 +++++-----
 3 files changed, 14 insertions(+), 5 deletions(-)

-- 
2.7.4
