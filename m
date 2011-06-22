Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:40097 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750724Ab1FVFed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 01:34:33 -0400
Message-ID: <4E017EE7.9040902@hoogenraad.net>
Date: Wed, 22 Jun 2011 07:34:31 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Steffen Barszus <steffenbpunkt@googlemail.com>
CC: Antti Palosaari <crope@iki.fi>, stybla@turnovfree.net,
	=?ISO-8859-1?Q?Sascha_W=FCstemann?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de>	<4DF9EA62.2040008@killerhippy.de>	<4DFA7748.6000704@hoogenraad.net>	<4DFFC82B.10402@iki.fi>	<4E002EBD.6050800@hoogenraad.net> <BANLkTim76FRL+ZNapHyjgFyOvuMXxGVzJQ@mail.gmail.com>
In-Reply-To: <BANLkTim76FRL+ZNapHyjgFyOvuMXxGVzJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks. Do you know more about this subject ?

We do have specs about the chipset, but

http://linuxtv.org/downloads/v4l-dvb-apis/remote_controllers.html#Remote_controllers_Intro

only mentions lirc, not rc-core.
This is about where my knowledge stops, however.

rc-core is only mentioned shortly in:
http://linuxtv.org/wiki/index.php/Remote_Controllers

Steffen Barszus wrote:
> 2011/6/21 Jan Hoogenraad<jan-conceptronic@hoogenraad.net>:
>> and add the IR remote interface, based
>> on the LIRC framework.
>> It actually should yield little code, and mainly requires a) understanding
>> of LIRC and b) comparing code tables to that the in-kernel code tables can
>> be re-used.
>
>
> sorry for the noise , but i guess you mean rc-core not Lirc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
