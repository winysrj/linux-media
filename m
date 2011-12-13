Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:60109 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752894Ab1LMEmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 23:42:20 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RaKC2-00035v-WC
	for linux-media@vger.kernel.org; Mon, 12 Dec 2011 20:42:19 -0800
Message-ID: <4EE6D7A9.6030905@seiner.com>
Date: Mon, 12 Dec 2011 20:42:17 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com> <4EDCB6D1.1060508@seiner.com> <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com> <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com> <4EE55304.9090707@seiner.com> <0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com> <4EE5F7BB.4070306@seiner.com>
In-Reply-To: <4EE5F7BB.4070306@seiner.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> Andy Walls wrote:
>> 800 MB for 320x420 frames? It sounds like your app has gooned its 
>> requested buffer size.
>>   
>
> That's an understatement.  :-)
>
>> <wild speculation>
>> This might be due to endianess differences between MIPS abd x86 and 
>> your app only being written and tested on x86.
>> </wild speculation>
>>   
>
> My speculation too.  I don't know where that number comes from; the 
> same app works fine with the saa7115 driver if I switch frame 
> grabbers.  I'll have to do some fiddling with the code to figure out 
> where the problem lies.  It's some interaction between the app and the 
> cx231xx driver.

HAH!

This simple patch fixes it on my MIPS platform - not tested on other 
architectures as I don't have them readily available running a newer kernel:


--- 
/data10/home/yan/openwrt/backfire/trunk/build_dir/linux-brcm47xx/linux-3.0.3/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c    
2011-08-17 10:57:16.000000000 -0700
+++ cx231xx-pcb-cfg.c    2011-12-12 20:16:23.000000000 -0800
@@ -672,7 +672,9 @@
     pcb config it is related to */
     cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);
 
-    config_info = *((u32 *) data);
+    //config_info = *((u32 *) data);
+    config_info = *(data);
+    cx231xx_info("config_info %x\n",config_info);
     usb_speed = (u8) (config_info & 0x1);
 
     /* Verify this device belongs to Bus power or Self power device */


No more errors and the frame grabber works up to 480x320 even on a slow 
MIPS board.

[   33.640000] cx231xx v4l2 driver loaded.
[   33.650000] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 
Mbps (2040:c200) with 5 interfaces
[   33.660000] cx231xx #0: registering interface 1
[   33.660000] cx231xx #0: config_info c9
[   33.670000] cx231xx #0: can't change interface 3 alt no. to 3: Max. 
Pkt size = 0
[   33.680000] cx231xx #0: can't change interface 4 alt no. to 1: Max. 
Pkt size = 0
[   33.690000] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[   33.800000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   33.820000] cx231xx #0: Changing the i2c master port to 3
[   33.820000] cx25840 0-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[   33.850000] cx25840 0-0044:  Firmware download size changed to 16 
bytes max length
[   35.880000] cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw firmware 
(16382 bytes)
[   35.920000] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
[   35.950000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   36.000000] cx231xx #0: video_mux : 0
[   36.010000] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[   36.010000] cx231xx #0: do_mode_ctrl_overrides NTSC
[   36.020000] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[   36.030000] cx231xx #0: cx231xx #0/0: registered device vbi0
[   36.040000] cx231xx #0: V4L2 device registered as video0 and vbi0
[   36.040000] cx231xx #0: EndPoint Addr 0x8400, Alternate settings: 5
[   36.050000] cx231xx #0: Alternate setting 0, max size= 512
[   36.050000] cx231xx #0: Alternate setting 1, max size= 184
[   36.060000] cx231xx #0: Alternate setting 2, max size= 728
[   36.070000] cx231xx #0: Alternate setting 3, max size= 2892
[   36.070000] cx231xx #0: Alternate setting 4, max size= 1800
[   36.080000] cx231xx #0: EndPoint Addr 0x8500, Alternate settings: 2
[   36.080000] cx231xx #0: Alternate setting 0, max size= 512
[   36.090000] cx231xx #0: Alternate setting 1, max size= 512
[   36.090000] cx231xx #0: EndPoint Addr 0x8600, Alternate settings: 2
[   36.100000] cx231xx #0: Alternate setting 0, max size= 512
[   36.110000] cx231xx #0: Alternate setting 1, max size= 576
[   36.110000] usbcore: registered new interface driver cx231xx
[   36.320000] ar71xx-wdt: enabling watchdog timer

-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

