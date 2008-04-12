Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhIh-0003S4-A1
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:56 +0200
Message-Id: <20080412150445.783923284@gentoo.org>
References: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:46 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Content-Disposition: inline; filename=01_mt312-var-types.diff
Subject: [linux-dvb] [patch 1/5] mt312: Cleanup buffer variables of
	read/write functions
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

Change type of buffer variables from void* to u8* to save some casts.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -58,7 +58,7 @@ static int debug;
 #define MT312_PLL_CLK		10000000UL	/* 10 MHz */
 
 static int mt312_read(struct mt312_state *state, const enum mt312_reg_addr reg,
-		      void *buf, const size_t count)
+		      u8 *buf, const size_t count)
 {
 	int ret;
 	struct i2c_msg msg[2];
@@ -84,7 +84,7 @@ static int mt312_read(struct mt312_state
 		int i;
 		dprintk("R(%d):", reg & 0x7f);
 		for (i = 0; i < count; i++)
-			printk(" %02x", ((const u8 *) buf)[i]);
+			printk(" %02x", buf[i]);
 		printk("\n");
 	}
 
@@ -92,7 +92,7 @@ static int mt312_read(struct mt312_state
 }
 
 static int mt312_write(struct mt312_state *state, const enum mt312_reg_addr reg,
-		       const void *src, const size_t count)
+		       const u8 *src, const size_t count)
 {
 	int ret;
 	u8 buf[count + 1];
@@ -102,7 +102,7 @@ static int mt312_write(struct mt312_stat
 		int i;
 		dprintk("W(%d):", reg & 0x7f);
 		for (i = 0; i < count; i++)
-			printk(" %02x", ((const u8 *) src)[i]);
+			printk(" %02x", src[i]);
 		printk("\n");
 	}
 
@@ -463,7 +463,7 @@ static int mt312_read_snr(struct dvb_fro
 	int ret;
 	u8 buf[2];
 
-	ret = mt312_read(state, M_SNR_H, &buf, sizeof(buf));
+	ret = mt312_read(state, M_SNR_H, buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
@@ -478,7 +478,7 @@ static int mt312_read_ucblocks(struct dv
 	int ret;
 	u8 buf[2];
 
-	ret = mt312_read(state, RS_UBC_H, &buf, sizeof(buf));
+	ret = mt312_read(state, RS_UBC_H, buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
