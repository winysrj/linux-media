Return-path: <mchehab@pedra>
Received: from v-smtp-auth-relay-2.gradwell.net ([79.135.125.41]:59291 "EHLO
	v-smtp-auth-relay-2.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648Ab0JSXYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 19:24:11 -0400
Message-ID: <leHzokEJiivMFwXd@echelon.upsilon.org.uk>
Date: Wed, 20 Oct 2010 00:23:53 +0100
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
From: dave cunningham <news004@upsilon.org.uk>
Subject: Re: AF9013/15 I2C problems
References: <0wdXDqCnQtuMFwvF@echelon.upsilon.org.uk>
 <4CBB1982.4050309@iki.fi>
In-Reply-To: <4CBB1982.4050309@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii;format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In message <4CBB1982.4050309@iki.fi>, Antti Palosaari wrote

>On 10/17/2010 01:47 PM, dave cunningham wrote:
>> I'm currently on hg version <14319:37581bb7e6f1>, on a debian-squeeze
>> system, kernel 2.6.32.
>>
>> I've googled and found various people seeing similar problems but have
>> yet to come across a solution.
>>
>> Would anyone have any suggestions (note if I switch back to firmware
>> 4.65 with just the Tevion stick things are fine - I'd like to use the
>> KWorld stick if possible though)?
>
>I have strong feeling this issue is fixed already. Install latest Git 
>master driver from Linuxtv.org
>

I've compiled the git media-master, commit 
<1c8c51f7413ec522c7b729c8ebc5ce815fb7d4a8> and still have problems.

With the Tevion Stick I now see the following at boot (with both 
firmware 4.65.0 and 4.95.0):


[    6.257795] DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
[    6.264875] TDA18271HD/C1 detected @ 1-00c0
[    6.902293] af9015: command failed:1
[    6.902789] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x0, len = 39, i2c_t
ransfer returned: -1
[    7.540215] af9015: command failed:1
[    7.540707] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x20, len = 1, i2c_t
ransfer returned: -1
[    8.178133] af9015: command failed:1
[    8.178747] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x20, len = 1, i2c_t
ransfer returned: -1
[    8.816417] af9015: command failed:1
[    8.817039] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x20, len = 1, i2c_transfer returned: -1
[    9.454467] af9015: command failed:1
[    9.455080] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x20, len = 1, i2c_transfer returned: -1
[   10.092508] af9015: command failed:1
[   10.093122] tda18271_write_regs: [1-00c0|M] ERROR: idx = 0x23, len = 1, i2c_transfer returned: -1
[   10.730542] af9015: command failed:1
...


The KWorld stick comes up OK and can be used but after changing 
channels/sources a few times in mythtv I get (firmware 4.95.0):


Oct 19 23:52:32 beta dhcpd: DHCPACK on 192.168.0.9 to 00:1c:c0:8c:88:7d via eth0
Oct 19 23:58:04 beta kernel: [  480.140076] af9013: I2C read failed reg:d507
Oct 19 23:58:06 beta kernel: [  482.152089] af9013: I2C read failed reg:d507
Oct 19 23:58:08 beta kernel: [  484.164077] af9013: I2C read failed reg:d507
Oct 19 23:58:10 beta kernel: [  486.176076] af9013: I2C read failed reg:d507
Oct 19 23:58:12 beta kernel: [  488.188128] af9013: I2C read failed reg:d507
...

-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
