Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jmea6-000478-Sw
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 02:35:59 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: Robert Schedel <r.schedel@yahoo.de>
Date: Fri, 18 Apr 2008 02:34:33 +0200
References: <47F9E95D.6070705@yahoo.de> <48066F62.8000709@yahoo.de>
	<48076C7A.7070901@yahoo.de>
In-Reply-To: <48076C7A.7070901@yahoo.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ay+BIk9bV0s2khJ"
Message-Id: <200804180234.34558@orion.escape-edv.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
Reply-To: linux-dvb@linuxtv.org
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

--Boundary-00=_ay+BIk9bV0s2khJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Robert Schedel wrote:
> Robert Schedel wrote:
> 
> > Is the 250ms timeout an approved limit? Decreasing it would push the
> > load further down. Probably it still has to cover slow CAMs as well as a
> > stressed PCI bus. Unfortunately, without CAM/CI I cannot make any
> > statements myself.
> 
> Just got another idea to improve the code: Function 
> "saa7146_wait_for_debi_done_sleep" could be reworked to use what is 
> known as "truncated binary exponential backoff" algorithm. IOW, on each 
> sleep duplicate the period from 1ms until a fixed maximum, e.g. 32ms. 
> This way polling ends fast for those users with fast bus/CAM, and those 
> requiring 200ms due to slow bus/CAM should not worry about e.g. 216ms 
> response time.
> 
> My first tests look promising (load goes down to 0). However, is not the 
> simple BEB algorithm already patented?

Load should go down to 0 if the sleep call does not busy-wait.

Please test whether the attached code fixes the problem.
Btw, I will not claim a patent for that. :D

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_ay+BIk9bV0s2khJ
Content-Type: text/x-diff;
  charset="us-ascii";
  name="saa7146_sleep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="saa7146_sleep.diff"

diff -r f500c56d9064 linux/drivers/media/common/saa7146_core.c
--- a/linux/drivers/media/common/saa7146_core.c	Fri Apr 11 11:22:15 2008 +0200
+++ b/linux/drivers/media/common/saa7146_core.c	Fri Apr 18 02:25:39 2008 +0200
@@ -64,8 +64,10 @@ static inline int saa7146_wait_for_debi_
 {
 	unsigned long timeout;
 	int err;
+	bool slow;
 
 	/* wait for registers to be programmed */
+	slow = false;
 	timeout = jiffies + usecs_to_jiffies(us1);
 	while (1) {
 		err = time_after(jiffies, timeout);
@@ -77,10 +79,12 @@ static inline int saa7146_wait_for_debi_
 					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
-		msleep(1);
+		msleep(slow ? 10 : 1);
+		slow = true;
 	}
 
 	/* wait for transfer to complete */
+	slow = false;
 	timeout = jiffies + usecs_to_jiffies(us2);
 	while (1) {
 		err = time_after(jiffies, timeout);
@@ -92,7 +96,8 @@ static inline int saa7146_wait_for_debi_
 				"completion\n",	dev->name, __func__));
 			return -ETIMEDOUT;
 		}
-		msleep(1);
+		msleep(slow ? 10 : 1);
+		slow = true;
 	}
 
 	return 0;

--Boundary-00=_ay+BIk9bV0s2khJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_ay+BIk9bV0s2khJ--
