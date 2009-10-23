Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:52081 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZJWRdg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 13:33:36 -0400
Message-ID: <4AE1E903.4030605@ridgerun.com>
Date: Fri, 23 Oct 2009 11:33:55 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	todd.fischer@ridgerun.com, linux-media@vger.kernel.org
References: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com> <87skdk7aul.fsf@deeprootsystems.com>
In-Reply-To: <87skdk7aul.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman wrote:
> <santiago.nunez@ridgerun.com> writes:
>
>   
>> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>>
>> This patch provides support for TVP7002 in architecture definitions
>> within DM365.
>>
>> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>> ---
>>  arch/arm/mach-davinci/board-dm365-evm.c |  170 ++++++++++++++++++++++++++++++-
>>  1 files changed, 166 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
>> index a1d5e7d..6c544d3 100644
>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
>> @@ -38,6 +38,11 @@
>>  #include <mach/common.h>
>>  #include <mach/mmc.h>
>>  #include <mach/nand.h>
>> +#include <mach/gpio.h>
>> +#include <linux/videodev2.h>
>> +#include <media/tvp514x.h>
>> +#include <media/tvp7002.h>
>> +#include <media/davinci/videohd.h>
>>  
>>  
>>  static inline int have_imager(void)
>> @@ -48,8 +53,11 @@ static inline int have_imager(void)
>>  
>>  static inline int have_tvp7002(void)
>>  {
>> -	/* REVISIT when it's supported, trigger via Kconfig */
>> +#ifdef CONFIG_VIDEO_TVP7002
>> +	return 1;
>> +#else
>>  	return 0;
>> +#endif
>>     
>
> I've said this before, but I'll say it again.  I don't like the
> #ifdef-on-Kconfig-option here.
>
> Can you add a probe hook to the platform_data so that when the tvp7002
> is found it can call pdata->probe() which could then set a flag
> for use by have_tvp7002().
>
> This will have he same effect without the ifdef since if the driver
> is not compiled in, its probe can never be triggered.
>
> Kevin
>
>   
Kevin,

I've been working on this particular implementation. This 
board-dm365-evm.c is specific to the board, therefore I don't still get 
the point of not having those values wired to the board file, but I know 
it'd be nice to have the CPLD configuration triggered upon TVP7002 
detection. I see two options:

1. Do the callback function inside pdata and initialize it at driver 
load time (tvp7002_probe). Set tvp5146 as default and override when 
driver loads (and restore when unloads).

2. Add an entry to sysfs such that it can be user-configurable whether 
to activate one of the other regardless of whether tvp5156 or tvp7002 
are actually there (the only result would be fail to access the device).

Sneha, do you have any suggestions on this one?


Regards,

-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


