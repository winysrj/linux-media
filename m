Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n13AcGKD001670
	for <video4linux-list@redhat.com>; Tue, 3 Feb 2009 05:38:16 -0500
Received: from mail-bw0-f10.google.com (mail-bw0-f10.google.com
	[209.85.218.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n13Ac0Z8020677
	for <video4linux-list@redhat.com>; Tue, 3 Feb 2009 05:38:00 -0500
Received: by bwz3 with SMTP id 3so1971706bwz.3
	for <video4linux-list@redhat.com>; Tue, 03 Feb 2009 02:37:59 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 12:37:59 +0200
Message-ID: <36c518800902030237x253285afje05cf6a41a1f8adb@mail.gmail.com>
From: vasaka@gmail.com
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: v4l2 loopback
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

Hello, I am writing v4l2 loopback device and stuck on a problem of
distinguishing who makes ioctl call: writer or reader?
it seems to me that I should use "enum v4l2_buf_type  type" which is
different for capture and output device, but I can not get to details
how to make use of it.

project is hosted here http://code.google.com/p/v4l2loopback/
--
Vasaka

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
