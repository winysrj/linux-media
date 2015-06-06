Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54496 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbFFUO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:14:29 -0400
Message-ID: <557354A2.7060900@iki.fi>
Date: Sat, 06 Jun 2015 23:14:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Unembossed Name <severe.siberian.man@mail.ru>,
	linux-media@vger.kernel.org
Subject: Re: Si2168 B40 frimware.
References: <0448C37B97FE43E6A8CD61968C10E73F@unknown> <55733133.6050502@iki.fi> <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown>
In-Reply-To: <CFB6F14A3740441FB49C6FF2FC3CAD56@unknown>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 11:02 PM, Unembossed Name wrote:
>>> Anybody want to test it? Unfortunately, I can not do it myself, because
>>> I do not own hardware with B40 revision.
>>
>> That does not even download. It looks like 17 byte chunk format, but
>> it does not divide by 17. Probably there is some bytes missing or too
>> many at the end of file.
>>
>> That is how first 16 bytes of those firmwares looks:
>> 4.0.4:  05 00 aa 4d 56 40 00 00  0c 6a 7e aa ef 51 da 89
>> 4.0.11: 08 05 00 8d fc 56 40 00  00 00 00 00 00 00 00 00
>> 4.0.19: 08 05 00 f0 9a 56 40 00  00 00 00 00 00 00 00 00
>>
>> 4.0.4 is 8 byte chunks, 4.0.11 is 17 byte.
>
> Hi Antti,
>
> You're right. I've made a mistake with determining of the end of a
> patch. It seems I  blindly used an obsolete information about size it
> should be. And because of that, these version of a patch can be even
> more recent. Like 4.0.20.
>
> Could you please check it again? And in case of success see which
> version it is?
>
> file
> name:dvb-demod-si2168-b40-rom4_0_2-patch-build-probably4_0_19.fw.tar.gz
> http://beholder.ru/bb/download/file.php?id=857
> Best regards.

That one works, DVB-T/T2 scan tested.

si2168 6-0064: found a 'Silicon Labs Si2168-B40'
si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 6-0064: firmware version: 4.0.19
si2157 7-0060: found a 'Silicon Labs Si2157-A30'
si2157 7-0060: firmware version: 3.0.5

regards
Antti

-- 
http://palosaari.fi/
