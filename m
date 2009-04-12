Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:31999 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZDLC4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 22:56:21 -0400
Received: by wa-out-1112.google.com with SMTP id j5so822086wah.21
        for <linux-media@vger.kernel.org>; Sat, 11 Apr 2009 19:56:19 -0700 (PDT)
Message-Id: <3C37DD03-2647-4CC8-8844-6975F1744AEC@gmail.com>
From: Mino Taoyama <mtaoyama@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Patch for Lorex QLR0440 (BTTV)
Date: Sat, 11 Apr 2009 19:56:17 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm new to this list so please be kind if I do something improper.

I have a patch that adds support for the Lorex QLR0440 CCTV card.  It  
is 4 channel multiplex input to a single BT878. It doesn't have an  
EEPROM so it can't be automatically identified. The change was that  
the card has an external video mux that is controlled by GPIO[16:17].

Below is the "hg diff".  I have tested it on my system and it works  
for me.

Can someone please let me know if I changed the code appropriately and  
if I created the patch correctly so that it can be submitted?

Thanks,
Mino
--------

diff -r dba0b6fae413 linux/Documentation/video4linux/CARDLIST.bttv
--- a/linux/Documentation/video4linux/CARDLIST.bttv	Thu Apr 09  
08:21:42 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.bttv	Sat Apr 11  
18:24:08 2009 -0700
@@ -158,3 +158,4 @@
  157 -> Geovision GV-800(S) (master)                        [800a:763d]
  158 -> Geovision GV-800(S) (slave)                         [800b: 
763d,800c:763d,800d:763d]
  159 -> ProVideo PV183                                       
[1830 
: 
1540,1831 
:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]
+160 -> Lorex QLR0440
diff -r dba0b6fae413 linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Apr 09 08:21:42  
2009 -0300
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Sat Apr 11 18:24:08  
2009 -0700
@@ -79,6 +79,9 @@
  static void gv800s_muxsel(struct bttv *btv, unsigned int input);
  static void gv800s_init(struct bttv *btv);

+static void qlr0440_muxsel(struct bttv *btv, unsigned int input);
+static void qlr0440_init(struct bttv *btv);
+
  static int terratec_active_radio_upgrade(struct bttv *btv);
  static int tea5757_read(struct bttv *btv);
  static int tea5757_write(struct bttv *btv, int value);
@@ -2940,6 +2943,18 @@
  		.tuner_type     = TUNER_ABSENT,
  		.tuner_addr	= ADDR_UNSET,
  	},
+	[BTTV_BOARD_LOREX_QLR0440] = {
+		.name           = "Lorex QLR0440",
+		.video_inputs   = 4,
+		/* .audio_inputs= 0, */
+		.svhs           = NO_SVHS,
+		.muxsel         = MUXSEL(2, 2, 2, 2),
+		.muxsel_hook    = qlr0440_muxsel,
+		.needs_tvaudio  = 0,
+		.pll            = PLL_28,
+		.tuner_type     = TUNER_ABSENT,
+		.tuner_addr	= ADDR_UNSET,
+	},
  };

  static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
@@ -3471,6 +3486,8 @@
  	case BTTV_BOARD_GEOVISION_GV800S:
  		gv800s_init(btv);
  		break;
+	case BTTV_BOARD_LOREX_QLR0440:
+		qlr0440_init(btv);
  	}

  	/* pll configuration */
@@ -4913,6 +4930,20 @@
  	master[btv->c.nr+3] = btv;
  }

+static void qlr0440_muxsel(struct bttv *btv, unsigned int input)
+{
+	/* video mux */
+	gpio_bits(0x030000, input << 16);
+}
+
+static void qlr0440_init(struct bttv *btv)
+{
+	/* enable gpio bits, mask obtained via btSpy */
+	gpio_inout(0xffffff, 0x030000);
+	gpio_write(0x000000);
+}
+
+
  /*  
----------------------------------------------------------------------- */
  /* motherboard chipset specific  
stuff                                      */

diff -r dba0b6fae413 linux/drivers/media/video/bt8xx/bttv.h
--- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Apr 09 08:21:42 2009  
-0300
+++ b/linux/drivers/media/video/bt8xx/bttv.h	Sat Apr 11 18:24:08 2009  
-0700
@@ -186,7 +186,7 @@
  #define BTTV_BOARD_GEOVISION_GV800S	   0x9d
  #define BTTV_BOARD_GEOVISION_GV800S_SL	   0x9e
  #define BTTV_BOARD_PV183                   0x9f
-
+#define BTTV_BOARD_LOREX_QLR0440           0xa0

  /* more card-specific defines */
  #define PT2254_L_CHANNEL 0x10

