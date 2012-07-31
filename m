Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:48932 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2GaWeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 18:34:16 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Wed, 1 Aug 2012 00:22:16 +0200
To: linux-media@vger.kernel.org
Cc: hselasky@c2i.net
Subject: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed too fast
Message-ID: <20120731222216.GA36603@triton8.kn-bremen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That likely fxes this MythTV ticket:

	http://code.mythtv.org/trac/ticket/10830

(which btw affects all usb tuners I tested as well, pctv452e,
dib0700, af9015)  pctv452e is still possibly broken with MythTV
even after this fix; it does work with VDR here tho despite I2C
errors.

Reduced testcase:

	http://people.freebsd.org/~nox/tmp/ioctltst.c

Thanx to devinheitmueller and crope from #linuxtv for helping with
this fix! :)

Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>

--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -604,6 +604,7 @@ static int dvb_frontend_thread(void *dat
 	enum dvbfe_algo algo;
 
 	bool re_tune = false;
+	bool semheld = false;
 
 	dprintk("%s\n", __func__);
 
@@ -627,6 +628,8 @@ restart:
 
 		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
 			/* got signal or quitting */
+			if (!down_interruptible (&fepriv->sem))
+				semheld = true;
 			fepriv->exit = DVB_FE_NORMAL_EXIT;
 			break;
 		}
@@ -742,6 +745,8 @@ restart:
 		fepriv->exit = DVB_FE_NO_EXIT;
 	mb();
 
+	if (semheld)
+		up(&fepriv->sem);
 	dvb_frontend_wakeup(fe);
 	return 0;
 }
@@ -1804,16 +1809,20 @@ static int dvb_frontend_ioctl(struct fil
 
 	dprintk("%s (%d)\n", __func__, _IOC_NR(cmd));
 
-	if (fepriv->exit != DVB_FE_NO_EXIT)
+	if (down_interruptible (&fepriv->sem))
+		return -ERESTARTSYS;
+
+	if (fepriv->exit != DVB_FE_NO_EXIT) {
+		up(&fepriv->sem);
 		return -ENODEV;
+	}
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
 	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
-	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
+	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
+		up(&fepriv->sem);
 		return -EPERM;
-
-	if (down_interruptible (&fepriv->sem))
-		return -ERESTARTSYS;
+	}
 
 	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
 		err = dvb_frontend_ioctl_properties(file, cmd, parg);
