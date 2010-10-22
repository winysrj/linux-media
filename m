Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab0JVWxx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 18:53:53 -0400
Message-ID: <4CC215EA.30504@redhat.com>
Date: Fri, 22 Oct 2010 20:53:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Adrian Taylor <adrian.taylor@realvnc.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Elgato Video Capture.
References: <20E008D5-74E6-4BD7-8337-08A27646E265@realvnc.com> <1CA567F4-48D2-4C45-B65B-26F1F7056BEA@wilsonet.com>
In-Reply-To: <1CA567F4-48D2-4C45-B65B-26F1F7056BEA@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-10-2010 11:25, Jarod Wilson escreveu:
> On Oct 22, 2010, at 7:30 AM, Adrian Taylor wrote:
> 
>> This patch allows this device successfully to show video, at least from
>> its composite input.
>>
>> I have no information about the true hardware contents of this device and so
>> this patch is based solely on fiddling with things until it worked. The
>> chip appears to be em2860, and the closest device with equivalent inputs
>> is the Typhoon DVD Maker. Copying the settings for that device appears
>> to do the trick. That's what this patch does.
>>
>> Patch redone against the staging/v2.6.37 branch of the v4l/dvb
>> media_tree as requested.
>>
>> Signed-off-by: Adrian Taylor <adrian.taylor@realvnc.com>
> 
> Looks good, thanks for the redo.
> 
> Reviewed-by: Jarod Wilson <jarod@redhat.com>
> 
> 

Thanks. Yet, I've renumbered it to 33, as we had this number free...
I think that the next free number is 59... It would be nice to
fill-in the blanks ;)

Cheers,
Mauro
