Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2BHNdo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Feb 2012 08:33:44 -0500
Message-ID: <4F3279B6.7000106@iki.fi>
Date: Wed, 08 Feb 2012 15:33:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWlsZSBEYXZpZG92acSH?= <mile.davidovic@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Issue with Afatech AF9015 DVB-T USB
References: <CAO+60fyyvqbO6NQ6f4EQ88+DQFEkqTogiNQi5WddfNW_o6Jg0w@mail.gmail.com>
In-Reply-To: <CAO+60fyyvqbO6NQ6f4EQ88+DQFEkqTogiNQi5WddfNW_o6Jg0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.02.2012 14:24, Mile Davidović wrote:
> Hello
> I am currently trying to use Afatech AF9015 DVB-T USB card. Generaly
> it is working fine on my PC and MIPS SoC.
>
> Except one part which is currently blocking me:
>
> Currently I am trying to record whole TS using dvbsnoop or dvbstream tool.
> It seems that I am unable to stream whole TS using following cmd:
> dvbstream 8192

dvbstream -f 666000 -o 8192 > stream.ts

> Also: dvbsnoop -s ts -tsraw -crc does not work.
> It seems that dvbsnoop is blocked in read ...
>
> I make quick check and it seems that DVB_USB_ADAP_HAS_PID_FILTER is
> enabled for this card.
>
> Has anyone succeeded in making Afatech card working in necessary mode?
>
> Thanks in advance
> MD

regards
Antti

-- 
http://palosaari.fi/
