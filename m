Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HLaBXS022989
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 17:36:11 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3HLZwAN017482
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 17:35:59 -0400
Date: Thu, 17 Apr 2008 23:35:51 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: video4linux-list@redhat.com
In-Reply-To: <patchbomb.1206497254@bluegene.athome>
Message-ID: <Pine.LNX.4.64.0804171323470.1117@cinke.fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement stereo
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

Hi!

Mauro, have you come to a decision about patch 2 and patch 3?

Unfotunately I can't test other sound systems than BG, so it is
still unknown if the detection also works on other systems, or not. I 
only confirmed one thing with the help of an old video casette 
recorder: mono DK sound is not misdetected as stereo.

Another question is the audio thread. Like I explained in my original 
post, it does more harm than good, because it occaisonally sets the audio 
to mono after starting a TV application. Altough my patches are not 
dependant on the removal of the thread, I think it should be removed.
What would be the correct way to do that? Delete the relevant lines, or 
just #ifdef them out?

Regards,
  Marton Balint


> Here are the updated versions of my cx88 patches (I only sent the old versions
> to the linux-dvb list, and they did not draw too much attention there) maybe
> better luck here...
> 
> The first is a simple fix for a possible Oops on the removal of cx88xx module
> caused by the IR worker. This patch is independent from the other two.
> 
> The second and the third patches are enhachments of the cx88 audio code, I
> tried to implement the detection of stereo TV channels for A2 mode. I had no
> idea how to detect it, and falling back to EN_A2_AUTO_STEREO instead of
> EN_A2_FORCE_MONO1 did not help either. (The card changed the audio mode
> periodically on both mono and stereo channels) Forcing STEREO mode also did not
> help, because it resulted a loud static noise on mono tv channels.
> 
> Testing proved that AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers change
> randomly if and only if the second audio channel is missing, so if these
> registers are constant (Usually 0x0000 and 0x01), we can assume that the tv
> channel has two audio channels, so we can use STEREO mode. This method seems a
> bit ugly, but nicam detection works the same way, so to avoid further
> msleep()-ing, the A2 stereo detection code is in the nicam detection function.
> 
> By the way, the audio thread in the cx88 code is totally useless, in fact, it
> occaisonally sets the audio to MONO after starting a TV application, so i think
> it should be removed. My patch does NOT fix cx88_get_stereo, and even if it
> would, the audio thread would not work as expected, because
> core->audiomode_current is not set in cx88_set_tvaudio, and AUTO stereo modes
> (EN_BTSC_AUTO_STEREO, EN_NICAM_AUTO_STEREO) would also cause problems, the
> autodetected audio mode should be set to core->audiomode_current to make it
> work.
> 
> Who is now the cx88 maintainer? I should send him a copy of the patches...
> 
> 
> Regards,
> 
>  Marton Balint
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
