Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yellowplantain@gmail.com>) id 1KlLZx-0007gZ-0P
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 12:38:44 +0200
Received: by rv-out-0506.google.com with SMTP id b25so892197rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 02 Oct 2008 03:38:36 -0700 (PDT)
Message-ID: <48E4A4A4.8030003@gmail.com>
Date: Thu, 02 Oct 2008 20:08:28 +0930
From: Plantain <yellowplantain@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <48E35E38.9040909@gmail.com> <48E394D0.5010808@linuxtv.org>	
	<48E3A687.9000703@gmail.com> <48E3BBD4.8090304@linuxtv.org>
	<1222900908.2706.18.camel@pc10.localdom.local>
In-Reply-To: <1222900908.2706.18.camel@pc10.localdom.local>
Content-Type: multipart/mixed; boundary="------------040404010102060207030409"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040404010102060207030409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hermann pitton wrote:
> Hi,
>
> Am Mittwoch, den 01.10.2008, 14:05 -0400 schrieb Steven Toth:
>   
>> Plantain wrote:
>>     
>>> Steven Toth wrote:
>>>       
>>>> Plantain wrote:
>>>>         
>>>>> Hey,
>>>>>
>>>>> I've luckily come across a Leadtek DTV1000S that I'd like to get working
>>>>> under Linux!
>>>>>
>>>>> From reading the Leadtek specifications
>>>>> (http://leadtek.com/eng/tv_tuner/specification.asp?pronameid=382&lineid=6&act=2),
>>>>>
>>>>> I now understand it has contained within it the following chips;
>>>>> NXP 18271
>>>>> TDA10048
>>>>>           
>>>> Firmware:
>>>>
>>>> http://steventoth.net/linux/hvr1700/
>>>>
>>>> Good luck!
>>>>
>>>> Regards,
>>>>
>>>> - Steve
>>>>         
>>> Hey,
>>>       
>> Either you or I dropped the mailinglist is CC'd. I've added it back. 
>> Please ensure the mailinglist is CC'd at all times.
>>
>>     
>>> So it doesn't matter at all that they are for different cards even
>>> though the chipsets are the same?
>>>       
>> Correct.
>>
>>     
>>> Even with the firmware, it seems that the tuner is not detected/loaded.
>>> I've pasted my current modprobe/dmesg below.
>>>       
>> If it's not found during an i2c scan then it's probably held in reset by 
>> a GPIO. YOu'd need to figure out which GPIO needs to be raised. I don't 
>> know the 7130 framework very well by I suspect running regspy.exe (from 
>> the dscaler project) on a windows system will probably show you the gpio 
>> configuration that windows uses when the TV playback software is running.
>>     
>
> for all what I can see we have no analog demodulator on that card like
> tda8290/95 or a 8290 integrated within a saa7131e chip. 
> All other saa713x chips don't have an internal analog demod with an i2c
> bridge to control the tuner.
>
> That simply means there is no analog tuner and  the correct tuner type
> for analog is tuner=4 TUNER_ABSENT. We can only configure the card for
> auto detection as a saa7130 device, enable Composite and S-Video support
> and maybe the remote if the IR controller is supported.
>
> Rest must be found and done within saa7134-dvb.c like pointed.
> Tuner is at 0x60/0xc0 and tda10048 at 0x08 (0x10 >> 1).
>
>   
>>> plantain@plantain-king ~ $ sudo modprobe saa7134 card=104 tuner=54
>>> plantain@plantain-king ~ $ dmesg
>>> ...
>>> saa7130/34: v4l2 driver version 0.2.14 loaded
>>> saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio:
>>> 0xfc005000
>>> saa7130[0]: subsystem: 107d:6655, board: Hauppauge WinTV-HVR1110
>>> DVB-T/Hybrid [card=104,insmod option]
>>> saa7130[0]: board init: gpio is 222104
>>> Chip ID is not zero. It is not a TEA5767
>>> tuner' 2-0060: chip found @ 0xc0 (saa7130[0])
>>> saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>>> saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
>>> saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
>>> Hauppauge eeprom.
>>> saa7130[0]: warning: unknown hauppauge model #0
>>> saa7130[0]: hauppauge eeprom: model=0
>>> tuner' 2-0060: Tuner has no way to set tv freq
>>> tuner' 2-0060: Tuner has no way to set tv freq
>>> saa7130[0]: registered device video0 [v4l2]
>>> saa7130[0]: registered device vbi0
>>> saa7130[0]: registered device radio0
>>> tda10046: chip is not answering. Giving up.
>>> tuner' 2-0060: Tuner has no way to set tv freq
>>> plantain@plantain-king ~ $
>>>
>>>
>>> I believe I am right with the tuner=54 modprobe option for the NXP 18271?
>>> I've no idea what to actually set card= to, I just guessed HVR1110 since
>>> it was similar to the firmware from which I've now taken from. If anyone
>>> can point me towards a better card= setting, that'd be great!
>>>       
>> I don't normally force load drivers with card=X. I typically just start 
>> patching the [7130] tree with the correct PCI'd, attach structs etc. 
>> It's easier that guessing - which leads to bad assumptions and mistakes.
>>
>> You can use the other trees [ cx23885, cx88 ] for reference code to show 
>> how to attach tuners and demods.
>>
>> - Steve
>>
>>     
> Cheers,
> Hermann
>
>   
Hey,

I'm not actually able to code in C, but I've spent the last 24 hours
puddling around trying to get somewhere. I believe I've added everything
that is needed for the card to be detected, but it's not detecting it,
even if I specify it with card=152 (the ID I've added). I have got the
code to compile at least, which I'm pretty proud of :)

I managed to get regspy to work (needed to revert 64bit vista to 32bit
XP), but the viewing software that came with the card just crashes on
32bit XP. I've built a small wiki page (with highres images) detailing
my progress, but I've really just hit a brick wall. Wikipage at
http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S

Short of learning C (which I am very slowly doing), I don't see anyway
forwards under my direction, so I've attached my efforts in the hope
someone else can take this forwards. From my limited understanding I've
provided all the necessary information for someone to finish it, and if
not I'll happily dig up anything else needed. I'm not familiar with any
version control system/patching, so I've just hg diff > file.diff, I
hope this is adequate.

I'm on #linuxtv @ freenode IRC for a significant portion of the day if
anyone has pointers for me/wants to ask questions about the card.

Cheers,

~Matthew~ (plantain on IRC)

--------------040404010102060207030409
Content-Type: text/plain;
 name="dtv1000s.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dtv1000s.diff"

diff -r 4db9722caf4f linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Oct 01 13:13:56 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Oct 02 20:04:16 2008 +0930
@@ -4587,6 +4587,7 @@
 			.amux = TV,
 		},
 	},
+
 	[SAA7134_BOARD_ADS_INSTANT_HDTV_PCI] = {
 		.name           = "ADS Tech Instant HDTV",
 		.audio_clock    = 0x00187de7,
@@ -4611,6 +4612,27 @@
 			.amux = LINE1,
 		} },
 	},
+	[SAA7134_BOARD_WINFAST_DTV1000S_PCI] = {
+		.name           = "Leadtek WinFast DTV 1000 S",
+		.tuner_type     = TUNER_ABSENT,
+/*inputs were copied verbatium, no idea how to find correct values*/ 
+		.inputs         = {{
+       			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+                },{
+                        .name = name_comp1,
+                        .vmux = 3,
+                        .amux = LINE1,
+                },{
+                        .name = name_svideo,
+                        .vmux = 8,
+                        .amux = LINE1,
+		}},
+	},
+
+
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5696,6 +5718,16 @@
 		.subdevice    = PCI_ANY_ID,
 		.driver_data  = SAA7134_BOARD_UNKNOWN,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+/* copied from dmesg line saa7130[0]: subsystem: 107d:6655, board: UNKNOWN/GENERIC [card=0,autodetected] */		
+		.subvendor    = 0x107d,
+		.subdevice    = 0x6655,
+		.driver_data  = SAA7134_BOARD_WINFAST_DTV1000S_PCI,
+        },{
+
+	
+
 		/* --- end of list --- */
 	}
 };
@@ -6067,6 +6099,13 @@
 		       "are supported for now.\n",
 			dev->name, card(dev).name, dev->name);
 		break;
+	case SAA7134_BOARD_WINFAST_DTV1000S_PCI:
+ 	        /* power-up tuner chip */
+/* I don't understand what is being written to where, this is all made up... regspy paste on wiki */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x000A8004, 0x000A8004);
+                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x000A8004, 0x000A8004);
+                msleep(10);
+		break;
 	}
 	return 0;
 }
diff -r 4db9722caf4f linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Wed Oct 01 13:13:56 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Thu Oct 02 20:04:16 2008 +0930
@@ -275,7 +275,7 @@
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
-
+#define SAA7134_BOARD_WINFAST_DTV1000S_PCI 152
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
 

--------------040404010102060207030409
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040404010102060207030409--
