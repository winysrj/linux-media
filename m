Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:48967 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2IZUXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 16:23:15 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Wed, 26 Sep 2012 22:11:42 +0200
To: Juergen Lock <nox@jelal.kn-bremen.de>
Cc: linux-media@vger.kernel.org, hselasky@c2i.net
Subject: Re: [PATCH, RFC, updated] Fix DVB ioctls failing if frontend
 open/closed too fast
Message-ID: <20120926201142.GA60610@triton8.kn-bremen.de>
References: <20120731222216.GA36603@triton8.kn-bremen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731222216.GA36603@triton8.kn-bremen.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 01, 2012 at 12:22:16AM +0200, Juergen Lock wrote:
> That likely fixes this MythTV ticket:
> 
> 	http://code.mythtv.org/trac/ticket/10830
> 
> (which btw affects all usb tuners I tested as well, pctv452e,
> dib0700, af9015)  pctv452e is still possibly broken with MythTV
> even after this fix; it does work with VDR here tho despite I2C
> errors.
> 
> Reduced testcase:
> 
> 	http://people.freebsd.org/~nox/tmp/ioctltst.c
> 
> Thanx to devinheitmueller and crope from #linuxtv for helping with
> this fix! :)
> 
Updated patch for media tree for_3.7:

Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>

--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -603,6 +603,7 @@ static int dvb_frontend_thread(void *dat
 	enum dvbfe_algo algo;
 
 	bool re_tune = false;
+	bool semheld = false;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
@@ -626,6 +627,8 @@ restart:
 
 		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
 			/* got signal or quitting */
+			if (!down_interruptible (&fepriv->sem))
+				semheld = true;
 			fepriv->exit = DVB_FE_NORMAL_EXIT;
 			break;
 		}
@@ -741,6 +744,8 @@ restart:
 		fepriv->exit = DVB_FE_NO_EXIT;
 	mb();
 
+	if (semheld)
+		up(&fepriv->sem);
 	dvb_frontend_wakeup(fe);
 	return 0;
 }
@@ -1819,16 +1824,20 @@ static int dvb_frontend_ioctl(struct fil
 	int err = -ENOTTY;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
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
