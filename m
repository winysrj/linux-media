Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQ5sgi9008996
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 00:54:42 -0500
Received: from tomts20-srv.bellnexxia.net (tomts20.bellnexxia.net
	[209.226.175.74])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQ5sTXU018093
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 00:54:29 -0500
Received: from toip7.srvr.bell.ca ([209.226.175.124])
	by tomts20-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20081126055424.QOGH1552.tomts20-srv.bellnexxia.net@toip7.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 00:54:24 -0500
From: Bill Pringlemeir <bpringle@sympatico.ca>
To: video4linux-list@redhat.com
Date: Wed, 26 Nov 2008 01:51:08 -0500
Message-ID: <87fxlff09v.fsf@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 2.6.25+ and KWorld ATSC 110 inputs.
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


I use tvtime and mplayer to view ATSC and NTSC content OTA.  I have
the same input for both and prefer not to split it due to loss.
Anyways, with 2.6.24 series and below the drivers seems to pick the
inputs 'properly' for my needs.  Now they don't.  I looked through the
source and it seems that things are being structured more sanely.

I have the following output when I set debug=1 for tuner_simple and
run 'mplayer dvb://',

tuner-simple 1-0061: using tuner params #1 (digital)
tuner-simple 1-0061: freq = 509.00 (8144), range = 2, config = 0xc6, cb = 0x44
tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=8848 | buf=0x22,0x90,0xc6,0x44


I don't get any output when running either tvtime or 'mplayer tv://'.
Is there some userspace ioctl call that should be made to set the
antenna input for NTSC content?  I also tried setting the atv_input
and dtv_input values.  This didn't seem to change anything.

I started getting lost in the code.  Why does simple_std_setup() check
for V4L2_STD_ATSC and then unconditionally use atv_input?  Maybe that
simple_set_rf_input() is undone at a later time?

Thanks for any info.  Search engines are sparse with information on
tuner_simple parameter information.  Although I expect I need some
code that does ioctls to the tuner modules.

Regards,
Bill Pringlemeir.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
