Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DA3LVr019997
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 06:03:21 -0400
Received: from fmmailgate02.web.de (fmmailgate02.web.de [217.72.192.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DA2Gt8016785
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 06:02:21 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id E1A59E59914F
	for <video4linux-list@redhat.com>;
	Sun, 13 Jul 2008 12:02:10 +0200 (CEST)
Received: from [217.95.137.23] (helo=[192.168.1.40])
	by smtp07.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226) id 1KHyPC-0000Ud-00
	for video4linux-list@redhat.com; Sun, 13 Jul 2008 12:02:10 +0200
Message-ID: <4879D2A2.4040907@web.de>
Date: Sun, 13 Jul 2008 12:02:10 +0200
From: Peter Schlaf <peter.schlaf@web.de>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <48793439.20700@web.de> <48793697.3080704@linuxtv.org>
In-Reply-To: <48793697.3080704@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: smscoreapi.c:689: error: 'uintptr_t' undeclared
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

hi,
thank you for your reply.

unfortunately there is no 'uintptr_t' in linux/types.h of my system 
(openSuSE 10.3, kernel 2.6.22.18-0.2-bigsmp) or in other files it includes.

a search for 'uintptr_t' under /usr/src/linux resulted in this:
   drivers/net/sk98lin/h/skdrv1st.h:142:#define uintptr_t  unsigned long

i put this define into smscoreapi.h and it worked.

cu


Michael Krufky schrieb:
> Peter,
> 
> Peter Schlaf wrote:
>> to workaround this i edited v4l/Makefile.media and commented out
>>
>>   sms1xxx-objs := smscoreapi.o smsusb.o smsdvb.o sms-cards.o
>>
>>   obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
>>
>>
>> after that, compiling all the other modules ended successfully.
> 
> 
> Thank you for posting this error.  Here is a fix:
> 
> diff -r f6b65eef0c94 linux/drivers/media/dvb/siano/smscoreapi.h
> --- a/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Jul 11 20:37:08 2008 -0400
> +++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Sat Jul 12 18:55:02 2008 -0400
> @@ -27,6 +27,7 @@
>  #include <linux/list.h>
>  #include <linux/mm.h>
>  #include <linux/scatterlist.h>
> +#include <linux/types.h>
>  #include <asm/page.h>
>  
>  #include "dmxdev.h"
> 
> 
> I'll push this in now.
> 
> Regards,
> 
> Mike Krufky
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
