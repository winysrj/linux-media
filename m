Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2Q73CMQ017122
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:03:12 -0400
Received: from sparc.fpv.umb.sk (sparc.fpv.umb.sk [194.160.44.70])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2Q72cnb025971
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 03:02:40 -0400
Message-ID: <47E9F4F4.2050503@datagate.sk>
Date: Wed, 26 Mar 2008 08:02:12 +0100
From: =?UTF-8?B?UGV0ZXIgVsOhZ25lcg==?= <peter.v@datagate.sk>
MIME-Version: 1.0
To: Marton Balint <cus@fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
In-Reply-To: <patchbomb.1206497254@bluegene.athome>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement
	stereo	detection
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
I am interested in ability to get stereo channels working with my avertv 
studio 303 which is a cx88 based.
I am not a developer nor I understand this stuff very well but anyway 
I'd like to try this out if it may help. With current v4l builds I am 
getting mono sound each time tv app is started (I am using mplayer btw).

So here are a few questions hopefully it's not a problem to ask them here:
1) are these patches already included in some repository? If not how 
should I go about applying them? Is the diff command the right way? What 
branch are they against?

2) The comments below indicates audio functionality for cx88 is not 
working as it should. So shal I be able to get stereo sound after 
applying these patches?

3) are there any tunner settings required in order to get stereo sound? 
or perhaps settings for some other modules?


Thanks


Peter


Marton Balint  wrote / napísal(a):
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
>   Marton Balint
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
