Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm25-vm6.bullet.mail.ukl.yahoo.com ([217.146.177.150]:35295
	"HELO nm25-vm6.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757617Ab2DFUVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 16:21:09 -0400
Message-ID: <4F7F5030.4070205@yahoo.com>
Date: Fri, 06 Apr 2012 21:21:04 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH] Linux 3.3 DVB userspace ABI broken for xine (FE_SET_FRONTEND)
References: <4F7F4CAF.4010501@yahoo.com>
In-Reply-To: <4F7F4CAF.4010501@yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------000300010701050707020300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000300010701050707020300
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

In fact, the following patch works for me.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------000300010701050707020300
Content-Type: text/x-patch;
 name="DVB.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DVB.diff"

--- linux-3.3/drivers/media/dvb/dvb-core/dvb_frontend.c.orig	2012-04-06 20:16:02.000000000 +0100
+++ linux-3.3/drivers/media/dvb/dvb-core/dvb_frontend.c	2012-04-06 21:17:38.000000000 +0100
@@ -1831,6 +1831,13 @@
 		return -EINVAL;
 
 	/*
+	 * Initialize output parameters to match the values given by
+	 * the user. FE_SET_FRONTEND triggers an initial frontend event
+	 * with status = 0, which copies output parameters to userspace.
+	 */
+	dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
+
+	/*
 	 * Be sure that the bandwidth will be filled for all
 	 * non-satellite systems, as tuners need to know what
 	 * low pass/Nyquist half filter should be applied, in

--------------000300010701050707020300--
