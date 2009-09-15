Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40030 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbZIOTwh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 15:52:37 -0400
Message-ID: <4AAFF081.7000904@iki.fi>
Date: Tue, 15 Sep 2009 22:52:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Roman v. Gemmeren" <roman@hasnoname.de>
CC: linux-media@vger.kernel.org
Subject: Re: MSI Digivox Micro HD support?
References: <200909152050.32487.roman@hasnoname.de>
In-Reply-To: <200909152050.32487.roman@hasnoname.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2009 09:50 PM, Roman v. Gemmeren wrote:
>>> i just bought the above mentioned DVBT-Stick after my terratec prodigy
>>> died (from overheating i guess).
>>> I remembered sth. about digivox being supported, but i found only drivers
>>> for the "Digivox Mini II 3.0" which don't seem to recognize that stick at
>>> all.
>>>
>>> Anyone got that card working? If it is just the usb-id which is missing,
>>> how /where would i add that to the source?
>>
>> Just do lsusb -vvd USB:ID and post here. From that we usually can say
>> which chips are used and correct driver needed for device. Also you can
>> look driver .inf file, driver filenames, look strings from driver, look
>> sniff or open the box to identify chips.
>>
>> Antti
> This is the output for the Stick:
>
> root@Seth:~strowi/tmp>  lsusb -vvd 1ba6:0001

Bad new. This looks like totally new chip. In my understanding no-one is 
working for that and this is first time I hear even it.
http://www.abilis.com/

If they are willing to give specs and sample code for the GPL then 
someone could be willing to write driver. Or reverse-engineering...

Antti
-- 
http://palosaari.fi/
