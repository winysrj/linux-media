Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K3sgi-00058U-Dk
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 15:06:00 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb@linuxtv.org
In-Reply-To: <1212535332.32385.29.camel@pascal>
References: <1212535332.32385.29.camel@pascal>
Content-Type: multipart/mixed; boundary="=-msyejWR+SWg3zrwMfnMX"
Date: Wed, 04 Jun 2008 15:06:04 +0200
Message-Id: <1212584764.32385.36.camel@pascal>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: [linux-dvb] [PATCH] Re:  Ooops in tda827x.c
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


--=-msyejWR+SWg3zrwMfnMX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Attached patch fixes the problem.

Best regards

Sigmund Augdal

On Wed, 2008-06-04 at 01:22 +0200, Sigmund Augdal wrote:
> changeset 49ba58715fe0 (7393) introduces an ooops in tda827x.c in
> tda827xa_lna_gain. The initialization of the "msg" variable accesses
> priv->cfg before the NULL check causing an oops when it is in fact
> NULL. 
> 
> Best regards
> 
> Sigmund Augdal
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

--=-msyejWR+SWg3zrwMfnMX
Content-Disposition: attachment; filename=tda827x-oops.patch
Content-Type: text/x-patch; name=tda827x-oops.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r 6541620a09b7 linux/drivers/media/common/tuners/tda827x.c
--- a/linux/drivers/media/common/tuners/tda827x.c	Tue Jun 03 10:32:16 2008 -0300
+++ b/linux/drivers/media/common/tuners/tda827x.c	Wed Jun 04 15:03:15 2008 +0200
@@ -419,13 +419,14 @@
 	unsigned char buf[] = {0x22, 0x01};
 	int arg;
 	int gp_func;
-	struct i2c_msg msg = { .addr = priv->cfg->switch_addr, .flags = 0,
+	struct i2c_msg msg = { .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
 
 	if (NULL == priv->cfg) {
 		dprintk("tda827x_config not defined, cannot set LNA gain!\n");
 		return;
 	}
+	msg.addr = priv->cfg->switch_addr;
 	if (priv->cfg->config) {
 		if (high)
 			dprintk("setting LNA to high gain\n");

--=-msyejWR+SWg3zrwMfnMX
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-msyejWR+SWg3zrwMfnMX--
