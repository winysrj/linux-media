Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:34398 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbLHWMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 17:12:13 -0500
Subject: Re: DVBSky T980C ci not working with kernel 4.x
To: Nibble Max <nibble.max@gmail.com>,
	"timo.helkio" <timo.helkio@kapsi.fi>
References: <201512081149525312370@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <5667544E.3010205@mbox200.swipnet.se>
Date: Tue, 8 Dec 2015 23:06:06 +0100
MIME-Version: 1.0
In-Reply-To: <201512081149525312370@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-12-08 04:49, Nibble Max wrote:
>
> Does this card work with the media code from dvbsky.net from kernel 4.x?
>
> On 2015-12-06 19:10:41, Timo_Helkiö <timo.helkio@kapsi.fi> wrote:
>>
>> Hi
>>
>>
>> Common interface in Dvbsky T980C is not working with Ubuntu 15.10 kernel
>> 4.2.0 and vanilla kernel 4.6 and latest dvb-drivers from Linux-media
>> git. With Ubuntu 15.04 and kernel 3.19 it is working. I have tryid to
>> find differences in drivers, but my knolege of c it is not possible.
>> Erros message is "invalid PC-card".
>>
>> I have also Tevii S470 with same PCIe bridge Conexant cx23885.
>>
>> How to debug this? I can do minor changes to drivers for testing it.
>>
>>    Timo Helkiö
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Best Regards,
> Max


the code from dvbsky works, specificaly this one:
http://www.dvbsky.net/download/linux/media_build-bst-151028.tar.gz

i contacted dvbsky a month or two ago and complained about their old 
drivers no longer working on newer kernels, then i got the above link 
and CI works.

but, i would prefer a working solution using the official code that is 
in the kernel or the "proper" media_build.

there is several reports of this card being broken but unfortunately it 
looks like noone can fix it.
unfortunately i dont know enough to debug kernel drivers or how the 
linux kernel works.


