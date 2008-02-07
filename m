Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m171iWHI024683
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 20:44:32 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m171iBZF003100
	for <video4linux-list@redhat.com>; Wed, 6 Feb 2008 20:44:11 -0500
Received: by wa-out-1112.google.com with SMTP id j37so798281waf.7
	for <video4linux-list@redhat.com>; Wed, 06 Feb 2008 17:44:06 -0800 (PST)
Message-ID: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
Date: Wed, 6 Feb 2008 17:44:05 -0800
From: "Guillaume Quintard" <guillaume.quintard@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Question about saa7115
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
(I'm not sure it's the right place, but I couldn't find any better
place, so, if there is, please let me know)

I'm kinda new to V4L2 (and kernel drivers in general) and I've been
asked to se if I could control a saa7115 on an embedded linux
platform, using the V4L2 driver.
the driver loads without a problem, it creates an interface in /dev/,
but that a I2C (89) file, and not a video (81) one. The thing is I
have two saa7115 on the I2C bus, and I don't how to issue my command
to the one I want.

Well, from what I understood, I can send instructions to the bus using
ioctl() and /dev/i2c-0, but these are i2c/smbus commands, not V4L2
ones, right ?

I read the sources and I still don't have a clue what I'm supposed to
do, could you please give me a few hints ?

Thanks
-- 
Guillaume

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
