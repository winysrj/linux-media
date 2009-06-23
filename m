Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:63319 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZFWMZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 08:25:06 -0400
Received: by wf-out-1314.google.com with SMTP id 26so6822wfd.4
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 05:25:09 -0700 (PDT)
Message-ID: <4A40C81E.7070304@gmail.com>
Date: Tue, 23 Jun 2009 22:18:38 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
Reply-To: mo.ucina@gmail.com
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, "Jan D. Louw" <jd.louw@mweb.co.za>
Subject: Re: [linux-dvb] Support for Compro VideoMate S350
References: <81c0b0550905250703o786a2a65ib757287da841dc11@mail.gmail.com> <4A3C3F4D.7050105@gmail.com> <200906201633.58431.liplianin@me.by>
In-Reply-To: <200906201633.58431.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for that Igor,

I have just pulled the latest hg and tried to apply patches . Patches 
12094 and 12095 went in with no problem . However patch 12096 failed 
with this output :

[root@localhost v4l-dvb]# patch -p1 < 12096.patch
patching file linux/drivers/media/common/ir-keymaps.c
Hunk #1 FAILED at 2800.
1 out of 1 hunk FAILED -- saving rejects to file 
linux/drivers/media/common/ir-keymaps.c.rej
patching file linux/drivers/media/video/saa7134/Kconfig
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
patching file linux/drivers/media/video/saa7134/saa7134-input.c
patching file linux/drivers/media/video/saa7134/saa7134.h
patching file linux/include/media/ir-common.h
Hunk #1 FAILED at 162.
1 out of 1 hunk FAILED -- saving rejects to file 
linux/include/media/ir-common.h.rej
[root@localhost v4l-dvb]#

I will attach the rej files to the email .

[root@localhost v4l-dvb]# cat linux/drivers/media/common/ir-keymaps.c.rej
***************
*** 2800,2802 ****
        [0x1b] = KEY_B,         /*recall*/
  };
  EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
--- 2800,2850 ----
        [0x1b] = KEY_B,         /*recall*/
  };
  EXPORT_SYMBOL_GPL(ir_codes_dm1105_nec);
+
+ IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE] = {
+       [0x00] = KEY_TV,
+       [0x01] = KEY_DVD,
+       [0x04] = KEY_RECORD,
+       [0x05] = KEY_VIDEO, /* TV/Video */
+       [0x07] = KEY_STOP,
+       [0x08] = KEY_PLAYPAUSE,
+       [0x0a] = KEY_REWIND,
+       [0x0f] = KEY_FASTFORWARD,
+       [0x10] = KEY_CHANNELUP,
+       [0x12] = KEY_VOLUMEUP,
+       [0x13] = KEY_CHANNELDOWN,
+       [0x14] = KEY_MUTE,
+       [0x15] = KEY_VOLUMEDOWN,
+       [0x16] = KEY_1,
+       [0x17] = KEY_2,
+       [0x18] = KEY_3,
+       [0x19] = KEY_4,
+       [0x1a] = KEY_5,
+       [0x1b] = KEY_6,
+       [0x1c] = KEY_7,
+       [0x1d] = KEY_8,
+       [0x1e] = KEY_9,
+       [0x1f] = KEY_0,
+       [0x21] = KEY_SLEEP,
+       [0x24] = KEY_ZOOM,
+       [0x25] = KEY_LAST,    /* Recall */
+       [0x26] = KEY_SUBTITLE, /* CC */
+       [0x27] = KEY_LANGUAGE, /* MTS */
+       [0x29] = KEY_CHANNEL, /* SURF */
+       [0x2b] = KEY_A,
+       [0x2c] = KEY_B,
+       [0x2f] = KEY_SHUFFLE, /* Snapshot */
+       [0x23] = KEY_RADIO,
+       [0x02] = KEY_PREVIOUSSONG,
+       [0x06] = KEY_NEXTSONG,
+       [0x03] = KEY_EPG,
+       [0x09] = KEY_SETUP,
+       [0x22] = KEY_BACKSPACE,
+       [0x0c] = KEY_UP,
+       [0x0e] = KEY_DOWN,
+       [0x0b] = KEY_LEFT,
+       [0x0d] = KEY_RIGHT,
+       [0x11] = KEY_ENTER,
+       [0x20] = KEY_TEXT,
+ };
+ EXPORT_SYMBOL_GPL(ir_codes_videomate_s350);
[root@localhost v4l-dvb]# cat linux/include/media/ir-common.h.rej
***************
*** 162,167 ****
  extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
  extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
  extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
  #endif

  /*
--- 162,168 ----
  extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
  extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
  extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
+ extern IR_KEYTAB_TYPE ir_codes_videomate_s350[IR_KEYTAB_SIZE];
  #endif

  /*
[root@localhost v4l-dvb]#



Best Regards

Milorad

