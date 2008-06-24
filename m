Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OA1WBk030140
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 06:01:32 -0400
Received: from mgate0.outbound.cnh.at (postfix@mgate0.outbound.cnh.at
	[195.149.216.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OA10nI009085
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 06:01:00 -0400
Received: from wuschlbuschl (cnh809212138.pppoe.surfer.cnh.at [80.92.121.38])
	by mgate0.outbound.cnh.at (Postfix) with SMTP id 6CEECFF15
	for <video4linux-list@redhat.com>;
	Tue, 24 Jun 2008 10:46:04 +0200 (CEST)
Message-ID: <597D1543B3BA4400910B04E46280B6C3@wuschlbuschl>
From: "B. Moser" <sy@itakka.at>
To: <video4linux-list@redhat.com>
Date: Tue, 24 Jun 2008 10:45:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Subject: how to get timedelayed pictures of camera on /dev/video0
Reply-To: "B. Moser" <sy@itakka.at>
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

I have a small problem - maybe someone out there can help me:

I have a camera connected to my compuer ( /dev/video0 ).
So far it is no problem to watch the pictures from the camera in realtime
(for example with mplayer or similar programs).

But I want to watch on screen what this camera showed 5 seconds ago.
So the pictures/video from this camera should go into a buffer - which I
would like to show on the monitor time-delayed a few seconds later.

regards
Bernhard

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
