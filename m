Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m22BhbnV005985
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 06:43:37 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m22Bh5bn014204
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 06:43:06 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: video4linux-list@redhat.com
Date: Sun, 2 Mar 2008 12:42:57 +0100
References: <47C14336.9030903@gmail.com> <20080226163918.GB9178@plankton>
	<20080227061107.2d5f9fc1@areia>
In-Reply-To: <20080227061107.2d5f9fc1@areia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021242.58744.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek
	ioctl interface
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

> Seems fine to me to have an specific ioctl for doing radio frequency seeks.

That seems to be a good approach. Is there any documentation on how the interface is currently implemented?

> It is good to have a patch to a real driver, implementing this feature. I don't
> like the idea of implementing newer ioctls at the API without having an
> in-kernel driver using. Having the driver ioctl implementation helps other
> developers that may need to use this interface on other places.

I would be very happy to add this functionality to my radio-si470x.c driver.
Seek support can be parameterized with this device in many ways.
This is all described in a document from Silabs (available via Google) called AN284Rev0_1.pdf

These parameters are not only used when seeking up/down, but also during frequency tuning.
They are already implemented as module parameters,
as they are country specific and should not be changed during normal operation:
- Band selection (upper/lower frequency limits)
- Spacing selection
- De-emphasis selection

Additionally these parameters are only used by the seek algorithm:
- RSSI Seek Threshold (range: 0..254, 254=highest threshold)
- Signal-Noise-Ratio (range: 0..15, 15=higest SNR ratio)
- FM-Impulse Noise Detection Counter (range: 0..15, 15=best audio quality)

Propably it is wise to give the user space applications the possiblity to change these parameters at run time (ioctl).
Else I'll implement them as module parameters, too.

Bye,
  Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
