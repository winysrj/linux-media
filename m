Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:43462 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab1CLPGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 10:06:19 -0500
Message-ID: <4D7B8BE7.2010307@linuxtv.org>
Date: Sat, 12 Mar 2011 16:06:15 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <391PcLoJ29568S04.1299939053@web04.cms.usa.net> <4D7B87D2.6030903@linuxtv.org> <4D7B89C1.2020607@gmail.com>
In-Reply-To: <4D7B89C1.2020607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/12/2011 03:57 PM, Martin Vidovic wrote:
> Andreas Oberritter wrote:
>> On 03/12/2011 03:10 PM, Issa Gorissen wrote:
>>  
>>> From: Andreas Oberritter <obi@linuxtv.org>
>>>    
>>>> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
>>>>      
>>>>> Andreas Oberritter wrote:
>>>>>        
>>>>>> It's rather unintuitive that some CAMs appear as ca0, while others as
>>>>>> cam0.
>>>>>>             
>>>>> Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
>>>>> as usual, to setup the CAM. The cam0 (or sec0) node is used to
>>>>> read/write
>>>>> transport stream. To me it  looks like an extension of the current
>>>>> API.
>>>>>         
>>>> I see. This raises another problem. How to find out, which ca device
>>>> cam0 relates to, in case there are more ca devices than cam devices?
>>>>
>>>>       
>>> Are you sure there can be more ca devices than cam devices ?
>>>     
>>
>> Yes. See my previous response to Ralph.
>>   
> 
> Isn't this the same as asking which 'dvr' device relates to which
> 'frontend' device?

No, because this is defined. If demuxN is configured to output to a dvr
device, then it outputs to dvrN. The input of demuxN is configured by
using DMX_SET_SOURCE, which can be frontendX or dvrY.

Regards,
Andreas
