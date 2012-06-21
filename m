Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm129.target-host.de ([188.72.225.129]:47032 "EHLO
	ffm129.target-host.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759942Ab2FURv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 13:51:29 -0400
From: <schulz@macnetix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jonathan Nieder <jrnieder@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	<linux-media@vger.kernel.org>,
	"Nikolaus Schulz" <schulz@macnetix.de>
Subject: [PATCH] dvb: push down ioctl lock in dvb_usercopy
Date: Thu, 21 Jun 2012 19:44:15 +0200
Message-ID: <1340300655-17696-1-git-send-email-schulz@macnetix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikolaus Schulz <schulz@macnetix.de>

Since most dvb ioctls wrap their real work with dvb_usercopy, the static mutex
used in dvb_usercopy effectively is a global lock for dvb ioctls.
Unfortunately, frontend ioctls can be blocked by the frontend thread for
several seconds; this leads to unacceptable lock contention.  Mitigate that by
pushing the mutex from dvb_usercopy down to the individual, device specific
ioctls.

There are 10 such ioctl functions using dvb_usercopy, either calling it
directly, or via the trivial wrapper dvb_generic_ioctl. The following already
employ their own locking and look safe:

    • dvb_demux_ioctl           (as per dvb_demux_do_ioctl)
    • dvb_dvr_ioctl             (as per dvb_dvr_do_ioctl)
    • dvb_osd_ioctl             (as per single non-trivial callee)
    • fdtv_ca_ioctl             (as per callees)
    • dvb_frontend_ioctl

The following functions do not, and are thus changed to use a device specific
mutex:

    • dvb_net_ioctl             (as per dvb_net_do_ioctl)
    • dvb_ca_en50221_io_ioctl   (as per dvb_ca_en50221_io_do_ioctl)
    • dvb_video_ioctl
    • dvb_audio_ioctl
    • dvb_ca_ioctl

Signed-off-by: Nikolaus Schulz <schulz@macnetix.de>
---
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    9 +++
 drivers/media/dvb/dvb-core/dvb_net.c        |   71 ++++++++++++++++++---------
 drivers/media/dvb/dvb-core/dvb_net.h        |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c         |    2 -
 drivers/media/dvb/ttpci/av7110.c            |    2 +
 drivers/media/dvb/ttpci/av7110.h            |    2 +
 drivers/media/dvb/ttpci/av7110_av.c         |    8 +++
 drivers/media/dvb/ttpci/av7110_ca.c         |   23 ++++++---
 8 files changed, 86 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 9be65a3..5d100a0 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -156,6 +156,9 @@ struct dvb_ca_private {
 
 	/* Slot to start looking for data to read from in the next user-space read operation */
 	int next_read_slot;
+
+	/* Mutex serializing ioctls */
+	struct mutex ioctl_mutex;
 };
 
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
@@ -1191,6 +1194,9 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 
 	dprintk("%s\n", __func__);
 
+	if (mutex_lock_interruptible(&ca->ioctl_mutex))
+		return -ERESTARTSYS;
+
 	switch (cmd) {
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
@@ -1241,6 +1247,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 		break;
 	}
 
+	mutex_unlock(&ca->ioctl_mutex);
 	return err;
 }
 
@@ -1695,6 +1702,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		mutex_init(&ca->slot_info[i].slot_lock);
 	}
 
+	mutex_init(&ca->ioctl_mutex);
+
 	if (signal_pending(current)) {
 		ret = -EINTR;
 		goto error;
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8766ce8..e675059 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1345,26 +1345,35 @@ static int dvb_net_do_ioctl(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_net *dvbnet = dvbdev->priv;
+	int ret = 0;
 
 	if (((file->f_flags&O_ACCMODE)==O_RDONLY))
 		return -EPERM;
 
+	if (mutex_lock_interruptible(&dvbnet->ioctl_mutex))
+		return -ERESTARTSYS;
+
 	switch (cmd) {
 	case NET_ADD_IF:
 	{
 		struct dvb_net_if *dvbnetif = parg;
 		int result;
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
+		if (!capable(CAP_SYS_ADMIN)) {
+			ret = -EPERM;
+			goto ioctl_error;
+		}
 
-		if (!try_module_get(dvbdev->adapter->module))
-			return -EPERM;
+		if (!try_module_get(dvbdev->adapter->module)) {
+			ret = -EPERM;
+			goto ioctl_error;
+		}
 
 		result=dvb_net_add_if(dvbnet, dvbnetif->pid, dvbnetif->feedtype);
 		if (result<0) {
 			module_put(dvbdev->adapter->module);
-			return result;
+			ret = result;
+			goto ioctl_error;
 		}
 		dvbnetif->if_num=result;
 		break;
@@ -1376,8 +1385,10 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct dvb_net_if *dvbnetif = parg;
 
 		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num])
-			return -EINVAL;
+		    !dvbnet->state[dvbnetif->if_num]) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
 
 		netdev = dvbnet->device[dvbnetif->if_num];
 
@@ -1388,16 +1399,18 @@ static int dvb_net_do_ioctl(struct file *file,
 	}
 	case NET_REMOVE_IF:
 	{
-		int ret;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if ((unsigned long) parg >= DVB_NET_DEVICES_MAX)
-			return -EINVAL;
+		if (!capable(CAP_SYS_ADMIN)) {
+			ret = -EPERM;
+			goto ioctl_error;
+		}
+		if ((unsigned long) parg >= DVB_NET_DEVICES_MAX) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
 		ret = dvb_net_remove_if(dvbnet, (unsigned long) parg);
 		if (!ret)
 			module_put(dvbdev->adapter->module);
-		return ret;
+		break;
 	}
 
 	/* binary compatibility cruft */
@@ -1406,16 +1419,21 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct __dvb_net_if_old *dvbnetif = parg;
 		int result;
 
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
+		if (!capable(CAP_SYS_ADMIN)) {
+			ret = -EPERM;
+			goto ioctl_error;
+		}
 
-		if (!try_module_get(dvbdev->adapter->module))
-			return -EPERM;
+		if (!try_module_get(dvbdev->adapter->module)) {
+			ret = -EPERM;
+			goto ioctl_error;
+		}
 
 		result=dvb_net_add_if(dvbnet, dvbnetif->pid, DVB_NET_FEEDTYPE_MPE);
 		if (result<0) {
 			module_put(dvbdev->adapter->module);
-			return result;
+			ret = result;
+			goto ioctl_error;
 		}
 		dvbnetif->if_num=result;
 		break;
@@ -1427,8 +1445,10 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct __dvb_net_if_old *dvbnetif = parg;
 
 		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num])
-			return -EINVAL;
+		    !dvbnet->state[dvbnetif->if_num]) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
 
 		netdev = dvbnet->device[dvbnetif->if_num];
 
@@ -1437,9 +1457,13 @@ static int dvb_net_do_ioctl(struct file *file,
 		break;
 	}
 	default:
-		return -ENOTTY;
+		ret = -ENOTTY;
+		break;
 	}
-	return 0;
+
+ioctl_error:
+	mutex_unlock(&dvbnet->ioctl_mutex);
+	return ret;
 }
 
 static long dvb_net_ioctl(struct file *file,
@@ -1505,6 +1529,7 @@ int dvb_net_init (struct dvb_adapter *adap, struct dvb_net *dvbnet,
 {
 	int i;
 
+	mutex_init(&dvbnet->ioctl_mutex);
 	dvbnet->demux = dmx;
 
 	for (i=0; i<DVB_NET_DEVICES_MAX; i++)
diff --git a/drivers/media/dvb/dvb-core/dvb_net.h b/drivers/media/dvb/dvb-core/dvb_net.h
index 1e53acd..ede78e8 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.h
+++ b/drivers/media/dvb/dvb-core/dvb_net.h
@@ -40,6 +40,7 @@ struct dvb_net {
 	int state[DVB_NET_DEVICES_MAX];
 	unsigned int exit:1;
 	struct dmx_demux *demux;
+	struct mutex ioctl_mutex;
 };
 
 void dvb_net_release(struct dvb_net *);
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 00a6732..e1217f6 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -417,10 +417,8 @@ int dvb_usercopy(struct file *file,
 	}
 
 	/* call driver */
-	mutex_lock(&dvbdev_mutex);
 	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
 		err = -EINVAL;
-	mutex_unlock(&dvbdev_mutex);
 
 	if (err < 0)
 		goto out;
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 4bd8bd5..2f54e2b 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2723,6 +2723,8 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 	if (ret < 0)
 		goto err_av7110_exit_v4l_12;
 
+	mutex_init(&av7110->ioctl_mutex);
+
 #if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
 	av7110_ir_init(av7110);
 #endif
diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/dvb/ttpci/av7110.h
index 88b3b2d..92ff02d 100644
--- a/drivers/media/dvb/ttpci/av7110.h
+++ b/drivers/media/dvb/ttpci/av7110.h
@@ -270,6 +270,8 @@ struct av7110 {
 	struct dvb_frontend* fe;
 	fe_status_t fe_status;
 
+	struct mutex ioctl_mutex;
+
 	/* crash recovery */
 	void				(*recover)(struct av7110* av7110);
 	fe_sec_voltage_t		saved_voltage;
diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 952b33d..301029c 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -1109,6 +1109,9 @@ static int dvb_video_ioctl(struct file *file,
 		}
 	}
 
+	if (mutex_lock_interruptible(&av7110->ioctl_mutex))
+		return -ERESTARTSYS;
+
 	switch (cmd) {
 	case VIDEO_STOP:
 		av7110->videostate.play_state = VIDEO_STOPPED;
@@ -1297,6 +1300,7 @@ static int dvb_video_ioctl(struct file *file,
 		break;
 	}
 
+	mutex_unlock(&av7110->ioctl_mutex);
 	return ret;
 }
 
@@ -1314,6 +1318,9 @@ static int dvb_audio_ioctl(struct file *file,
 	    (cmd != AUDIO_GET_STATUS))
 		return -EPERM;
 
+	if (mutex_lock_interruptible(&av7110->ioctl_mutex))
+		return -ERESTARTSYS;
+
 	switch (cmd) {
 	case AUDIO_STOP:
 		if (av7110->audiostate.stream_source == AUDIO_SOURCE_MEMORY)
@@ -1442,6 +1449,7 @@ static int dvb_audio_ioctl(struct file *file,
 		ret = -ENOIOCTLCMD;
 	}
 
+	mutex_unlock(&av7110->ioctl_mutex);
 	return ret;
 }
 
diff --git a/drivers/media/dvb/ttpci/av7110_ca.c b/drivers/media/dvb/ttpci/av7110_ca.c
index 9fc1dd0..6c78e44 100644
--- a/drivers/media/dvb/ttpci/av7110_ca.c
+++ b/drivers/media/dvb/ttpci/av7110_ca.c
@@ -253,12 +253,16 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	struct dvb_device *dvbdev = file->private_data;
 	struct av7110 *av7110 = dvbdev->priv;
 	unsigned long arg = (unsigned long) parg;
+	int ret = 0;
 
 	dprintk(8, "av7110:%p\n",av7110);
 
+	if (mutex_lock_interruptible(&av7110->ioctl_mutex))
+		return -ERESTARTSYS;
+
 	switch (cmd) {
 	case CA_RESET:
-		return ci_ll_reset(&av7110->ci_wbuffer, file, arg, &av7110->ci_slot[0]);
+		ret = ci_ll_reset(&av7110->ci_wbuffer, file, arg, &av7110->ci_slot[0]);
 		break;
 	case CA_GET_CAP:
 	{
@@ -277,8 +281,10 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	{
 		ca_slot_info_t *info=(ca_slot_info_t *)parg;
 
-		if (info->num < 0 || info->num > 1)
+		if (info->num < 0 || info->num > 1) {
+			mutex_unlock(&av7110->ioctl_mutex);
 			return -EINVAL;
+		}
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
 							CA_CI_LINK : CA_CI;
@@ -306,10 +312,10 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	{
 		ca_descr_t *descr = (ca_descr_t*) parg;
 
-		if (descr->index >= 16)
-			return -EINVAL;
-		if (descr->parity > 1)
+		if (descr->index >= 16 || descr->parity > 1) {
+			mutex_unlock(&av7110->ioctl_mutex);
 			return -EINVAL;
+		}
 		av7110_fw_cmd(av7110, COMTYPE_PIDFILTER, SetDescr, 5,
 			      (descr->index<<8)|descr->parity,
 			      (descr->cw[0]<<8)|descr->cw[1],
@@ -320,9 +326,12 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 	}
 
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
-	return 0;
+
+	mutex_unlock(&av7110->ioctl_mutex);
+	return ret;
 }
 
 static ssize_t dvb_ca_write(struct file *file, const char __user *buf,
-- 
1.7.2.5

