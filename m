Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADBbO8a000937
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 06:37:24 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADBbC7j025300
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 06:37:12 -0500
Received: from smtp6-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 18F271977B
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:37:12 +0100 (CET)
Received: from [192.168.0.13] (lns-bzn-39-82-255-26-50.adsl.proxad.net
	[82.255.26.50])
	by smtp6-g19.free.fr (Postfix) with ESMTP id D7CEC19779
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:37:08 +0100 (CET)
From: Jean-Francois Moine <moinejf@free.fr>
To: Video 4 Linux <video4linux-list@redhat.com>
In-Reply-To: <20081112191736.bcbc1e37.ospite@studenti.unina.it>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 13 Nov 2008 12:33:58 +0100
Message-Id: <1226576038.2040.42.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Wed, 2008-11-12 at 19:17 +0100, Antonio Ospite wrote:
> Well, with my hacks to gspca.c the ov534 driver has become really
> trivial. The source has shrunk from 33K to 13K. But these hacks could
> not be accepted though :) But, yes, the opinion on gspca is positive.

Hello Antonio,

Thank you for your opinion.

I looked again at your subdriver, and it seems good to me. So forget
about mine which is too buggy.

About your hacks to gspca, there are good and bad ideas. The good idea
is to have the bulk_nurbs parameter. The bad idea is to force it to one
when no set. To preserve the compatibility, the bulk_nurbs may be set to
some value for webcams which accept permanent bulk read, the submit
being done by gspca. For the other webcams, as those in finepix, a null
bulk_nurbs will indicate that the bulk read requests are done by the
subdriver. Is it OK for you?

Also, I saw a little problem in your subdriver: in pkt_scan, you use a
static variable (count). This does not work with many active webcams and
also after stop / restart streaming. Instead, you may know the current
byte count using the frame values data and data_end.

> The improvement that I always dream to see is to have bridge and
> sensor
> drivers split, so sensor drivers can be shared, a-la soc_camera, I
> mean.

There were many threads about this subject, but I could not find many
common values for a same sensor with different bridges in gspca...

> Bringing that idea to the extreme, one could think even to share
> sensor
> drivers with the soc_camera framework itself, but I only have this
> abstract suggestion, no idea at all about how it can be done, sorry.
> Could it be a GSoC project for next summer?

Why not?

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
