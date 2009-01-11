Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BC8q1c022550
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 07:08:52 -0500
Received: from mail3.sea5.speakeasy.net (mail3.sea5.speakeasy.net
	[69.17.117.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0BC8XJI004146
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 07:08:33 -0500
Date: Sun, 11 Jan 2009 04:08:31 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jose Diaz <xt4mhz@gmail.com>
In-Reply-To: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0901110356290.1626@shell2.speakeasy.net>
References: <b101ebb80901081906i5343bf1dl21020c2e89fdfdf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Help with Osprey 230 cards - no sound.
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

On Fri, 9 Jan 2009, Jose Diaz wrote:
> I need help using Osprey 230 cards. I did a huge research but not success.

You might try the driver at http://linuxtv.org/hg/~tap/osprey

I have not updated it for 15 months so it will probably not work with a
2.6.28 kernel.  Probably better off with something from around 2.6.25.

Some Osprey cards support multiple audio sampling rates via an extern ADC
and some cards also have a volume control chip.  I know these features are
supported for the 440, but I'm not sure what features the 230 has and what
is supported on that card.

> The problem is that I cant mix the video and the audio from the Osprey 230
> card because the audio is not recorded. I can stream the video but not with

Try recording the audio with arecord.  Don't worry about vlc until you have
that working.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
