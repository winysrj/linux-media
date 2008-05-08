Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48ERJaN016372
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 10:27:19 -0400
Received: from mail.linsys.ca (205-200-74-130.static.mts.net [205.200.74.130])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m48ER72e024252
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 10:27:07 -0400
Received: from localhost.localdomain by linsys.ca (MDaemon PRO v9.6.5)
	with ESMTP id md50000251762.msg
	for <video4linux-list@redhat.com>; Thu, 08 May 2008 09:26:54 -0500
Message-ID: <48230D7E.9050503@linsys.ca>
Date: Thu, 08 May 2008 09:26:06 -0500
From: Dinesh Bhat <dbhat@linsys.ca>
MIME-Version: 1.0
To: Video-4l-list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Apple quicktime v210 codec equivalent support on V4L
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

Hello all,

We have a card that supports v210 codec type on Mac OS X. We have our 
regular drivers (we implement frame buffers) and are interested in 
supporting v4l for this card. I was wondering if there is any direct 
support available for v210 codec. Can anyone please suggest what is the 
best way to go here if we want to support v4l?

Here are the details on v210 packing.

http://developer.apple.com/quicktime/icefloe/dispatch019.html#v210

Thanks for your help.

Kind Regards,

Dinesh

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
