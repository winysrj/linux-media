Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52439 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3BCADm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2013 19:03:42 -0500
Received: by mail-we0-f181.google.com with SMTP id t44so3882574wey.12
        for <linux-media@vger.kernel.org>; Sat, 02 Feb 2013 16:03:41 -0800 (PST)
Message-ID: <510DA959.6000106@googlemail.com>
Date: Sun, 03 Feb 2013 00:03:37 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
References: <510A9A1E.9090801@googlemail.com> <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com> <510ADB2F.4080901@googlemail.com> <510AF800.2090607@googlemail.com> <510BACD5.2070406@googlemail.com> <510BCE2F.1070100@googlemail.com> <CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com> <510C2DA2.7020000@googlemail.com> <CAGoCfiy3hJtkxZG==wg4o1AG2dV3ESiwApNj3GxENDsLSQ=jSA@mail.gmail.com>
In-Reply-To: <CAGoCfiy3hJtkxZG==wg4o1AG2dV3ESiwApNj3GxENDsLSQ=jSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/01/13 21:07, Devin Heitmueller wrote:
> On Fri, Feb 1, 2013 at 4:03 PM, Chris Clayton <chris2553@googlemail.com> wrote:
>> Yes, I noticed that but even with the tuning timeout set at medium or
>> longest, I doesn't find any channels. However, I've been following the debug
>> messages through the code and ended up at
>> drivers/media/pci/cx23885/cx23885-i2c.c.
>>
>> I've found that by amending I2C_WAIT_DELAY from 32 to 64, I get improved
>> results from scanning. With that delay doubled, scandvb now finds 49
>> channels over 3 frequencies. That's with all debugging turned off, so no
>> extra delays provided by the production of debug messages.
>>
>> I'll play around more tomorrow and update then.
>
> It could be that the cx23885 driver doesn't properly implement I2C
> clock stretching, which is something you don't encounter on most
> tuners but is an issue when communicating with the Xceive parts.
>

Well, the action seems to be in drivers/pci/cx23885/cx23885-i2c.c.

I answer to your point above, I've had to look up what I2C clock 
stretching is and I believe that, basically, the driver would wait for 
the hardware to give the go-ahead to continue. That's what seems to be 
happening in i2c_wait_done(), but whether that's a good implementation I 
cannot say.

I've noticed that there is some consistency in the failure. For example, 
if I boot the laptop, activate the dvb-t card and then run a channel 
scan, no channels will be found. If I then turn on debugging in the 
cx23885 driver (by writing 1 to 
/sys/module/cx23885/parameters/i2c_debug), and then run the scan again, 
some channels will be found. The number found varies from just a few to, 
on one occasion, all 117 of them. Then, I can turn debugging off again 
and channels will again be found when I run the scan and continue to be 
found each time I run the scan. If I reboot, the cycle starts again.

I've also added some printks to the cx23885-i2c.c to find out where the 
return value of -5 (-EIO) comes from. I've found that the call to 
i2c_wait_done in i2c_sendbytes (line 145) returns 0 and that results in 
-EIO being returned a few lines later. My debug output also contained 
the value of the variable cnt, which controls the enclosing for() loop. 
cnt always has the value 3. I don't know what this might mean in terms 
of locating the problem, but hopefully someone on the list will.

Chris
> Devin
>
