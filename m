Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:35153 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbeKXDAL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 22:00:11 -0500
From: Andreas Pape <ap@ca-pape.de>
To: linux-media@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Andreas Pape <ap@ca-pape.de>
Subject: [PATCH 0/3] Fix for webcam issues with ASUS A6VM
Date: Fri, 23 Nov 2018 17:14:51 +0100
Message-Id: <20181123161454.3215-1-ap@ca-pape.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set of patches makes the Syntek USB webcam integrated into Asus A6VM
notebooks accessible again.

Andreas Pape (3):
  media: stkwebcam: Support for ASUS A6VM notebook added.
  media: stkwebcam: Bugfix for not correctly initialized camera
  media: stkwebcam: Bugfix for wrong return values

 drivers/media/usb/stkwebcam/stk-webcam.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.17.1
