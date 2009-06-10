Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:48422 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbZFJOcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 10:32:14 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KL100A881PNY450@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 10 Jun 2009 10:32:13 -0400 (EDT)
Date: Wed, 10 Jun 2009 10:32:11 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <4A2F6AB3.7080406@gatech.edu>
To: David Ward <david.ward@gatech.edu>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Message-id: <4A2FC3EB.6010802@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D4778.4090505@gatech.edu>
 <4A2D7277.7080400@kernellabs.com>
 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
 <4A2E6FDD.5000602@kernellabs.com>
 <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com>
 <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu>
 <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com>
 <4A2EB233.3080800@kernellabs.com>
 <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com>
 <4A2EB75A.4070409@kernellabs.com> <4A2F6AB3.7080406@gatech.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ward wrote:
> On 06/09/2009 03:26 PM, Steven Toth wrote:
>> 30db for the top end of ATSC sounds about right.
>>
>> David, when you ran the windows signal monitor - did it claim QAM64 or 
>> 256 when it was reporting 30db?
> 
> Steven and Devin,
> 
> All the digital signals are 256 QAM.
> 
>> 39 is very good, exceptional.
>>
>> And did they do as I suggested, which is measure db across the high 
>> channels? ... and ideally against your problematic channel?
>>
>> I assume not.
> 
> Comcast checked the outlet on channels 2 (41 dB) and 83 (39 dB).  I 
> looked afterwards and saw that the first of those is analog programming, 
> but the second just appears as analog noise on my TV set. (??)  I asked 
> them to check a specific ATSC channel, but it seems that their meter was 
> fixed to those two frequencies, which doesn't really help.  The ATSC 
> rebroadcasts by Comcast are on high frequencies; the program I am 
> testing primarily is on channel 79 (tunes at 555 MHz).
> 
> Under Windows I'm now seeing 34.5-34.8 dB for lower frequency QAM, 
> 32.5-32.7 dB for higher frequency QAM, and about 30.5 dB for ATSC.  
> Under Linux with azap, the corresponding BER/UNC values are 0x0140, 
> 0x0134, and 0x0132.  I'm not exactly sure what numbers I should be going 
> by here...again, wish I had my own meter.

Which of these three values is UNC/BER and which is snr? I don't understand, I 
need you to be more specific.

34 is good, normal. However 30.5 is still edgy under windows, assuming QAM 256. 
Did you get a chance to review the signal monitor to determine whether it was 64 
or 256?

If you have any way to attenuate the signal then you'll find that very quickly 
the windows 30.5 will drop just a little and you'll begin to see real 
uncorrectable errors. I alluded to this yesterday. With 30.5 your just a 
fraction above 'working' reliably.

If you were to insert attenuation through some barrel connectors, or join some 
other cables together to impede the RF, you'd see that 30.5 drop quickly and the 
errors would begin to appear. I suspect this will still occur, as I mentioned 
yesterday.

The windows drivers is working slightly better for you but it's still no where 
near good enough RF for reliable 24x7x365 viewing. You'll find the RF on your 
local cable rings varies during an average day. It certainly does for me on 
various products. What looks great today (when you're on the edge) can look ugly 
at 9pm in the evening or 7am thursday morning.

I wouldn't expect pristine recordings with Microsoft MCE (or other apps) (for 
any random moment in the week) with a 30.5 reading.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
