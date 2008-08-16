Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KUDUg-0006S3-7f
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 06:34:40 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 16 Aug 2008 06:31:21 +0200
References: <200808121443.27020.mldvb@mortal-soul.de>
In-Reply-To: <200808121443.27020.mldvb@mortal-soul.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bglpIAlWTrBkFa4"
Message-Id: <200808160631.23359@orion.escape-edv.de>
Cc: VDR mailing list <vdr@linuxtv.org>
Subject: Re: [linux-dvb] Possible SMP problems with budget_av/saa7134
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

--Boundary-00=_bglpIAlWTrBkFa4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Matthias Dahl wrote:
> Hello all.
> 
> I am resending the following message because I didn't get any response so far 
> and in addition I am putting it on cc' to the vdr devel list. I'd look into 
> this issue myself, yet I don't have the necessary time to dive into the DVB 
> tree. So please, if anyone knows how to debug this or has any hint where the 
> problem could be located... I'd be more than grateful to hear about it.
> 
> By the way, just today after a few minutes of uptime with vdr 1.7.0, I got 
> those (increased the CAM check interval to 5 seconds btw):
> 
> vdr: [3280] ERROR: can't write to CI adapter on device 0: Input/output error
> vdr: [3280] ERROR: can't write to CI adapter on device 0: Invalid argument
> 
> And the CAM stopped working until I restarted vdr. In one forum post someone 
> reported about similar problems with MythTV, so it's becoming more and more 
> likely that this is indeed a problem within the dvb tree. And if it's a SMP 
> problem, it should get fixed because multicore systems will be everywhere 
> pretty soon.
> 
> Thanks again.
> 
> ----------------------------------------------------------------------------------
> 
> Hello all.
> 
> After minutes or hours or days of running vdr 1.4.7, I get the following 
> messages in my syslog: 
> 
>    dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
>    dvb_ca adapter 0: DVB CAM link initialisation failed :(
> 
> When running vdr 1.6.x, the problems are even more frequent/worse and I get
> those:
> 
>   dvb_ca adapter 0: CAM tried to send a buffer larger than the link buffer
>   size (192 > 128)!
>   vdr: [3140] ERROR: can't write to CI adapter on device 0: Input/output error
>   dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
>   dvb_ca adapter 0: DVB CAM link initialisation failed :(
> 
> The result is always the same, the CAM stops decrypting and I have to restart 
> vdr. After a lot of searching around, I've learnt that I am not the only one 
> with those problems and they seem to be related to multi core systems. I read 
> that pining vdr down to one CPU core might help... and indeed it did.
> 
> This cannot be a hardware related issue because...
> 
>  1) meanwhile I switched from a NForce 590 SLI to a X48 chipset and thus also
>     from an AMD64 X2 5600+ (Winchester) to an Intel Core2Duo E8400 (Wolfdale)
> 
>  2) I swapped my KNC One DVB-C Plus for a new one
> 
> And the problems persist.
> 
> I've already written a report to the vdr list which was unfortunately ignored 
> and besides it looks more like a dvb issue itself.
> 
> I was unable to test the kernel with nosmp or similar (which was reported by 
> others to work just fine) because I need this machine to work on.
> 
> I've attached detailed informations about my system and I'd be more than happy 
> to help fix this once and for all, so one can savely rely on vdr again.
> 
> Last but not least, I am using a AlphaCrypt Light module with 3.15 firmware.
> 
> Thanks a lot in advance for every help.
> 
> Best regards,
> Matthias Dahl

Please test the attached patch (untested because I do not own this kind
of hardware). Please save your work before loading the patched driver,
since a locking bug might crash your machine...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--Boundary-00=_bglpIAlWTrBkFa4
Content-Type: text/x-diff;
  charset="us-ascii";
  name="budget-av_camlock_1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="budget-av_camlock_1.diff"

diff -r cbfa05ad2711 linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Aug 01 08:23:41 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Sat Aug 16 06:21:58 2008 +0200
@@ -65,6 +65,7 @@ struct budget_av {
 	struct tasklet_struct ciintf_irq_tasklet;
 	int slot_status;
 	struct dvb_ca_en50221 ca;
+	struct mutex camlock;
 	u8 reinitialise_demod:1;
 };
 
@@ -136,6 +137,8 @@ static int ciintf_read_attribute_mem(str
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTHI);
 	udelay(1);
 
@@ -144,6 +147,9 @@ static int ciintf_read_attribute_mem(str
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 1\n");
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -155,6 +161,8 @@ static int ciintf_write_attribute_mem(st
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTHI);
 	udelay(1);
 
@@ -163,6 +171,9 @@ static int ciintf_write_attribute_mem(st
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 2\n");
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -174,6 +185,8 @@ static int ciintf_read_cam_control(struc
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTLO);
 	udelay(1);
 
@@ -181,8 +194,10 @@ static int ciintf_read_cam_control(struc
 	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 3\n");
-		return -ETIMEDOUT;
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -194,6 +209,8 @@ static int ciintf_write_cam_control(stru
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTLO);
 	udelay(1);
 
@@ -202,6 +219,9 @@ static int ciintf_write_cam_control(stru
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 5\n");
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -274,6 +294,8 @@ static int ciintf_poll_slot_status(struc
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	/* test the card detect line - needs to be done carefully
 	 * since it never goes high for some CAMs on this interface (e.g. topuptv) */
 	if (budget_av->slot_status == SLOTSTATUS_NONE) {
@@ -304,10 +326,13 @@ static int ciintf_poll_slot_status(struc
 			if (budget_av->slot_status != SLOTSTATUS_NONE) {
 				ciintf_slot_shutdown(ca, slot);
 				printk(KERN_INFO "budget-av: cam ejected 5\n");
+				mutex_unlock(&budget_av->camlock);
 				return 0;
 			}
 		}
 	}
+
+	mutex_unlock(&budget_av->camlock);
 
 	/* read from attribute memory in reset/ready state to know when the CAM is ready */
 	if (budget_av->slot_status == SLOTSTATUS_RESET) {
@@ -332,6 +357,7 @@ static int ciintf_init(struct budget_av 
 	struct saa7146_dev *saa = budget_av->budget.dev;
 	int result;
 
+	mutex_init(&budget_av->camlock);
 	memset(&budget_av->ca, 0, sizeof(struct dvb_ca_en50221));
 
 	saa7146_setgpio(saa, 0, SAA7146_GPIO_OUTLO);

--Boundary-00=_bglpIAlWTrBkFa4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_bglpIAlWTrBkFa4--
