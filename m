Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40783 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2BHO6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 09:58:53 -0500
Received: by qadc10 with SMTP id c10so3538217qad.19
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2012 06:58:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F3279B6.7000106@iki.fi>
References: <CAO+60fyyvqbO6NQ6f4EQ88+DQFEkqTogiNQi5WddfNW_o6Jg0w@mail.gmail.com>
	<4F3279B6.7000106@iki.fi>
Date: Wed, 8 Feb 2012 15:58:52 +0100
Message-ID: <CAO+60fy91Cbd+172u1qA8J28SXSDO6pDtqh9=U=itC59NNGQ2g@mail.gmail.com>
Subject: Re: Issue with Afatech AF9015 DVB-T USB
From: =?UTF-8?Q?Mile_Davidovi=C4=87?= <mile.davidovic@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank You.

Kind regards
MD

On Wed, Feb 8, 2012 at 2:33 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 08.02.2012 14:24, Mile Davidović wrote:
>>
>> Hello
>> I am currently trying to use Afatech AF9015 DVB-T USB card. Generaly
>> it is working fine on my PC and MIPS SoC.
>>
>> Except one part which is currently blocking me:
>>
>> Currently I am trying to record whole TS using dvbsnoop or dvbstream tool.
>> It seems that I am unable to stream whole TS using following cmd:
>> dvbstream 8192
>
>
> dvbstream -f 666000 -o 8192 > stream.ts
>
>
>> Also: dvbsnoop -s ts -tsraw -crc does not work.
>> It seems that dvbsnoop is blocked in read ...
>>
>> I make quick check and it seems that DVB_USB_ADAP_HAS_PID_FILTER is
>> enabled for this card.
>>
>> Has anyone succeeded in making Afatech card working in necessary mode?
>>
>> Thanks in advance
>> MD
>
>
> regards
> Antti
>
> --
> http://palosaari.fi/
