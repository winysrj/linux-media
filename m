Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8GEH2C021060
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:17 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8GE23P030942
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 11:14:03 -0500
Received: by ey-out-2122.google.com with SMTP id 4so444057eyf.39
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 08:14:01 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 19:13:54 +0300
Message-Id: <1228752834.1809.92.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH 0/2] fixes for radio mr800
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

This is two patches for radio-mr800. Both can be applied against current
hg tree.

1) This corrects unplug functions, fix to previous patch. Discussed much
with David. I think patch is okay. May be i'm wrong.

2) Because this device doesn't provide any powermanagment
capabilities(may be they exist but unknown to me yet, so they are not
implemented), we should turn them off. Current module goes to sleep and
never wakes up if autosuspend enabled. This is bad, and doesn't allow to
work fine with radio.

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
