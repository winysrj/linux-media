Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.248.54]:53042 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0CFTSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 14:18:32 -0500
Message-ID: <4B92AA84.5010908@online.no>
Date: Sat, 06 Mar 2010 20:18:28 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201003032105.06263.liplianin@me.by> <4B903127.208@online.no> <201003061352.06763.liplianin@me.by>
In-Reply-To: <201003061352.06763.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin skrev:
> On 5 марта 2010 00:16:07 Hendrik Skarpeid wrote:
>   
>> Igor M. Liplianin skrev:
>>     
>>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
>>>       
>>>> Igor M. Liplianin wrote:
>>>>         
>>>>> Now to find GPIO's for LNB power control and ... watch TV :)
>>>>>           
>>>> Yep. No succesful tuning at the moment. There might also be an issue
>>>> with the reset signal and writing to GPIOCTR, as the module at the
>>>> moment loads succesfully only once.
>>>> As far as I can make out, the LNB power control is probably GPIO 16 and
>>>> 17, not sure which is which, and how they work.
>>>> GPIO15 is wired to tuner #reset
>>>>         
>>> New patch to test
>>>
>>> ------------------------------------------------------------------------
>>>
>>>
>>> No virus found in this incoming message.
>>> Checked by AVG - www.avg.com
>>> Version: 9.0.733 / Virus Database: 271.1.1/2721 - Release Date: 03/03/10
>>> 20:34:00
>>>       
>> modprobe si21xx debug=1 produces this output when scanning.
>>
>> [ 2187.998349] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
>> [ 2187.998353] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
>> [ 2187.999881] si21xx: si21xx_setacquire
>> [ 2187.999884] si21xx: si21xx_set_symbolrate : srate = 27500000
>> [ 2188.022645] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x01
>> [ 2188.054350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
>> [ 2188.054355] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
>> [ 2188.055875] si21xx: si21xx_setacquire
>> [ 2188.055879] si21xx: si21xx_set_symbolrate : srate = 27500000
>> [ 2188.110359] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
>> [ 2188.110366] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
>> [ 2188.111885] si21xx: si21xx_setacquire
>> [ 2188.111889] si21xx: si21xx_set_symbolrate : srate = 27500000
>> [ 2188.166350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
>> [ 2188.166354] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
>>
>> Since the tuner at hand uses a Si2109 chip, VSTATUS 0x01 and 0x02 would
>> indicate that blind scanning is used. Blind scanning is a 2109/2110
>> specific function, and may not very usable since we always use initial
>> tuning files anyway. 2109/10 also supports the legacy scanning method
>> which is supported by Si2107708.
>>
>> Is the use of blind scanning intentional?
>>     
> Yes, of course, it's intentional. Why not?
> User has freedom to make little errors in channels.conf file. Also the chip didn't support DVB-S2. 
> And last, has who si2107/08 ? My chip is si2109.
>
>
>   

I agree, it's best to use the hardware features. I was worried that I 
may be getting bad i2c data.
If I understand you correctly, you have a working Si2109 frontend driver?
Here's what I'm getting:
Added a few printouts to si21xx.c

        u8 signal = si21_readreg(state, ANALOG_AGC_POWER_LEVEL_REG);
        dprintk("%s : FE_READ_STATUS : AGC_POWER: 0x%02x\n", __func__, 
signal);

        si21_readregs(state, LOCK_STATUS_REG_1, regs_read, 0x02);

        reg_read = 0;

        for (i = 0; i < 7; ++i)
                reg_read |= ((regs_read[0] >> i) & 0x01) << (6 - i);

        lock = ((reg_read & 0x7f) | (regs_read[1] & 0x80));

        dprintk("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, lock);
        dprintk("%s : FE_READ_REGS : REGS[0]: 0x%02x\n", __func__, 
regs_read[0]);
        dprintk("%s : FE_READ_REGS : REGS[1]: 0x%02x\n", __func__, 
regs_read[1]);

hendrik@iptv:~$ scan -a 1 Sirius-5.0E

[72933.818871] si21xx: si21xx_set_symbolrate : srate = 27500000
[72933.900276] si21xx: si21_read_status : FE_READ_STATUS : AGC_POWER: 0x20
[72933.908807] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[72933.908812] si21xx: si21_read_status : FE_READ_REGS : REGS[0]: 0x20
[72933.908815] si21xx: si21_read_status : FE_READ_REGS : REGS[1]: 0x00
[72933.908827] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
[72933.914962] si21xx: si21xx_setacquire
[72933.914967] si21xx: si21xx_set_symbolrate : srate = 27500000
[72933.949370] si21xx: si21_read_status : FE_READ_STATUS : AGC_POWER: 0x21
[72933.957877] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x01
[72933.957882] si21xx: si21_read_status : FE_READ_REGS : REGS[0]: 0xc0
[72933.957885] si21xx: si21_read_status : FE_READ_REGS : REGS[1]: 0x60
[72933.996316] si21xx: si21_read_status : FE_READ_STATUS : AGC_POWER: 0x20
[72934.004959] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
[72934.004964] si21xx: si21_read_status : FE_READ_REGS : REGS[0]: 0x20
[72934.004968] si21xx: si21_read_status : FE_READ_REGS : REGS[1]: 0x00

So, we have signal and sometimes we are getting carrier also.
What worries me most is the FE_READ_REGS : REGS[1]: 0x60
According to the datasheet this register 0x10 Lock status 2,  is RCVL 0 
0 0 0 0 BSDA BSDO so 0x60 would seem meaningless.

Same results using szap.
hendrik@iptv:~$ szap -a 1 -r -n 170
reading channels from file '/home/hendrik/.szap/channels.conf'
zapping to 170 'NRK1;NRK':
sat 0, frequency = 12015 MHz V, symbolrate 27500000, vpid = 0x0200, apid 
= 0x0280 sid = 0x0240
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
status 01 | signal c600 | snr 0000 | ber 000000b1 | unc 00000000 |
status 01 | signal c600 | snr 0000 | ber 0000000f | unc 00000000 |
status 01 | signal c000 | snr 0000 | ber 0000980f | unc 00000000 |
status 03 | signal c600 | snr 0000 | ber 000098a3 | unc 00000000 |
status 03 | signal c000 | snr 0000 | ber 000098c7 | unc 00000000 |

Signal but no lock.
Any ideas?
