Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:8541 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbbJBUj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 16:39:29 -0400
From: Antonio Ospite <ao2@ao2.it>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, moinejf@free.fr,
	Anders Blomdell <anders.blomdell@control.lth.se>,
	Thomas Champagne <lafeuil@gmail.com>,
	Antonio Ospite <ao2@ao2.it>, stable@vger.kernel.org
Subject: [PATCH] [media] gspca: ov534/topro: prevent a division by 0
Date: Fri,  2 Oct 2015 22:33:13 +0200
Message-Id: <1443817993-32406-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance sends a zeroed struct v4l2_streamparm in
v4l2-test-formats.cpp::testParmType(), and this results in a division by
0 in some gspca subdrivers:

  divide error: 0000 [#1] SMP
  Modules linked in: gspca_ov534 gspca_main ...
  CPU: 0 PID: 17201 Comm: v4l2-compliance Not tainted 4.3.0-rc2-ao2 #1
  Hardware name: System manufacturer System Product Name/M2N-E SLI, BIOS
    ASUS M2N-E SLI ACPI BIOS Revision 1301 09/16/2010
  task: ffff8800818306c0 ti: ffff880095c4c000 task.ti: ffff880095c4c000
  RIP: 0010:[<ffffffffa079bd62>]  [<ffffffffa079bd62>] sd_set_streamparm+0x12/0x60 [gspca_ov534]
  RSP: 0018:ffff880095c4fce8  EFLAGS: 00010296
  RAX: 0000000000000000 RBX: ffff8800c9522000 RCX: ffffffffa077a140
  RDX: 0000000000000000 RSI: ffff880095e0c100 RDI: ffff8800c9522000
  RBP: ffff880095e0c100 R08: ffffffffa077a100 R09: 00000000000000cc
  R10: ffff880067ec7740 R11: 0000000000000016 R12: ffffffffa07bb400
  R13: 0000000000000000 R14: ffff880081b6a800 R15: 0000000000000000
  FS:  00007fda0de78740(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000014630f8 CR3: 00000000cf349000 CR4: 00000000000006f0
  Stack:
   ffffffffa07a6431 ffff8800c9522000 ffffffffa077656e 00000000c0cc5616
   ffff8800c9522000 ffffffffa07a5e20 ffff880095e0c100 0000000000000000
   ffff880067ec7740 ffffffffa077a140 ffff880067ec7740 0000000000000016
  Call Trace:
   [<ffffffffa07a6431>] ? v4l_s_parm+0x21/0x50 [videodev]
   [<ffffffffa077656e>] ? vidioc_s_parm+0x4e/0x60 [gspca_main]
   [<ffffffffa07a5e20>] ? __video_do_ioctl+0x280/0x2f0 [videodev]
   [<ffffffffa07a5ba0>] ? video_ioctl2+0x20/0x20 [videodev]
   [<ffffffffa07a59b9>] ? video_usercopy+0x319/0x4e0 [videodev]
   [<ffffffff81182dc1>] ? page_add_new_anon_rmap+0x71/0xa0
   [<ffffffff811afb92>] ? mem_cgroup_commit_charge+0x52/0x90
   [<ffffffff81179b18>] ? handle_mm_fault+0xc18/0x1680
   [<ffffffffa07a15cc>] ? v4l2_ioctl+0xac/0xd0 [videodev]
   [<ffffffff811c846f>] ? do_vfs_ioctl+0x28f/0x480
   [<ffffffff811c86d4>] ? SyS_ioctl+0x74/0x80
   [<ffffffff8154a8b6>] ? entry_SYSCALL_64_fastpath+0x16/0x75
  Code: c7 93 d9 79 a0 5b 5d e9 f1 f3 9a e0 0f 1f 00 66 2e 0f 1f 84 00
    00 00 00 00 66 66 66 66 90 53 31 d2 48 89 fb 48 83 ec 08 8b 46 10 <f7>
    76 0c 80 bf ac 0c 00 00 00 88 87 4e 0e 00 00 74 09 80 bf 4f
  RIP  [<ffffffffa079bd62>] sd_set_streamparm+0x12/0x60 [gspca_ov534]
   RSP <ffff880095c4fce8>
  ---[ end trace 279710c2c6c72080 ]---

Following what the doc says about a zeroed timeperframe (see
http://www.linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-parm.html):

  ...
  To reset manually applications can just set this field to zero.

fix the issue by resetting the frame rate to a default value in case of
an unusable timeperframe.

The fix is done in the subdrivers instead of gspca.c because only the
subdrivers have notion of a default frame rate to reset the camera to.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: stable@vger.kernel.org
---

Hi,

I think the problem in the gspca subdrivers has always been there, so the
patch could be applied to any relevant stable releases.

After the fix, v4l2-compliance runs fine but it gets two failures, I'll send
another mail about those.

After this change gets merged I will also send a patch to use defines for the
default framerates used below as the same value is used in multiple places.

Ah, I ran the patch through scripts/checkpatch.pl from 4.3-rc2 and it
complained about the commit message but I think it may be a false positive.

Ciao ciao,
   Antonio


 drivers/media/usb/gspca/ov534.c | 9 +++++++--
 drivers/media/usb/gspca/topro.c | 6 +++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 146071b..bfff1d1 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -1491,8 +1491,13 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 	struct v4l2_fract *tpf = &cp->timeperframe;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	/* Set requested framerate */
-	sd->frame_rate = tpf->denominator / tpf->numerator;
+	if (tpf->numerator == 0 || tpf->denominator == 0)
+		/* Set default framerate */
+		sd->frame_rate = 30;
+	else
+		/* Set requested framerate */
+		sd->frame_rate = tpf->denominator / tpf->numerator;
+
 	if (gspca_dev->streaming)
 		set_frame_rate(gspca_dev);
 
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index c70ff40..c028a5c 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -4802,7 +4802,11 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 	struct v4l2_fract *tpf = &cp->timeperframe;
 	int fr, i;
 
-	sd->framerate = tpf->denominator / tpf->numerator;
+	if (tpf->numerator == 0 || tpf->denominator == 0)
+		sd->framerate = 30;
+	else
+		sd->framerate = tpf->denominator / tpf->numerator;
+
 	if (gspca_dev->streaming)
 		setframerate(gspca_dev, v4l2_ctrl_g_ctrl(gspca_dev->exposure));
 
-- 
2.6.0

