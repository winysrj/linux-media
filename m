Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:61229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaHUCEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 22:04:51 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAM009EQWG1NL00@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Aug 2014 11:04:49 +0900 (KST)
From: Changbing Xiong <cb.xiong@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, crope@iki.fi
Subject: [PATCH 1/3] media: fix kernel deadlock due to tuner pull-out while
 playing
Date: Thu, 21 Aug 2014 10:04:25 +0800
Message-id: <1408586666-2105-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enviroment: odroidx2 + Hauppauge(WinTV-Aero-M)
Normally, ADAP_STREAMING bit is set in dvb_usb_start_feed and cleared in dvb_usb_stop_feed.
But in exceptional cases, for example, when the tv is playing programs, and the tuner is pulled out.
then dvb_usbv2_disconnect is called, it will first call dvb_usbv2_adapter_frontend_exit to stop
dvb_frontend_thread, and then call dvb_usbv2_adapter_dvb_exit to clear ADAP_STREAMING bit, At this point,
if dvb_frontend_thread is sleeping and wait for ADAP_STREAMING to be cleared to get out of sleep.
then dvb_frontend_thread can never be stoped, because clearing ADAP_STREAMING bit is performed after
dvb_frontend_thread is stopped(i.e. performed in dvb_usbv2_adapter_dvb_exit), So deadlock becomes true.

[  240.822037] INFO: task khubd:497 blocked for more than 120 seconds.
[  240.822655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.830493] khubd           D c0013b3c     0   497      2 0x00000000
[  240.836996] [<c0013b3c>] (__schedule+0x200/0x54c) from [<c00110f4>] (schedule_timeout+0x14c/0x19c)
[  240.845940] [<c00110f4>] (schedule_timeout+0x14c/0x19c) from [<c00137f4>] (wait_for_common+0xac/0x150)
[  240.855234] [<c00137f4>] (wait_for_common+0xac/0x150) from [<c004989c>] (kthread_stop+0x58/0x90)
[  240.864004] [<c004989c>] (kthread_stop+0x58/0x90) from [<c03b2ebc>] (dvb_frontend_stop+0x3c/0x9c)
[  240.872849] [<c03b2ebc>] (dvb_frontend_stop+0x3c/0x9c) from [<c03b2f3c>] (dvb_unregister_frontend+0x20/0xd8)
[  240.882666] [<c03b2f3c>] (dvb_unregister_frontend+0x20/0xd8) from [<c03ed938>] (dvb_usbv2_exit+0x68/0xfc)
[  240.892204] [<c03ed938>] (dvb_usbv2_exit+0x68/0xfc) from [<c03eda18>] (dvb_usbv2_disconnect+0x4c/0x70)
[  240.901499] [<c03eda18>] (dvb_usbv2_disconnect+0x4c/0x70) from [<c031c050>] (usb_unbind_interface+0x58/0x188)
[  240.911395] [<c031c050>] (usb_unbind_interface+0x58/0x188) from [<c02c3e78>] (__device_release_driver+0x74/0xd0)
[  240.921544] [<c02c3e78>] (__device_release_driver+0x74/0xd0) from [<c02c3ef0>] (device_release_driver+0x1c/0x28)
[  240.931697] [<c02c3ef0>] (device_release_driver+0x1c/0x28) from [<c02c39b8>] (bus_remove_device+0xc4/0xe4)
[  240.941332] [<c02c39b8>] (bus_remove_device+0xc4/0xe4) from [<c02c1344>] (device_del+0xf4/0x178)
[  240.950106] [<c02c1344>] (device_del+0xf4/0x178) from [<c0319eb0>] (usb_disable_device+0xa0/0x1c8)
[  240.959040] [<c0319eb0>] (usb_disable_device+0xa0/0x1c8) from [<c03128b4>] (usb_disconnect+0x88/0x188)
[  240.968326] [<c03128b4>] (usb_disconnect+0x88/0x188) from [<c0313edc>] (hub_thread+0x4d0/0x1200)
[  240.977100] [<c0313edc>] (hub_thread+0x4d0/0x1200) from [<c0049690>] (kthread+0xa4/0xb0)
[  240.985174] [<c0049690>] (kthread+0xa4/0xb0) from [<c0009118>] (ret_from_fork+0x14/0x3c)
[  240.993259] INFO: task kdvb-ad-0-fe-0:3256 blocked for more than 120 seconds.
[  241.000349] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.008162] kdvb-ad-0-fe-0  D c0013b3c     0  3256      2 0x00000000
[  241.014507] [<c0013b3c>] (__schedule+0x200/0x54c) from [<c03eda44>] (wait_schedule+0x8/0x10)
[  241.022924] [<c03eda44>] (wait_schedule+0x8/0x10) from [<c001120c>] (__wait_on_bit+0x74/0xb8)
[  241.031434] [<c001120c>] (__wait_on_bit+0x74/0xb8) from [<c00112b8>] (out_of_line_wait_on_bit+0x68/0x70)
[  241.040902] [<c00112b8>] (out_of_line_wait_on_bit+0x68/0x70) from [<c03e5e88>] (dvb_usb_fe_sleep+0xf4/0xfc)
[  241.050618] [<c03e5e88>] (dvb_usb_fe_sleep+0xf4/0xfc) from [<c03b4b74>] (dvb_frontend_thread+0x124/0x4e8)
[  241.060164] [<c03b4b74>] (dvb_frontend_thread+0x124/0x4e8) from [<c0049690>] (kthread+0xa4/0xb0)
[  241.068929] [<c0049690>] (kthread+0xa4/0xb0) from [<c0009118>] (ret_from_fork+0x14/0x3c)

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
old mode 100644
new mode 100755
index de02db8..d2da3be
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -770,9 +770,9 @@ static int dvb_usbv2_adapter_exit(struct dvb_usb_device *d)

 	for (i = MAX_NO_OF_ADAPTER_PER_DEVICE - 1; i >= 0; i--) {
 		if (d->adapter[i].props) {
-			dvb_usbv2_adapter_frontend_exit(&d->adapter[i]);
 			dvb_usbv2_adapter_dvb_exit(&d->adapter[i]);
 			dvb_usbv2_adapter_stream_exit(&d->adapter[i]);
+			dvb_usbv2_adapter_frontend_exit(&d->adapter[i]);
 		}
 	}

--
1.7.9.5

