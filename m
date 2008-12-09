Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9HWN5L000389
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 12:32:23 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9HUHZ8024892
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 12:30:44 -0500
Received: by ewy14 with SMTP id 14so65254ewy.3
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 09:30:16 -0800 (PST)
Message-ID: <de8cad4d0812090930k75d973em4f21d36777ee02a2@mail.gmail.com>
Date: Tue, 9 Dec 2008 12:30:16 -0500
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Changes in cx18 - Request more info
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

Hi Andy,

I noticed you made some code updates in your tree and I am anxious to
try them out. Based on the info provided in your notes, I am unable to
determine what levels I should set to provide to increase performance
of my 3 cards. Any pointers you can provide would be most appreciated.
Here's my current modprobe.conf statement:

options cx18 enc_yuv_buffers=0 enc_vbi_buffers=0 enc_pcm_buffers=0
debug=3 enc_mpg_buffers=8 enc_ts_buffers=8

But it sounds like I should be decreasing buffers and not increasing
them to remove artifacts.


Regards,

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
