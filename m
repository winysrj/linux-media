Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ0aaAV026054
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 19:36:36 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ0Zkn1014865
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 19:35:46 -0500
Received: by ug-out-1314.google.com with SMTP id j30so398093ugc.13
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 16:35:46 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Wed, 19 Nov 2008 03:35:55 +0300
Message-Id: <1227054955.2389.32.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/1] radio-mr800: fix unplug
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

This patch fix such thing. When you listening the radio with you
user-space application(kradio/gnomeradio/mplayer/etc) and suddenly you
unplug the device from usb port and then close application or change
frequency of the radio - a lot of oopses appear in dmesg. I also had big
problems with stability of kernel(different memory leaks, lockings) in
~30% of cases when using mplayer trying to reproduce this bug.

This thing happens with dsbr100 radio and radio-mr800. I told about this
thing to Douglas Schilling Landgraf and then he suggested right decision
for dsbr100. He told me that he get ideas of preventing this bug from
Tobias radio-si470x driver. Hopefully this bug didn't show up in
radio-si470x. Well, i used Douglas suggestion and code of si470x and
made this patch.

Douglas said that he's going to create patch for dsbr100.

Patch places a lof of safety checks in functions, adds disconnect_lock
mutex and changes disconnect and release functions of module. May be
it's good to add it to 2.6.28 because it fixes an issue.
I tested this thing under 2.6.28-rc5.

-- 
Best regards, Klimov Alexey


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
