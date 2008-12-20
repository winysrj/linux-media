Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK38swE026774
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:08:54 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK38dLu011331
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:08:40 -0500
Received: by ewy14 with SMTP id 14so1312232ewy.3
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:08:39 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:08:50 +0300
Message-Id: <1229742531.10297.108.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 0/5] patches for dsbr100 radio
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

Hello, all
Here is series of patches for dsbr100 usb radio.
Most of them are trivial and just fix comments, codingstyle, etc.

Patches should be applied after previous unplug and correct fix to
dsbr100.c(that not in hg-tree yet)
All tested under 2.6.28-rc9 kernel. Works fine.

I appreciate your review, comments, suggestions, remarks.
May be few patches should be merged in one patch. May be somewhere my
english is bad.

Douglas, if you aren't so very busy, please review and test it.

-- 
Best regards, Klimov Alexey


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
