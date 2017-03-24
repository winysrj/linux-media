Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:45684 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936872AbdCXQsd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:33 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 0/8] Add cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:51 +0000
Message-Id: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series introduces a new helper function called cec_get_drvdata() which
returns the adapter private data and can be used by drivers that use CEC.

Best regards,
Jose Miguel Abreu

Jose Abreu (8):
  [media] cec: Add cec_get_drvdata()
  [media] staging: st-cec: Use cec_get_drvdata()
  [media] staging: s5p-cec: Use cec_get_drvdata()
  [media] i2c: adv7511: Use cec_get_drvdata()
  [media] i2c: adv7604: Use cec_get_drvdata()
  [media] i2c: adv7842: Use cec_get_drvdata()
  [media] usb: pulse8-cec: Use cec_get_drvdata()
  [media] platform: vivid: Use cec_get_drvdata()

 drivers/media/i2c/adv7511.c               | 6 +++---
 drivers/media/i2c/adv7604.c               | 6 +++---
 drivers/media/i2c/adv7842.c               | 6 +++---
 drivers/media/platform/vivid/vivid-cec.c  | 4 ++--
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 6 +++---
 drivers/staging/media/s5p-cec/s5p_cec.c   | 6 +++---
 drivers/staging/media/st-cec/stih-cec.c   | 6 +++---
 include/media/cec.h                       | 5 +++++
 8 files changed, 25 insertions(+), 20 deletions(-)

-- 
1.9.1
