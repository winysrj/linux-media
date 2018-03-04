Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37083 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbeCDPtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2018 10:49:18 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: alan@linux.intel.com
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 1/3] staging: media: Replace "be be" with "be"
Date: Sun,  4 Mar 2018 21:18:25 +0530
Message-Id: <1520178507-25141-2-git-send-email-arushisinghal19971997@gmail.com>
In-Reply-To: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
References: <1520178507-25141-1-git-send-email-arushisinghal19971997@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replace "be be" with "be".

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
index df0aad9..4057a5a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_pipe_public.h
@@ -402,7 +402,7 @@ ia_css_pipe_set_isp_config(struct ia_css_pipe *pipe,
  exception holds for IA_CSS_EVENT_TYPE_PORT_EOF, for this event an IRQ is always
  raised.
  Note that events are still queued and the Host can poll for them. The
- or_mask and and_mask may be be active at the same time\n
+ or_mask and and_mask may be active at the same time\n
  \n
  Default values, for all pipe id's, after ia_css_init:\n
  or_mask = IA_CSS_EVENT_TYPE_ALL\n
-- 
2.7.4
