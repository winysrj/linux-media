Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48344
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752226AbdIATh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:37:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 14/14] media: frontend.h: Avoid the term DVB when doesn't refer to a delivery system
Date: Fri,  1 Sep 2017 16:37:50 -0300
Message-Id: <c101d7c6905dea8ac030504d89e0b3b03ce71a9f.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB term can either refer to the subsystem or to a delivery
system. Avoid it in the first case at the kernel-doc markups.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/dvb/frontend.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 8c5191f74bd4..b81b74efbd02 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -239,11 +239,11 @@ enum fe_sec_mini_cmd {
  * @FE_NONE:		The frontend doesn't have any kind of lock.
  *			That's the initial frontend status
  * @FE_HAS_SIGNAL:	Has found something above the noise level.
- * @FE_HAS_CARRIER:	Has found a DVB signal.
+ * @FE_HAS_CARRIER:	Has found a signal.
  * @FE_HAS_VITERBI:	FEC inner coding (Viterbi, LDPC or other inner code).
  * 			is stable.
  * @FE_HAS_SYNC:	Synchronization bytes was found.
- * @FE_HAS_LOCK:	DVB were locked and everything is working.
+ * @FE_HAS_LOCK:	Digital TV were locked and everything is working.
  * @FE_TIMEDOUT:	Fo lock within the last about 2 seconds.
  * @FE_REINIT:		Frontend was reinitialized, application is recommended
  *			to reset DiSEqC, tone and parameters.
@@ -269,7 +269,7 @@ enum fe_status {
  * This parameter indicates if spectral inversion should be presumed or
  * not. In the automatic setting (``INVERSION_AUTO``) the hardware will try
  * to figure out the correct setting by itself. If the hardware doesn't
- * support, the DVB core will try to lock at the carrier first with
+ * support, the %dvb_frontend will try to lock at the carrier first with
  * inversion off. If it fails, it will try to enable inversion.
  */
 enum fe_spectral_inversion {
-- 
2.13.5
