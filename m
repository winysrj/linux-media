Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62573 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbdJFVid (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 17:38:33 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix s5p-mfc lock contention in request firmware paths
Date: Fri,  6 Oct 2017 15:30:06 -0600
Message-Id: <cover.1507325072.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes inefficiencies and lock contention in the request
firmware paths.

Shuah Khan (2):
  media: s5p-mfc: check for firmware allocation before requesting
    firmware
  media: s5p-mfc: fix lock confection - request_firmware() once and keep
    state

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  4 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 15 ++++++++++-----
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.7.4
