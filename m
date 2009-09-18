Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:38286 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZIRQp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 12:45:59 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQ600B4KEKNHSF0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 18 Sep 2009 12:46:00 -0400 (EDT)
Date: Fri, 18 Sep 2009 12:45:59 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hw capabilities of the HVR-2200
In-reply-to: <4AB3B43A.2030103@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4AB3B947.1040202@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/18/09 12:24 PM, Jed wrote:
>
>> **a repost because of earlier issues in getting emails to the list**
>>
>> Hi Kernellabs or anyone involved with driver development of the
>> HVR-2200...

Hello.

>>
>> I know this is a loooong way down the priority list of features to be
>> added, if ever!
>> But I'm wanting to know if the *possibility* is there 'hardware-wise'
>> for the following:
>>
>> 1) h.263/mpeg4/VC-1/DivX/Xvid hardware encode of A/V-in

Yes, this exists in hardware on the SAA7164 and therefore the HVR2200 and HVR2250.

>> 2) Component input for the A/V-in

Yes, this exists on the HVR2250 product only.

>> 3) Hw encode bypass for A/V-in

No idea. Regardless of whether it does or does not I wouldn't plan to add basic 
raw TV support to the driver, without going through the encoder.

>> 4) Is Hw encode purely for A/V-in? (hauppauge's site suggests
>> otherwise but it may be a typo)

Yes.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
