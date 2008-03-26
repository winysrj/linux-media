Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QKdsbc023740
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 16:39:54 -0400
Received: from mailout05.sul.t-online.de (mailout05.sul.t-online.de
	[194.25.134.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QKdgpH011473
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 16:39:42 -0400
Message-ID: <001a01c88f81$80aec670$6402a8c0@desktop>
From: "Torsten Seeboth" <Torsten.Seeboth@t-online.de>
To: "Marton Balint" <cus@fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
Date: Wed, 26 Mar 2008 21:39:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement
	stereodetection
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

> The second and the third patches are enhachments of the cx88 audio code, I
> tried to implement the detection of stereo TV channels for A2 mode. I had
> no idea how to detect it, and falling back to EN_A2_AUTO_STEREO instead of
> EN_A2_FORCE_MONO1 did not help either. (The card changed the audio mode
> periodically on both mono and stereo channels) Forcing STEREO mode also
> did not help, because it resulted a loud static noise on mono tv channels.

It's a bug of the audio dsp part.

> Testing proved that AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers
> change randomly if and only if the second audio channel is missing, so if
> these registers are constant (Usually 0x0000 and 0x01), we can assume that
> the
> tv channel has two audio channels, so we can use STEREO mode. This method
> seems a bit ugly, but nicam detection works the same way, so to avoid
> further msleep()-ing, the A2 stereo detection code is in the nicam
> detection
> function.

No, the Nicam_Status_Regs contain only and only if Nicam is forced before.
Your patch _can_ work for B/G, but I don't think so for others, like D/K
etc.

> By the way, the audio thread in the cx88 code is totally useless, in fact,
> it occaisonally sets the audio to MONO after starting a TV application, so
> i think it should be removed. My patch does NOT fix cx88_get_stereo, and
> even if it would, the audio thread would not work as expected, because
> core->audiomode_current is not set in cx88_set_tvaudio, and AUTO stereo
> modes (EN_BTSC_AUTO_STEREO, EN_NICAM_AUTO_STEREO) would also cause
> problems, the autodetected audio mode should be set to
> core->audiomode_current
> to make it work.

Sorry, not an native english speaker here.

If it were easy it would already be done. ;)

I am the one who did that in cx88-tvaudio.c. With Mauro's and many others
help I have moved this part from DScaler project where I am from into this
file.

Still not finished as you can see in comments. There is much more to do if
you want to get safe mono/stereo or a2/nicam/btsc detection.

I did many things trying to understand on how audio things are going on on
this chip. Together witht some others from this list I have learned from m$
driver how it really works by using de-asm/debuggers tools. To make a long
story short: The only way is to take some audio samples into memory, compare
it to tables and do some calculations depands on video-mode.

Torsten

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
