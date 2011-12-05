Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58908 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab1LEPHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 10:07:00 -0500
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com>
In-Reply-To: <4EDC4E9B.40301@seiner.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: cx231xx kernel oops
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 05 Dec 2011 10:06:59 -0500
To: Yan Seiner <yan@seiner.com>, linux-media@vger.kernel.org
Message-ID: <78544d27-43ee-402b-bb50-748637a272e3@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner <yan@seiner.com> wrote:

>Yan Seiner wrote:
>> Andy Walls wrote:
>>> On Sun, 2011-12-04 at 18:01 -0800, Yan Seiner wrote:
>>>  
>>>> I am experiencing a kernel oops when trying to use a Hauppage USB 
>>>> Live 2 frame grabber.  The oops is below.
>>>>
>>>> The system is a SOC 260Mhz Broadcom BCM47XX access point running 
>>>> OpenWRT.
>>>>
>>>> root@anchor:/# uname -a
>>>> Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
>>>>
>>>> The OOPS could be due to the limited hardware or something else.  
>>>> I'd appreciate any suggestions for making this work.  I was hoping 
>>>> with hardware compression I could make it work on this platform.  I
>
>>>> am currently using a Hauppage USB Live (saa7115 based) with no 
>>>> problems but with limited resolution.
>>>>
>>>> cx231xx v4l2 driver loaded.
>>>> cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps 
>>>> (2040:c200) with 5 interfaces
>>>> cx231xx #0: registering interface 1
>>>> cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size =
>0
>>>> cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size =
>0
>>>> cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
>>>> cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>>>> cx231xx #0: Changing the i2c master port to 3
>>>> cx231xx #0: cx25840 subdev registration failure
>>>>     
>>>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> The cx231xx driver requires the cx25840 module.  I'll wager you
>didn't
>>> install it on your router.
>>>
>>>   
>>
>> I made sure the module was loaded; same thing.  :-(
>>
>> Module                  Size  Used by    Tainted: G 
>> cx231xx               124608  0
>> cx2341x                13552  1 cx231xx
>> cx25840                35568  2
>> rc_core                12640  1 cx231xx
>> videobuf_vmalloc        3168  1 cx231xx
>> videobuf_core          12384  2 cx231xx,videobuf_vmalloc
>>
>> I was not able to catch the first bit.
>>
>> cx231xx #1: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>> cx231xx #1: can't change interface 4 alt no. to 1 (err=-22)
>> cx231xx #1: Identified as Hauppauge USB Live 2 (card=9)
>> cx231xx #1: cx231xx_dif_set_standard: setStandard to ffffffff
>> cx231xx #1: can't change interface 5 alt no. to 0 (err=-22)
>> cx231xx #1: Changing the i2c master port to 3
>> cx25840 3-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #1)
>> cx25840 3-0044:  Firmware download size changed to 16 bytes max
>length
>> cx25840 3-0044: unable to open firmware v4l-cx231xx-avcore-01.fw
>????
>
>Maybe I need that, eh?  :-)
>
>-- 
>Few people are capable of expressing with equanimity opinions which
>differ from the prejudices of their social environment. Most people are
>even incapable of forming such opinions.
>    Albert Einstein
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yes, you need the firmware file. :)

Regards,
Andy
