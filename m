Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:34358 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751096Ab1FUFkQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 01:40:16 -0400
Message-ID: <4E002EBD.6050800@hoogenraad.net>
Date: Tue, 21 Jun 2011 07:40:13 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, stybla@turnovfree.net
CC: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net> <4DFFC82B.10402@iki.fi>
In-Reply-To: <4DFFC82B.10402@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti:

You are great !

So as far as I am concerned, it would be great if one of the others 
could use up your work on the USB bridge, and add the IR remote 
interface, based on the LIRC framework.
It actually should yield little code, and mainly requires a) 
understanding of LIRC and b) comparing code tables to that the in-kernel 
code tables can be re-used.

Note that Zdenek Styblik seems to have received updates from Realtek 
THIS month
http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start

He has posted a Ver 2.2.0 of the driver at:
http://www.turnovfree.net/~stybla/linux/v4l-dvb/lv5tdlx/

It supports the RTL2832U and RTL2836 and way more tuners (MT2266 FC2580 
TUA9001 and MXL5007T E4000 FC0012  tda18272 fc0013)

However, the code is not split up.


Antti Palosaari wrote:
> It is Maxim who have been hacking with RTL2832/RTL2832U lately. But I
> think he have given up since no noise anymore.
>
> I have taken now it again up to my desk and have been hacking two days
> now. Currently I am working with RTL2830 demod driver, I started it from
> scratch. Take sniffs, make scripts to generate code from USB traffic,
> copy pasted that to driver skeleton and now I have picture. Just
> implement all one-by-one until ready :-) I think I will implement it as
> minimum possible, no any signal statistic counters - lets add those
> later if someone wants to do that.
>
> USB-bridge part is rather OK as I did earlier and it is working with
> RTL2831U and RTL2832U at least. No remote support yet.
>
> I hope someone else would make missing driver for RTL2832U demod still...
>
>
> Antti
>
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
