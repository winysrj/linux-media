Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFB0C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2B220835
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 16:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o2yXUryQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfCQQvw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 12:51:52 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:36673 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfCQQvv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 12:51:51 -0400
Received: by mail-pf1-f172.google.com with SMTP id p10so2799644pff.3
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2019 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D+KyDDs5z1hx6FdlqUk2QNFPmMRNwxOnaYCBXStEuq4=;
        b=o2yXUryQqMdVc74WuWxzvcVknwVwZPydr6msDCdT5Qc3xNJbWGYoz+Qn4RpsZywUl3
         wGgmv8bradA8xikRXDXHrhnjL22blg0xPaQdq0CDXCFRmCtF/2SZ0jFmABZEX+2jeIrT
         4OXSuoZ++/tb16Cr0T/F10uO5kgUY8bwZQgjYtCvyqr2p0q7H8czi3KKt6Py1eQYu8pF
         /2p96188bi6MNM+KzXq/vPO7GKG8T3YPD+r87qWXTMfvwuDE0azZLOH/9O98VaZjD7Ac
         9VvFvaCcOHNhoxNS4xtyGsdewSbDPaEEPm3kG8QBj+NDqs4gs7aPMAO20WeNzyThSVR3
         uBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D+KyDDs5z1hx6FdlqUk2QNFPmMRNwxOnaYCBXStEuq4=;
        b=Uh/Mu5So9aiHAQn7ZJnb6zWYOUmLBEJHVNoUSlyib9Tb2O64Y42E2L/aDbgOtSsxYg
         zMBGzZlmJbMKCzjK+wWm+3QGBdWJuMDlXO/eaSMaFCmZeS2YD0usFI1std6uhqBdhcl2
         FhqDjL1kwvec/+05U6HgDkjn5CvSNwDmmtg4Zo4oaNsvORDPdMz3LWioVnIPWEDYrGvS
         UP9RYosAUE37TiymdJdAHWf4Vw/DmcJ+cYzTTIYs0DMN0aAlhbxmyESOSid7Ui0RX6KQ
         mWqF1GA2HwduXH+97qF7/oaeFo3vAPSyajYacRDU9z/5KWGEgfXx9bGc5Wxy65GrQPb7
         kD8Q==
X-Gm-Message-State: APjAAAUMAatLN4AwyY1KEuE3ev3msX0R4+UNEy7SCXvV3PCIauL4sMha
        DGpIWARp/90ouIqscC99gX01rr50
X-Google-Smtp-Source: APXvYqzKGXkGphGZMuMpOD3WnhjB4P754cljw5SB818vCR1hAncuwmunvVH74CLovEMkwg5yF4pllQ==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr15329199plk.313.1552841510718;
        Sun, 17 Mar 2019 09:51:50 -0700 (PDT)
Received: from perclnx98.iil.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id o2sm476025pfh.128.2019.03.17.09.51.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Mar 2019 09:51:49 -0700 (PDT)
From:   dorodnic@gmail.com
X-Google-Original-From: sergey.dorodnicov@intel.com
To:     linux-media@vger.kernel.org
Cc:     laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH] [uvcvideo] Add "Auto" to power line frequency control
Date:   Sun, 17 Mar 2019 13:01:24 -0400
Message-Id: <1552842085-3439-1-git-send-email-sergey.dorodnicov@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Based on section 4.2.2.3.6 of the USB Device Class Definition for Video Devices
and inline with v4l2-ctrls.c, this patch is adding "Auto" to the list of valid
values of the power line frequency control.

Tested on 5.0.0-rc7 using Intel D415 and D435 USB cameras. 

Sergey Dorodnicov (1):
  media: Add missing "Auto" option to the power line frequency control

 drivers/media/usb/uvc/uvc_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.7.4

