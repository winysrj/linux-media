Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33491 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbcCQTja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 15:39:30 -0400
Received: by mail-wm0-f54.google.com with SMTP id l68so40819261wml.0
        for <linux-media@vger.kernel.org>; Thu, 17 Mar 2016 12:39:30 -0700 (PDT)
Subject: Re: [PATCH] media: rc: reduce size of struct ir_raw_event
To: Sean Young <sean@mess.org>
References: <56E9CDAE.2040200@gmail.com>
 <20160316222826.GA6635@gofer.mess.org> <56EA517B.5030903@gmail.com>
 <20160317105340.GA10247@gofer.mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56EB0769.7000704@gmail.com>
Date: Thu, 17 Mar 2016 20:37:13 +0100
MIME-Version: 1.0
In-Reply-To: <20160317105340.GA10247@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.03.2016 um 11:53 schrieb Sean Young:
> On Thu, Mar 17, 2016 at 07:40:59AM +0100, Heiner Kallweit wrote:
>> Am 16.03.2016 um 23:28 schrieb Sean Young:
>>> On Wed, Mar 16, 2016 at 10:18:38PM +0100, Heiner Kallweit wrote:
>>>> +	u8		pulse:1;
>>>> +	u8		reset:1;
>>>> +	u8		timeout:1;
>>>> +	u8		carrier_report:1;
>>>
>>> Why are you changing the type of the bitfields? 
>>>
>> I did this to make sure that the compiler uses one byte for
>> the bit field. When testing gcc also used just one byte when
>> keeping the original "unsigned" type for the bit field members.
>> Therefore it wouldn't be strictly neeeded.
>>
>> But I'm not sure whether it's guaranteed that the compiler packs a
>> bit field to the smallest possible data type and we can rely on it.
>> AFAIK C99 is a little more specific about this implementation detail of
>> bit fields but C89/C90 is used for kernel compilation.
> 
> It might be worth reading about structure packing rules rather than
> guessing.
> 
Whenever it became interesting when reading the statement was:
unspecified / implementation-dependent.
But at least C90 clearly states that only signed / unsigned int are
acceptable for bit fields. Therefore leave the bit field as it is.
I will provide a v2.

Heiner
> 
> Sean
> 

