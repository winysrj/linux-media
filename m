Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56JQx13020786
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 15:26:59 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56JQl9x005606
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 15:26:48 -0400
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 58A583F6231
	for <video4linux-list@redhat.com>;
	Fri,  6 Jun 2008 21:26:47 +0200 (CEST)
Received: from sidero.numenor.net (lac49-1-82-245-43-74.fbx.proxad.net
	[82.245.43.74])
	by smtp5-g19.free.fr (Postfix) with ESMTP id C41053F62FA
	for <video4linux-list@redhat.com>;
	Fri,  6 Jun 2008 21:26:46 +0200 (CEST)
From: stef <stef.dev@free.fr>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Fri, 6 Jun 2008 21:25:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806062125.54034.stef.dev@free.fr>
Subject: PCTV 310c again
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

	while trying to have my PCTV 310c working for the SECAM-L analog channels I 
receive, I noticed that the module is allways trying to load MTS firmwares 
(see log below). But extract_xc3028.pl doesn't create MTS firmwares for 
SECAM-L. So no firmware is found and analog doesn't work.
	By adding the 310c id next to the CX88_BOARD_PROLINK_PV_8000GT in the switch 
within cx88_setup_xc3028() to force to non-mts firmwares, I got analog 
SECAM-L working. I know this isn't the right fix, and I hope that someone 
will come with a better solution.

Regards,
	Stef

dmesg of failed firmware load:
cx88[0]/0: AUD_STATUS: 0x32 [mono/no pilot] ctl=A2_FORCE_MONO1
xc2028 6-0061: load_firmware called
xc2028 6-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 
0000000000000000.
xc2028 6-0061: Found firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.
xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: setting GPIO to TV!
xc2028 6-0061: Load init1 firmware, if exists
xc2028 6-0061: load_firmware called
xc2028 6-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 
0000000000000000.
xc2028 6-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 
0000000000000000.
xc2028 6-0061: load_firmware called
xc2028 6-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 
0000000000000000.
xc2028 6-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 
0000000000000000.
xc2028 6-0061: load_firmware called
xc2028 6-0061: seek_firmware called, want type=F8MHZ MTS (6), id 
0000000000400000.
xc2028 6-0061: Can't find firmware for type=MTS (4), id 0000000000400000.
xc2028 6-0061: load_firmware called
xc2028 6-0061: seek_firmware called, want type=MTS (4), id 0000000000400000.
xc2028 6-0061: Can't find firmware for type=MTS (4), id 0000000000400000.
cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)
cx88[0]/0: set_audio_standard_NICAM SECAM-L NICAM (status: devel)
cx88[0]/0: start nicam autodetect.
cx88[0]/0: nicam is not detected.
cx88[0]/0: set_audio_standard_A2 AM-L (status: devel)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
