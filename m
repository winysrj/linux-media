Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35133 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbbFDM5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 08:57:20 -0400
Received: by qkhq76 with SMTP id q76so23068408qkh.2
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 05:57:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557048EF.3040703@iki.fi>
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
	<557048EF.3040703@iki.fi>
Date: Thu, 4 Jun 2015 08:57:19 -0400
Message-ID: <CALzAhNXzdH5kMctu3c2xY-Lhwd8xFjsna_4nr4S++66Q1FjFow@mail.gmail.com>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> This fix works well for me and properly enables DVB-T tuning behavior
>> using tzap.
>>
>> Thanks to Peter Faulkner-Ball for describing his workaround.
>
>
> hymm, I am not sure that patch at all. It is Olli who has been responsible
> adding support for multiple chip revisions, so I will leave that for Olli. I
> have only 2 Si2168 devices and both are B40 version.
>
> Anyhow, for me it looks like firmware major version is always increased when
> new major revision of chip is made. Due to that I expected 5.0 after B
> version 5.0.
> A 1.0
> A 2.0
> A 3.0
> B 4.0
> C 5.0 ?
> D 6.0 ?

The other email describes the I2C reply from the part, its cleared a
D40, not a D 6.0.

> And how we could explain situation Olli has device that had been working
> earlier, but now it does not? Could you Olli look back you old git tree and
> test if it still works? One possible reason could be also PCIe interface I2C
> adapter bug. Or timing issue.

Unlikely a timing issues or an i2c bug.

In my case I have multiple cards. The second card was acquired later
and never tested, and exhibited the issue.

Olli would need to speak for himself.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
