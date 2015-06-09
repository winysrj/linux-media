Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp52.i.mail.ru ([94.100.177.112]:38208 "EHLO smtp52.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbbFIB53 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 21:57:29 -0400
Message-ID: <E21EB9CE868F46199F08CAF33C2798E1@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
References: <A9A450C95D0047DA969F1F370ED24FE4@unknown> <5575B32D.8050809@iki.fi> <143B25D372A842478792E29914320459@unknown> <55762957.1060403@iki.fi>
Subject: Re: About Si2168 Part, Revision and ROM detection.
Date: Tue, 9 Jun 2015 08:57:21 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Antti Palosaari"
To: "Unembossed Name" <severe.siberian.man@mail.ru>; <linux-media@vger.kernel.org>
Sent: Tuesday, June 09, 2015 6:46 AM
Subject: Re: About Si2168 Part, Revision and ROM detection.


>> And at the same time, he was able to successfully upload firmware patch,
>> that
>> designed for A30 ROM 3.0.2 and makes version 3.0.2 => 3.0.20 after patching
>> completes. Here it is: http://beholder.ru/bb/download/file.php?id=732
>>
>> What can be cause of that? Probably it's either broken or corrupted
>> firmware
>> (I doubt in it), or possibly it's designed for A30 revision, but with
>> another ROM
>> version?
> 
> I expected dvb-demod-si2168-a30-01.fw to be update for 3.0.2 ROM. But 
> not sure. Olli surely has sniffs to check which ROM and PBUILD device 
> has replied. If it appears to be some other than 3.0.2 it explains some 
> things (why firmware is incompatible).

That would be really good to retest it somehow. 

>> #define Si2168B_ROM1_4_0_2_PBUILD   2
>>
>> Here we can see here, that ROM from a chip vendor can come as:
>> PMAJOR   '2'
>> PMINOR   '0'
>> PBUILD   3
>> And not only 2.0.2, 3.0.2, 4.0.2 and so on.
> 
> These values meet 100% for those sniffs. But is there really any other 
> than these? Have you seen any other version than Si2168-B 4.0.2 for example?

No, I have not seen. And a hw vendor, who gave us this little info, also wrote about 4.0.2
But, there is nothing impossible. If they already done that one time. Why not to do it again.

BTW: I've found that I've missed a few more things.
1. It is also possible to start A30 without patch and even stub code. Just boot it.

2. Hw vendor gave us a little advice. I'm not sure, will it be useful for you, but, as he wrote: 
"when you checking CTS status, check it by a mask 0x3C and she should be empty,
because sometimes you can receive a wrong status, you should ignore it, if by
a mask 0x3C not  zeroes".

3. After fw download completion, it's possible to switch a demod into a sleep mode with a
command Si2168_POWER_DOWN_CMD (without CTS status checking). And wake
it when it needed with a command Si2168_START_CLK_CMD (with a parameter
Si2168_POWER_UP_CMD_WAKE_UP_WAKE_UP) any desired number of times. 
After that you do not need to reupload fw patch again.

4. After you switching chip pins with a command Si2168_DD_EXT_AGC_TER_CMD, 
you have to give a command Si2168_DD_RESTART_CMD, otherwise pins will not be 
switched. And after Si2168_DD_RESTART_CMD you have to wait minimum 10ms.

