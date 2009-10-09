Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41498 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZJIHf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 03:35:29 -0400
Received: by ewy4 with SMTP id 4so372204ewy.37
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 00:34:52 -0700 (PDT)
Message-ID: <4ACF03BA.4070505@xfce.org>
Date: Fri, 09 Oct 2009 09:34:50 +0000
From: Ali Abdallah <aliov@xfce.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
References: <4ACDF829.3010500@xfce.org>	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	 <4ACDFED9.30606@xfce.org>	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	 <4ACE2D5B.4080603@xfce.org> <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
In-Reply-To: <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Oct 8, 2009 at 2:20 PM, Ali Abdallah <aliov@xfce.org> wrote:
>   
>> I have the card since alsmost 3 years, it never worked, but now i'm in
>> urgent need of getting an analog usb stick to work with Linux.
>>
>> The PCTV hybrid:
>>
>> Bus 001 Device 004: ID eb1a:2881 eMPIA Technology, Inc.
>>
>> Thanks for you support, but i need an analog usb stick, well hopefully the
>> wintv 900H will get supported soon.
>>     
>
> Well, I added support for that device last month, so I would suggest
> you install the latest v4l-dvb code from
> http://linuxtv.org/hg/v4l-dvb.  Directions can be found here:
>
> http://linuxtv.org/repo
>   
Okay, i installed the latest drivers+the firmware of the device using 
extract_xc3028.pl, the device seems to be detected now, i can detect all 
the analog TV of my cable using tvtime, but manually, i mean i had to 
disable signal detection when scanning, otherwise i got no results, 
since the picture quality is terrible.

Of course i'm sure that all the connections (cable to antenna, cable to 
the usb stick, ...) are correct, since it works with my old PC equipped 
with a PCI TV card.

Any advice, what could be the problem? firmware? since you said (you 
added support for this device) should i open a bug report? is this 
device reported as working by other users?

Please help if possible, almost two weeks with no real success.

> Cheers,
>
> Devin
>
>   

Cheers,

Ali.

