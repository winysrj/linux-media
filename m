Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:33331 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3EGML7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 08:11:59 -0400
Message-ID: <5188EF5C.3030003@asianux.com>
Date: Tue, 07 May 2013 20:11:08 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	josephdanielwalter@gmail.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] staging: strncpy issue, need always let NUL terminated string
  ended by zero.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


For NUL terminated string, need always let it ended by zero.

The 'name' may be copied to user mode ('dvb_fe->ops.info' is 'struct
dvb_frontend_info' which is defined in ./include/uapi/...), and its
length is also known within as102_dvb_register_fe(), so need fully
initialize it (not use strlcpy instead of strncpy).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/staging/media/as102/as102_fe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 9ce8c9d..b3efec9 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -334,6 +334,7 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
 	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
 	strncpy(dvb_fe->ops.info.name, as102_dev->name,
 		sizeof(dvb_fe->ops.info.name));
+	dvb_fe->ops.info.name[sizeof(dvb_fe->ops.info.name) - 1] = '\0';
 
 	/* register dvb frontend */
 	errno = dvb_register_frontend(dvb_adap, dvb_fe);
-- 
1.7.7.6
