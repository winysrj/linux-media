Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58480 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2FVTyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 15:54:53 -0400
Received: by gglu4 with SMTP id u4so1863784ggl.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 12:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE4CA11.5030208@gmail.com>
References: <4FE4BC43.9070100@gmail.com>
	<CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com>
	<4FE4C2BE.2060301@gmail.com>
	<CALF0-+V430u34yv8arUsN=N5Vh-cJs=7JJdiaEH_OonarJ065g@mail.gmail.com>
	<4FE4CA11.5030208@gmail.com>
Date: Fri, 22 Jun 2012 16:54:52 -0300
Message-ID: <CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com>
Subject: Re: Tuner NOGANET NG-PTV FM
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ariel Mammoli <cmammoli@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ariel,

On Fri, Jun 22, 2012 at 4:40 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
> Hello again Ezequiel,
>
> El vie 22 jun 2012 16:16:51 ART, Ezequiel Garcia ha escrito:
>> Hi Ariel,
>>
>> Please don't drop linux-media from Cc.
>>
>> On Fri, Jun 22, 2012 at 4:08 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>> Hi Ezequiel,
>>>
>>> El vie 22 jun 2012 15:51:02 ART, Ezequiel Garcia ha escrito:
>>>> Hi Ariel,
>>>>
>>>> On Fri, Jun 22, 2012 at 3:41 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>>>>>
>>>>> I have a tuner NOGANET "NG-FM PTV" which has the Philips chip 7134.
>>>>> I have reviewed the list of values several times but can not find it.
>>>>> What are the correct values to configure the module saa7134?
>>>>>
>>>>
>>>> That's a PCI card, right? PCI are identified by subvendor  and subdevice IDs.
>>>>
>>>> Can you tell us those IDs for your card?
>>>>
>>>> Regards,
>>>> Ezequiel.
>>>
>>> Indeed it is a PCI card. Below are the data:
>>> 04:05.0 Multimedia controller [0480]: Philips Semiconductors SAA7130
>>> Video Broadcast Decoder [1131:7130] (rev 01)
>>>
>>
>> I believe it is currently not supported under Linux.
>>

I was just looking here:

http://linuxtv.org/wiki/index.php/Compro_VideoMate_S350

and I think I gave you wrong information, sorry.

Could you better *full* output of

$ lspci -vvnn

with the board connected?

Sorry again for misdirections,
Ezequiel.
