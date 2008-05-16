Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GDuvHZ008685
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 09:56:57 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GDuSSv023746
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 09:56:29 -0400
Received: by fk-out-0910.google.com with SMTP id e30so824073fke.3
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 06:56:28 -0700 (PDT)
Message-ID: <a5eaedfa0805160656t29d2858ao3c1c81469b87b0af@mail.gmail.com>
Date: Fri, 16 May 2008 19:26:27 +0530
From: "Veda N" <veda74@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: pixel count doubts
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
I am trying to write a camera sensor driver.

The sensor documents says that -
For the resolution VGA, The pixel count is 640x480x3.

I did not understand what is meant by x3 in pixel count.

Usually it is 60x480. The number of bytes per pixel is 2.

Does this mean that instead of 2 bytes per pixel. it is 3 bytes?


How should i account this pixel count in my driver.
How much should be  bytesperline and sizeimage
How should i account this in my application as well.

Regards,
vedan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
