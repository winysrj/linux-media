Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23H4XgU003707
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 12:04:33 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n23H4Aik030645
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 12:04:10 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1591483yxm.81
	for <video4linux-list@redhat.com>; Tue, 03 Mar 2009 09:04:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49AD5FC5.80001@tsukinokage.net>
References: <49AD402C.3050906@tsukinokage.net>
	<286e6b7c0903030655h794a10b3o107b768d3eb67880@mail.gmail.com>
	<26aa882f0903030842h2918c036l28fe6f2d6a6cc79b@mail.gmail.com>
	<49AD5FC5.80001@tsukinokage.net>
Date: Tue, 3 Mar 2009 12:04:10 -0500
Message-ID: <26aa882f0903030904t20e74a75xd8b4bf4b0b340f4c@mail.gmail.com>
From: Jackson Yee <jackson@gotpossum.com>
To: Seann Clark <nombrandue@tsukinokage.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Video On Demand (VOD) server
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

On Tue, Mar 3, 2009 at 11:50 AM, Seann Clark <nombrandue@tsukinokage.net> wrote:
> The exact thing I want to do, is have a central media server, which serves
> up video streams, so I can stream content to computers, MythTV, Ps3, and
> like devices and watch/control playback in a decentralized fashion, where
> one users playback doesn't have a thing to do with a different user/device.
> I don't need recording done on my media system, but pure playback, like what
> Media Tomb seems to offer (Working on that right now and will test it when I
> get home). I have read a lot of places for a 'video server' for lack of
> better words to google for, and 90% of my inital relevant hits pointed to
> VLC. I have seen aspects of VLC that seem to work with it, using RTP and
> RTSP, but I haven't been able to get that to work. In the most simple terms,
> I am looking for a streaming media server (I am looking at MediaTomb as a
> UPnP server that I can use with my Ps3, maybe).
>
> The problem is, everything but my primary media server has a 'small' hard
> drive (I use that term loosely) and most of my content is centralized. Using
> my Audio side as an example, I run my primary 'radio' using MPD as the
> source and Icecast as the streaming system. For different 'channels' and
> ShoutCast tie in, I use LiquidSoap to set up audio streams. This solution
> has worked very well for an Audio side.
>
> I am also looking for something like that on the Video side.

MediaTomb probably would be the best program for that purpose. I
myself have mplayer installed on all of my computers/devices and a web
server on my file server, so watching something at the house is as
simple as typing in

mplayer http://fileserver/that.nice.new.movie.from.netflix.mp4

That file server also outputs to the TV as well, so my wife can use
our wireless keyboard to select something to play.

If you want live streaming, then by all means use RTP/RTSP. For
previously recorded content, there's nothing simpler and more
effective than HTTP or Samba, especially at LAN speeds. For WAN
speeds, I'd look into ffserver where you can create Flash files or 3GP
video for mobile devices.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
