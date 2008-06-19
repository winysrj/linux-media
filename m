Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5J8p8Oa028289
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 04:51:08 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5J8os6h020122
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 04:50:54 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: video4linux-list@redhat.com
Date: Thu, 19 Jun 2008 10:08:04 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_lPhWIMOjL3tJKK0"
Message-Id: <200806191008.05063.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: [PATCH] cx88-dvb: Fix Oops in case no i2c bus is available
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

--Boundary-00=_lPhWIMOjL3tJKK0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there!

The attached patch will fix an Oops occurring in cx88-dvb when cx88 core does 
not have a valid i2c-bus registered.

The reason for me is different and will be handled (and solved I hope) in 
another thread, but the Oops should not be here and so this is fixed first.

Regards
Matthias

--Boundary-00=_lPhWIMOjL3tJKK0
Content-Type: text/x-diff;
  charset="utf-8";
  name="cx88-dvb-oops-i2c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-dvb-oops-i2c.diff"

cx88-dvb: Fix Oops in case no i2c bus is available

For me loading i2c_algo_bit with bit_test=1 detects "SDA stuck high" and
aborts registering the cx88 i2c-bus. cx88-dvb however does not check the
registration success and just uses core->i2c_adap to attach dvb frontend
modules leading to an oops in the first i2c_transfer call.
Added a check for i2c registration success before attaching a frontend and
dvb_register will return -EINVAL in error case.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-dvb.c
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c
@@ -533,6 +533,11 @@ static int dvb_register(struct cx8802_de
 	dev->dvb.name = core->name;
 	dev->ts_gen_cntrl = 0x0c;
 
+	if (0 != core->i2c_rc) {
+		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
+		goto frontend_detach;
+	}
+
 	/* init frontend */
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_DVB_T1:

--Boundary-00=_lPhWIMOjL3tJKK0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_lPhWIMOjL3tJKK0--
