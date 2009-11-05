Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:59848 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZKEDDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 22:03:47 -0500
Received: from localhost ([127.0.0.1] helo=webmail.exetel.com.au)
	by acorn.exetel.com.au with esmtp (Exim 4.68)
	(envelope-from <rglowery@exemail.com.au>)
	id 1N5sTN-0003Ai-NF
	for linux-media@vger.kernel.org; Thu, 05 Nov 2009 13:53:17 +1100
Message-ID: <17531.64.213.30.2.1257389597.squirrel@webmail.exetel.com.au>
Date: Thu, 5 Nov 2009 13:53:17 +1100 (EST)
Subject: bisected regression in tuner-xc2028
From: "Robert Lowery" <rglowery@exemail.com.au>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been having some difficulties getting my DVICO dual digital 4
(rev1) working with recent kernels, failing to tune and getting errors
like the following

kernel: [ 315.032076] dvb-usb: bulk message failed: -110 (4/0)
kernel: [ 315.032080] cxusb: i2c read failed

and making the machine very slow as documented at
https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/459523

Using the v4l-dvb tree, I was able to bisect the issue down to
http://linuxtv.org/hg/v4l-dvb/rev/7276a5854219

At first I though I could workaround the issue by setting no_poweroff=1,
but that did not work.  The following diff did however resolve the issue.

diff -r 43878f8dbfb0 linux/drivers/media/common/tuners/tuner-xc2028.c
--- a/linux/drivers/media/common/tuners/tuner-xc2028.c        Sun Nov 01
07:17:46
2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-xc2028.c        Tue Nov 03
14:24:05
2009 +1100
@@ -1240,7 +1240,7 @@
         .get_frequency     = xc2028_get_frequency,
         .get_rf_strength   = xc2028_signal,
         .set_params        = xc2028_set_params,
-        .sleep             = xc2028_sleep,
+        //.sleep             = xc2028_sleep,
 #if 0
         int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
         int (*get_status)(struct dvb_frontend *fe, u32 *status);

This led me to dvb_frontend.c where I could see i2c_gate_ctrl() was being
called if .sleep was non zero.  Setting dvb_powerdown_on_sleep=0 worked
around the issue by stoppign i2c_gate_ctrl() being called, so I suspect
i2c_gate_ctrl() is triggering the issue somehow.

Any thoughts on a proper solution for this issue?

-Rob


