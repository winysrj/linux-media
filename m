Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4MDl07N022531
	for <video4linux-list@redhat.com>; Sat, 22 May 2010 09:47:01 -0400
Received: from mail-wy0-f174.google.com (mail-wy0-f174.google.com
	[74.125.82.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4MDkjt0006787
	for <video4linux-list@redhat.com>; Sat, 22 May 2010 09:46:46 -0400
Received: by wyb29 with SMTP id 29so524053wyb.33
	for <video4linux-list@redhat.com>; Sat, 22 May 2010 06:46:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 22 May 2010 14:46:44 +0100
Message-ID: <AANLkTimXIFtu3Up2JMwpn2hAE6jz86YOnggxQwxih37O@mail.gmail.com>
Subject: VIDIOC_G_STD, VIDIOC_S_STD, VIDIO_C_ENUMSTD for outputs
From: Andre Draszik <v4l2@andred.net>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

As per the spec, the above ioctl codes are defined for inputs only -
it would be useful if there were similar codes for outputs.

I therefore propose to add the following:

VIDIOC_G_OUTPUT_STD
VIDIOC_S_OUTPUT_STD
VIDIOC_ENUM_OUTPUT_STD

which would behave similar to the above, but for output devices.

Thoughts?


Cheers,
Andre'

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
