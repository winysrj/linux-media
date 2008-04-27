Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3RJ5MIA023158
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 15:05:22 -0400
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.18.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3RJ4pgx008292
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 15:04:52 -0400
Received: from [62.216.212.3] (helo=blacksheep.qnet)
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <kiu@gmx.net>) id 1JqCB9-0003h8-0C
	for video4linux-list@redhat.com; Sun, 27 Apr 2008 21:04:51 +0200
Message-ID: <20080427210450.5u7wgb4xdwkws8cs@blacksheep.qnet>
Date: Sun, 27 Apr 2008 21:04:50 +0200
From: kiu <kiu@gmx.net>
To: video4linux-list@redhat.com
References: <20080427205841.4pehkhp5sgoccco8@blacksheep.qnet>
In-Reply-To: <20080427205841.4pehkhp5sgoccco8@blacksheep.qnet>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Subject: Re: TerraTec Cinergy C - tuning fails
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

Quoting kiu <kiu@gmx.net>:

> If i now run (dvb)scan it searches for QAM64 and QAM256 and finds

sorry, i meant: w_scan -fc -x -vvvv

> signals there. After scanning it tries to tune the channels, but
> freezes with this message:
>
> tune to:
>>>> tuning status == 0x1f
> add_filter:1388: add filter pid 0x0000
> start_filter:1334: start filter pid 0x0000 table_id 0x00

-- 
kiu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
