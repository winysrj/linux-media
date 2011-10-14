Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab1JNNTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 09:19:40 -0400
Message-ID: <4E9836E5.6040601@redhat.com>
Date: Fri, 14 Oct 2011 10:19:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org, Eddi De Pieri <eddi@depieri.net>
Subject: Re: PCTV 520e on Linux
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com> <CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com> <4E970CA7.8020807@iki.fi> <CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com> <4E970F7A.5010304@iki.fi> <CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com> <4E976EF6.1030101@southpole.se> <CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com>
In-Reply-To: <CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-10-2011 20:19, Devin Heitmueller escreveu:
> On Thu, Oct 13, 2011 at 7:06 PM, Benjamin Larsson <benjamin@southpole.se> wrote:
>> On 10/13/2011 07:48 PM, Devin Heitmueller wrote:
>>> On Thu, Oct 13, 2011 at 12:19 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>> You were close:  em2884, drx-k, xc5000, and for analog it uses the
>>>>> afv4910b.
>>>> Then it should be peace of cake at least for digital side.
>>> I don't think we've ever done xc5000 on an em28xx before, so it's
>>> entirely possible that the xc5000 clock stretching will expose bugs in
>>> the em28xx i2c implementation (it uncovered bugs in essentially every
>>> other bridge driver I did work on).
>>>
>>> That, and we don't know how much is hard-coded into the drx-k driver
>>> making it specific to the couple of device it's currently being used
>>> with.
>>>
>>> But yeah, it shouldn't be rocket science.  I added support for the
>>> board in my OSX driver and it only took me a couple of hours.
>>>
>>> Devin
>>>
>>
>> Eddi De Pieri has patches for the HVR-930C that works somewhat. The
>> hardware in that stick is the same.
>>
>> MvH
>> Benjamin Larsson
> 
> While the basic chips used are different, they are completely
> different hardware designs and likely have different GPIO
> configurations as well as IF specs.

The IF settings for xc5000 with DRX-K are solved with this patch:
	http://patchwork.linuxtv.org/patch/7932/

Basically, DRX-K will use whatever IF the tuner uses.

I've sent to Eddi to get some feedback, but he never returned back.

> 
> Devin
> 

