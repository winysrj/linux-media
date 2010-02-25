Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1PJ7qHf001367
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 14:07:52 -0500
Received: from mail-bw0-f220.google.com (mail-bw0-f220.google.com
	[209.85.218.220])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1PJ7dhK017817
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 14:07:39 -0500
Received: by bwz20 with SMTP id 20so3587934bwz.11
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 11:07:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B86C704.3060709@swartzlander.org>
References: <4B86C704.3060709@swartzlander.org>
Date: Thu, 25 Feb 2010 14:07:38 -0500
Message-ID: <829197381002251107v68f8cd87q90345de5715f6cc@mail.gmail.com>
Subject: Re: Chronic USB disconnect events for Pinnacle Dazzle DVC 100 video
	capture device
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ben Swartzlander <ben@swartzlander.org>
Cc: video4linux-list@redhat.com
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

On Thu, Feb 25, 2010 at 1:52 PM, Ben Swartzlander <ben@swartzlander.org> wrote:
> I have a Pinnacle Dazzle DVC 100 USB video capture device hooked up to a
> security camera capturing video 24/7. A few times a month, my kernel
> suddenly decides that the USB device was disconnected and reconnected,
> resulting in the device getting a new number and causing my recording
> software to stop recording until I restart it with the new device number.
> Here is an example of the dmesg output when it happens:

The USB host controller might be going to sleep if the PC's
suspend/resume kicked in.  Or, is there a USB hub involved which might
have been power cycled?  It's pretty hard to figure out *why* the
hardware decided to disconnect the USB device.

The reason the device gets a new device number is because it is still
in use when the disconnect occurs.  If the application were not
running at the time of the disconnect event, you would get the same
device number.

Also, it's probably worth mentioning that these sorts of devices are
not really designed for capture 24/7, so it might be overheating or
some bug in the hardware.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
