Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39429 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3FHNQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jun 2013 09:16:53 -0400
Message-ID: <51B32E9E.8060909@iki.fi>
Date: Sat, 08 Jun 2013 16:16:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rodrigo Tartajo <rtarty@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl28xxu IR remote
References: <51B26B2C.7090406@gmail.com> <51B31628.2090702@iki.fi> <51B31D57.8000605@iki.fi> <51B3289A.4090307@gmail.com>
In-Reply-To: <51B3289A.4090307@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2013 03:50 PM, Rodrigo Tartajo wrote:
> El 08/06/13 14:02, Antti Palosaari escribió:
>> On 06/08/2013 02:31 PM, Antti Palosaari wrote:
>>> On 06/08/2013 02:22 AM, Rodrigo Tartajo wrote:
>>>> Hi, I just compiled and tested Antti Palosaari branch and can confirm
>>>> the remote works for my RTL2832U. I have updated the wiki[1] entry
>>>> with the steps necessary to configure the remote control. Please
>>>> confirm if these fixes your problem.
>>>>
>>>> Rodrigo.
>>>>
>>>> [1] http://www.linuxtv.org/wiki/index.php/RealTek_RTL2832U
>>>
>>>
>>> Good. I tested it quite limited set of remote controllers and even found
>>> one NEC remote which didn't worked - RC_MAP_MSI_DIGIVOX_II. Maybe
>>> timings should be adjusted or there is some other factor. I didn't cared
>>> to look it more as I am not very familiar with these raw remote
>>> protocols and real life variations.
>>>
>>> I also had no reference to adjust remote timings. I just used one RC5
>>> remote and calibrated timings according to that. If there is someone
>>> having better reference signals, then feel free to change that timing
>>> value to more correct.
>>
>> Rodrigo,
>> as it was you who has defined that factor as a:
>> 1000000000 / 38000 * 2 = 52631
>>
>> I found 50800 most suitable by error and trial testing against one RC5 remote. I see 38000 is coming from IR frequency, but what is 1GHz clock derived? And why multiply by 2? Reference clock feed to chip is 28.800 MHz and most likely these timings should be derived somehow from it. I tried to make different calculations but didn't find any suitable...
>>
>> Also what I remember, these IR leds will not return receiver carrier at given frequency (38kHz in that case) but instead longer pulses. If there is 0.5 sec 38 kHz modulated IR wave then IR-led will return 0.5 sec continuous pulse. So that frequency should not matter too.
>>
>> I did learning IR remote controller, which has both receiver and IR sender, as a school project:
>> http://palosaari.fi/img_1305.jpg
>>
>> Unfortunately that was returned to the uni and was thrown to the trash can :S I have thought many times that board could be handy tool for hacking support for these remote controllers...
>>
>>
>> regards
>> Antti
>>
> Hi,
> The kernel IR protocol decoder works with nanoseconds length for the pulses/silences, while the IR receiver is sending back a runlenght encoded bytes with the number of ticks at 38KHz (I suppose it is 38Khz, as it is the most common carrier). While doing an hexdump of these IR bytes returned by the device, I could discern their encoding: the higher bit is the indicator of pulses (1) or space (0), the next 7 bits encode the higher 7 bits of a 8 bit counter, dropping the lowest bit (you lose precision, but increase the range of possible values from 127 to 255, reducing the chance of needing multiple bytes to encode a single value). The formula in the macro '#define TICSAT38KHZTONS(x) ((x) * (1000000000/38000))', and why it was feed with 'TICSAT38KHZTONS(((u32)(buf[i] & 0x7F)) << 1)' should be now easier to understand.
> And you are right, unless there is some hidden register we have no information about the carrier frequency, and can only guess the one used.

Aah, now I see, it is not 1GHz but 1 second in nanoseconds. Yeah, seems 
like that calculation is very near. There is some inner logic inside 
chip to calculate nanoseconds from the reference clock. I think 28.800 
MHz is the only possible reference clock so it is easy.

> As a bonus, found attached a statistics of the frequency and count of commands for the remote controls in available on "Remote Central"[1], as you can see the most common carrier frequency is 38KHz or some light variations of it (36, 40 comes next). This list is at least 5 years old, but I dont think there should be any variations with the possible current values.
>
> Rodrigo.
>
> [1]: http://www.remotecentral.com/cgi-bin/codes/

regards
Antti


-- 
http://palosaari.fi/
