Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0887Cht024906
	for <video4linux-list@redhat.com>; Thu, 8 Jan 2009 03:07:12 -0500
Received: from correo.cdmon.com (correo.cdmon.com [212.36.74.112])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0886r63030836
	for <video4linux-list@redhat.com>; Thu, 8 Jan 2009 03:06:54 -0500
Message-ID: <4965B412.5010005@cdmon.com>
Date: Thu, 08 Jan 2009 09:06:42 +0100
From: Jordi Moles Blanco <jordi@cdmon.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <49646351.6030709@cdmon.com>
	<1231374524.2613.3.camel@pc10.localdom.local>
In-Reply-To: <1231374524.2613.3.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: support for remote in lifeview trio
Reply-To: jordi@cdmon.com
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

En/na hermann pitton ha escrit:
> Hi Jordi,
>
> Am Mittwoch, den 07.01.2009, 09:09 +0100 schrieb Jordi Moles Blanco:
>   
>> hi,
>>
>> i've been googling and trying some things during days with no luck.
>>
>> i want to get the remote which comes with this card working, and i only 
>> found old posts like this one:
>>
>> http://www.spinics.net/lists/vfl/msg29862.html
>>
>> which assures that the patch gets the remote to work on that card.
>>
>> i downloaded the latest v4l source code and tried to patch it with the 
>> code proposed on that post, but var names have changed and i don't have 
>> a clue on how to apply it properly.
>>
>> i haven't seen any more recent post, so i guess it may still be in a 
>> to-do list, or may be it was rejected for some reason to go into the 
>> main-line.
>>
>> Could anyone tell me if this patch will ever be included? or... what v4l 
>> version could i download to be able to patch it as described?
>>
>>     
>
> the MSI TV@nywhere Plus with similar problems is included now.
>
> http://linuxtv.org/hg/v4l-dvb/rev/7d81fb776d1f
>
> Might be a hook for the Trio as well, but I don't remember the details
> offhand anymore.
>
> Cheers,
> Hermann
>
>
>   
hi,

thanks for the info,

i'll have a look and see if i can get adapt the patch to work with my card.

thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
