Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34961 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbdHBRPP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 13:15:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] constify media pci_device_id/pci_tbl.
Date: Wed,  2 Aug 2017 22:44:48 +0530
Message-Id: <1501694097-16207-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SAA7146 DVD card base pci device id const.

Arvind Yadav (9):
  [PATCH 1/9] [media] drv-intf: saa7146: constify pci_device_id.
  [PATCH 2/9] [media] ttpci: budget: constify pci_device_id.
  [PATCH 3/9] [media] ttpci: budget-patch: constify pci_device_id.
  [PATCH 4/9] [media] ttpci: budget-ci: constify pci_device_id.
  [PATCH 5/9] [media] ttpci: budget-av: constify pci_device_id.
  [PATCH 6/9] [media] ttpci: av7110: constify pci_device_id.
  [PATCH 7/9] [media] saa7146: mxb: constify pci_device_id.
  [PATCH 8/9] [media] saa7146: hexium_orion: constify pci_device_id.
  [PATCH 9/9] [media] saa7146: hexium_gemini: constify pci_device_id.

 drivers/media/pci/saa7146/hexium_gemini.c | 2 +-
 drivers/media/pci/saa7146/hexium_orion.c  | 2 +-
 drivers/media/pci/saa7146/mxb.c           | 2 +-
 drivers/media/pci/ttpci/av7110.c          | 2 +-
 drivers/media/pci/ttpci/budget-av.c       | 2 +-
 drivers/media/pci/ttpci/budget-ci.c       | 2 +-
 drivers/media/pci/ttpci/budget-patch.c    | 2 +-
 drivers/media/pci/ttpci/budget.c          | 2 +-
 include/media/drv-intf/saa7146.h          | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.7.4
