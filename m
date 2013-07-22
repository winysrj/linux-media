Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60239 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3GVVKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 17:10:17 -0400
Message-ID: <51ED9F8F.10206@iki.fi>
Date: Tue, 23 Jul 2013 00:09:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Taegert <jantaegert@gmx.net>
CC: linux-media@vger.kernel.org, thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net> <51E92A78.50706@iki.fi> <51E974DB.7010609@gmx.net>
In-Reply-To: <51E974DB.7010609@gmx.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2013 08:18 PM, Jan Taegert wrote:
> Hello,
>
> when the culprit is the e4000 driver but the old driver from
> https://github.com/valtri/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> worked for me, then must be somewhere there in the driver sources a
> solution for the signal issues.
>
> Does it make sense to look for a particular string in the sources? I
> don't have any clue of coding but perhaps I can be helpful in this way.

Feel free to look. Those are different drivers and you cannot compare 
easily. For my experience you will need huge amount of time and much 
luck with that approach.

As I said, the easiest solution is just to took sniffs and copy&paste 
generated code until it starts working.

regards
Antti

>
> There are
> - tuner_e4000.c
> - nim_rtl2832_e4000.c
>
> Thanks,
> Jan.
>
>
>
> Am 19.07.2013 14:00, schrieb Antti Palosaari:
>> Hello
>> It is e4000 driver problem. Someone should take the look what there is
>> wrong. Someone sent non-working stick for me, but I wasn't able to
>> reproduce issue. I used modulator to generate signal with just same
>> parameters he said non-working, but it worked for me. It looks like
>> e4000 driver does not perform as well as it should.
>>
>> Maybe I should take Windows XP and Linux, use modulator to find out
>> signal condition where Windows works but Linux not, took sniffs and
>> compare registers... But I am busy and help is more than welcome.
>>
>> regards
>> Antti
>


-- 
http://palosaari.fi/
