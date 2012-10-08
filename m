Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44334 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab2JHKAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 06:00:22 -0400
Message-ID: <5072A41D.5050403@iki.fi>
Date: Mon, 08 Oct 2012 12:59:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Wolfgang Bail <wolfgang.bail@t-online.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-msi-digivox-ii: Add full scan keycodes - Was: Re:
 v4l
References: <201209300549.26996.wolfgang.bail@t-online.de> <20121007100301.3870ef32@redhat.com>
In-Reply-To: <20121007100301.3870ef32@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2012 04:03 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 30 Sep 2012 05:49:26 +0200
> Wolfgang Bail <wolfgang.bail@t-online.de> escreveu:
>
>> Hello,
>>
>> the ir-rc from my msi DigiVox mini II Version 3 (af9015) will not work since
>> kernel 3.2.x (kubuntu 12.04), same with s2-liplianin or v4l.
>>
>> sudo ir-keytable -t shows:
>>
>> Testing events. Please, press CTRL-C to abort.
>> 1348890734.303273: event MSC: scancode = 317
>> 1348890734.303280: event key down: KEY_POWER (0x0074)
>> 1348890734.303282: event sync
>> 1348890734.553961: event key up: KEY_POWER (0x0074)
>> 1348890734.553963: event sync
>> 1348890741.303451: event MSC: scancode = 30d
>> 1348890741.303457: event key down: KEY_DOWN (0x006c)
>> 1348890741.303459: event sync
>> ^[[B1348890741.553956: event key up: KEY_DOWN (0x006c)
>>
>> So I changed in rc-msi-digivox-ii.c { 0x0002, KEY_2 }, to { 0x0302, KEY_2 },
>> and so on. And now it works well.
>>
>> I hope, my mini patch is standard, the first I made.
>
> Well, you should have using a subject like:
>
> [PATCH] rc-msi-digivox-ii: Add full scan keycodes
>
> And your signed-off-by. There are some pages at linuxtv.org wiki that points
> how to write a patch.
>
> Yet, as this is a really trivial one, I'll accept it without your Signed-off-by.
>
>> I don't know, whether
>> there are different variants of remote controls. But I don't believe it,
>> because it was ok with kernel 2.6.x.
>
> No, this seems just yet-another-regression caused by some patch that changed
> the code that gets IR scancode to report the 16-bit keycode, instead of
> just the last 8 bits.
>
> Thanks for it.

Yes, it is that commit where I introduced that mistake:

http://git.opencores.org/?a=commitdiff&p=linux&h=d3bb73de97a9685bb150f81017d7e184fdb18451


Acked-by: Antti Palosaari <crope@iki.fi>

regards
Antti


-- 
http://palosaari.fi/
