Return-path: <linux-media-owner@vger.kernel.org>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:43412 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1L0SAO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 13:00:14 -0500
Message-ID: <4EFA07AB.8080001@holzeisen.de>
Date: Tue, 27 Dec 2011 19:00:11 +0100
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: af9015: Second Tuner hangs after a while
References: <4EF9F5E9.9020908@holzeisen.de> <4EF9FF86.7020605@iki.fi>
In-Reply-To: <4EF9FF86.7020605@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I managed to get the Oops when disconnecting:

Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.144450] Oops: 0000 [#1] SMP
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.147537] Process kworker/0:4 (pid: 1912, ti=f2f94000 task=f44d6180 task.ti=f2f94000)
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.147682] Stack:
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.148008] Call Trace:
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.148008] Code: f8 75 09 83 ea 28 74 04 89 d0 eb e7 83 c0 10 e9 ba 73 d9 c8 55 89 cd 57 56 89 c6 53 bb a1
ff ff ff 83 ec 08 89 54 24 04 8b 40 08
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.148008] EIP: [<f850c92e>] i2c_transfer+0x17/0xb7 [i2c_core] SS:ESP 0068:f2f95eec
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.148008] CR2: 0000000000000002
Message from syslogd@xbmc at Dec 27 17:53:32 ...
 kernel:[  493.164072] Oops: 0000 [#2] SMP


Antti Palosaari wrote:
> On 12/27/2011 06:44 PM, Thomas Holzeisen wrote:
>> Until some time ago, there was not even a remote chance getting this Dual-Tuner Stick to work. When trying to tune in a
>> second transponder, the log got spammed with these:
>>
>> [  835.412375] af9015: command failed:1
>> [  835.412383] mxl5005s I2C write failed
>>
>> However, I applied the patches ba730b56cc9afbcb10f329c17320c9e535c43526 and 61875c55170f2cf275263b4ba77e6cc787596d9f
>> from Antti Palosaari. For the first time I got able to receive two Transponders at once. Sadly after a while the second
>> adapter stops working, showing the I2C erros above. The first adapter keeps working. Also attaching and removing the
>> stick does not work out very well.
> 
>> this is repeatable to me every time. Removing the stick when in warm state, leads to kernel oops every time. Kernel
>> Version is 3.1.2.
> 
> Rather interesting problems. As I understand there is two success reports and of course tests I have done. This is first
> report having problems.
> 
> I have PULL requested those changes about one month ago and hope those will committed soon in order to get more
> testers... It is big change, basically whole driver is rewritten and as it is one of the most popular devices it will be
> big chaos after Kernel merge if there will be problems like you have. For now I will still be and wait more reports.
> 
> 
> regards
> Antti

