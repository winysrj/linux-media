Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49GHqTh006793
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 12:17:52 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49GHWAa008229
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 12:17:32 -0400
Message-ID: <48247919.8020402@users.sourceforge.net>
Date: Fri, 09 May 2008 18:17:29 +0200
From: Andre Auzi <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <482370FD.7000001@users.sourceforge.net>	
	<1210296633.2541.26.camel@pc10.localdom.local>
	<1210297053.2541.31.camel@pc10.localdom.local>
In-Reply-To: <1210297053.2541.31.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cx88 driver: Help needed to add radio support on Leadtek	WINFAST
 DTV 2000 H (version J)
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

hermann pitton a écrit :
> Am Freitag, den 09.05.2008, 03:30 +0200 schrieb hermann pitton:
>> Am Donnerstag, den 08.05.2008, 23:30 +0200 schrieb Andre Auzi:
> 
>> Radio on the FMD1216ME/I MK3 is not perfect anyway, on other stuff it
>> might also only be the best hack around then, but some still claim new
>> hardware doesn't exist ...
> 
> One is missing here.
> 
> You might have the newer FMD1216MEX, Steve mentioned sometime
> previously, it might be slightly different for the radio support.
> 
> I do know exactly nothing about it.
> 
> Cheers,
> Hermann
> 
> 
> 

 From the driver's inf file I read:

[LR6F2B.AddReg]
HKR,"DriverData","FMD1216MEX",0x0010001, 0x01, 0x00, 0x00, 0x00

This probably means you guessed right.

That's a step forward, isn't it?

Too bad you cannot say more.

I'll keep you posted.

Rgards,
Andre

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
