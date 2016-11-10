Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45125
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752287AbcKJIky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 03:40:54 -0500
Date: Thu, 10 Nov 2016 06:40:47 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
Message-ID: <20161110064047.1e0a6b4b@vento.lan>
In-Reply-To: <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
References: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
        <CA+55aFxXoc3GzAXWPZL=RB2xhmhP1acR3m2S_mdoiO97+80kDA@mail.gmail.com>
        <20161108182215.41f1f3d2@vento.lan>
        <CADDKRnD_+uhQc7GyK3FfnDSRUkL5WkZNV7F+TsEhhDdo6O=Vmw@mail.gmail.com>
        <CA+55aFwsYHbXFimTL137Zwbc0bhOmR+XzDnUBmM=Pgn+8xBnWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 11:07:35 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Wed, Nov 9, 2016 at 3:09 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> >
> > Tried patch with no success. Again a NULL ptr dereferece.  
> 
> That patch was pure garbage, I think. Pretty much all the other
> drivers that use the same approach will have the same issue. Adding
> that init function just for the semaphore is crazy.
> 
> I suspect a much simpler approach is to just miove the "data_mutex"
> away from the priv area and into "struct dvb_usb_device" and
> "dvb_usb_adapter". Sure, that grows those structures a tiny bit, and
> not every driver may need that mutex, but it simplifies things
> enormously. Mauro?
> 
>              Linus


[PATCH] cinergyT2-core: move data_mutex to struct dvb_usb_device

The data_mutex is initialized too late, as it is needed for
the device's power control, causing an OOPS:

dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100 PGD 0
Oops: 0002 [#1] SMP
Modules linked in: dvb_usb_cinergyT2(+) dvb_usb
CPU: 0 PID: 2029 Comm: modprobe Not tainted 4.9.0-rc4-dvbmod #24
Hardware name: FUJITSU LIFEBOOK A544/FJNBB35 , BIOS Version 1.17 05/09/2014
task: ffff88020e943840 task.stack: ffff8801f36ec000
RIP: 0010:[<ffffffff846617af>]  [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100
RSP: 0018:ffff8801f36efb10  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88021509bdc8 RCX: 00000000c0000100
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88021509bdcc
RBP: ffff8801f36efb58 R08: ffff88021f216320 R09: 0000000000100000
R10: ffff88021f216320 R11: 00000023fee6c5a1 R12: ffff88020e943840
R13: ffff88021509bdcc R14: 00000000ffffffff R15: ffff88021509bdd0
FS:  00007f21adb86740(0000) GS:ffff88021f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000215bce000 CR4: 00000000001406f0
Stack:
 ffff88021509bdd0 0000000000000000 0000000000000000 ffffffffc0137c80
 ffff88021509bdc8 ffff8801f5944000 0000000000000001 ffffffffc0136b00
 ffff880213e52000 ffff88021509bdc8 ffffffff84661856 ffff88021509bd80
Call Trace:
 [<ffffffff84661856>] ? mutex_lock+0x16/0x25
 [<ffffffffc013616f>] ? cinergyt2_power_ctrl+0x1f/0x60 [dvb_usb_cinergyT2]
 [<ffffffffc012e67e>] ? dvb_usb_device_init+0x21e/0x5d0 [dvb_usb]
 [<ffffffffc0136021>] ? cinergyt2_usb_probe+0x21/0x50 [dvb_usb_cinergyT2]
 [<ffffffff844326f3>] ? usb_probe_interface+0xf3/0x2a0
 [<ffffffff8438e348>] ? driver_probe_device+0x208/0x2b0
 [<ffffffff8438e477>] ? __driver_attach+0x87/0x90
 [<ffffffff8438e3f0>] ? driver_probe_device+0x2b0/0x2b0
 [<ffffffff8438c612>] ? bus_for_each_dev+0x52/0x80
 [<ffffffff8438d983>] ? bus_add_driver+0x1a3/0x220
 [<ffffffff8438ec06>] ? driver_register+0x56/0xd0
 [<ffffffff84431527>] ? usb_register_driver+0x77/0x130
 [<ffffffffc013a000>] ? 0xffffffffc013a000
 [<ffffffff84000426>] ? do_one_initcall+0x46/0x180
 [<ffffffff840eb2c8>] ? free_vmap_area_noflush+0x38/0x70
 [<ffffffff840f3844>] ? kmem_cache_alloc+0x84/0xc0
 [<ffffffff840b802c>] ? do_init_module+0x50/0x1be
 [<ffffffff84095adb>] ? load_module+0x1d8b/0x2100
 [<ffffffff84093020>] ? find_symbol_in_section+0xa0/0xa0
 [<ffffffff84095fe9>] ? SyS_finit_module+0x89/0x90
 [<ffffffff846637a0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
Code: e8 a7 1d 00 00 8b 03 83 f8 01 0f 84 97 00 00 00 48 8b 43 10 4c 8d 7b 08 48 89 63 10 4c 89 3c 24 41 be ff ff ff ff 48 89 44 24 08 <48> 89 20 4c 89 64 24 10 eb 1a 49 c7 44 24 08 02 00 00 00 c6 43 RIP  [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100 RSP <ffff8801f36efb10>
CR2: 0000000000000000

So, move it to the struct dvb_usb_device and initialize it
before calling the driver's callbacks.

Reported-by: Jörg Otte <jrg.otte@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 8ac825413d5a..87e3bd33900d 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -42,7 +42,6 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 struct cinergyt2_state {
 	u8 rc_counter;
 	unsigned char data[64];
-	struct mutex data_mutex;
 };
 
 /* We are missing a release hook with usb_device data */
@@ -56,12 +55,12 @@ static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int enable)
 	struct cinergyt2_state *st = d->priv;
 	int ret;
 
-	mutex_lock(&st->data_mutex);
+	mutex_lock(&d->data_mutex);
 	st->data[0] = CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
 	st->data[1] = enable ? 1 : 0;
 
 	ret = dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
-	mutex_unlock(&st->data_mutex);
+	mutex_unlock(&d->data_mutex);
 
 	return ret;
 }
@@ -71,12 +70,12 @@ static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
 	struct cinergyt2_state *st = d->priv;
 	int ret;
 
-	mutex_lock(&st->data_mutex);
+	mutex_lock(&d->data_mutex);
 	st->data[0] = CINERGYT2_EP1_SLEEP_MODE;
 	st->data[1] = enable ? 0 : 1;
 
 	ret = dvb_usb_generic_rw(d, st->data, 2, st->data, 3, 0);
-	mutex_unlock(&st->data_mutex);
+	mutex_unlock(&d->data_mutex);
 
 	return ret;
 }
@@ -89,7 +88,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	adap->fe_adap[0].fe = cinergyt2_fe_attach(adap->dev);
 
-	mutex_lock(&st->data_mutex);
+	mutex_lock(&d->data_mutex);
 	st->data[0] = CINERGYT2_EP1_GET_FIRMWARE_VERSION;
 
 	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
@@ -97,7 +96,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
 			"state info\n");
 	}
-	mutex_unlock(&st->data_mutex);
+	mutex_unlock(&d->data_mutex);
 
 	/* Copy this pointer as we are gonna need it in the release phase */
 	cinergyt2_usb_device = adap->dev;
@@ -166,7 +165,7 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	mutex_lock(&st->data_mutex);
+	mutex_lock(&d->data_mutex);
 	st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
 
 	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
@@ -202,7 +201,7 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	}
 
 ret:
-	mutex_unlock(&st->data_mutex);
+	mutex_unlock(&d->data_mutex);
 	return ret;
 }
 
@@ -210,7 +209,6 @@ static int cinergyt2_usb_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct dvb_usb_device *d;
-	struct cinergyt2_state *st;
 	int ret;
 
 	ret = dvb_usb_device_init(intf, &cinergyt2_properties,
@@ -218,9 +216,6 @@ static int cinergyt2_usb_probe(struct usb_interface *intf,
 	if (ret < 0)
 		return ret;
 
-	st = d->priv;
-	mutex_init(&st->data_mutex);
-
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 3896ba9a4179..84308569e7dc 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -142,6 +142,7 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 {
 	int ret = 0;
 
+	mutex_init(&d->data_mutex);
 	mutex_init(&d->usb_mutex);
 	mutex_init(&d->i2c_mutex);
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 1448c3d27ea2..12b71acee550 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -404,6 +404,7 @@ struct dvb_usb_adapter {
  *  Powered is in/decremented for each call to modify the state.
  * @udev: pointer to the device's struct usb_device.
  *
+ * @data_mutex: mutex to protect the data structure used to store URB data
  * @usb_mutex: semaphore of USB control messages (reading needs two messages)
  * @i2c_mutex: semaphore for i2c-transfers
  *
@@ -433,6 +434,7 @@ struct dvb_usb_device {
 	int powered;
 
 	/* locking */
+	struct mutex data_mutex;
 	struct mutex usb_mutex;
 
 	/* i2c */


