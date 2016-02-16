Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbcBPK3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 05:29:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] [media] siano: firmware buffer is too small
Date: Tue, 16 Feb 2016 08:28:21 -0200
Message-Id: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by KASAN:

	BUG: KASAN: slab-out-of-bounds in memcpy+0x1d/0x40 at addr ffff880000038d8c
	Read of size 128 by task systemd-udevd/2536
	page:ffffea0000000800 count:1 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 0
	flags: 0xffff8000004000(head)
	page dumped because: kasan: bad access detected
	CPU: 1 PID: 2536 Comm: systemd-udevd Not tainted 4.5.0-rc3+ #47
	Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
	  ffff880000038d8c ffff8803b0f1f1e8 ffffffff81933901 0000000000000080
	  ffff8803b0f1f280 ffff8803b0f1f270 ffffffff815602c5 ffffffff8284cf93
	  ffffffff822ddc00 0000000000000282 0000000000000001 ffff88009c7c6000
	Call Trace:
	  [<ffffffff81933901>] dump_stack+0x85/0xc4
	  [<ffffffff815602c5>] kasan_report_error+0x525/0x550
	  [<ffffffff815606e9>] kasan_report+0x39/0x40
	  [<ffffffff8155f84d>] memcpy+0x1d/0x40
	  [<ffffffffa120cb90>] smscore_set_device_mode+0xee0/0x2560 [smsmdtv]

Such error happens at the memcpy code below:

0x4bc0 is in smscore_set_device_mode (drivers/media/common/siano/smscoreapi.c:975).
970					      sizeof(u32) + payload_size));
971
972			data_msg->mem_addr = mem_address;
973			memcpy(data_msg->payload, payload, payload_size);
974
975			rc = smscore_sendrequest_and_wait(coredev, data_msg,
976					data_msg->x_msg_header.msg_length,
977					&coredev->data_download_done);
978
979			payload += payload_size;

The problem is that the Siano driver uses a header to store the firmware,
with requires a few more bytes than allocated.

Tested with:
	PCTV 77e (2013:0257)
	Hauppauge WinTV MiniStick (2040:5510)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smscoreapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 2a8d9a36d6f0..f3a42834d7d6 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1167,8 +1167,8 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 		return rc;
 	}
 	pr_debug("read fw %s, buffer size=0x%zx\n", fw_filename, fw->size);
-	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
-			 GFP_KERNEL | GFP_DMA);
+	fw_buf = kmalloc(ALIGN(fw->size + sizeof(struct sms_firmware),
+			 SMS_ALLOC_ALIGNMENT), GFP_KERNEL | GFP_DMA);
 	if (!fw_buf) {
 		pr_err("failed to allocate firmware buffer\n");
 		rc = -ENOMEM;
-- 
2.5.0

