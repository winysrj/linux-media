Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760491Ab0JGMrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 08:47:09 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o97Cl9j2012113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:47:09 -0400
Received: from pedra (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o97Ck4sh028624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 08:47:08 -0400
Date: Thu, 7 Oct 2010 09:45:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] V4L/DVB: staging/tm6000: Fix a warning message
Message-ID: <20101007094542.6a2e6a7c@pedra>
In-Reply-To: <f3a134520bf3f816b8f7192426af875603a1434e.1286455481.git.mchehab@redhat.com>
References: <f3a134520bf3f816b8f7192426af875603a1434e.1286455481.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I added a code to the driver to force it to produce a warning. This
were intended to remind me about a very bad hack. I never found a way
to workaround. So, instead of those warnings:

drivers/staging/tm6000/tm6000-core.c: In function ‘tm6000_init_analog_mode’:
drivers/staging/tm6000/tm6000-core.c:328: warning: ISO C90 forbids mixed declarations and code

Let's document the issue and hope if someone with the support of the vendor
might fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 57cb69e..3d82510 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -188,6 +188,8 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
 
 int tm6000_init_analog_mode(struct tm6000_core *dev)
 {
+	struct v4l2_frequency f;
+
 	if (dev->dev_type == TM6010) {
 		int val;
 
@@ -324,8 +326,16 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 
 	/* Tuner firmware can now be loaded */
 
-	/*FIXME: Hack!!! */
-	struct v4l2_frequency f;
+	/*
+	 * FIXME: This is a hack! xc3028 "sleeps" when no channel is detected
+	 * for more than a few seconds. Not sure why, as this behavior does
+	 * not happen on other devices with xc3028. So, I suspect that it
+	 * is yet another bug at tm6000. After start sleeping, decoding 
+	 * doesn't start automatically. Instead, it requires some
+	 * I2C commands to wake it up. As we want to have image at the
+	 * beginning, we needed to add this hack. The better would be to
+	 * discover some way to make tm6000 to wake up without this hack.
+	 */
 	mutex_lock(&dev->lock);
 	f.frequency = dev->freq;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
-- 
1.7.1

