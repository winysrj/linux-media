Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0EaCWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 22:22:44 -0400
Received: by fxm10 with SMTP id 10so2062820fxm.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 19:22:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C031951.8070800@gmail.com>
References: <AANLkTikyQt4CKLQ1JqjeiNZLMv9Fa9YzcV-BcROd1QWe@mail.gmail.com>
	<AANLkTik_Pqab77LY-XpBdeQ8rSUkP2k9AxyIvzRygbBE@mail.gmail.com>
	<4C031951.8070800@gmail.com>
Date: Mon, 31 May 2010 05:22:42 +0300
Message-ID: <AANLkTilRsC00Ah2cm1L7sJDliGcyVlCxeDuCBpGFkgLP@mail.gmail.com>
Subject: Re: TBS 6980 Dual Tuner PCI-e card.....not in Wiki at all?
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 31, 2010 at 5:05 AM, Emmanuel <eallaud@gmail.com> wrote:
> Konstantin Dimitrov a �crit :
>>
>> hello, i can't comment on your questions about the Wiki, but i made
>> the driver for TBS 6980 and i can ensure you that the driver will be
>> released as open-source under GPL as soon as i have permission to do
>> that, but compared to other cards at least even at the moment you can
>> use the card in Linux and it's very easy to add support for it using
>> the binary modules even to the latest V4L code from repository and so
>> those "blobs" are actually not so big limitation.
>>
>> also, you are very wrong about the price - as far as i know retails
>> price is less than 200 USD, for example TBS online shop gives a price
>> of 158.99 USD:
>>
>> http://www.buydvb.net/pcie-dvbs2-dual-tuner-tv-card_p11.html
>>
>> and i believe the dual DVB-S2 card with price of 1000 USD that you're
>> talking about is the NetUP one and not the TurboSight TBS 6980 dual
>> DVB-S2 card.
>>
>
> I have two questions for you: do these board support (or will support in the
> near future) a CI interface for pay TV, and what is the best symbol rate
> they can achieve in DVB-S2 (I think I need QPSK only but could be 8PSK)

TBS 6980 specifications are:

DVB-S QPKS: 1000 - 45000 kSps

DVB-S2 QPSK and 8PSK: 2000 - 36000 kSps

but i personally have tested DVB-S2 8PSK up to 33500 kSps and it works
fine. so, DVB-S2 symbol rate range is still better than what most
other cards can offer i believe, which usually support 10000 - 30000
kSps for DVB-S2. TBS are developing card that will support 1000 -
45000 kSps for DVB-S2 (both QPSK and 8PSK), but i believe it won't be
released any time soon.

> RELIABLY.
> TIA
> Bye
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at �http://vger.kernel.org/majordomo-info.html
>
