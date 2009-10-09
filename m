Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:3155 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbZJINgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 09:36:11 -0400
Received: by ey-out-2122.google.com with SMTP id 4so1476235eyf.19
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 06:35:03 -0700 (PDT)
Message-ID: <4ACF5825.7010202@xfce.org>
Date: Fri, 09 Oct 2009 15:35:01 +0000
From: Ali Abdallah <aliov@xfce.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
References: <4ACDF829.3010500@xfce.org>	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	 <4ACDFED9.30606@xfce.org>	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	 <4ACE2D5B.4080603@xfce.org>	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	 <4ACF03BA.4070505@xfce.org> <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
In-Reply-To: <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Oct 9, 2009 at 5:34 AM, Ali Abdallah <aliov@xfce.org> wrote:
>   
>> Okay, i installed the latest drivers+the firmware of the device using
>> extract_xc3028.pl, the device seems to be detected now, i can detect all the
>> analog TV of my cable using tvtime, but manually, i mean i had to disable
>> signal detection when scanning, otherwise i got no results, since the
>> picture quality is terrible.
>>
>> Of course i'm sure that all the connections (cable to antenna, cable to the
>> usb stick, ...) are correct, since it works with my old PC equipped with a
>> PCI TV card.
>>
>> Any advice, what could be the problem? firmware? since you said (you added
>> support for this device) should i open a bug report? is this device reported
>> as working by other users?
>>
>> Please help if possible, almost two weeks with no real success.
>>     
>
> Could you please provide a screen shot of the tvtime output?
>   

I will provide you a screenshot when i go back home this evening.
> Also, are you trying to capture over-the-air or are you capturing
> cable television?
>   
It is a cable but at the end it is connected to main antenna of the 
building.

> What analog standard are you using?  PAL-BG?
>   

SECAM.
> Did you make sure to tell tvtime which analog standard you are using?
>   
Yes i'm sure, settings are SECAM, area France.

> Could you try the S-Video or composite input and see if the picture
> quality is still bad (as this well help isolate whether it's a problem
> with the tuner chip or the decoder.
>   

I will also try these at reply this evening.



> Devin
>
>   
Cheers,
Ali.
