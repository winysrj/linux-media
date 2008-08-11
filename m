Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BH88Y5024372
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 13:08:08 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7BH7Z7S018364
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 13:07:36 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Wieslaw Kierbedz <w.kier@farba.eu.org>
In-Reply-To: <48A03B42.3080301@farba.eu.org>
References: <48A03B42.3080301@farba.eu.org>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 19:00:12 +0200
Message-Id: <1218474012.2676.38.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Double thread. DVB H.264. PCTV 7010ix.
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

Am Montag, den 11.08.2008, 15:14 +0200 schrieb Wieslaw Kierbedz:
> Helo.
> 
> First is the question.
> Does anybody have any experiences about decoding DVB-T H.264 streams 
> with v4l?
> Does it works? How?

I'm no expert for all the details, but use it nearly everyday for HDTV
1080i recording on the saa7134 driver with DVB-S and tda10086/tda8263.

Also it has a very long tradition with ffmpeg and mp4live (mpeg4ip) for
example for video network streaming.

Links in all directions as usual are here.
http://en.wikipedia.org/wiki/H.264/MPEG-4_AVC

Mike Krufky just is asking for inclusion of a driver for Chinese HDTV
and it is great to see an Open Source driver for it.

Main x264 codec development is visible on the vlc/x264 project and at
ffmpeg devel.

Some known applications dealing with it are ffmpeg/ffplay, vlc, mplayer,
xine, xine/kaffeine, vdr, mythtv and others.

Most active users are on the linux-dvb ML at linuxtv.org using Manu
Abraham's multiproto DVB-S2 out of tree repository.

> Second is quasi offer.
> I've got Pinnacle PCTV 7010ix.
> I fount, that some skeleton driver for saa7162 already exist.
> If some developers need tests or user cooperation - welcome.
> Regards

This one and next.

http://linuxtv.org/pipermail/linux-dvb/2008-July/027454.html

It seems to be more tricky than initially expected.

Cheers,
Hermann

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
