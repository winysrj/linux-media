Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57388 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaCERIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Mar 2014 12:08:20 -0500
From: Ole Ernst <olebowle@gmx.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, Ole Ernst <olebowle@gmx.com>
Subject: [PATCH] dvb_frontend: Fix possible read out of bounds
Date: Wed,  5 Mar 2014 18:08:15 +0100
Message-Id: <1394039295-5638-1-git-send-email-olebowle@gmx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check if index is within bounds _before_ accessing the value.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2d32c13..6ce435a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1279,7 +1279,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	switch(tvp->cmd) {
 	case DTV_ENUM_DELSYS:
 		ncaps = 0;
-		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+		while (ncaps < MAX_DELSYS && fe->ops.delsys[ncaps]) {
 			tvp->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
 			ncaps++;
 		}
@@ -1596,7 +1596,7 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	 * supported
 	 */
 	ncaps = 0;
-	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+	while (ncaps < MAX_DELSYS && fe->ops.delsys[ncaps]) {
 		if (fe->ops.delsys[ncaps] == desired_system) {
 			c->delivery_system = desired_system;
 			dev_dbg(fe->dvb->device,
@@ -1628,7 +1628,7 @@ static int dvbv5_set_delivery_system(struct dvb_frontend *fe,
 	* of the desired system
 	*/
 	ncaps = 0;
-	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+	while (ncaps < MAX_DELSYS && fe->ops.delsys[ncaps]) {
 		if (dvbv3_type(fe->ops.delsys[ncaps]) == type)
 			delsys = fe->ops.delsys[ncaps];
 		ncaps++;
@@ -1703,7 +1703,7 @@ static int dvbv3_set_delivery_system(struct dvb_frontend *fe)
 	 * DVBv3 standard
 	 */
 	ncaps = 0;
-	while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+	while (ncaps < MAX_DELSYS && fe->ops.delsys[ncaps]) {
 		if (dvbv3_type(fe->ops.delsys[ncaps]) != DVBV3_UNKNOWN) {
 			delsys = fe->ops.delsys[ncaps];
 			break;
-- 
1.9.0

