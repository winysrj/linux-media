Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:44153 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754863Ab1LMOrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 09:47:13 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RaTdQ-0002R2-Pg
	for linux-media@vger.kernel.org; Tue, 13 Dec 2011 06:47:12 -0800
Message-ID: <4EE7656F.4070309@seiner.com>
Date: Tue, 13 Dec 2011 06:47:11 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com> <4EDCB6D1.1060508@seiner.com> <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com> <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com> <4EE55304.9090707@seiner.com> <0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com> <4EE5F7BB.4070306@seiner.com> <4EE6D7A9.6030905@seiner.com>
In-Reply-To: <4EE6D7A9.6030905@seiner.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> Yan Seiner wrote:
>> Andy Walls wrote:
>>> 800 MB for 320x420 frames? It sounds like your app has gooned its 
>>> requested buffer size.
>>>   
>>
>> That's an understatement.  :-)
>>
>>> <wild speculation>
>>> This might be due to endianess differences between MIPS abd x86 and 
>>> your app only being written and tested on x86.
>>> </wild speculation>
>>>   
>>
>> My speculation too.  I don't know where that number comes from; the 
>> same app works fine with the saa7115 driver if I switch frame 
>> grabbers.  I'll have to do some fiddling with the code to figure out 
>> where the problem lies.  It's some interaction between the app and 
>> the cx231xx driver.
>
> HAH!
>
> This simple patch fixes it on my MIPS platform - not tested on other 
> architectures as I don't have them readily available running a newer 
> kernel:
>
OK, too groggy last night with my own success... Here's the better 
solution.  Should work on all architectures.

diff -U3 
/data10/home/yan/openwrt/backfire/trunk/build_dir/linux-brcm47xx/linux-3.0.3/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c 
cx231xx-pcb-cfg.c
--- 
/data10/home/yan/openwrt/backfire/trunk/build_dir/linux-brcm47xx/linux-3.0.3/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c    
2011-08-17 10:57:16.000000000 -0700
+++ cx231xx-pcb-cfg.c    2011-12-13 05:50:36.000000000 -0800
@@ -672,7 +672,9 @@
     pcb config it is related to */
     cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);
 
-    config_info = *((u32 *) data);
+    //config_info = *((u32 *) data);
+    config_info = ((u32)(*(data))) + (((u32)(*(data+1))) << 8) + 
(((u32)(*(data+2))) << 16) + (((u32)(*(data+3))) << 24);
+    cx231xx_info("config_info %x\n",config_info);
     usb_speed = (u8) (config_info & 0x1);
 
     /* Verify this device belongs to Bus power or Self power device */



-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

