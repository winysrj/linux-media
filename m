Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail01.syd.optusnet.com.au ([211.29.132.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <russell@kliese.wattle.id.au>) id 1JQMGd-0006av-Bb
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 13:35:44 +0100
Received: from [192.168.0.4] (c220-239-70-96.rochd3.qld.optusnet.com.au
	[220.239.70.96]) (authenticated sender russell.kliese)
	by mail01.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m1GCZcbx007084
	for <linux-dvb@linuxtv.org>; Sat, 16 Feb 2008 23:35:39 +1100
Message-ID: <47B6DA8C.9070008@kliese.wattle.id.au>
Date: Sat, 16 Feb 2008 22:43:56 +1000
From: Russell Kliese <russell@kliese.wattle.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47B5A504.9080400@kliese.wattle.id.au>	
	<47B617F1.30006@t-online.de>
	<1203118506.7303.63.camel@pc08.localdom.local>
In-Reply-To: <1203118506.7303.63.camel@pc08.localdom.local>
Content-Type: multipart/mixed; boundary="------------020002070809020402030101"
Subject: Re: [linux-dvb] MSI TV@nywhere A/D v1.1 patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020002070809020402030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've updated the patch with the suggested changes and the card still 
functions correctly.

I've also spent some time testing things. S-video and Composite inputs 
work. The radio also seems to be working fine (it can find channels when 
I scan, but I haven't tested the audio output).

One improvement I can think of with supporting this card is to skip 
trying to boot the tda10046 from eeprom because there doesn't seem to be 
an eeprom on this board for the tda10046. This would speed up the 
initial driver load, but it's certainly not an important issue.

Here is the patch description:

This patch adds support for the MSI TV@nywhere A/D v1.1 card.

Signed-off-by: Russell Kliese russell@kliese.wattle.id.au

hermann pitton wrote:
> Hi,
>
> Am Freitag, den 15.02.2008, 23:53 +0100 schrieb Hartmut Hackmann:
>   
>> Hi, Russell
>>
>> Russell Kliese schrieb:
>>     
>>> Hi,
>>>
>>> I've created a patch to support the MSI TV@nywhere A/D v1.1 card. This
>>> card previously had firmware upload issues when using card=109. With
>>> this patch, it's auto-detected and I haven't experienced any firmware
>>> upload problems (although my testing hasn't been exhaustive, but I have
>>> tried a couple of cold boots).
>>>
>>> I've tested both analog and digital TV. I haven't yet tested S-Video or
>>> composite inputs, so these might need to be tweaked.
>>>
>>> It would be great if this patch could be merged into the main
>>> repository. If there are any special requirements to allow this to be
>>> done, please let me know.
>>>
>>> Cheers,
>>>
>>> Russell Kliese
>>>
>>>       
>> You were able to help yourself, good!
>> Few questions / commments:
>> - Does the board support FM Radio?
>> - Can you test the composite / S-Video inputs somehow?
>>   We already have boards with wrong configurations here but i would
>>   like to minimize the number ;-)
>> - The code fragment in saa7134-cards.c from line 5479 on should not be
>>   necessary. Can you please cross check?
>>     
>
> please also drop the duplicate code in saa7134-dvb and just use
> &philips_tiger_s_config.
>
>   
>> When i integrate the patch, i would like to mention you as the patch author.
>> For this, i will need a signature from you:
>> Signed-off-by: Your Name <your email address>
>>     
>
> Thanks,
> Hermann
>
>   


--------------020002070809020402030101
Content-Type: text/x-patch;
 name="v4l-dvb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb.diff"

diff -r 5a5e0c3f723b linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Feb 15 16:41:06 2008 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Sat Feb 16 00:40:50 2008 +1000
@@ -131,3 +131,4 @@ 130 -> Beholder BeholdTV M6 / BeholdTV M
 130 -> Beholder BeholdTV M6 / BeholdTV M6 Extra [5ace:6190,5ace:6193]
 131 -> Twinhan Hybrid DTV-DVB 3056 PCI          [1822:0022]
 132 -> Genius TVGO AM11MCE
+133 -> MSI TV@nywhere A/D v1.1                  [1462:8625]
diff -r 5a5e0c3f723b linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Feb 15 16:41:06 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Feb 16 21:50:52 2008 +1000
@@ -4030,6 +4030,36 @@ struct saa7134_board saa7134_boards[] = 
 			.gpio = 0x6000,
 		},
 	},
+	[SAA7134_BOARD_MSI_TVANYWHERE_AD11] = {
+		.name           = "MSI TV@nywhere A/D v1.1",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config   = 2,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x0200000,
+		.inputs = {{
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		},{
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+		},{
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		}},
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio   = 0x0200000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4980,6 +5010,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subvendor    = 0x1822, /*Twinhan Technology Co. Ltd*/
 		.subdevice    = 0x0022,
 		.driver_data  = SAA7134_BOARD_TWINHAN_DTV_DVB_3056,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1462, /* MSI */
+		.subdevice    = 0x8625, /* TV@nywhere A/D v1.1 */
+		.driver_data  = SAA7134_BOARD_MSI_TVANYWHERE_AD11,
 	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -5477,6 +5513,8 @@ int saa7134_board_init2(struct saa7134_d
 			break;
 		}
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
+		break;
 	}
 	return 0;
 }
diff -r 5a5e0c3f723b linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Feb 15 16:41:06 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Feb 16 21:34:58 2008 +1000
@@ -1064,6 +1064,9 @@ static int dvb_init(struct saa7134_dev *
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config);
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
+		configure_tda827x_fe(dev, &philips_tiger_s_config);
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 5a5e0c3f723b linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Feb 15 16:41:06 2008 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Wed Feb 13 21:42:57 2008 +1000
@@ -261,6 +261,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132
+#define SAA7134_BOARD_MSI_TVANYWHERE_AD11  133
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--------------020002070809020402030101
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020002070809020402030101--
