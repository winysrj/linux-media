Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54568 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3LWSdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 13:33:53 -0500
Received: by mail-ob0-f174.google.com with SMTP id wn1so5714783obc.5
        for <linux-media@vger.kernel.org>; Mon, 23 Dec 2013 10:33:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7sF2mGXKWLWa5_LLxXhMf5WOsFODJBZ+Lovz8KP0qyuKA@mail.gmail.com>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
	<52A1A76A.6070301@epfl.ch>
	<CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
	<52B04D70.8060201@epfl.ch>
	<CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>
	<CA+2YH7sF2mGXKWLWa5_LLxXhMf5WOsFODJBZ+Lovz8KP0qyuKA@mail.gmail.com>
Date: Mon, 23 Dec 2013 19:33:50 +0100
Message-ID: <CA+2YH7vfwTxnorkm4saFt2rZ5SRWcH92XQvX=VMJcK4jPrYRig@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: florian.vaussard@epfl.ch
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 23, 2013 at 6:45 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Wed, Dec 18, 2013 at 11:09 AM, Enrico <ebutera@users.berlios.de> wrote:
>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard
>> <florian.vaussard@epfl.ch> wrote:
>>> So I converted the iommu to DT (patches just sent), used pdata quirks
>>> for the isp / mtv9032 data, added a few patches from other people
>>> (mainly clk to fix a crash when deferring the omap3isp probe), and a few
>>> small hacks. I get a 3.13-rc3 (+ board-removal part from Tony Lindgren)
>>> to boot on DT with a working MT9V032 camera. The missing part is the DT
>>> binding for the omap3isp, but I guess that we will have to wait a bit
>>> more for this.
>>>
>>> If you want to test, I have a development tree here [1]. Any feedback is
>>> welcome.
>>>
>>> Cheers,
>>>
>>> Florian
>>>
>>> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
>>
>> Thanks Florian,
>>
>> i will report what i get with my setup.
>
> Uhm it's unrelated to omap3isp but i get a kernel panic in serial_omap_probe:

Sorry for the noise, it was a stupid problem with DT.

Enrico
