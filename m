Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35226 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3FHMvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 08:51:22 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi5so2011703wib.8
        for <linux-media@vger.kernel.org>; Sat, 08 Jun 2013 05:51:21 -0700 (PDT)
Message-ID: <51B3289A.4090307@gmail.com>
Date: Sat, 08 Jun 2013 14:50:34 +0200
From: Rodrigo Tartajo <rtarty@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: rtl28xxu IR remote
References: <51B26B2C.7090406@gmail.com> <51B31628.2090702@iki.fi> <51B31D57.8000605@iki.fi>
In-Reply-To: <51B31D57.8000605@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------060009050100010002010609"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060009050100010002010609
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

El 08/06/13 14:02, Antti Palosaari escribió:
> On 06/08/2013 02:31 PM, Antti Palosaari wrote:
>> On 06/08/2013 02:22 AM, Rodrigo Tartajo wrote:
>>> Hi, I just compiled and tested Antti Palosaari branch and can confirm
>>> the remote works for my RTL2832U. I have updated the wiki[1] entry
>>> with the steps necessary to configure the remote control. Please
>>> confirm if these fixes your problem.
>>>
>>> Rodrigo.
>>>
>>> [1] http://www.linuxtv.org/wiki/index.php/RealTek_RTL2832U
>>
>>
>> Good. I tested it quite limited set of remote controllers and even found
>> one NEC remote which didn't worked - RC_MAP_MSI_DIGIVOX_II. Maybe
>> timings should be adjusted or there is some other factor. I didn't cared
>> to look it more as I am not very familiar with these raw remote
>> protocols and real life variations.
>>
>> I also had no reference to adjust remote timings. I just used one RC5
>> remote and calibrated timings according to that. If there is someone
>> having better reference signals, then feel free to change that timing
>> value to more correct.
> 
> Rodrigo,
> as it was you who has defined that factor as a:
> 1000000000 / 38000 * 2 = 52631
> 
> I found 50800 most suitable by error and trial testing against one RC5 remote. I see 38000 is coming from IR frequency, but what is 1GHz clock derived? And why multiply by 2? Reference clock feed to chip is 28.800 MHz and most likely these timings should be derived somehow from it. I tried to make different calculations but didn't find any suitable...
> 
> Also what I remember, these IR leds will not return receiver carrier at given frequency (38kHz in that case) but instead longer pulses. If there is 0.5 sec 38 kHz modulated IR wave then IR-led will return 0.5 sec continuous pulse. So that frequency should not matter too.
> 
> I did learning IR remote controller, which has both receiver and IR sender, as a school project:
> http://palosaari.fi/img_1305.jpg
> 
> Unfortunately that was returned to the uni and was thrown to the trash can :S I have thought many times that board could be handy tool for hacking support for these remote controllers...
> 
> 
> regards
> Antti
> 
Hi,
The kernel IR protocol decoder works with nanoseconds length for the pulses/silences, while the IR receiver is sending back a runlenght encoded bytes with the number of ticks at 38KHz (I suppose it is 38Khz, as it is the most common carrier). While doing an hexdump of these IR bytes returned by the device, I could discern their encoding: the higher bit is the indicator of pulses (1) or space (0), the next 7 bits encode the higher 7 bits of a 8 bit counter, dropping the lowest bit (you lose precision, but increase the range of possible values from 127 to 255, reducing the chance of needing multiple bytes to encode a single value). The formula in the macro '#define TICSAT38KHZTONS(x) ((x) * (1000000000/38000))', and why it was feed with 'TICSAT38KHZTONS(((u32)(buf[i] & 0x7F)) << 1)' should be now easier to understand.
And you are right, unless there is some hidden register we have no information about the carrier frequency, and can only guess the one used.

As a bonus, found attached a statistics of the frequency and count of commands for the remote controls in available on "Remote Central"[1], as you can see the most common carrier frequency is 38KHz or some light variations of it (36, 40 comes next). This list is at least 5 years old, but I dont think there should be any variations with the possible current values.

Rodrigo.

[1]: http://www.remotecentral.com/cgi-bin/codes/

--------------060009050100010002010609
Content-Type: text/plain; charset=UTF-8;
 name="cuentafreq.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cuentafreq.txt"

   6644 38.38
   6481 38.03
   3101 36.04
   3024 40.24
   2295 37.01
   2063 38.74
   1444 35.73
   1237 57.57
   1113 36.68
    792 39.1
    599 37.34
    564 37.68
    546 40.64
    370 32.9
    352 460.57
    209 35.43
    179 58.38
    177 41.87
    166 109.08
    157 39.48
    120 345.43
    119 32.64
     80 121.92
     64 42.3
     61 43.63
     60 30.48
     51 41.45
     47 41.04
     47 33.16
     46 34.26
     43 56.78
     42 39.86
     40 88.19
     40 30.7
     37 56.02
     30 33.98
     28 32.38
     24 98.69
     21 106.28
     20 75.37
     20 63.77
     20 34.54
     20 31.17
     20 20.22
     20 115.14
     20 1036.29
     19 35.13
     17 59.22
     16 43.18
     15 26.92
     11 50.55
      9 33.43
      8 142.94
      6 30.04
      5 28.39
      5 26.74
      5 118.43
      4 153.52
      3 42.73
      3 33.7
      3 31.4
      3 28.59
      2 64.77
      2 60.96
      2 518.14
      2 48.2
      2 47.1
      1 62.8
      1 60.07
      1 49.35
      1 414.51
      1 180.22
      1 112.03

--------------060009050100010002010609--
