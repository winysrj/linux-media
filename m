Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5N0oCM9005917
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 20:50:13 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5N0nfN6001314
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 20:49:41 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <D5F1658C-2441-4532-859E-D9ABECA20BA5@tvwhere.com>
References: <de8cad4d0806150505k6b865dedq359d278ab467c801@mail.gmail.com>
	<1213567472.3173.50.camel@palomino.walls.org>
	<1213573393.2683.85.camel@pc10.localdom.local>
	<1213579027.3164.36.camel@palomino.walls.org>
	<D5F1658C-2441-4532-859E-D9ABECA20BA5@tvwhere.com>
Content-Type: multipart/mixed; boundary="=-QNAE6KG2FvPjzMGj76s9"
Date: Sun, 22 Jun 2008 20:45:50 -0400
Message-Id: <1214181950.15114.27.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, mark@npsl.co.uk, linux-dvb@linuxtv.org,
	ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] cx18 - dmesg errors and ir transmit
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-QNAE6KG2FvPjzMGj76s9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-06-17 at 09:17 -0400, Brandon Jenkins wrote:
> >> Am Sonntag, den 15.06.2008, 18:04 -0400 schrieb Andy Walls:
> >>> On Sun, 2008-06-15 at 08:05 -0400, Brandon Jenkins wrote:
> >
> >>>> Also, I have noticed a new message in dmesg indicating that ir
> >>>> transmitters may now be accessible? Is there anything I need to  
> >>>> do to
> >>>> make use of them?
> >>>>

> >>> I haven't had a chance to try the IR blaster out yet (it was on my  
> >>> todo
> >>> list before Feb 2009).  "Mark's brain dump" has a modified lirc  
> >>> package
> >>> for the PVR-150 IR blaster:
> >>>
> >>> http://www.blushingpenguin.com/mark/blog/?p=24
> >>> http://charles.hopto.org/blog/?p=24
> >>>

> Andy,
> 
> Thank you for taking an interest. I am not quite sure what you said  
> above, but if you need someone to test I am willing to do so. While I  
> was trying to figure out how to make this work; I did find the  
> lirc_pvr150 code, but got lost when trying to make it work with the  
> cx18. I do have the firmware downloaded as well.
> 
> I can set up a HG clone of which ever branch of yours you'd like me to  
> use. The only drivers I compile are for the cx18 and for the HD-PVR,  
> which I can merge into your branch.

Brandon,

I have made changes to the cx18 driver code to add in the IR chip reset
support for the Z8F0811 IR microcontroller chip on the HVR-1600.  I have
done no testing aside from making sure that the change didn't break the
cx18 driver when not using IR.

You can find it as the latest change in this repository:

http://linuxtv.org/hg/~awalls/cx18-i2c/


I am also including my best guess at a patch to the lirc_pvr150.c module
for the HVR-1600.  I have not compiled it; I have not tested it.  It's
what I think needed to be done, which is not a lot given the HVR-1600's
similarity to the PVR-150.  Please let me know how testing turns out.

Regards,
Andy

--=-QNAE6KG2FvPjzMGj76s9
Content-Disposition: attachment; filename=lirc-pvr150-cx18.diff
Content-Type: text/x-patch; name=lirc-pvr150-cx18.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- lirc/drivers/lirc_pvr150/lirc_pvr150.c.orig	2008-06-22 20:04:23.000000000 -0400
+++ lirc/drivers/lirc_pvr150/lirc_pvr150.c	2008-06-22 20:25:49.000000000 -0400
@@ -67,6 +67,7 @@
 /* We need to be able to reset the crappy IR chip by talking to the ivtv driver */
 struct ivtv;
 void ivtv_reset_ir_gpio(struct ivtv *itv);
+void cx18_reset_ir_gpio(void *data);
 
 struct IR 
 {
@@ -197,7 +198,12 @@ static int add_to_buf(struct IR *ir)
 			printk(KERN_ERR "lirc_pvr150: polling the IR receiver "
 			                "chip failed, trying reset\n");
 			
-			ivtv_reset_ir_gpio(i2c_get_adapdata(ir->c_rx.adapter));
+			if (strncmp(ir->c_rx.name, "cx18", 4)) 
+				ivtv_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_rx.adapter));
+			else
+				cx18_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_rx.adapter));
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout((100 * HZ + 999) / 1000);
 			ir->need_boot = 1;
@@ -983,7 +989,12 @@ static ssize_t write(struct file *filep,
 				up(&ir->lock);
 				return ret;
 			}
-			ivtv_reset_ir_gpio(i2c_get_adapdata(ir->c_tx.adapter));
+			if (strncmp(ir->c_tx.name, "cx18", 4)) 
+				ivtv_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_tx.adapter));
+			else
+				cx18_reset_ir_gpio(
+					i2c_get_adapdata(ir->c_tx.adapter));
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout((100 * HZ + 999) / 1000);
 			ir->need_boot = 1;
@@ -1434,6 +1445,7 @@ int init_module(void)
 {
 	init_MUTEX(&tx_data_lock);
 	request_module("ivtv");
+	request_module("cx18");
 	request_module("firmware_class");
 	i2c_add_driver(&driver);
 	return 0;

--=-QNAE6KG2FvPjzMGj76s9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-QNAE6KG2FvPjzMGj76s9--
