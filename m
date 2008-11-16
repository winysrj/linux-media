Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGN72Kt006075
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 18:07:02 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAGN6mOo006778
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 18:06:48 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1045966nfc.21
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 15:06:48 -0800 (PST)
Message-ID: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
Date: Sun, 16 Nov 2008 18:06:47 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>, V4L <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Attention em28xx users
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

Hello there,

Over the last few days I have been been pushing a number of
fixes/improvements into the mainline em28xx driver.  These include
remote control fixes, em2874 device support, and other cleanups.  I
look forward to continuing to improve the driver now that Empia has
been so kind to provide me with datasheets.

One concern about the mainline em28xx driver expressed has to do with
device support.  There are many, many devices out there, and I need
help ensuring that they work properly with the driver.  Now is the
time for users who have non-working em28xx-based devices to come
forward.

I am willing to debug any ATSC/NTSC em28xx based device a user cannot
get to work under Linux, for the cost of shipping me the device for
one week (I'll pay return shipping).  We're at the point now where
most of them are pretty easy to get working, but I cannot afford to
buy every $50 device out there.

The only condition I'm restricting this to at this point is the em28xx
based device needs to have pre-existing chipset support for the other
components (such as the video decoder, demodulator, and tuner).
However, this does represent a vast majority of the em28xx based
devices out there.  Also, I'm keeping it to ATSC/NTSC because I don't
have any access to a DVB based signal.

Users of em28xx based devices that want to see them supported:  Now is
the time to contact me.  If you're interested, please email me the
product name, the list of chips in the device, and I will work with
you to get it supported.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
