Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:34924 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZHZQkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 12:40:23 -0400
Message-ID: <4A956575.4080207@ridgerun.com>
Date: Wed, 26 Aug 2009 10:40:21 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4A954B35.3090902@ridgerun.com> <A69FA2915331DC488A831521EAE36FE40154E2C0F5@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40154E2C0F5@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Official/Staging git tree for v4l2?
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks.

I get the following error after doing a git clone:

git clone 
http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
Initialized empty Git repository in 
/home/snunez/Projects/git_trees/mchehab/linux-next/.git/
Getting alternates list for 
http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
Also look at 
http://www.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git/
Getting pack list for 
http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
Getting index for pack 9b00cd8cdc6dc894f442e67243d48a667ac0bf0c
Getting index for pack 4a4e3c3d379a1f1ce18d16e93523a7cd1753655e
Getting index for pack 9c4fc44de8cf7d89f78e57e232c81a6c54685276
Getting pack 9c4fc44de8cf7d89f78e57e232c81a6c54685276
 which contains 6f5ee0854a60eceedda876a44f00d9daf9616e06
walk 6f5ee0854a60eceedda876a44f00d9daf9616e06
Getting pack list for 
http://www.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git/
Getting index for pack 510b239769ca73da4b7c208359adefc418e453ce
error: Unable to find dcd94dbdaff452b95d4ba11fdbf853b5bda8e6e7 under 
http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
Cannot obtain needed object dcd94dbdaff452b95d4ba11fdbf853b5bda8e6e7
while processing commit 6f5ee0854a60eceedda876a44f00d9daf9616e06.
fatal: Fetch failed.


Karicheri, Muralidharan wrote:
> The VPFE capture driver is currently available at
>
> http://www.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
>
> I usually use this for creating my patches for V4L.
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
>
>   
>> -----Original Message-----
>> From: Santiago Nunez-Corrales [mailto:snunez@ridgerun.com]
>> Sent: Wednesday, August 26, 2009 10:48 AM
>> To: Linux Media Mailing List; Karicheri, Muralidharan
>> Subject: Official/Staging git tree for v4l2?
>>
>> Good morning,
>>
>>
>> I am currently giving support to the TV7002 driver in dm365 and need to
>> add some extra controls and definitions in the v4l2 interface. What is
>> the official or staging git tree I can clone for development? The kernel
>> version is 2.6.31.
>>
>>
>> Regards,
>>
>>
>> --
>> Santiago Nunez-Corrales, Eng.
>> RidgeRun Engineering, LLC
>>
>> Guayabos, Curridabat
>> San Jose, Costa Rica
>> +(506) 2271 1487
>> +(506) 8313 0536
>> http://www.ridgerun.com
>>
>>
>>     
>
>   


-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


