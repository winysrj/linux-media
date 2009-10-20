Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:33506 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZJTQha (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 12:37:30 -0400
Message-ID: <4ADDE74E.4000609@ridgerun.com>
Date: Tue, 20 Oct 2009 10:37:34 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com> <87skdk7aul.fsf@deeprootsystems.com> <B85A65D85D7EB246BE421B3FB0FBB59301DDF23F62@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DDF23F62@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

Nori, Sekhar wrote:
> On Fri, Oct 16, 2009 at 00:17:46, Kevin Hilman wrote:
>   
>> <santiago.nunez@ridgerun.com> writes:
>>
>>     
>>> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>>>
>>> This patch provides support for TVP7002 in architecture definitions
>>> within DM365.
>>>
>>> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>>> ---
>>>  arch/arm/mach-davinci/board-dm365-evm.c |  170 ++++++++++++++++++++++++++++++-
>>>  1 files changed, 166 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
>>> index a1d5e7d..6c544d3 100644
>>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>>> @@ -38,6 +38,11 @@
>>>  #include <mach/common.h>
>>>  #include <mach/mmc.h>
>>>  #include <mach/nand.h>
>>> +#include <mach/gpio.h>
>>> +#include <linux/videodev2.h>
>>> +#include <media/tvp514x.h>
>>> +#include <media/tvp7002.h>
>>> +#include <media/davinci/videohd.h>
>>>
>>>
>>>  static inline int have_imager(void)
>>> @@ -48,8 +53,11 @@ static inline int have_imager(void)
>>>
>>>  static inline int have_tvp7002(void)
>>>  {
>>> -   /* REVISIT when it's supported, trigger via Kconfig */
>>> +#ifdef CONFIG_VIDEO_TVP7002
>>> +   return 1;
>>> +#else
>>>     return 0;
>>> +#endif
>>>       
>> I've said this before, but I'll say it again.  I don't like the
>> #ifdef-on-Kconfig-option here.
>>
>> Can you add a probe hook to the platform_data so that when the tvp7002
>> is found it can call pdata->probe() which could then set a flag
>> for use by have_tvp7002().
>>
>> This will have he same effect without the ifdef since if the driver
>> is not compiled in, its probe can never be triggered.
>>     
>
> But this wouldn't work when TVP7002 is built as a module. Correct?
> The current patch does not take care of the module case as well.
>
> Patch 6/6 of this series does seem to make the TVP7002 driver available
> as module.
>
>   
Well, that was the intention given the inherent convenience of 
loading/unloading the TVP7002 driver for applications. Now, given that 
scenario, I know the #ifdef option is not elegant, but it is simple and 
accomplishes the purpose with the module approach. Any other 
suggestions/ideas?

> Thanks,
> Sekhar
>   

Regards,

-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


