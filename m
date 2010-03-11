Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:38417 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab0CKPif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 10:38:35 -0500
Received: from MacBook-Pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KZ400IIPJG6TXL0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 11 Mar 2010 10:38:31 -0500 (EST)
Date: Thu, 11 Mar 2010 10:38:30 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hw capabilities of the HVR-2200
In-reply-to: <4B968267.3090808@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4B990E76.2010603@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com>
 <4AB3B947.1040202@kernellabs.com> <4AB3C17D.1030300@gmail.com>
 <4AB3C8E5.4010700@kernellabs.com> <4AB3CDC2.20505@gmail.com>
 <4B968267.3090808@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/9/10 12:16 PM, Jed wrote:
> 19/09/09 Jed wrote:
>>>>>>> 2) Component input for the A/V-in
>>>>>
>>>>> Yes, this exists on the HVR2250 product only.
>>>>
>>>> Ah shite, are you sure?
>>>> If you look at the specs for the reference card it was there, did they
>>>> take it out at the last minute?
>>>
>>> It's not feature Hauppauge supports on the HVR2200 today. I have a
>>> suspicion this may change but I'm neither confirming, denying or
>>> announcing anything. It would make sense to officially support
>>> component cables on the HVR2200 since the silicon supports it.
>>> If/when it does I'm sure it will be mentioned in the forums or on the
>>> HVR2200 product packaging.
>
> Hi Steve, when you said this is not a feature Hauppauge supports.
> Did you mean it's not fully enabled physically in the PCB...
> Or is it just something they need to add support for in the driver?
> If the latter do you know if their policy has changed or is about to?

No idea, I have no answer.

>>>>>>> 3) Hw encode bypass for A/V-in
>>>>>
>>>>> No idea. Regardless of whether it does or does not I wouldn't plan to
>>>>> add basic raw TV support to the driver, without going through the
>>>>> encoder.
>>>>
>>>> Why do you rule it out unequivocally, is it just because I've annoyed
>>>> you? :-(
>>>
>>> Raw analog TV isn't a high priority feature on my mental check-list.
>>> Analog TV via the encoder is much more interesting and applicable to
>>> many people.
>
> Assuming that progress has been made on analogue to
> h.263/mpeg4/VC-1/DivX/Xvid via the A/V-in encoder.
> Is this still considered a low priority?

Raw analog is still very low down any list I have for the HVR22xx driver.

>
> Has progress been made on hw encode via A/V-in?
> I'm "finally" putting my entire system together soon, can't wait!
> Looking forward to seeing how everything has progressed.
> I'll be sure to do some donations once I'm up & running!

The current driver supports DTV only. I have no ETA for analog on the HVR22xx 
driver. If you need analog support then the HVR22xx isn't the right product for you.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490

