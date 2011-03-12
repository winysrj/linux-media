Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:52782 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1CLOsx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:48:53 -0500
Message-ID: <4D7B87D2.6030903@linuxtv.org>
Date: Sat, 12 Mar 2011 15:48:50 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <391PcLoJ29568S04.1299939053@web04.cms.usa.net>
In-Reply-To: <391PcLoJ29568S04.1299939053@web04.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/12/2011 03:10 PM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>> On 03/11/2011 10:44 PM, Martin Vidovic wrote:
>>> Andreas Oberritter wrote:
>>>> It's rather unintuitive that some CAMs appear as ca0, while others as
>>>> cam0.
>>>>   
>>> Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
>>> as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
>>> transport stream. To me it  looks like an extension of the current API.
>>
>> I see. This raises another problem. How to find out, which ca device
>> cam0 relates to, in case there are more ca devices than cam devices?
>>
> 
> Are you sure there can be more ca devices than cam devices ?

Yes. See my previous response to Ralph.

Regards,
Andreas
