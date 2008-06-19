Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JGeBjg014190
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 12:40:17 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JGdOAI016551
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 12:39:24 -0400
Received: by yx-out-2324.google.com with SMTP id 3so139483yxj.81
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 09:39:24 -0700 (PDT)
To: Jan Frey <linux@janfrey.de>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <200806152158.48344.linux@janfrey.de> (Jan Frey's message of "Sun,
	15 Jun 2008 21:58:47 +0200")
References: <200806152158.48344.linux@janfrey.de>
Date: Thu, 19 Jun 2008 18:38:48 +0200
Message-ID: <khcbp9y7b.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi Jan,

> 2. I can't get DVB-T to work. All the modules load fine, scanning for 
> channels fails, no channel can be tuned - no stations found. I tried to 
> use dvbsnoop, only visible effect is the following line repeated in kernel 
> log:
>
>  cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000003)  

DVB-T works fine for me unless I have used the HW MPEG encoder
beforehand. As the card is in a development machine which is mainly
used for digitizing composite video and occasionally used for DVB-T
software development (with a reboot in between) I have not
investigated it further... On the other hand, I only tune to a known
frequency and have not tried to scan for channels.

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
