Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1M7Phwr007739
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 02:25:43 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1M7PAxs032589
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 02:25:12 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JSSHG-00086o-R8
	for video4linux-list@redhat.com; Fri, 22 Feb 2008 07:25:02 +0000
Received: from 62-20-103-122.customer.telia.com ([62.20.103.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 07:25:02 +0000
Received: from yarrick by 62-20-103-122.customer.telia.com with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 07:25:02 +0000
To: video4linux-list@redhat.com
From: Erik Ekman <yarrick@kryo.se>
Date: Fri, 22 Feb 2008 07:17:41 +0000 (UTC)
Message-ID: <loom.20080222T071446-180@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] bttv i2c: printk() tweaks
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

Hi there

(Resending through Gmane, didnt seem to work to post directly)

On my box with Kubuntu (running 2.6.22-ubuntu14) and bt848 card my dmesg looks 
like this:

[   59.580794] bttv0: Hauppauge eeprom indicates model#56104
[   59.580796] bttv0: using tuner=5
[   59.580859] bttv0: i2c: checking for MSP34xx @ 0x80... <6>/build/buildd/
linux-source-2.6.22-2.6.22/drivers/usb/class/usblp.c: usblp0: USB  
Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x03F0 pid 0x0517
[   59.625235] usbcore: registered new interface driver usblp
[   59.625239] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/class 
usblp.c: v0.13: USB Printer Device Class driver
[   59.689345] not found
[   59.689351] bttv0: i2c: checking for TDA9875 @ 0xb0... <5>sd 0:0:0:0: [sda] 
Attached SCSI removable disk
[   59.969741] sd 0:0:0:1: [sdb] Attached SCSI removable disk
[   59.972012] not found
[   59.972017] bttv0: i2c: checking for TDA7432 @ 0x8a... <5>sd 0:0:0:2: [sdc] 
Attached SCSI removable disk
[   59.979097] sd 0:0:0:3: [sdd] Attached SCSI removable disk
[   60.004267] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   60.004294] sd 0:0:0:1: Attached scsi generic sg1 type 0
[   60.004319] sd 0:0:0:2: Attached scsi generic sg2 type 0
[   60.004345] sd 0:0:0:3: Attached scsi generic sg3 type 0
[   60.043115] not found
[   60.370001] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   60.410211] tuner 1-0061: chip found @ 0xc2 (bt848 #0 [sw])
[   60.410239] tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   60.410243] tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   60.417156] bttv0: registered device video0
[   60.417178] bttv0: registered device vbi0

The "not found" part of the i2c code gets printed on its own row due
to lots of modules loading at the same time. Patch below against
latest hg fixes this, and I also added KERN_* in some places.

Comments are welcome. Please CC me, I am not on the list.

/Erik

------------------------------------------


bttv i2c: printk() tweaks
Signed-off-by: Erik Ekman <yarrick@kryo.se>

diff -r f89d5927677a linux/drivers/media/video/bt8xx/bttv-i2c.c
--- a/linux/drivers/media/video/bt8xx/bttv-i2c.c        Mon Feb 18
13:03:16 2008 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c        Tue Feb 19
23:17:31 2008 +0100
@@ -255,7 +255,7 @@ static int bttv_i2c_xfer(struct i2c_adap
       int i;

       if (i2c_debug)
-               printk("bt-i2c:");
+               printk(KERN_DEBUG "bt-i2c:");
       btwrite(BT848_INT_I2CDONE|BT848_INT_RACK, BT848_INT_STAT);
       for (i = 0 ; i < num; i++) {
               if (msgs[i].flags & I2C_M_RD) {
@@ -358,21 +358,21 @@ int bttv_I2CRead(struct bttv *btv, unsig

       if (0 != btv->i2c_rc)
               return -1;
-       if (bttv_verbose && NULL != probe_for)
-               printk(KERN_INFO "bttv%d: i2c: checking for %s @ 0x%02x... ",
-                      btv->c.nr,probe_for,addr);
       btv->i2c_client.addr = addr >> 1;
       if (1 != i2c_master_recv(&btv->i2c_client, &buffer, 1)) {
               if (NULL != probe_for) {
                       if (bttv_verbose)
-                               printk("not found\n");
+                               printk(KERN_INFO
+                                       "bttv%d: i2c: no %s found @ 0x%02X\n",
+                                       btv->c.nr, probe_for, addr);
               } else
-                       printk(KERN_WARNING "bttv%d: i2c read 0x%x: error\n",
+                       printk(KERN_WARNING "bttv%d: i2c: read @ 0x%x: error\n",
                              btv->c.nr,addr);
               return -1;
       }
       if (bttv_verbose && NULL != probe_for)
-               printk("found\n");
+               printk(KERN_INFO "bttv%d: i2c: found %s @ 0x%02X\n",
+                       btv->c.nr, probe_for, addr);
       return buffer;
 }

@@ -423,7 +423,7 @@ static void do_i2c_scan(char *name, stru
               rc = i2c_master_recv(c,&buf,0);
               if (rc < 0)
                       continue;
-               printk("%s: i2c scan: found device @ 0x%x  [%s]\n",
+               printk(KERN_INFO "%s: i2c scan: found device @ 0x%x  [%s]\n",
                      name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
       }
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
