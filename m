Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55994 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0AWX3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 18:29:23 -0500
Received: by ewy26 with SMTP id 26so745103ewy.28
        for <linux-media@vger.kernel.org>; Sat, 23 Jan 2010 15:29:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5B837A.6020001@barber-family.id.au>
References: <4B5B0E12.3090706@barber-family.id.au>
	 <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com>
	 <4B5B837A.6020001@barber-family.id.au>
Date: Sat, 23 Jan 2010 18:29:21 -0500
Message-ID: <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com>
Subject: Re: New Hauppauge HVR-2200 Revision?
From: Steven Toth <stoth@kernellabs.com>
To: Francis Barber <fedora@barber-family.id.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I put some new patches into the saa7164-stable earlier today. These
will probably help.

www.kernellabs.com/hg/saa7164-stable

Let me know.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

On Sat, Jan 23, 2010 at 6:17 PM, Francis Barber
<fedora@barber-family.id.au> wrote:
> On 23/01/2010 11:00 PM, Steven Toth wrote:
>>>
>>> I'm a confused by 8940 because this isn't listed in the hcw89.inf file on
>>> the CD that shipped with the product (driver version 7.6.1.27118).  They
>>> list 8900, 8901, 8980, 8991, 8993, 89A0, and 89A1.  I downloaded the
>>> latest
>>> drivers from the website (7.6.27.27223) and this adds 8951 and 8953, but
>>> still not 8940.
>>>
>>> The firmware shipped with 7.6.1.27118 is the same as is available on your
>>> website, although they have updated it for 7.6.27.27223.
>>>
>>
>>
>>>
>>> If there is any other information that would be helpful please let me
>>> know.
>>>
>>
>> Does this actually work under windows? It sounds like the driver
>> doesn't support it?
>>
>> Regards,
>>
>>
>
> As expected, the card didn't work in Windows with either of those driver
> versions.  However, hauppauge.com has different drivers to hauppauge.co.uk!
>  The latest HVR2250 drivers from hauppauge.com, version 7.6.27.27323,
> include 8940 in the inf file.  This version installs fine on Windows.
>
> Regards,
> Frank.
>
