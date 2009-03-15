Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:58539 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZCOTru (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:47:50 -0400
Received: by ewy25 with SMTP id 25so3234047ewy.37
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2009 12:47:46 -0700 (PDT)
Subject: Re: [linux-dvb] EC168 and MT2060
From: "t.Hgch" <pureherz@gmail.com>
Reply-To: pureherz@gmail.com
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <49BD3B31.8030308@iki.fi>
References: <1237129041.7993.38.camel@0ri0n>  <49BD3B31.8030308@iki.fi>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 20:47:44 +0100
Message-Id: <1237146464.7993.94.camel@0ri0n>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Partially received? If there is really MT2060 tuner then channels should 
>   not be received at all.


I checked again and i am getting a couple of dtv channels and some more
radio channels, and they display/sound pretty well.
I'm sure that the card model is the one I previously mentioned, the
output from lsusb is:

Bus 001 Device 002: ID 18b4:1001  

> I can look usb-sniffs if you will take.
> http://www.pcausa.com/Utilities/UsbSnoop/default.htm

I didn't find  usbsnoop for linux, so I used usbmon. Here is a sample:


$ cat /tmp/1.mon.out
ffff8801838d56c0 2182968204 C Bi:1:002:2 0 16384 = 04040404 022cece4
26e3e083 a2838c0d 2c2c044a f2b383b5 62c2f204 044c0d8c
ffff8801838d56c0 2182968252 S Bi:1:002:2 -115 16384 <
ffff8801838d5540 2182974450 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5540 2182974487 S Bi:1:002:2 -115 16384 <
ffff8801839110c0 2182975625 S Ci:1:002:0 s c0 03 0000 ff01 0001 1 <
ffff8801839110c0 2182975704 C Ci:1:002:0 0 1 = f6
ffff8801839110c0 2182975739 S Ci:1:002:0 s c0 03 0000 ff24 0001 1 <
ffff8801839110c0 2182975826 C Ci:1:002:0 0 1 = 9e
ffff8801839110c0 2182975844 S Ci:1:002:0 s c0 03 0000 ff24 0001 1 <
ffff8801839110c0 2182975950 C Ci:1:002:0 0 1 = 9e
ffff8801838d5f00 2182981077 C Bi:1:002:2 0 16384 = 5c63d0d0 8d71950e
0349e41d 1790faee 21f63a87 c3ecfd72 c4c439e0 031581c9
ffff8801838d5f00 2182981114 S Bi:1:002:2 -115 16384 <
ffff8801838d5900 2182987700 C Bi:1:002:2 0 16384 = a50ebc68 c9330e94
76f88de8 471fff10 ffffffff ffffffff ffffffff ffffffff
ffff8801838d5900 2182987729 S Bi:1:002:2 -115 16384 <
ffff8801838d5cc0 2182994329 C Bi:1:002:2 0 16384 = 32539246 dda07011
3d29d323 666d740a 01b276ba 3756ace7 4d9a1a15 f8811264
ffff8801838d5cc0 2182994366 S Bi:1:002:2 -115 16384 <
ffff8801838d5c00 2183000953 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5c00 2183000990 S Bi:1:002:2 -115 16384 <
ffff8801838d56c0 2183007576 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d56c0 2183007609 S Bi:1:002:2 -115 16384 <
ffff8801838d5540 2183014204 C Bi:1:002:2 0 16384 = 008324ad baaeb448
8ec91b4b 423c58d3 eb1d2e01 4d6fbc00 3f220a13 a097ffb9
ffff8801838d5540 2183014246 S Bi:1:002:2 -115 16384 <
ffff8801838d5f00 2183020826 C Bi:1:002:2 0 16384 = c01f636c d042ff99
a496c7c5 003e996b 74f410bf e6e9255b a46d6f3c 98a07367
ffff8801838d5f00 2183020858 S Bi:1:002:2 -115 16384 <
ffff8801838d5900 2183027075 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5900 2183027108 S Bi:1:002:2 -115 16384 <
ffff8801838d5cc0 2183033701 C Bi:1:002:2 0 16384 = ffffffff 471fff10
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5cc0 2183033737 S Bi:1:002:2 -115 16384 <
ffff8801838d5c00 2183040327 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5c00 2183040360 S Bi:1:002:2 -115 16384 <
ffff8801838d56c0 2183046953 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d56c0 2183046989 S Bi:1:002:2 -115 16384 <
ffff8801838d5540 2183053579 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5540 2183053611 S Bi:1:002:2 -115 16384 <
ffff8801838d5f00 2183060202 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5f00 2183060240 S Bi:1:002:2 -115 16384 <
ffff8801838d5900 2183066827 C Bi:1:002:2 0 16384 = 3610dba2 469d1903
f8213796 17ed446f 1c190056 4c260490 9b1fc3f3 3b84e7d8
ffff8801838d5900 2183066854 S Bi:1:002:2 -115 16384 <
ffff8801838d5cc0 2183073452 C Bi:1:002:2 0 16384 = ad95f480 ce07d629
6adbcffb 818ad9fd f6ba14b5 bb6fa406 47013715 f1be2df2
ffff8801838d5cc0 2183073484 S Bi:1:002:2 -115 16384 <
ffff8801838d5c00 2183079702 C Bi:1:002:2 0 16384 = 940800a3 f7808007
200c08a2 45e02500 2f16b7cd 043c9d8e c2544689 49cec360
ffff8801838d5c00 2183079730 S Bi:1:002:2 -115 16384 <
ffff8801838d56c0 2183086328 C Bi:1:002:2 0 16384 = 3618534c c55001c3
4262569b f9584966 7ab44fc1 8486c28c 614b62a0 3f6185d6
ffff8801838d56c0 2183086361 S Bi:1:002:2 -115 16384 <
ffff8801838d5540 2183093078 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5540 2183093108 S Bi:1:002:2 -115 16384 <
ffff8801838d5f00 2183099703 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5f00 2183099733 S Bi:1:002:2 -115 16384 <
ffff8801838d5900 2183106328 C Bi:1:002:2 0 16384 = d7bce76b 58c027df
7c7e795f 6220d441 59534db8 83b9ca08 00d6dac9 4b970838
ffff8801838d5900 2183106358 S Bi:1:002:2 -115 16384 <
ffff8801838d5cc0 2183112955 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
ffff8801838d5cc0 2183112991 S Bi:1:002:2 -115 16384 <
ffff8801838d5c00 2183119579 C Bi:1:002:2 0 16384 = ffffffff ffffffff
ffffffff ffffffff 471fff10 ffffffff ffffffff ffffffff
ffff8801838d5c00 2183119608 S Bi:1:002:2 -115 16384 <
ffff8801838d56c0 2183126204 C Bi:1:002:2 0 16384 = 6ba2048c 04040404
04e0c2f7 762f756b a74fce97 7a7604a7 ce0e863e f737865d
ffff8801838d56c0 2183126235 S Bi:1:002:2 -115 16384 <
ffff8801838d5540 2183132831 C Bi:1:002:2 0 16384 = 81696b73 7d5f4408
a942a36f ed083ab2 36fd4567 90bdd5a3 90b446cf 0477d4d5
ffff8801838d5540 2183132872 S Bi:1:002:2 -115 16384 <
ffff8801838d5f00 2183139078 C Bi:1:002:2 0 16384 = f59a7ab8 e0834163
6accb952 d8de306b 5ad31dcd 8f3eed6c d73ac7f9 8f51b6c5
ffff8801838d5f00 2183139112 S Bi:1:002:2 -115 16384 <

The stream was caught using the 8Mhz broadband. Let me know if i can be
of any more help.

Regards,

Tony

