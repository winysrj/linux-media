Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23GnlZs023827
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:49:47 -0500
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n23GnWOU021579
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:49:32 -0500
Received: by gxk19 with SMTP id 19so5587936gxk.3
	for <video4linux-list@redhat.com>; Tue, 03 Mar 2009 08:49:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1236097442.5650.86.camel@smunday.skyangel.local>
References: <49AD402C.3050906@tsukinokage.net>
	<1236097442.5650.86.camel@smunday.skyangel.local>
Date: Tue, 3 Mar 2009 11:49:31 -0500
Message-ID: <26aa882f0903030849q66f226f9oa53707d40b379ea9@mail.gmail.com>
From: Jackson Yee <jackson@gotpossum.com>
To: Sherrod Munday <sherrod.munday@skyangel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

On Tue, Mar 3, 2009 at 11:24 AM, Sherrod Munday
<sherrod.munday@skyangel.com> > Along this line, I picked up a few
set-top boxes from Circuit City
> (going out of business here in the States), and I've been trying to get
> them working as a VOD client.
>
> They're labeled "MediaEdge STB-3", manufactured by Canopus, and they are
> running (as far as I can tell) a RedHat-based fully open OS (root
> password provided).  They have a Sigma Designs EM8621L-F video chip
> onboard, and the CPU is an AMCC PowerPC PPC440EP chip.  The Circuit City
> models have DVI-D, component, and composite output (other models also
> include S-Video), and they solely use IP input.  There's no local
> onboard storage, though there is smbclient support; I also wonder about
> whether it's possible to enable the PowerPC chip's USB support with
> simple addition of a header on the MoBo (there are various lands and
> pads available for header-style connections).
>
> According to the manufacturer (including from some tech specs they
> release) the STB-3 supports MPEG 2 SD and HD video and audio playback
> (among other formats), and they use RTSP for the delivery.
>
> Normally, Canopus sells an expensive proprietary Microsoft Windows
> software-based server, and they also manufacture a hardware real-time
> encoder (﻿model LEB-60; video in & IP-delivered MPEG 1/2/4 out), so I'm
> somewhat confident that it's likely possible to get this STB to play
> VODs and/or live streams from open-source VOD servers or real-time
> encoders (a la VLC capture/stream mode or similar).
>
> I can easily create a normal web page (with examples from Canopus) that
> the STB will display, and I can use the remote to browse and select
> content, but so far I can't get the STB to actually play the content.
>
> Anyone interested in poking around inside of a unit to get VOD and
> streaming working?  I could provide remote telnet/ssh access to the box
> (it has built-in servers) or ship one if need be...
>
> I'm especially interested in this because Circuit City is disposing of
> all of their client units so I expect there will be plenty available for
> little money, but they won't sell the server software because it's on a
> leased server that's going back to the vendor.
>
> By the way, these STB-3 models are not designed to be consumer models;
> they are actually sold specifically configured for each customer that
> buys in bulk (hence the Circuit City models missing the S-video
> support).  That said, it seems the platform is stable enough to reliably
> use either in a business environment or as a personal/home VOD client.

That sounds very interesting, Sherrod. I've been thinking of a similar
project myself, except I plan on using either a Beagleboard or Nvidia
ION platform to output to a HDMI connection along the lines of Apple
TV or the Roku Box from Netflix. Unfortunately, the number of projects
in my head and the amount of time that I have to actually do the
projects are not in unison. Please let me know how your project goes.


Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
