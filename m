Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CL6HO2010105
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 17:06:17 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CL65ae017900
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 17:06:05 -0400
Message-ID: <4828B13A.4070606@users.sourceforge.net>
Date: Mon, 12 May 2008 23:06:02 +0200
From: =?ISO-8859-1?Q?Andr=E9_AUZI?= <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: PATCH: Add remote control support for ITEMS ITV-301 PCI Stereo TV
 Tuner [2/2]
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

Hi list,

here's the second patch which adds the remote control support for the 
mentioned card.

Regards,
Andre

# HG changeset patch
# User Andre Auzi <aauzi@users.sourceforge.net>
# Date 1210624981 -7200
# Node ID e8de7c0a8b65064815782f2d655fbb5c4092bc94
# Parent  73ccafbb571a2678f115635339e540a97c301e5f
Add remote control support for ITEMS ITV-301 PCI Stereo TV Tuner

From: Andre Auzi <aauzi@users.sourceforge.net>



Signed-off-by: Andre Auzi <aauzi@users.sourceforge.net>

diff -r 73ccafbb571a -r e8de7c0a8b65 
linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Mon May 12 
22:08:59 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Mon May 12 
22:43:01 2008 +0200
@@ -5697,6 +5697,7 @@ int saa7134_board_init1(struct saa7134_d
       case SAA7134_BOARD_BEHOLD_505FM:
       case SAA7134_BOARD_BEHOLD_507_9FM:
       case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
+       case SAA7134_BOARD_ITEMS_ITV301:
               dev->has_remote = SAA7134_REMOTE_GPIO;
               break;
       case SAA7134_BOARD_FLYDVBS_LR300:
diff -r 73ccafbb571a -r e8de7c0a8b65 
linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c Mon May 12 
22:08:59 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c Mon May 12 
22:43:01 2008 +0200
@@ -423,6 +423,18 @@ int saa7134_input_init1(struct saa7134_d
               mask_keydown = 0xf00000;
               polling = 50; /* ms */
               break;
+       case SAA7134_BOARD_ITEMS_ITV301:
+               ir_codes     = ir_codes_manli;
+               mask_keycode = 0x00001f00;
+               mask_keyup   = 0x00004000;
+               polling      = 12; /* ms : has to be fast enough to 
sample auto
+                                   * repeat sequences - Nyquist and 
Shannon
+                                   * said so (or something quite similar).
+                                   * We must trust them.
+                                   * Tuned to have at minimun one no 
change
+                                   * for each key state when auto 
repeat is
+                                   * active.
+                                   */
       }
       if (NULL == ir_codes) {
               printk("%s: Oops: IR config error [card=%d]\n",

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
