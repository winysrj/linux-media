Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7BKo4pJ011323
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:50:04 -0400
Received: from smtp.nexicom.net (dell.nexicom.net [216.168.96.13])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7BKnquW031967
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:49:53 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-146.nexicom.net
	[98.124.36.146])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id o7BKnplC008035
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:49:52 -0400
Received: from [127.0.0.1] (unknown [192.168.1.1])
	by mail.lockie.ca (Postfix) with ESMTP id 098FA98303
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 16:49:51 -0400 (EDT)
Message-ID: <4C630CEE.7000200@lockie.ca>
Date: Wed, 11 Aug 2010 16:49:50 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
Subject: upgraded software and audio stopped working
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

 It could just be coincidental that the audio stopped working after I
upgrade software.
I didn't try it right after I upgraded the system software so it could
be the hardware just failed.
I can still tune channels, I just don't get audio.

bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
bttv0: Hauppauge eeprom indicates model#44981
bttv0: tuner type=50
bttv0: audio absent, no audio device found!
tuner 2-0061: chip found @ 0xc2 (bt878 #0 [sw])

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
