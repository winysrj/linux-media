Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFLqSKe002489
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 16:52:28 -0500
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFLqI82000894
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 16:52:19 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Andr=C3=A1s_L=C5=91rincz?= <andras.lorincz@gmail.com>
In-Reply-To: <a21d779b0812131517r2d53760dvbb583805f5e4959@mail.gmail.com>
References: <a21d779b0812131517r2d53760dvbb583805f5e4959@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Dec 2008 22:47:05 +0100
Message-Id: <1229377625.3844.20.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Ragged, rifted sound with with tv card
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

Am Sonntag, den 14.12.2008, 01:17 +0200 schrieb András Lőrincz:
> Hello,
> 
> I'm having a genius videwonder pro tv tuner which has 3 chips on it:
> saa7135HL, TDA8290 and TDA8275. It is recognized as a lifeview tv (you
> can see it in the dmesg attached) and it is usable with the saa7134
> driver (I have attached the lsmod output too). It has something
> annoying with the audio, pretty often it has a ragged sound, that is,
> the sound is interrupted for let's say half a second a few times
> repeatedly, then the sound is good for a few seconds then again those
> sound interruption. I've enabled ts_debug and audio_debug for the
> saa7134 module and I could notice that the driver does a tvaudio
> thread scan pretty often and at those moments is happening the
> mentioned behavior, something like this can be seen in dmesg:
> 
> saa7133[0]/audio: scanning: B/G D/K I
> saa7133[0]/audio: tvaudio thread scan start [425]
> saa7133[0]/audio: scanning: B/G D/K I
> saa7133[0]/audio: tvaudio thread scan start [426]
> saa7133[0]/audio: scanning: B/G D/K I
> saa7133[0]/audio: tvaudio thread scan start [427]
> saa7133[0]/audio: scanning: B/G D/K I
> saa7133[0]/audio: tvaudio thread status: 0x1002a4 [B/G A2,stereo]
> saa7133[0]/audio: detailed status:  A2/EIAJ pilot tone ## A2/EIAJ
> stereo ########### init done
> 
> a burst of tvaudio scan starts and disturbs the audio. I'm using
> tvtime as the viewer application but tried with mplayer also and the
> same happens. Is there a solution to this, maybe with the help of some
> module parameters?

about the first generation of the tda8275 is said it needs a strong
signal. Also according to your logs it takes often very long after
losing lock to find the pilot tone again.

Either you have a very weak signal and/or bursts of interferences
disturb the tuner. On a tuned channel with reasonable signal quality it
should normally never happen that the audio kernelthread starts.

Problems with the voltage supply, either caused by the PSU or even by
external bursts can cause such too.

In general it is not a driver problem and such reports go close to zero.

>From the saa7134 module options you can try on the saa7133/35/31e family
audio_ddep=0x04 for PAL_BGH and dual FM.

This might give you a quicker lock after the signal loss, but can't cure
other underlying problems.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
