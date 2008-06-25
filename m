Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5PJpirt001489
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 15:51:44 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5PJpXaU031212
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 15:51:34 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1705567fga.7
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 12:51:33 -0700 (PDT)
Message-ID: <30353c3d0806251251v6f91a7efy7ceedab39a42f0a6@mail.gmail.com>
Date: Wed, 25 Jun 2008 15:51:33 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Bug in stv680
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

I'm currently in the process of developing driver for a currently
unsupported usb camera. For guidance, I've been referencing the code
of other usb camera drivers. While reviewing the stv680 code, I've
come across a bug that looks like it could crash the driver. Since I
do not have a camera that is supported by this driver, I can only rely
on my interpretation of the code and how my still underdeveloped
driver behaves.

In stv_open, stv680->user is set to 1. In stv_close, stv680->user is
set to 0. In stv680_disconnect, the value of stv680->user is used to
determine if the stv680 struct should be freed. Under the following
conditions stv680->user will be 0 and the stv680 struct will be freed
while it is still in use.
     1. Application 1 opens the device. stv680->user transitions from 0->1
     2. Application 2 opens the device. stv680->user transitions from 1->1
     3. Application 2 closes the device. stv680->user transitions from 1->0
     4. Device is physically disconnected. stv680 is freed.
     5. Application 1 closes the device.

The crash could happen at step 4 in stv680_read, stv680_mmap, or
stv680_do_ioctl, or at step 5 in stv_close depending on how
Application 1 is using the device.

The apparent fix for this, is that stv680->user should be incremented
whenever the device is opened, and decremented when it is closed.
Likewise, a lock should be used to guarantee exclusive access to
stv680->user to avoid a race condition between stv_open and stv_close.
This should correct the case where the structure is freed by
stv_disconnect while it is still open and in use.

I should note, the v4l2 specs indicate that the device may be opened
multiple times as in the case above. The reasoning for this is that
while one application is streaming the video, another may modify
controls. A valid fix would therefore not be to deny multiple opens to
the device.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
