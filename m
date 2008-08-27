Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7RGEUOM006450
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 12:14:30 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7RGEJJl016211
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 12:14:19 -0400
Received: by py-out-1112.google.com with SMTP id a29so1810857pyi.0
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 09:14:19 -0700 (PDT)
Message-ID: <d90126080808270914t23cfc92fi64849efbea68a0b6@mail.gmail.com>
Date: Wed, 27 Aug 2008 21:44:18 +0530
From: "sunder ramani" <sunder.svit@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: video_waiton
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

hi all,

I would want to achieve the DQBUF call to return after a specified timeout
in case of unavaiablitiy of a filled buffer. However, I find that the DQBUF
call sleeps on schedule() rather than a wait_event_interrutible.

Can i replace this schedule and rather use wait_event_interrutible_timeout?

I would also like to know if there would be any difference in putting the
process to sleep via these methods other than the timeout functinality.

Thanx
Sundar
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
