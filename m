Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OKvCcx013044
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 16:57:12 -0400
Received: from hermes.gsix.se (hermes.gsix.se [193.11.224.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9OKv0g0024387
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 16:57:00 -0400
Received: from dng-gw.sgsnet.se ([193.11.230.69] helo=[172.16.172.22])
	by hermes.gsix.se with esmtp (Exim 4.63)
	(envelope-from <jonatan@akerlind.nu>) id 1KtTiN-00074t-MQ
	for video4linux-list@redhat.com; Fri, 24 Oct 2008 22:56:59 +0200
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 24 Oct 2008 22:56:57 +0200
Message-Id: <1224881817.20411.4.camel@skoll>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: HVR-1300 analog and mythtv error opening device
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

Hi,

thought I should give the card a try without using the mpeg encoder so I
removed the blackbird device from my mythtv and added the v4l device
instead. Now when opening the tv feed in mythtv i get this in dmesg:

BUG: cx88 can't find device struct. Can't proceed with open

I seem to be able to open the video stream in xawtv (i get a picture
that moves when running xawtv on a remote X display on my laptop). So is
this a problem with mythtv doing the wrong thing or is there something
lacking in the v4l module?

/Jonatan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
