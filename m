Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35533 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2DEOYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:24:25 -0400
Received: by vcqp1 with SMTP id p1so537265vcq.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 07:24:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7C4C58.5050703@gmail.com>
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com>
 <4F7C3787.5020602@iki.fi> <4F7C4141.40004@gmail.com> <4F7C481A.2020203@iki.fi>
 <4F7C4C58.5050703@gmail.com>
From: pierigno <pierigno@gmail.com>
Date: Thu, 5 Apr 2012 16:23:42 +0200
Message-ID: <CAN7fRVvX2gEWHAEAqqZ1Jbgx+atU8S_dXVc9Q83_o+-L69nq7g@mail.gmail.com>
Subject: Re: [PATCH] af9035: add several new USB IDs
To: gennarone@gmail.com
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello,

these are the definitions needed for AVermedia Twinstar. The stick
works correctly so far: I was also able to tune many channels through
kaffeine (~300 channels here in Turin, Italy). and watching
continuously a channel for 4 hours without interruptions or visual
glitches. Switching from one channel to another takes ~1 sec. Just one
tuner is recognized at the moment.

Regards,
Pierangelo Terzulli


--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -821,29 +821,68 @@ err:

 enum af9035_id_entry {
       AF9035_0CCD_0093,
+       AF9035_0CCD_00AA,
       AF9035_15A4_9035,
+       AF9035_15A4_1000,
       AF9035_15A4_1001,
+       AF9035_15A4_1002,
+       AF9035_15A4_1003,
+       AF9035_07CA_0825,
+       AF9035_07CA_A825,
+       AF9035_07CA_0835,
       AF9035_07CA_A835,
       AF9035_07CA_B835,
+       AF9035_07CA_A333,
+       AF9035_07CA_0337,
+       AF9035_07CA_F337,
+       AF9035_07CA_0867,
       AF9035_07CA_1867,
+       AF9035_07CA_3867,
       AF9035_07CA_A867,
+       AF9035_07CA_B867,
 };

 static struct usb_device_id af9035_id[] = {
       [AF9035_0CCD_0093] = {
               USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK)},
+       [AF9035_0CCD_00AA] = {
+               USB_DEVICE(USB_VID_TERRATEC,
USB_PID_TERRATEC_CINERGY_T_STICK_2)},
       [AF9035_15A4_9035] = {
               USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035)},
-       [AF9035_15A4_1001] = {
+       [AF9035_15A4_1000] = {
               USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_2)},
+       [AF9035_15A4_1001] = {
+               USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_3)},
+       [AF9035_15A4_1002] = {
+               USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_4)},
+       [AF9035_15A4_1003] = {
+               USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_5)},
+       [AF9035_07CA_0825] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0825)},
+       [AF9035_07CA_A825] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A825)},
+       [AF9035_07CA_0835] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0835)},
       [AF9035_07CA_A835] = {
               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835)},
       [AF9035_07CA_B835] = {
               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B835)},
+       [AF9035_07CA_A333] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A333)},
+       [AF9035_07CA_0337] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0337)},
+       [AF9035_07CA_F337] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_F337)},
+       [AF9035_07CA_0867] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0867)},
       [AF9035_07CA_1867] = {
               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
+       [AF9035_07CA_3867] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_3867)},
       [AF9035_07CA_A867] = {
               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
+       [AF9035_07CA_B867] = {
+               USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B867)},
       {},
 };

@@ -886,30 +925,47 @@ static struct dvb_usb_device_properties
af9035_properties[] = {

               .i2c_algo = &af9035_i2c_algo,

-               .num_device_descs = 4,
+               .num_device_descs = 5,
               .devices = {
                       {
                               .name = "TerraTec Cinergy T Stick",
                               .cold_ids = {
                                       &af9035_id[AF9035_0CCD_0093],
+                                       &af9035_id[AF9035_0CCD_00AA],
                               },
                       }, {
                               .name = "Afatech Technologies DVB-T stick",
                               .cold_ids = {
                                       &af9035_id[AF9035_15A4_9035],
+                                       &af9035_id[AF9035_15A4_1000],
                                       &af9035_id[AF9035_15A4_1001],
+                                       &af9035_id[AF9035_15A4_1002],
+                                       &af9035_id[AF9035_15A4_1003],
+                               },
+                       }, {
+                               .name = "AVerMedia AVerTV TwinStar (A825)",
+                               .cold_ids = {
+                                       &af9035_id[AF9035_07CA_0825],
+                                       &af9035_id[AF9035_07CA_A825],
                               },
                       }, {
                               .name = "AVerMedia AVerTV Volar HD/PRO (A835)",
                               .cold_ids = {
+                                       &af9035_id[AF9035_07CA_0835],
                                       &af9035_id[AF9035_07CA_A835],
                                       &af9035_id[AF9035_07CA_B835],
                               },
                       }, {
                               .name = "AVerMedia HD Volar (A867)",
                               .cold_ids = {
+                                       &af9035_id[AF9035_07CA_A333],
+                                       &af9035_id[AF9035_07CA_0337],
+                                       &af9035_id[AF9035_07CA_F337],
+                                       &af9035_id[AF9035_07CA_0867],
                                       &af9035_id[AF9035_07CA_1867],
+                                       &af9035_id[AF9035_07CA_3867],
                                       &af9035_id[AF9035_07CA_A867],
+                                       &af9035_id[AF9035_07CA_B867],
                               },
                       },
               }

--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -77,7 +77,10 @@
 #define USB_PID_AFATECH_AF9015_9015                    0x9015
 #define USB_PID_AFATECH_AF9015_9016                    0x9016
 #define USB_PID_AFATECH_AF9035                         0x9035
-#define USB_PID_AFATECH_AF9035_2                       0x1001
+#define USB_PID_AFATECH_AF9035_2                       0x1000
+#define USB_PID_AFATECH_AF9035_3                       0x1001
+#define USB_PID_AFATECH_AF9035_4                       0x1002
+#define USB_PID_AFATECH_AF9035_5                       0x1003
 #define USB_PID_TREKSTOR_DVBT                          0x901b
 #define USB_VID_ALINK_DTU                              0xf170
 #define USB_PID_ANSONIC_DVBT_USB                       0x6000
@@ -155,6 +158,7 @@
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE              0x0055
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2         0x0069
 #define USB_PID_TERRATEC_CINERGY_T_STICK               0x0093
+#define USB_PID_TERRATEC_CINERGY_T_STICK_2             0x00aa
 #define USB_PID_TERRATEC_CINERGY_T_STICK_RC            0x0097
 #define USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC       0x0099
 #define USB_PID_TWINHAN_VP7041_COLD                    0x3201
@@ -224,10 +228,19 @@
 #define USB_PID_AVERMEDIA_A850T                                0x850b
 #define USB_PID_AVERMEDIA_A805                         0xa805
 #define USB_PID_AVERMEDIA_A815M                                0x815a
+#define USB_PID_AVERMEDIA_0825                         0x0825
+#define USB_PID_AVERMEDIA_A825                         0xa825
+#define USB_PID_AVERMEDIA_0835                         0x0835
 #define USB_PID_AVERMEDIA_A835                         0xa835
 #define USB_PID_AVERMEDIA_B835                         0xb835
+#define USB_PID_AVERMEDIA_A333                         0xa333
+#define USB_PID_AVERMEDIA_0337                         0x0337
+#define USB_PID_AVERMEDIA_F337                         0xf337
+#define USB_PID_AVERMEDIA_0867                         0x0867
 #define USB_PID_AVERMEDIA_1867                         0x1867
+#define USB_PID_AVERMEDIA_3867                         0x3867
 #define USB_PID_AVERMEDIA_A867                         0xa867
+#define USB_PID_AVERMEDIA_B867                         0xb867
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_CT3650             0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY       0x005a
