Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44064 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbZJNLqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 07:46:15 -0400
Received: by ewy4 with SMTP id 4so4314771ewy.37
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 04:45:38 -0700 (PDT)
Message-ID: <4AD5D5F2.9080102@xfce.org>
Date: Wed, 14 Oct 2009 13:45:22 +0000
From: Ali Abdallah <aliov@xfce.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
References: <4ACDF829.3010500@xfce.org>	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	 <4ACDFED9.30606@xfce.org>	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	 <4ACE2D5B.4080603@xfce.org>	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	 <4ACF03BA.4070505@xfce.org>	 <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>	 <4ACF714A.2090209@xfce.org> <829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
In-Reply-To: <829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Oct 9, 2009 at 1:22 PM, Ali Abdallah <aliov@xfce.org> wrote:
>   
>> Screenshots here for TV and S-Video input configuration with TV time.
>>
>> http://ali.blogsite.org/files/tvtime/
>>     
>>> Could you try the S-Video or composite input and see if the picture
>>> quality is still bad (as this well help isolate whether it's a problem
>>> with the tuner chip or the decoder.
>>>
>>>       
>> Same picture quality with S-Video, but with composite there is no picture.
>>     
>
> Ok, this helps alot.  This rules out the tuner and suggests that
> perhaps the video decoder is not being programmed properly.
>
> Could you please send me the output of "dmesg"?  I'll see about
> setting up a tree with some additional debugging for you to try out.
>   

Follow up, i manager to get the hvr 900 instead the 900H, and i got the 
same result with the analog signal, i tried with my friend's windows 
system, same result, no analog channels detected, however i got all the 
channels a hvr pci card, so i expect these USB keys needs really a very 
strong signal, so there is no problem in the driver, sorry for the 
noise, hopefully the 900H will get a driver soon.


> Thanks,
>
> Devin
>
>   
Thanks,
Ali.
