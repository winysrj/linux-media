Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:54428 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab1FVLMF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 07:12:05 -0400
Message-ID: <4E01CDFF.8050502@iki.fi>
Date: Wed, 22 Jun 2011 14:11:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steffen Barszus <steffenbpunkt@googlemail.com>
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Jarod Wilson <jarod@wilsonet.com>, stybla@turnovfree.net,
	=?ISO-8859-1?Q?Sascha_W=FCstemann?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de>	<4DF9EA62.2040008@killerhippy.de>	<4DFA7748.6000704@hoogenraad.net>	<4DFFC82B.10402@iki.fi>	<4E002EBD.6050800@hoogenraad.net>	<BANLkTim76FRL+ZNapHyjgFyOvuMXxGVzJQ@mail.gmail.com>	<4E017EE7.9040902@hoogenraad.net> <20110622081359.6d55979a@grobi>
In-Reply-To: <20110622081359.6d55979a@grobi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/22/2011 09:13 AM, Steffen Barszus wrote:
> On Wed, 22 Jun 2011 07:34:31 +0200
> Jan Hoogenraad<jan-conceptronic@hoogenraad.net>  wrote:
>
>> Thanks. Do you know more about this subject ?
>>
>> We do have specs about the chipset, but
>>
>> http://linuxtv.org/downloads/v4l-dvb-apis/remote_controllers.html#Remote_controllers_Intro
>>
>> only mentions lirc, not rc-core.
>> This is about where my knowledge stops, however.
>>
>> rc-core is only mentioned shortly in:
>> http://linuxtv.org/wiki/index.php/Remote_Controllers
>
> I think/hope Jarod can comment on this - i just know that new remotes
> should use rc-core, as this is the "new thing" for this. I'm no
> developer whatsoever :)

No problem there, I already know rather well how rc-core is working :) 
Will do that.

RTL2830 demod driver seems to be now rather OK, missing all statistics 
as I planned, but otherwise rather ready. Seems to have some more work 
for getting statistic since looks like it polls huge amount of regs when 
updating those.

I am now finalizing that USB-bridge part. Do you have idea if that 
should be called;

as used chipset names:
dvb_usb_rtl2831u
dvb_usb_rtl2832u
dvb_usb_rtl2836u
dvb_usb_rtl2840u

or just name it as generic:
dvb_usb_rtl28xxu
dvb_usb_rtl2800u

or some other.

rtl28xxu or rtl2800u sounds best for me.

regards
Antti

-- 
http://palosaari.fi/
