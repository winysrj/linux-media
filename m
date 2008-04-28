Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SMJS7j004067
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 18:19:28 -0400
Received: from cabrera.red.sld.cu (cabrera.red.sld.cu [201.220.222.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SMJEaW013593
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 18:19:16 -0400
From: Maykel Moya <moya-lists@infomed.sld.cu>
To: video4linux-list <video4linux-list@redhat.com>
Content-Type: multipart/mixed; boundary="=-35J2FteTU1WzPs7ybUY7"
Date: Mon, 28 Apr 2008 18:20:26 -0400
Message-Id: <1209421227.17970.46.camel@localhost>
Mime-Version: 1.0
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] tm6000: make tree buildable
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


--=-35J2FteTU1WzPs7ybUY7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The tip of tm6010 as of 20080428 (rev: baa8870a) fails to build from
source. Find attached a patch to make it buildable.

Signed-off-by: Maykel Moya <moya@infomed.sld.cu>


--=-35J2FteTU1WzPs7ybUY7
Content-Disposition: attachment; filename=make-tree-buildable
Content-Type: text/plain; name=make-tree-buildable; charset=UTF-8
Content-Transfer-Encoding: 7bit

FIX: Make tree actually build

diff -r c945d3faba4f linux/drivers/media/video/tm6000/tm6000-dvb.c
--- a/linux/drivers/media/video/tm6000/tm6000-dvb.c	Mon Apr 28 01:50:24 2008 -0400
+++ b/linux/drivers/media/video/tm6000/tm6000-dvb.c	Mon Apr 28 10:09:01 2008 -0400
@@ -212,6 +212,8 @@
 	return (!dvb->frontend) ? -1 : 0;
 }
 
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 int tm6000_dvb_register(struct tm6000_core *dev)
 {
 	int ret = -1;
@@ -229,7 +231,7 @@
 	}
 
 	ret = dvb_register_adapter(&dvb->adapter, "Trident TVMaster 6000 DVB-T",
-							  THIS_MODULE, &dev->udev->dev);
+							  THIS_MODULE, &dev->udev->dev, adapter_nr);
 	dvb->adapter.priv = dev;
 
 	if (dvb->frontend) {

--=-35J2FteTU1WzPs7ybUY7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-35J2FteTU1WzPs7ybUY7--
