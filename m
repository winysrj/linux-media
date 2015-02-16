Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49750 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbBPUqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 15:46:54 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so46090835obc.1
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 12:46:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E24C83.7090309@iki.fi>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
	<54E24C83.7090309@iki.fi>
Date: Mon, 16 Feb 2015 20:46:53 +0000
Message-ID: <CAE6wzSKCaMnP-NVJQSfkzVxjds0GDuXAfLQtscM6BMtGg-0vdQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] [media] pci: Add support for DVB PCIe cards from
 Prospero Technologies Ltd.
From: Philip Downer <pdowner@prospero-tech.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On Mon, Feb 16, 2015 at 8:01 PM, Antti Palosaari <crope@iki.fi> wrote:
> Moikka!
>
>
> On 02/16/2015 09:48 PM, Philip Downer wrote:
>>
>> The Vortex PCIe card by Prospero Technologies Ltd is a modular DVB card
>> with a hardware demux, the card can support up to 8 modules which are
>> fixed to the board at assembly time. Currently we only offer one
>> configuration, 8 x Dibcom 7090p DVB-t tuners, but we will soon be
>> releasing
>> other configurations. There is also a connector for an infra-red receiver
>> dongle on the board which supports RAW IR.
>>
>> The driver has been in testing on our systems (ARM Cortex-A9, Marvell
>> Sheva,
>> x86, x86-64) for longer than 6 months, so I'm confident that it works.
>> However as this is the first Linux driver I've written, I'm sure there are
>> some things that I've got wrong. One thing in particular which has been
>> raised by one of our early testers is that we currently register all of
>> our frontends as being attached to one adapter. This means the device is
>> enumerated in /dev like this:
>>
>> /dev/dvb/adapter0/frontend0
>> /dev/dvb/adapter0/dvr0
>> /dev/dvb/adapter0/demux0
>>
>> /dev/dvb/adapter0/frontend1
>> /dev/dvb/adapter0/dvr1
>> /dev/dvb/adapter0/demux1
>>
>> /dev/dvb/adapter0/frontend2
>> /dev/dvb/adapter0/dvr2
>> /dev/dvb/adapter0/demux2
>>
>> etc.
>>
>> Whilst I think this is ok according to the spec, our tester has complained
>> that it's incompatible with their software which expects to find just one
>> frontend per adapter. So I'm wondering if someone could confirm if what
>> I've done with regards to this is correct.
>
>
> As I understand all those tuners are independent (could be used same time)
> you should register those as a 8 adapters, each having single frontend, dvr
> and demux.

Yes, all those tuners can be operated independently. So would I be
correct in saying that in Linux an adapter is an independent tuner?

In that case the only time you would have frontend0, frontend1 etc is
when there is a single dvb source that is switched between tuners?

-- 
Philip Downer
+44 (0)7879 470 969
pdowner@prospero-tech.com
