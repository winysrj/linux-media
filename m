Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RM5Zxr003511
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:05:36 -0400
Received: from smtp6.pp.htv.fi (smtp6.pp.htv.fi [213.243.153.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RM5OFN004117
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 18:05:24 -0400
Date: Thu, 28 Aug 2008 01:04:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <David.Woodhouse@intel.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <20080827220430.GP11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: [2.6 patch] dabusb_fpga_download(): fix a memory leak
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

This patch fixes a memory leak in an error path.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/dabusb.c |    1 +
 1 file changed, 1 insertion(+)

dbff650900ac6393678ff51a8e0b4986fece1bd0 
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 48f4b92..79faedf 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -389,34 +389,35 @@ static int dabusb_fpga_init (pdabusb_t s, pbulk_transfer_t b)
 static int dabusb_fpga_download (pdabusb_t s, const char *fname)
 {
 	pbulk_transfer_t b = kmalloc (sizeof (bulk_transfer_t), GFP_KERNEL);
 	const struct firmware *fw;
 	unsigned int blen, n;
 	int ret;
 
 	dbg("Enter dabusb_fpga_download (internal)");
 
 	if (!b) {
 		err("kmalloc(sizeof(bulk_transfer_t))==NULL");
 		return -ENOMEM;
 	}
 
 	ret = request_firmware(&fw, "dabusb/bitstream.bin", &s->usbdev->dev);
 	if (ret) {
 		err("Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
+		kfree(b);
 		return ret;
 	}
 
 	b->pipe = 1;
 	ret = dabusb_fpga_clear (s, b);
 	mdelay (10);
 	blen = fw->data[73] + (fw->data[72] << 8);
 
 	dbg("Bitstream len: %i", blen);
 
 	b->data[0] = 0x2b;
 	b->data[1] = 0;
 	b->data[2] = 0;
 	b->data[3] = 60;
 
 	for (n = 0; n <= blen + 60; n += 60) {
 		// some cclks for startup

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
