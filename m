Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta-out.inet.fi ([195.156.147.13] helo=kirsi2.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anssi.hannula@gmail.com>) id 1JzYjm-0004NB-4n
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 16:59:18 +0200
Received: from mail.onse.fi (84.250.84.250) by kirsi2.rokki.sonera.fi (8.5.014)
	id 482C7FD6005D2D81 for linux-dvb@linuxtv.org;
	Fri, 23 May 2008 17:59:13 +0300
Received: from gamma.onse.fi (gamma [10.0.0.7])
	by mail.onse.fi (Postfix) with ESMTP id 4C8514723865
	for <linux-dvb@linuxtv.org>; Fri, 23 May 2008 17:58:55 +0300 (EEST)
Message-ID: <4836DBB6.5040006@gmail.com>
Date: Fri, 23 May 2008 17:59:02 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------010207020301020401000209"
Subject: [linux-dvb] [multiproto patch] fix ATSC api conversion
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------010207020301020401000209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The attached patch fixes ATSC conversion in olddrv_to_newapi.

-- 
Anssi Hannula

--------------010207020301020401000209
Content-Type: text/x-patch;
 name="multiproto-fix-atsc-conversion.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multiproto-fix-atsc-conversion.diff"

From: Anssi Hannula <anssi.hannula@gmail.com>

multiproto: fix ATSC conversion in olddrv_to_newapi

In olddrv_to_newapi() the ATSC modulation conversion used newmod_to_oldmod()
instead of the correct oldmod_to_newmod(). Fix it.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>

---

diff -r 46df93f7bcee -r 6fdfb2b22241 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Sun Apr 13 17:52:40 2008 +0400
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Fri May 23 17:17:02 2008 +0300
@@ -562,7 +562,7 @@
 		}
 		break;
 	case FE_ATSC:
-		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
+		oldmod_to_newmod(vsb->modulation, &atsc->modulation);
 		break;
 	default:
 		dprintk("%s: Unsupported delivery system %x\n", __func__, fe_type);

--------------010207020301020401000209
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010207020301020401000209--
