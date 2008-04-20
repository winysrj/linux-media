Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3KCQlwV015520
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 08:26:47 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3KCQZpT020441
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 08:26:35 -0400
Message-ID: <480B3673.3040707@pickworth.me.uk>
Date: Sun, 20 Apr 2008 13:26:27 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Gert Vervoort <gert.vervoort@hccnet.nl>
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
In-Reply-To: <480B26FC.50204@hccnet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
Reply-To: ian@pickworth.me.uk
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

Gert Vervoort wrote:
> Ian Pickworth wrote:
>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
>> for   the Hauppauge WinTV appear to have suffered some regression 
>> between the two kernel versions.
>>
>> The problem is that the tuner is not being detected and set correctly 
>> for either the video or the radio device on the card.
>>
> Similar issue here with a Leadtek Winfast 2000XP card. Video works, but 
> radio doesn't.
> For my card I can workaround the issue by adding the "tuner=38" option 
> to the cx88xx module.
> 
>   Gert

That workaround works for me as well - with "tuner=38" for cx88xx I can 
now tune to both video and radio channels.

So it looks like its just the auto detection that has regressed in 2.6.25.

Thanks
Regards
Ian


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
