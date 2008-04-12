Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhIh-0003S5-AU
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:56 +0200
Message-Id: <20080412150447.084696372@gentoo.org>
References: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:47 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Content-Disposition: inline; filename=02_mt312-fix-diseqc.diff
Subject: [linux-dvb] [patch 2/5] mt312: Fix diseqc
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Correct the frequency of the emitted diseqc signal to 22kHz.
Adds sleep(100) to wait for message to be transmitted.

For now the only user of mt312 is b2c2-flexcop, and it
does overwrite all diseqc related functions with own code.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -270,7 +270,7 @@ static int mt312_initfe(struct dvb_front
 				MT312_SYS_CLK) * 2, 1000000);
 
 	/* DISEQC_RATIO */
-	buf[1] = mt312_div(MT312_PLL_CLK, 15000 * 4);
+	buf[1] = mt312_div(MT312_PLL_CLK, 22000 * 4);
 
 	ret = mt312_write(state, SYS_CLK, buf, sizeof(buf));
 	if (ret < 0)
@@ -323,6 +323,9 @@ static int mt312_send_master_cmd(struct 
 	if (ret < 0)
 		return ret;
 
+	/* is there a better way to wait for message to be transmitted */
+	msleep(100);
+
 	/* set DISEQC_MODE[2:0] to zero if a return message is expected */
 	if (c->msg[0] & 0x02) {
 		ret = mt312_writereg(state, DISEQC_MODE, (diseqc_mode & 0x40));

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
