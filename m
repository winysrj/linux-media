Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M9GEkJ026989
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 05:16:14 -0400
Received: from vesta.asc.rssi.ru (vesta.asc.rssi.ru [193.232.12.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M9EiJ7004727
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 05:15:06 -0400
Received: from vesta.asc.rssi.ru (localhost [127.0.0.1])
	by vesta.asc.rssi.ru (8.12.7/8.12.7/SuSE Linux 0.6) with ESMTP id
	m8M9jWeH000071
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 13:45:32 +0400
Received: (from kostyuk@localhost)
	by vesta.asc.rssi.ru (8.12.7/8.12.7/Submit) id m8M9jW7M000070
	for video4linux-list@redhat.com; Mon, 22 Sep 2008 13:45:32 +0400
From: Sergey Kostyuk <kostyuk@vesta.asc.rssi.ru>
Date: Mon, 22 Sep 2008 13:45:32 +0400
To: video4linux-list@redhat.com
Message-ID: <48D7693C.mail1811NYE1@vesta.asc.rssi.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Custom Standards
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


There are two cases concerning TV standards handling:

1. The devices like HDMI/DVI transmitters (i2c-clients from Silicon Images) can generate custom
TV signal (HDTV,VESA,PAL, etc) which can be described by a single structure. It is possible that
handling of DVI devices and related stuff (like processing of EDID from digital TVs) are
partially implemented in FrameBuffer kernel subsystem.

2. Simple TV-encoders (adv7170, bt865, etc) use only predefined standards PAL,NTSC,SECAM.
????The  contemporary TV-encoders (fs453 from Focus Enhancements
) use predefined HDTV-standards in addition to the usual PAL,NTSC.

So we have to have 2 different interfaces. This is simplified description of HDTV problem :-)

Sergey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
