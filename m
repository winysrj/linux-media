Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JGsp39024996
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 12:54:51 -0400
Received: from mta3.srv.hcvlny.cv.net (mta3.srv.hcvlny.cv.net [167.206.4.198])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JGs3s8026628
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 12:54:03 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K2P0096XYXTIF91@mta3.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 19 Jun 2008 12:53:55 -0400 (EDT)
Date: Thu, 19 Jun 2008 12:53:53 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <khcbp9y7b.fsf@liva.fdsoft.se>
To: Frej Drejhammar <frej.drejhammar@gmail.com>
Message-id: <485A8F21.907@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <200806152158.48344.linux@janfrey.de>
	<khcbp9y7b.fsf@liva.fdsoft.se>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: HVR-1300 support lacking quality?
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

Frej Drejhammar wrote:
> Hi Jan,
> 
>> 2. I can't get DVB-T to work. All the modules load fine, scanning for 
>> channels fails, no channel can be tuned - no stations found. I tried to 
>> use dvbsnoop, only visible effect is the following line repeated in kernel 
>> log:
>>
>>  cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000003)  
> 
> DVB-T works fine for me unless I have used the HW MPEG encoder
> beforehand. As the card is in a development machine which is mainly
> used for digitizing composite video and occasionally used for DVB-T
> software development (with a reboot in between) I have not
> investigated it further... On the other hand, I only tune to a known
> frequency and have not tried to scan for channels.

Somebody was trashing GPIO's recently, try the tip and report back, it 
should be ok now.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
