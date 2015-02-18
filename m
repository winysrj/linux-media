Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64360 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbBRLH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 06:07:27 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so519624obb.13
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 03:07:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E3931C.9060508@iki.fi>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
	<54E24C83.7090309@iki.fi>
	<20150216214743.6a9180a6@recife.lan>
	<CAE6wzS+i1uaNr23ViFdW0U0Pf3j7--vV16dwRggTVV7X0AiCKg@mail.gmail.com>
	<54E3931C.9060508@iki.fi>
Date: Wed, 18 Feb 2015 11:07:26 +0000
Message-ID: <CAE6wzSJ8-cB=NGU9SmZ1jqmWv5wpzSShRnquM8JFk3CtSj4pAA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] [media] pci: Add support for DVB PCIe cards from
 Prospero Technologies Ltd.
From: Philip Downer <pdowner@prospero-tech.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On Tue, Feb 17, 2015 at 7:14 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 02/17/2015 08:22 PM, Philip Downer wrote:
>>
>> Hi Mauro,
>>
>> On Mon, Feb 16, 2015 at 11:47 PM, Mauro Carvalho Chehab
>> <mchehab@osg.samsung.com> wrote:
>>>
>>> Em Mon, 16 Feb 2015 22:01:07 +0200
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> Moikka!
>>>>
>>>> On 02/16/2015 09:48 PM, Philip Downer wrote:
>>>>>
>>>>> The Vortex PCIe card by Prospero Technologies Ltd is a modular DVB card
>>>>> with a hardware demux, the card can support up to 8 modules which are
>>>>> fixed to the board at assembly time. Currently we only offer one
>>>>> configuration, 8 x Dibcom 7090p DVB-t tuners, but we will soon be
>>>>> releasing
>>>>> other configurations. There is also a connector for an infra-red
>>>>> receiver
>>>>> dongle on the board which supports RAW IR.
>>>>>
>>>>> The driver has been in testing on our systems (ARM Cortex-A9, Marvell
>>>>> Sheva,
>>>>> x86, x86-64) for longer than 6 months, so I'm confident that it works.
>>>>> However as this is the first Linux driver I've written, I'm sure there
>>>>> are
>>>>> some things that I've got wrong. One thing in particular which has been
>>>>> raised by one of our early testers is that we currently register all of
>>>>> our frontends as being attached to one adapter. This means the device
>>>>> is
>>>>> enumerated in /dev like this:
>>>>>
>>>>> /dev/dvb/adapter0/frontend0
>>>>> /dev/dvb/adapter0/dvr0
>>>>> /dev/dvb/adapter0/demux0
>>>>>
>>>>> /dev/dvb/adapter0/frontend1
>>>>> /dev/dvb/adapter0/dvr1
>>>>> /dev/dvb/adapter0/demux1
>>>>>
>>>>> /dev/dvb/adapter0/frontend2
>>>>> /dev/dvb/adapter0/dvr2
>>>>> /dev/dvb/adapter0/demux2
>>>>>
>>>>> etc.
>>>>>
>>>>> Whilst I think this is ok according to the spec, our tester has
>>>>> complained
>>>>> that it's incompatible with their software which expects to find just
>>>>> one
>>>>> frontend per adapter. So I'm wondering if someone could confirm if what
>>>>> I've done with regards to this is correct.
>>>>
>>>>
>>>> As I understand all those tuners are independent (could be used same
>>>> time) you should register those as a 8 adapters, each having single
>>>> frontend, dvr and demux.
>>>
>>>
>>> Yeah, creating one adapter per device is the best solution, if you
>>> can't do things like:
>>>
>>>          frontend0 -> demux2 -> dvr5
>>
>>
>> Thanks for confirming what Antti said, I'll change the driver and resubmit
>> it.
>
>
> Also, take care to fix issues to meet Kernel coding style and checkpatch.pl
> requirements where possible.

Sure, I had pushed this patch through checkpatch and fixed most
things, the only things I'm aware of that aren't fixed are line
lengths and one section with too many nested statements. However I've
read that line lengths are less of an issue these days in kernel code
and the section with too many nested statements came from dibcom
therefore I didn't want to refactor this, at least not without a lot
of testing. Please let me know if I'm wrong in my assumptions or if
I've missed something in generating this patch.

-- 
Philip Downer
pdowner@prospero-tech.com
