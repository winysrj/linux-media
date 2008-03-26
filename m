Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q2ErsM006626
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:53 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q2EMZQ006657
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 22:14:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 2302833CC6
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:14:22 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XVidT7qj4n7t for <video4linux-list@redhat.com>;
	Wed, 26 Mar 2008 03:14:13 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1206497254@bluegene.athome>
Date: Wed, 26 Mar 2008 03:07:34 +0100
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
Subject: [PATCH 0 of 3] cx88: fix oops on rmmod and implement stereo
	detection
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

Here are the updated versions of my cx88 patches (I only sent the old versions
to the linux-dvb list, and they did not draw too much attention there) maybe
better luck here...

The first is a simple fix for a possible Oops on the removal of cx88xx module
caused by the IR worker. This patch is independent from the other two.

The second and the third patches are enhachments of the cx88 audio code, I
tried to implement the detection of stereo TV channels for A2 mode. I had no
idea how to detect it, and falling back to EN_A2_AUTO_STEREO instead of
EN_A2_FORCE_MONO1 did not help either. (The card changed the audio mode
periodically on both mono and stereo channels) Forcing STEREO mode also did not
help, because it resulted a loud static noise on mono tv channels.

Testing proved that AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers change
randomly if and only if the second audio channel is missing, so if these
registers are constant (Usually 0x0000 and 0x01), we can assume that the tv
channel has two audio channels, so we can use STEREO mode. This method seems a
bit ugly, but nicam detection works the same way, so to avoid further
msleep()-ing, the A2 stereo detection code is in the nicam detection function.

By the way, the audio thread in the cx88 code is totally useless, in fact, it
occaisonally sets the audio to MONO after starting a TV application, so i think
it should be removed. My patch does NOT fix cx88_get_stereo, and even if it
would, the audio thread would not work as expected, because
core->audiomode_current is not set in cx88_set_tvaudio, and AUTO stereo modes
(EN_BTSC_AUTO_STEREO, EN_NICAM_AUTO_STEREO) would also cause problems, the
autodetected audio mode should be set to core->audiomode_current to make it
work.

Who is now the cx88 maintainer? I should send him a copy of the patches...


Regards,

 Marton Balint


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
