Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:49943 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab1JRJRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 05:17:12 -0400
Date: Tue, 18 Oct 2011 11:13:36 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 11/14] staging/media/as102: fix compile warning about unused
 function
Message-Id: <20111018111336.62af07ce.chmooreck@poczta.onet.pl>
In-Reply-To: <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267319685 18000
# Node ID 84b93826c0a19efa114a6808165f91390cb86daa
# Parent  22ef1bdca69a2781abf397c53a0f7f6125f5359a
as102: fix compile warning about unused function

From: Devin Heitmueller <dheitmueller@kernellabs.com>

The function in question is only used on old kernels, so we had the call to
the function #ifdef'd, but the definition of the function was stil being
included.

Priority: normal

Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>

diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/media/dvb/as102/as102_fe.c
--- linux/drivers/staging/media/as102/as102_fe.c
+++ linuxb/drivers/staging/media/as102/as102_fe.c
@@ -32,6 +32,7 @@
 static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
 					  struct dvb_frontend_parameters *src);
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
 static void as102_fe_release(struct dvb_frontend *fe)
 {
 	struct as102_dev_t *dev;
@@ -42,7 +43,6 @@
 	if (dev == NULL)
 		return;
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
 	if (mutex_lock_interruptible(&dev->bus_adap.lock))
 		return;
 
@@ -50,7 +50,6 @@
 	as10x_cmd_turn_off(&dev->bus_adap);
 
 	mutex_unlock(&dev->bus_adap.lock);
-#endif
 
 	/* release frontend callback ops */
 	memset(&fe->ops, 0, sizeof(struct dvb_frontend_ops));
@@ -66,7 +65,6 @@
 	LEAVE();
 }
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19))
 static int as102_fe_init(struct dvb_frontend *fe)
 {
 	int ret = 0;
