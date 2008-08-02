Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72FItmT025526
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 11:18:55 -0400
Received: from n6.bullet.ukl.yahoo.com (n6.bullet.ukl.yahoo.com
	[217.146.182.183])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72FHreo003678
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 11:17:53 -0400
From: Lars Oliver Hansen <lolh@ymail.com>
To: video4linux-list@redhat.com
Date: Sat, 02 Aug 2008 17:17:43 +0200
Message-Id: <1217690263.6605.25.camel@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Subject: Re: saa7134-alsa  appears to be broken
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

I experience the same problem: the sound part of the saa7134 driver
doesn't load.

Ususally I get such symbol errors with MadWiFis snapshot driver after
every application installation which configured some kernel stuff. I
then unload the MadWiFi driver and do a clean install according to their
description.

I'm new to Linux and thus don't know the options I have for and how to
make a clean install in general. Hermann suggested to do a make
rminstall in his response. Could anyone help me here as how to do this
with the saa7134 experimental driver (it's cloning the relevant
Mercurial repository) or what else I could try?

As I installed the sound driver after make-ing the TV card driver I
guess an update of some dependancies may be necessary. I don't know
anything about the relations there at all. Would someone shed some light
on this? Thanks for taking time for this issue and for a possible answer
in advance!

Kind Regards,

Lars


P.s.: here's the dmesg output again:

[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_tvaudio_setmute
[    0.000000] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa_dsp_writel
[    0.000000] saa7134_alsa: Unknown symbol saa_dsp_writel
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_alloc
[    0.000000] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_build
[    0.000000] saa7134_alsa: Unknown symbol saa7134_pgtable_build
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_pgtable_free
[    0.000000] saa7134_alsa: Unknown symbol saa7134_pgtable_free
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_dmasound_init
[    0.000000] saa7134_alsa: Unknown symbol saa7134_dmasound_init
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_dmasound_exit
[    0.000000] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
[    0.000000] saa7134_alsa: disagrees about version of symbol
saa7134_set_dmabits
[    0.000000] saa7134_alsa: Unknown symbol saa7134_set_dmabits

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
