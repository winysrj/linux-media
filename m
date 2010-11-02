Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34355 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0KBMFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 08:05:39 -0400
Received: by wyf28 with SMTP id 28so6620690wyf.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 05:05:37 -0700 (PDT)
Message-ID: <4CCFFE8C.80307@gmail.com>
Date: Tue, 02 Nov 2010 13:05:32 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: "jackc@RT" <jackc@realtek.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: rtl2832u support
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com> <4CBDED21.5040204@iki.fi> <EDE698A2-FCE2-4BE2-BE08-EB5FAF162B8F@gmail.com> <4CBDF47F.6040702@iki.fi>
In-Reply-To: <4CBDF47F.6040702@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Antti Palosaari wrote:
> On 10/19/2010 10:33 PM, Damjan Marion wrote:
>>
>> On Oct 19, 2010, at 9:10 PM, Antti Palosaari wrote:
>>> On 10/19/2010 08:42 PM, Damjan Marion wrote:
>>>> Is there any special reason why driver for rtl2832u DVB-T receiver 
>>>> chipset is not included into v4l-dvb?
>>>
>>> It is due to lack of developer making driver suitable for Kernel. I 
>>> have done some work and have knowledge what is needed, but no time 
>>> nor interest enough currently. It should be implement as one 
>>> USB-interface driver and two demod drivers (RTL2830, RTL2832) to 
>>> support for both RTL2831U and RTL2832U.
>>
>> Can you share what you done so far?
> 
> Look LinuxTV.org HG trees. There is Jan and my trees, both for RTL2831U. 
> I split driver logically correct parts. Also I have some RTL2832U hacks 
> here in my computer, I can give those for the person really continuing 
> development.
> 
> Antti
> 

Hi there,

Jack, is Realtek Interested?

Kind regards,
poma
