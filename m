Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:53547 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0XqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 19:46:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: y2038@lists.linaro.org, awalls@md.metrocast.net,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] media: cec: move compat_ioctl handling to cec-api.c
Date: Mon, 27 Aug 2018 21:56:23 +0200
Message-Id: <20180827195649.4170969-3-arnd@arndb.de>
In-Reply-To: <20180827195649.4170969-1-arnd@arndb.de>
References: <20180827195649.4170969-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All the CEC ioctls are compatible, and they are only implemented
in one driver, so we can simply let this driver handle them
natively.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/cec/cec-api.c |  1 +
 fs/compat_ioctl.c           | 12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index b6536bbad530..9067728feb60 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -665,6 +665,7 @@ const struct file_operations cec_devnode_fops = {
 	.owner = THIS_MODULE,
 	.open = cec_open,
 	.unlocked_ioctl = cec_ioctl,
+	.compat_ioctl = cec_ioctl,
 	.release = cec_release,
 	.poll = cec_poll,
 	.llseek = no_llseek,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index e38e6c785459..33f48933a865 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1195,18 +1195,6 @@ COMPATIBLE_IOCTL(VIDEO_CLEAR_BUFFER)
 COMPATIBLE_IOCTL(VIDEO_SET_STREAMTYPE)
 COMPATIBLE_IOCTL(VIDEO_SET_FORMAT)
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
-/* cec */
-COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
-COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
-COMPATIBLE_IOCTL(CEC_ADAP_S_LOG_ADDRS)
-COMPATIBLE_IOCTL(CEC_ADAP_G_PHYS_ADDR)
-COMPATIBLE_IOCTL(CEC_ADAP_S_PHYS_ADDR)
-COMPATIBLE_IOCTL(CEC_G_MODE)
-COMPATIBLE_IOCTL(CEC_S_MODE)
-COMPATIBLE_IOCTL(CEC_TRANSMIT)
-COMPATIBLE_IOCTL(CEC_RECEIVE)
-COMPATIBLE_IOCTL(CEC_DQEVENT)
-
 /* joystick */
 COMPATIBLE_IOCTL(JSIOCGVERSION)
 COMPATIBLE_IOCTL(JSIOCGAXES)
-- 
2.18.0
