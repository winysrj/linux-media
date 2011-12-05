Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:35955 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754998Ab1LEEyw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 23:54:52 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RXQZn-0001cX-G1
	for linux-media@vger.kernel.org; Sun, 04 Dec 2011 20:54:51 -0800
Message-ID: <4EDC4E9B.40301@seiner.com>
Date: Sun, 04 Dec 2011 20:54:51 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com>
In-Reply-To: <4EDC4C84.2030904@seiner.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> Andy Walls wrote:
>> On Sun, 2011-12-04 at 18:01 -0800, Yan Seiner wrote:
>>  
>>> I am experiencing a kernel oops when trying to use a Hauppage USB 
>>> Live 2 frame grabber.  The oops is below.
>>>
>>> The system is a SOC 260Mhz Broadcom BCM47XX access point running 
>>> OpenWRT.
>>>
>>> root@anchor:/# uname -a
>>> Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
>>>
>>> The OOPS could be due to the limited hardware or something else.  
>>> I'd appreciate any suggestions for making this work.  I was hoping 
>>> with hardware compression I could make it work on this platform.  I 
>>> am currently using a Hauppage USB Live (saa7115 based) with no 
>>> problems but with limited resolution.
>>>
>>> cx231xx v4l2 driver loaded.
>>> cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps 
>>> (2040:c200) with 5 interfaces
>>> cx231xx #0: registering interface 1
>>> cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
>>> cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>>> cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
>>> cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>>> cx231xx #0: Changing the i2c master port to 3
>>> cx231xx #0: cx25840 subdev registration failure
>>>     
>>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> The cx231xx driver requires the cx25840 module.  I'll wager you didn't
>> install it on your router.
>>
>>   
>
> I made sure the module was loaded; same thing.  :-(
>
> Module                  Size  Used by    Tainted: G 
> cx231xx               124608  0
> cx2341x                13552  1 cx231xx
> cx25840                35568  2
> rc_core                12640  1 cx231xx
> videobuf_vmalloc        3168  1 cx231xx
> videobuf_core          12384  2 cx231xx,videobuf_vmalloc
>
> I was not able to catch the first bit.
>
> cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
> cx231xx #1: can't change interface 4 alt no. to 1 (err=-22)
> cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
> cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
> cx231xx #1: can't change interface 5 alt no. to 0 (err=-22)
> cx231xx #1: Changing the i2c master port to 3
> cx25840 3-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #1)
> cx25840 3-0044:  Firmware download size changed to 16 bytes max length
> cx25840 3-0044: unable to open firmware v4l-cx231xx-avcore-01.fw
????

Maybe I need that, eh?  :-)

-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

