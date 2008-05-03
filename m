Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m43C0ngO008193
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 08:00:49 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m43C0dx2008449
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 08:00:39 -0400
Received: by wf-out-1314.google.com with SMTP id 25so88108wfc.6
	for <video4linux-list@redhat.com>; Sat, 03 May 2008 05:00:39 -0700 (PDT)
Message-ID: <22dcca890805030500s42889ddcl7370c7745dca8bba@mail.gmail.com>
Date: Sat, 3 May 2008 14:00:38 +0200
From: "Youri Matthys" <yourimatthys@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <22dcca890802120002m19ff0f10x6776cdbdccc1f443@mail.gmail.com>
MIME-Version: 1.0
References: <22dcca890802120002m19ff0f10x6776cdbdccc1f443@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: [PATCH] repeating remote control keys on Compro VideoMate
	DVB-T300
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

James,

After much fiddling around and searching the net I've finally resolved the
problem and added it to your patch. With your permission I would like to
send your patch to the v4l devs so the code can be integrated.

Kind regards, Youri


diff -r 27b2c6a80826 linux/drivers/media/video/saa7134/saa7134-input.c

--- a/linux/drivers/media/video/saa7134/saa7134-input.c Fri Nov 30 18:27:26
2007 +0200 +++ b/linux/drivers/media/video/saa7134/saa7134-input.c Sun Dec
02 23:08:43 2007 +1100

@@ -76,6 +76,12 @@ static int build_key(struct saa7134_dev
     }
     /* rising SAA7134_GPIO_GPRESCAN reads the status */
     saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+    /* eliminate repeating keys issue on some boards*/
+    switch (dev->board) {
+    case SAA7134_BOARD_VIDEOMATE_DVBT_200:
+        saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+        break;
+    }
     saa_setb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);

     gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);

@@ -324,6 +330,7 @@ int saa7134_input_init1(struct saa7134_dev
         ir_codes     = ir_codes_videomate_tv_pvr;
         mask_keycode = 0x003F00;
         mask_keyup   = 0x040000;
+        polling      = 50; // ms
         break;
     case SAA7134_BOARD_FLYDVBS_LR300:
     case SAA7134_BOARD_FLYDVBT_LR301:
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
