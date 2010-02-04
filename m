Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxweblb05fl.versatel.de ([89.246.255.248]:48927 "EHLO
	mxweblb05fl.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab0BDSuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 13:50:13 -0500
Received: from ens28fl.versatel.de (ens28fl.versatel.de [82.140.32.10])
	by mxweblb05fl.versatel.de (8.13.1/8.13.1) with ESMTP id o14IoApn030547
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 19:50:10 +0100
Received: from cinnamon-sage.de (i577A58B9.versanet.de [87.122.88.185])
	(authenticated bits=0)
	by ens28fl.versatel.de (8.12.11.20060308/8.12.11) with SMTP id o14IoALL013797
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 19:50:11 +0100
Received: from 192.168.23.2:49526 by cinnamon-sage.de for <hverkuil@xs4all.nl>,<awalls@radix.net>,<linux-media@vger.kernel.org> ; 04.02.2010 19:50:03
Message-ID: <4B6B16DA.5060902@cinnamon-sage.de>
Date: Thu, 04 Feb 2010 19:50:02 +0100
From: Lars Hanisch <dvb@cinnamon-sage.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: ivtv-utils/test/ps-analyzer.cpp: error in extracting SCR?
References: <4B6A123F.5080500@cinnamon-sage.de> <1265253363.3122.106.camel@palomino.walls.org> <201002040825.32062.hverkuil@xs4all.nl>
In-Reply-To: <201002040825.32062.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.02.2010 08:25, schrieb Hans Verkuil:
> On Thursday 04 February 2010 04:16:03 Andy Walls wrote:
>> On Thu, 2010-02-04 at 01:18 +0100, Lars Hanisch wrote:
>>> Hi,
>>>
>>>    I'm writing some code repacking the program stream that ivtv delivers
>>> into a transport stream (BTW: is there existing code for this?).
>>
>> Buy a CX23418 based board.  That chip's firmware can produce a TS.
>>
>> I think Compro and LeadTek cards are available in Europe and are
>> supported by the cx18 driver.

  My PVR150 and 350 are still ok and I hope I have DVB-S-access in one 
or two years... But I will keep that in mind in case I need a new card.

>>
>>>   Since
>>> many players needs the PCR I would like to use the SCR of the PS and

>>> place it in the adaption field of the TS (if wikipedia [1] and my
>>> interpretation of it is correct it should be the same).
>>>
>>>    I stumbled upon the ps-analyzer.cpp in the test-directory of the
>>> ivtv-utils (1.4.0). From line 190 to 198 the SCR and SCR extension are
>>> extracted from the PS-header. But referring to [2] the SCR extension has
>>> 9 bits, the highest 2 bits in the fifth byte after the sync bytes and
>>> the lower 7 bits in the sixth byte. The last bit is a marker bit (always 1).
>>>
>>>    So instead of
>>>
>>> scr_ext = (hdr[4]&  0x1)<<  8;
>>> scr_ext |= hdr[5];
>>>
>>>    I think it should be
>>>
>>> scr_ext = (unsigned)(hdr[4]&  0x3)<<  7;
>>> scr_ext |= (hdr[5]&  0xfe)>>  1;
>>
>>
>> Given the non-authoritative MPEG-2 documents I have, yes, you appear to
>> be correct on this.
>>
>> Please keep in mind that ps-analyzer.cpp is simply a debug tool from an
>> ivtv developer perspective.  You base prodcution software off of it at
>> your own risk. :)

  Of course I will. :-) I already had coded my part and was looking for 
references...

>>
>>>    And the bitrate is coded in the next 22 bits, so it should be
>>>
>>> mux_rate = (unsigned)(hdr[6])<<  14;
>>> mux_rate |= (unsigned)(hdr[7])<<  6;
>>> mux_rate |= (unsigned)(hdr[8]&  0xfc)>>  2;
>>>
>>>    Am I correct?
>
> Yes, you are correct. I miscounted the bits when I wrote this originally.
> Thanks for reporting this!

  You're welcome!

Regards,
Lars.

>
> Regards,
>
> 	Hans
>
>>
>> I did not check this one, but I would not be surprised if ps-analyzer
>> had this wrong too.
>>
>> Regards,
>> Andy
>>
>>> Regards,
>>> Lars.
>>>
>>> [1] http://en.wikipedia.org/wiki/Presentation_time_stamp
>>> [2] http://en.wikipedia.org/wiki/MPEG_program_stream
>>> --
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
