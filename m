Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D5ipho028850
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 01:44:51 -0400
Received: from mxout10.netvision.net.il (mxout10.netvision.net.il
	[194.90.6.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4D5idfI027349
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 01:44:40 -0400
Received: from mail.linux-boards.com ([62.90.235.247])
	by mxout10.netvision.net.il
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K0S00CIVLEZ6G70@mxout10.netvision.net.il> for
	video4linux-list@redhat.com; Tue, 13 May 2008 08:47:23 +0300 (IDT)
Date: Tue, 13 May 2008 08:44:33 +0300
From: Mike Rapoport <mike@compulab.co.il>
In-reply-to: <998e4a820805121959q77b3197cj692b813da6c68a7@mail.gmail.com>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
Message-id: <48292AC1.3020505@compulab.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=GB2312
Content-transfer-encoding: 8BIT
References: <998e4a820805121959q77b3197cj692b813da6c68a7@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: writting norflash will affect capture on pxa270?
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



·ëöÎ wrote:
> My platform is pxa270.
> When pxa270 is capturring, I write a file to JFFS2 norflash.Then FIFO
> will overrun.But if I write a file to YAFFS nandflash,FIFO will not
> overrun.

NOR flash writes are *slow*, so this indeed can be an issue.

> 

-- 
Sincerely yours,
Mike.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
