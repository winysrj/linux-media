Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Fabian Frederick <fabf@skynet.be>,
	Johannes Stezenbach <js@linuxtv.org>, stable@vger.kernel.org
Subject: [PATCH 1/6] [media] em28xx: remove firmware before releasing xc5000 priv state
Date: Sun, 28 Sep 2014 23:23:18 -0300
Message-Id: <aa2aa3055b58c0257f21caf993eb297c49b1e2db.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hybrid_tuner_release_state() can free the priv state, so we need to
release the firmware before calling it.

root@debian:~# rmmod em28xx_dvb em28xx_v4l drxk em28xx
[ 1992.790039] em2884 #0: Closing DVB extension
[ 1992.797623] xc5000 2-0061: destroying instance
[ 1992.799595] general protection fault: 0000 [#1] PREEMPT SMP
[ 1992.800032] Modules linked in: drxk em28xx_dvb(-) em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom
[ 1992.800032] CPU: 3 PID: 2095 Comm: rmmod Not tainted 3.17.0-rc5-00734-g214635f-dirty #91
[ 1992.800032] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 1992.800032] task: ffff88003cf700d0 ti: ffff88003c398000 task.ti: ffff88003c398000
[ 1992.800032] RIP: 0010:[<ffffffff81320721>]  [<ffffffff81320721>] release_firmware+0x2c/0x52
[ 1992.800032] RSP: 0000:ffff88003c39be58  EFLAGS: 00010246
[ 1992.800032] RAX: ffffffff8188d408 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000006
[ 1992.800032] RDX: 0000000000000004 RSI: ffff88003cf70860 RDI: 6b6b6b6b6b6b6b6b
[ 1992.800032] RBP: ffff88003c39be60 R08: 0000000000000200 R09: 0000000000000001
[ 1992.800032] R10: ffff88003c39bcc0 R11: ffffffff82ac6100 R12: ffff88003bc5a000
[ 1992.800032] R13: ffff88003d6a81c8 R14: 00007fd6e977d090 R15: 0000000000000800
[ 1992.800032] FS:  00007fd6e8633700(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
[ 1992.800032] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1992.800032] CR2: 0000000000400184 CR3: 000000003b996000 CR4: 00000000000006a0
[ 1992.800032] Stack:
[ 1992.800032]  ffff88003befcc00 ffff88003c39be80 ffffffff813cbd36 ffff88003bc5a000
[ 1992.800032]  ffff88003baa2000 ffff88003c39bea0 ffffffff813e2f75 ffff88003d6a8000
[ 1992.800032]  ffff88003baa2000 ffff88003c39bec8 ffffffffa0046804 ffff88003baa2000
[ 1992.800032] Call Trace:
[ 1992.800032]  [<ffffffff813cbd36>] xc5000_release+0xa0/0xbf
[ 1992.800032]  [<ffffffff813e2f75>] dvb_frontend_detach+0x35/0x7d
[ 1992.800032]  [<ffffffffa0046804>] em28xx_dvb_fini+0x195/0x1d0 [em28xx_dvb]
[ 1992.800032]  [<ffffffffa0009211>] em28xx_unregister_extension+0x3d/0x79 [em28xx]
[ 1992.800032]  [<ffffffffa0048e20>] em28xx_dvb_unregister+0x10/0x1f0 [em28xx_dvb]
[ 1992.800032]  [<ffffffff810942e8>] SyS_delete_module+0x141/0x19e
[ 1992.800032]  [<ffffffff81488792>] system_call_fastpath+0x16/0x1b
[ 1992.800032] Code: 48 85 ff 48 c7 c0 08 d4 88 81 48 89 e5 53 48 89 fb 74 3b 48 3d 08 d4 88 81 74 10 48 8b 50 08 48 39 53 08 74 18 48 83 c0 18 eb e8 <48> 8b 7b 18 48 85 ff 75 13 48 8b 7b 08 e8 32 16 de ff 48 89 df
[ 1992.800032] RIP  [<ffffffff81320721>] release_firmware+0x2c/0x52
[ 1992.800032]  RSP <ffff88003c39be58>
[ 1992.867774] ---[ end trace 499f4df0704fd661 ]---

Reported-by: Johannes Stezenbach <js@linuxtv.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e44c8aba6074..803a0e63d47e 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1333,9 +1333,9 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
-		hybrid_tuner_release_state(priv);
 		if (priv->firmware)
 			release_firmware(priv->firmware);
+		hybrid_tuner_release_state(priv);
 	}
 
 	mutex_unlock(&xc5000_list_mutex);
-- 
1.9.3

