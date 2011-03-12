Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42481 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1CLO5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:57:08 -0500
Received: by fxm17 with SMTP id 17so1785211fxm.19
        for <linux-media@vger.kernel.org>; Sat, 12 Mar 2011 06:57:07 -0800 (PST)
Message-ID: <4D7B89C1.2020607@gmail.com>
Date: Sat, 12 Mar 2011 15:57:05 +0100
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <391PcLoJ29568S04.1299939053@web04.cms.usa.net> <4D7B87D2.6030903@linuxtv.org>
In-Reply-To: <4D7B87D2.6030903@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter wrote:
> On 03/12/2011 03:10 PM, Issa Gorissen wrote:
>   
>> From: Andreas Oberritter <obi@linuxtv.org>
>>     
>>> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
>>>       
>>>> Andreas Oberritter wrote:
>>>>         
>>>>> It's rather unintuitive that some CAMs appear as ca0, while others as
>>>>> cam0.
>>>>>   
>>>>>           
>>>> Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
>>>> as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
>>>> transport stream. To me it  looks like an extension of the current API.
>>>>         
>>> I see. This raises another problem. How to find out, which ca device
>>> cam0 relates to, in case there are more ca devices than cam devices?
>>>
>>>       
>> Are you sure there can be more ca devices than cam devices ?
>>     
>
> Yes. See my previous response to Ralph.
>   

Isn't this the same as asking which 'dvr' device relates to which 
'frontend' device?

Regards,
Martin
