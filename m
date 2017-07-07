Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:52531 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdGGLI5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 07:08:57 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v7 2/6] [media] cec-notifier.h: Prevent build warnings using forward declaration
Date: Fri,  7 Jul 2017 12:08:05 +0100
Message-Id: <e0e455ac3f40b3dd0344127bbb8773cea579620e.1499425271.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499425271.git.joabreu@synopsys.com>
References: <cover.1499425271.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499425271.git.joabreu@synopsys.com>
References: <cover.1499425271.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIC_CEC_NOTIFIER is not set and we only include cec-notifier.h
we can get build warnings like these ones:

"warning: ‘struct cec_notifier’ declared inside parameter list will
not be visible outside of this definition or declaration"

Prevent these warnings by using forward declaration of notifier
structure.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec-notifier.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 298f996..84f9376 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -21,14 +21,14 @@
 #ifndef LINUX_CEC_NOTIFIER_H
 #define LINUX_CEC_NOTIFIER_H
 
-#include <linux/types.h>
-#include <media/cec.h>
-
 struct device;
 struct edid;
 struct cec_adapter;
 struct cec_notifier;
 
+#include <linux/types.h>
+#include <media/cec.h>
+
 #if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
 
 /**
-- 
1.9.1
