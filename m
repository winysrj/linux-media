Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7CF1E5j005402
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 11:01:14 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7CF14ci012945
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 11:01:04 -0400
Received: by wr-out-0506.google.com with SMTP id c49so1840380wra.19
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 08:00:59 -0700 (PDT)
Message-ID: <ea4209750808120800x4b7c50bfra7101145dbad6b06@mail.gmail.com>
Date: Tue, 12 Aug 2008 17:00:59 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: DIBCOM devices
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

Hi all, I've been a long time working on some pinnacle hybrid card. I
managed to get working the dvb-t part (thanks to the linux-dvb mailing list
help), but now I'm trying the analogue. For this reason I switched to the
v4linux mailing list. I've been looking at the code under
drivers/media/video folder and sincerely I have no idea on where to start.
The device has a dibcom 7700 bridge with a conexant CX25843 demodulator and
xc3028 tuner. It's my impression or there is nothing done on using the
dibcom usb bridge for analogue?

Albert
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
