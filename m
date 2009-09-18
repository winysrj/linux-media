Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:52323 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbZIRRwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 13:52:41 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQ600I94HNPGOC0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:52:38 -0400 (EDT)
Date: Fri, 18 Sep 2009 13:52:37 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hw capabilities of the HVR-2200
In-reply-to: <4AB3C17D.1030300@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4AB3C8E5.4010700@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com>
 <4AB3B947.1040202@kernellabs.com> <4AB3C17D.1030300@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>> 2) Component input for the A/V-in
>>
>> Yes, this exists on the HVR2250 product only.
>
> Ah shite, are you sure?
> If you look at the specs for the reference card it was there, did they
> take it out at the last minute?

It's not feature Hauppauge supports on the HVR2200 today. I have a suspicion 
this may change but I'm neither confirming, denying or announcing anything. It 
would make sense to officially support component cables on the HVR2200 since the 
silicon supports it. If/when it does I'm sure it will be mentioned in the forums 
or on the HVR2200 product packaging.

>
>>>> 3) Hw encode bypass for A/V-in
>>
>> No idea. Regardless of whether it does or does not I wouldn't plan to
>> add basic raw TV support to the driver, without going through the
>> encoder.
>
> Why do you rule it out unequivocally, is it just because I've annoyed
> you? :-(

Raw analog TV isn't a high priority feature on my mental check-list. Analog TV 
via the encoder is much more interesting and applicable to many people.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
