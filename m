Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHCrNFN029268
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 07:53:23 -0500
Received: from mail.anno.name (baal.anno.name [92.51.131.125])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHCqB0k007598
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 07:52:53 -0500
Received: from [192.168.178.24] (p579C250E.dip.t-dialin.net [87.156.37.14])
	by mail.anno.name (Postfix) with ESMTPA id A163E22C4C242
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:52:10 +0100 (CET)
Message-ID: <4948F603.1070906@wakelift.de>
Date: Wed, 17 Dec 2008 13:52:19 +0100
From: Timo Paulssen <timo@wakelift.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: zc3xx webcam (041e:4034 Creative Webcam Instant) stopped working
 some time ago (since gspca kernel integration?)
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

Hello,

I recently tried using my webcam, the Creative Webcam Instant (usb ID
041e:4034) again, but I can't get it to work any more.

When I started using this webcam, i could get it to work with the
spca5xx driver, which I usually compiled per hand and inserted into the
kernel. Then came gspcav1, which worked, too. But with the gspca, that
is integrated in the kernel now (I'm using 2.6.27.9 retrieved from
kernel.org) the webcam won't work.

The first symptom is, that spcaview won't start any more and camstream
spits out these lines while showing a black window at the size i requested:


W: run(): VIDIOCSYNC(1) failed (Invalid argument)
W: VDLinux::run() VIDIOCMCAPTURE failed (Invalid argument)


similarly, spcaview tells me:


cvsync err
: Invalid argument
cmcapture: Invalid argument
>>cmcapture err -1
cvsync err
: Invalid argument


and then segfaults.

More interestingly, spcaview now complains, that my camera is "Not an
Spca5xx Camera !!".

Any help on how to get the camera working again would be very appreciated :)

Thanks for all the hard and good work,

  - Timo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
