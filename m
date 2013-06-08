Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3FHMDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jun 2013 08:03:11 -0400
Message-ID: <51B31D57.8000605@iki.fi>
Date: Sat, 08 Jun 2013 15:02:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rodrigo Tartajo <rtarty@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl28xxu IR remote
References: <51B26B2C.7090406@gmail.com> <51B31628.2090702@iki.fi>
In-Reply-To: <51B31628.2090702@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2013 02:31 PM, Antti Palosaari wrote:
> On 06/08/2013 02:22 AM, Rodrigo Tartajo wrote:
>> Hi, I just compiled and tested Antti Palosaari branch and can confirm
>> the remote works for my RTL2832U. I have updated the wiki[1] entry
>> with the steps necessary to configure the remote control. Please
>> confirm if these fixes your problem.
>>
>> Rodrigo.
>>
>> [1] http://www.linuxtv.org/wiki/index.php/RealTek_RTL2832U
>
>
> Good. I tested it quite limited set of remote controllers and even found
> one NEC remote which didn't worked - RC_MAP_MSI_DIGIVOX_II. Maybe
> timings should be adjusted or there is some other factor. I didn't cared
> to look it more as I am not very familiar with these raw remote
> protocols and real life variations.
>
> I also had no reference to adjust remote timings. I just used one RC5
> remote and calibrated timings according to that. If there is someone
> having better reference signals, then feel free to change that timing
> value to more correct.

Rodrigo,
as it was you who has defined that factor as a:
1000000000 / 38000 * 2 = 52631

I found 50800 most suitable by error and trial testing against one RC5 
remote. I see 38000 is coming from IR frequency, but what is 1GHz clock 
derived? And why multiply by 2? Reference clock feed to chip is 28.800 
MHz and most likely these timings should be derived somehow from it. I 
tried to make different calculations but didn't find any suitable...

Also what I remember, these IR leds will not return receiver carrier at 
given frequency (38kHz in that case) but instead longer pulses. If there 
is 0.5 sec 38 kHz modulated IR wave then IR-led will return 0.5 sec 
continuous pulse. So that frequency should not matter too.

I did learning IR remote controller, which has both receiver and IR 
sender, as a school project:
http://palosaari.fi/img_1305.jpg

Unfortunately that was returned to the uni and was thrown to the trash 
can :S I have thought many times that board could be handy tool for 
hacking support for these remote controllers...


regards
Antti

-- 
http://palosaari.fi/
