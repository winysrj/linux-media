Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34633 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZIRRUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 13:20:25 -0400
Received: by fxm17 with SMTP id 17so861767fxm.37
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 10:20:28 -0700 (PDT)
Message-ID: <4AB3C17D.1030300@gmail.com>
Date: Sat, 19 Sep 2009 03:21:01 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hw capabilities of the HVR-2200
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com> <4AB3B947.1040202@kernellabs.com>
In-Reply-To: <4AB3B947.1040202@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> **a repost because of earlier issues in getting emails to the list**
>>>
>>> Hi Kernellabs or anyone involved with driver development of the
>>> HVR-2200...
> 
> Hello.

You're starting to see me as a nemesis now aren't you?
I'm really a nice person, I promise! :-D

>>>
>>> I know this is a loooong way down the priority list of features to be
>>> added, if ever!
>>> But I'm wanting to know if the *possibility* is there 'hardware-wise'
>>> for the following:
>>>
>>> 1) h.263/mpeg4/VC-1/DivX/Xvid hardware encode of A/V-in
> 
> Yes, this exists in hardware on the SAA7164 and therefore the HVR2200 
> and HVR2250.

Thank-you.

>>> 2) Component input for the A/V-in
> 
> Yes, this exists on the HVR2250 product only.

Ah shite, are you sure?
If you look at the specs for the reference card it was there, did they 
take it out at the last minute?

>>> 3) Hw encode bypass for A/V-in
> 
> No idea. Regardless of whether it does or does not I wouldn't plan to 
> add basic raw TV support to the driver, without going through the encoder.

Why do you rule it out unequivocally, is it just because I've annoyed 
you? :-(

The only reason I suggest this is because it'd be nice to have the 
option to offload encoding to some other device or to 'soft-encode'.

Of course demand for such functionality would prolly be the lowest, so 
it's understandable if it's the last thing implemented, if at all.

>>> 4) Is Hw encode purely for A/V-in? (hauppauge's site suggests
>>> otherwise but it may be a typo)
> 
> Yes.

Thank-you.

