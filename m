Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4DMq6Rp013405
	for <video4linux-list@redhat.com>; Thu, 13 May 2010 18:52:06 -0400
Received: from mail-gw0-f46.google.com (mail-gw0-f46.google.com [74.125.83.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4DMptEb008102
	for <video4linux-list@redhat.com>; Thu, 13 May 2010 18:51:56 -0400
Received: by gwj19 with SMTP id 19so915803gwj.33
	for <video4linux-list@redhat.com>; Thu, 13 May 2010 15:51:55 -0700 (PDT)
MIME-Version: 1.0
From: Alexjan Carraturo <axjslack@gmail.com>
Date: Fri, 14 May 2010 00:51:34 +0200
Message-ID: <AANLkTilbPB2DeJhah0XzSMYEOpXUTzt-v4-h9JsV1BP2@mail.gmail.com>
Subject: Pinnacle PCTV DVB-T 70e
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

Hello everyone,

My name Alexjan Carraturo and am new to this list, and I apologize if
my first request for assistance infringe some custom.

Long time I try to run a particular type of device DVB-T, and sometimes I did.

The device in question is a Usbstick Pinnacle PCTV DVB-T (70th); is
USB, running lsusb we have this

eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick

As I said before, once I managed to get it working with both Fedora
and Slackware (the Linux distributions that I use routinely).

Did not work with the drivers on the kernel (em28xx, em28xx-dvb); the
"traditional driver" try to recognize the device, but doesn't work.

The device works only (and very well) with a version made by some
individuals, called em28xx-new. There is a version of these drivers,
compile manually, but it works only until kernel 2.6.31 (
http://launchpadlibrarian.net/35049921/em28xx-new.tar.gz )

Searching the internet I saw that many users are trying to work this
board (very common).

Is there a way to incorporate the changes mentioned in the official driver?
Or, you can suggest how they might be modified drivers indicated to
work with recent kernels (2.6.32, and soon 2.6.33 or later)?

Thank yuo

Alex.
-- 
########################################
Alexjan Carraturo
admin of
Free Software Users Group Italia
http://www.fsugitalia.org
Fedora Ambassador: Axjslack
openSUSE Ambassador: Axjslack
Free Software Foundation Europe Fellow 1623
Software Freedom International board member
########################################

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
