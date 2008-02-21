Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1L9BWKb011985
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 04:11:33 -0500
Received: from hs-out-0708.google.com (hs-out-0708.google.com [64.233.178.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1L9B2nP003816
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 04:11:02 -0500
Received: by hs-out-0708.google.com with SMTP id k27so2535740hsc.3
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 01:11:02 -0800 (PST)
Message-ID: <5b5250670802210111l607d14c1j5bae7ee44beaab92@mail.gmail.com>
Date: Thu, 21 Feb 2008 14:41:01 +0530
From: "thirunavukarasu selvam" <gs.thiru@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Streaming C-band Signal with Nexus-S card
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

Hi all,

I am using WinTv-Nexus S card and a C-Band feed is connected to it.
If i start streaming a channel from C-BAND signal using vlc, its working
properly.
However if i continue the same for longer time say more than a day, it stops
to stream in the middle. But VLC is running in the background without any
issues.
I am not able to view the video on the screen.

Then i killed the vlc process.
unloaded the nexus-s card drivers and reloaded it again.
After this if i start to stream a channel it is doing it properly.

Please tell me what could be the issue behind this.
This problem persists for long time.

Thanks in Advance for ur help

Regards
Thiru.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
