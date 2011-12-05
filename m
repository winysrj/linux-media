Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:52655 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754698Ab1LEEVm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 23:21:42 -0500
Message-ID: <4EDC46D4.6060708@seiner.com>
Date: Sun, 04 Dec 2011 20:21:40 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org>
In-Reply-To: <1323058527.12343.3.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2011-12-04 at 18:01 -0800, Yan Seiner wrote:
>   
>> I am experiencing a kernel oops when trying to use a Hauppage USB Live 2 
>> frame grabber.  The oops is below.
>>
>> The system is a SOC 260Mhz Broadcom BCM47XX access point running OpenWRT.
>>
>> root@anchor:/# uname -a
>> Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
>>
>> The OOPS could be due to the limited hardware or something else.  I'd 
>> appreciate any suggestions for making this work.  I was hoping with 
>> hardware compression I could make it work on this platform.  I am 
>> currently using a Hauppage USB Live (saa7115 based) with no problems but 
>> with limited resolution.
>>
>> cx231xx v4l2 driver loaded.
>> cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
>> cx231xx #0: registering interface 1
>> cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
>> cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
>> cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
>> cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
>> cx231xx #0: Changing the i2c master port to 3
>> cx231xx #0: cx25840 subdev registration failure
>>     
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The cx231xx driver requires the cx25840 module.  I'll wager you didn't
> install it on your router.
>
>   
Right in one.  I did not because it didn't seem to be required - no 
missing symbols or error messages.  Would a warning to syslog be possible?

With 8MB of flash, I remove everything that is not required.

--Yan

-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

