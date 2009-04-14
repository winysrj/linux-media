Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3E5PvWf005328
	for <video4linux-list@redhat.com>; Tue, 14 Apr 2009 01:25:57 -0400
Received: from mail-bw0-f170.google.com (mail-bw0-f170.google.com
	[209.85.218.170])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3E5PghK002833
	for <video4linux-list@redhat.com>; Tue, 14 Apr 2009 01:25:43 -0400
Received: by bwz18 with SMTP id 18so2332797bwz.3
	for <video4linux-list@redhat.com>; Mon, 13 Apr 2009 22:25:42 -0700 (PDT)
Date: Tue, 14 Apr 2009 15:27:11 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090414152711.33934ad4@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Tuner Philips MK3 and aux byte.
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

Hi All.

I found that Philips tuner FMD1216-MK3 has auxilliary byte for sensitivity manipulation.
It can be set from 102dB to 118dB. Can I use V4L2_CID_GAIN for set sensitivity level of tuner?

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
