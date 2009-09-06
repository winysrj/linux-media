Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward3.yandex.ru ([77.88.46.8]:43530 "EHLO forward3.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZIFQ6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Sep 2009 12:58:16 -0400
Message-ID: <4AA3E7AD.5080307@yandex.ru>
Date: Sun, 06 Sep 2009 19:47:41 +0300
From: geroin22 <geroin22@yandex.ru>
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for Compro VideoMate E800 (DVB-T part only)
References: <4AA3D64E.3070203@yandex.ru> <a728f9f90909060901r5e714825kae88bacdeeadd158@mail.gmail.com>
In-Reply-To: <a728f9f90909060901r5e714825kae88bacdeeadd158@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alex Deucher пишет:
> On Sun, Sep 6, 2009 at 11:33 AM, geroin22<geroin22@yandex.ru> wrote:
>   
>>
>> Nothing new, just adding Compro VideoMate E800 (DVB-T part only).
>> Tested with Ubuntu 9.04 kernel 2.6.28 work well.
>>
>>     
>
> Please add your Signed-off-by.
>
>   
>> diff -Naur a/linux/Documentation/video4linux/CARDLIST.cx23885
>> b/linux/Documentation/video4linux/CARDLIST.cx23885
>> --- a/linux/Documentation/video4linux/CARDLIST.cx23885  2009-09-01
>> 16:43:46.000000000 +0300
>> +++ b/linux/Documentation/video4linux/CARDLIST.cx23885  2009-09-06
>> 15:37:13.373793025 +0300
>> @@ -23,3 +23,4 @@
>>  22 -> Mygica X8506 DMB-TH                                 [14f1:8651]
>>  23 -> Magic-Pro ProHDTV Extreme 2                         [14f1:8657]
>>  24 -> Hauppauge WinTV-HVR1850                             [0070:8541]
>> + 25 -> Compro VideoMate E800                               [1858:e800]
>> diff -Naur a/linux/drivers/media/video/cx23885/cx23885-cards.c
>> b/linux/drivers/media/video/cx23885/cx23885-cards.c
>> --- a/linux/drivers/media/video/cx23885/cx23885-cards.c 2009-09-01
>> 16:43:46.000000000 +0300
>> +++ b/linux/drivers/media/video/cx23885/cx23885-cards.c 2009-09-06
>> 15:35:23.434293199 +0300
>> @@ -211,6 +211,10 @@
>>                .portb          = CX23885_MPEG_ENCODER,
>>                .portc          = CX23885_MPEG_DVB,
>>        },
>> +        [CX23885_BOARD_COMPRO_VIDEOMATE_E800] = {
>> +               .name           = "Compro VideoMate E800",
>> +               .portc          = CX23885_MPEG_DVB,
>> +       },
>> };
>> const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>>
>> @@ -342,6 +346,10 @@
>>                .subvendor = 0x0070,
>>                .subdevice = 0x8541,
>>                .card      = CX23885_BOARD_HAUPPAUGE_HVR1850,
>> +        }, {
>> +               .subvendor = 0x1858,
>> +               .subdevice = 0xe800,
>> +               .card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
>>        },
>> };
>> const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
>> @@ -537,6 +545,7 @@
>>        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>>        case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>>        case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>> +        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>>                /* Tuner Reset Command */
>>                bitmask = 0x04;
>>                break;
>> @@ -688,6 +697,7 @@
>>                break;
>>        case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>>        case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>> +        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>>                /* GPIO-2  xc3028 tuner reset */
>>
>>                /* The following GPIO's are on the internal AVCore (cx25840)
>> */
>> @@ -912,6 +922,7 @@
>>        case CX23885_BOARD_HAUPPAUGE_HVR1255:
>>        case CX23885_BOARD_HAUPPAUGE_HVR1210:
>>        case CX23885_BOARD_HAUPPAUGE_HVR1850:
>> +        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>>        default:
>>                ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
>>                ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>> @@ -928,6 +939,7 @@
>>        case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>>        case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>>        case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
>> +        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>>                dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
>>                                &dev->i2c_bus[2].i2c_adap,
>>                                "cx25840", "cx25840", 0x88 >> 1, NULL);
>> diff -Naur a/linux/drivers/media/video/cx23885/cx23885-dvb.c
>> b/linux/drivers/media/video/cx23885/cx23885-dvb.c
>> --- a/linux/drivers/media/video/cx23885/cx23885-dvb.c   2009-09-01
>> 16:43:46.000000000 +0300
>> +++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c   2009-09-06
>> 16:09:17.154602943 +0300
>> @@ -744,6 +744,7 @@
>>        }
>>        case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>>        case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
>> +        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
>>                i2c_bus = &dev->i2c_bus[0];
>>
>>                fe0->dvb.frontend = dvb_attach(zl10353_attach,
>> diff -Naur a/linux/drivers/media/video/cx23885/cx23885.h
>> b/linux/drivers/media/video/cx23885/cx23885.h
>> --- a/linux/drivers/media/video/cx23885/cx23885.h       2009-09-01
>> 16:43:46.000000000 +0300
>> +++ b/linux/drivers/media/video/cx23885/cx23885.h       2009-09-06
>> 15:36:40.229792022 +0300
>> @@ -79,6 +79,7 @@
>> #define CX23885_BOARD_MYGICA_X8506             22
>> #define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
>> #define CX23885_BOARD_HAUPPAUGE_HVR1850        24
>> +#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
>>
>> #define GPIO_0 0x00000001
>> #define GPIO_1 0x00000002
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>   

Signed-off-by: Vladimir Geroy geroin22@yandex.ru


diff -Naur a/linux/Documentation/video4linux/CARDLIST.cx23885 b/linux/Documentation/video4linux/CARDLIST.cx23885
--- a/linux/Documentation/video4linux/CARDLIST.cx23885	2009-09-01 16:43:46.000000000 +0300
+++ b/linux/Documentation/video4linux/CARDLIST.cx23885	2009-09-06 15:37:13.373793025 +0300
@@ -23,3 +23,4 @@
  22 -> Mygica X8506 DMB-TH                                 [14f1:8651]
  23 -> Magic-Pro ProHDTV Extreme 2                         [14f1:8657]
  24 -> Hauppauge WinTV-HVR1850                             [0070:8541]
+ 25 -> Compro VideoMate E800                               [1858:e800]
diff -Naur a/linux/drivers/media/video/cx23885/cx23885-cards.c b/linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c	2009-09-01 16:43:46.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	2009-09-06 15:35:23.434293199 +0300
@@ -211,6 +211,10 @@
 		.portb		= CX23885_MPEG_ENCODER,
 		.portc		= CX23885_MPEG_DVB,
 	},
+        [CX23885_BOARD_COMPRO_VIDEOMATE_E800] = {
+		.name		= "Compro VideoMate E800",
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -342,6 +346,10 @@
 		.subvendor = 0x0070,
 		.subdevice = 0x8541,
 		.card      = CX23885_BOARD_HAUPPAUGE_HVR1850,
+        }, {
+		.subvendor = 0x1858,
+		.subdevice = 0xe800,
+		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -537,6 +545,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* Tuner Reset Command */
 		bitmask = 0x04;
 		break;
@@ -688,6 +697,7 @@
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* GPIO-2  xc3028 tuner reset */
 
 		/* The following GPIO's are on the internal AVCore (cx25840) */
@@ -912,6 +922,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -928,6 +939,7 @@
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
diff -Naur a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	2009-09-01 16:43:46.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	2009-09-06 16:09:17.154602943 +0300
@@ -744,6 +744,7 @@
 	}
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		i2c_bus = &dev->i2c_bus[0];
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
diff -Naur a/linux/drivers/media/video/cx23885/cx23885.h b/linux/drivers/media/video/cx23885/cx23885.h
--- a/linux/drivers/media/video/cx23885/cx23885.h	2009-09-01 16:43:46.000000000 +0300
+++ b/linux/drivers/media/video/cx23885/cx23885.h	2009-09-06 15:36:40.229792022 +0300
@@ -79,6 +79,7 @@
 #define CX23885_BOARD_MYGICA_X8506             22
 #define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
 #define CX23885_BOARD_HAUPPAUGE_HVR1850        24
+#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002

