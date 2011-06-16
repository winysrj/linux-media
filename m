Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:50356 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094Ab1FPVgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 17:36:12 -0400
Message-ID: <4DFA7748.6000704@hoogenraad.net>
Date: Thu, 16 Jun 2011 23:36:08 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: =?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>
CC: linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de> <4DF9EA62.2040008@killerhippy.de>
In-Reply-To: <4DF9EA62.2040008@killerhippy.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sascha: Thanks for the links

Would you know how to contact poma ?
http://www.spinics.net/lists/linux-media/msg24890.html

I will be getting more info from Realtek soon.
I did not realize that they were putting out updated drivers.

Once the status becomes more clear, I'll update
http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U

Sascha Wüstemann wrote:
> Thomas Holzeisen wrote:
>> Hi there,
>>
>> I tried to get an RTL2831U dvb-t usb-stick running with a more recent kernel (2.6.38) and failed.
>>
>> The hg respository ~jhoogenraad/rtl2831-r2 aborts on countless drivers, the rc coding seem have to
>> changed a lot since it got touched the last time.
>>
>> The hg respository ~anttip/rtl2831u wont compile as well, since its even older.
>>
>> The recent git respositories for media_tree and anttip dont contain drivers for the rtl2831u.
>>
>> Has this device been abandoned, or is anyone working on it?
>>
>> greetings,
>> Thomas
>
> There are still people working on it and there is new sources, e.g. look at
> http://www.spinics.net/lists/linux-media/msg24890.html
> at the very bottom. Worked like a charm at my system with kernel 2.6.39.
>
> I think, there will be announcements later at
> http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start
>
> Greetings from Braunschweig, Germany.
> Sascha
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
