Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39114 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZLEMmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 07:42:23 -0500
Received: by bwz27 with SMTP id 27so2533178bwz.21
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2009 04:42:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0912040752330.16617@ybpnyubfg.ybpnyqbznva>
References: <751357790912030639l6ddcb4bar486fdea6b9aa1a8e@mail.gmail.com>
	 <751357790912030731g5b09bac8w322f4c1754c3d87d@mail.gmail.com>
	 <alpine.DEB.2.01.0912040752330.16617@ybpnyubfg.ybpnyqbznva>
Date: Sat, 5 Dec 2009 13:42:28 +0100
Message-ID: <19a3b7a80912050442r5433e8d9o75fadd6b7655ebd1@mail.gmail.com>
Subject: Re: Fwd: DVB-APPS patch for uk-WinterHill
From: Christoph Pfister <christophpfister@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: Justin Hornsby <justin0hornsby@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

2009/12/4 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
> On Thu, 3 Dec 2009, Justin Hornsby wrote:
>> Since 02 Dec 2009 the UK WinterHill transmitter site has been
>> broadcasting on different frequencies & in a different mode with
>> different modulation.  Channels have been re-arranged to occupy five
>> multiplexes and the original BBC 'B' mux is now broadcasting DVB-T2
>> for high definition services (which of course cannot yet be tuned by
>> mere mortals). The 'WinterHill B' transmitter stopped broadcasting on
>> 02 Dec.
>>
>> The attached file is a patch to reflect these changes.
>
>> +T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>> +T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>> +T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>> +T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>> +T 801833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

Updated.

> While the DVB-T2 multiplex (MUX B) cannot be tuned by existing
> DVB-T-only devices, and I don't know if the dvb-apps are being
> prepared for DVB-T2 (there don't appear to be any of the
> known DVB-S2 transponders listed in a couple positions), the
> modulation parameters, for future reference, are probably
> something like
>
> +# T2 738000000 8MHz 2/3 NONE QAM256 32k 1/128 NONE     #E54 DVB-T2 HD MUX B
>
> There may need to be additional details specified, I'm no expert.
> These values are, of course, unconfirmed.
>
> The same would be true for Crystal Palace at 10kW, but on channel
> E31, or 554000000, no offset.

I think it's too early to add T2 transponders (and guys playing around
with such equipment usually know how to get the necessary parameters).

> barry bouwsma

Thanks,

Christoph
