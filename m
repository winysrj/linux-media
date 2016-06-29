Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:55120 "EHLO smtp.220.in.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbcF2Gnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 02:43:43 -0400
Subject: Re: si2157 driver
To: Olli Salonen <olli.salonen@iki.fi>
References: <5772DC68.9050600@kaa.org.ua>
 <CAAZRmGwCeKQnLU7xFH2TDwhWorzcxRQDT1-pSi97h7VxZFG_KQ@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Message-ID: <57736E1B.2090308@kaa.org.ua>
Date: Wed, 29 Jun 2016 09:43:39 +0300
MIME-Version: 1.0
In-Reply-To: <CAAZRmGwCeKQnLU7xFH2TDwhWorzcxRQDT1-pSi97h7VxZFG_KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,
thanks for fast reply.

It's possible to improve driver to support analog mode?

I try to find datasheet for this chip,
but looks like only short version is a public.


On 29.06.16 07:42, Olli Salonen wrote:
> Hi Oleg,
> 
> Correct, only digital TV is supported currently by the driver.
> 
> Cheers,
> -olli
> 
> On 28 June 2016 at 23:22, Oleh Kravchenko <oleg@kaa.org.ua> wrote:
>> Hello linux media developers!
>>
>> I try add support for usb hybrid tuner, it based on:
>> CX23102-112, Si2158, Si2168
>>
>> I updated cx231xx-cards.c with valid ids, but I don't have idea how to
>> use Si2158.
>> It is not listed in tuner-types.c
>>
>> Why si2157.c is absent in tuner-types.c?
>> Or at the current state si2157.c don't have analog support?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
