Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZLKUuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 15:50:55 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 11 Dec 2009 14:50:49 -0600
Subject: RE: [PATCH - v1 5/6] V4L - vpfe capture - build environment for
 ISIF driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40155CEE24B@dlee06.ent.ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
	<1260464429-10537-2-git-send-email-m-karicheri2@ti.com>
	<1260464429-10537-3-git-send-email-m-karicheri2@ti.com>
	<1260464429-10537-4-git-send-email-m-karicheri2@ti.com>
 <1260464429-10537-5-git-send-email-m-karicheri2@ti.com>
 <4B213200.1030603@ru.mvista.com>
In-Reply-To: <4B213200.1030603@ru.mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok. I will do.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Sergei Shtylyov [mailto:sshtylyov@ru.mvista.com]
>Sent: Thursday, December 10, 2009 12:38 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; hverkuil@xs4all.nl;
>khilman@deeprootsystems.com; Nori, Sekhar; Hiremath, Vaibhav; davinci-
>linux-open-source@linux.davincidsp.com
>Subject: Re: [PATCH - v1 5/6] V4L - vpfe capture - build environment for
>ISIF driver
>
>Hello.
>
>m-karicheri2@ti.com wrote:
>
>> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>
>> Adding Makefile and Kconfig for ISIF driver
>>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> ---
>> Applies to linux-next tree
>>  drivers/media/video/Kconfig          |   15 ++++++++++++++-
>>  drivers/media/video/davinci/Makefile |    1 +
>>  2 files changed, 15 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 9dc74c9..8250c68 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -552,7 +552,7 @@ config VIDEO_VPSS_SYSTEM
>>  	depends on ARCH_DAVINCI
>>  	help
>>  	  Support for vpss system module for video driver
>> -	default y
>> +	default n
>>
>
>   You might as well have deleted "default".
>
>WBR, Sergei

