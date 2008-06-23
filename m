Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NM9u9q006500
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:09:56 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NM9S8q024964
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:09:31 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "Diego V. Martinez" <dvm2810@yahoo.com.ar>
In-Reply-To: <891346.15759.qm@web51507.mail.re2.yahoo.com>
References: <891346.15759.qm@web51507.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 00:07:21 +0200
Message-Id: <1214258841.6208.16.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [linux-dvb] ASUS My-Cinema remote patch
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

Hi Diego,

Am Montag, den 23.06.2008, 08:52 -0700 schrieb Diego V. Martinez:
> Hi Hermann,
> 
> I've the Asus MyCinema P7131 Analog TV Card (the one that has the green box in http://www.bttv-gallery.de) and I after I applied the patch "saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch" the IR control starts working but the S-Video input still fails (black screen on tvtime as before applying the patch).
> 
> My linux distribution is Fedora Core 6.
> 
> My kernel version is 2.6.25.5.
> 
> I use "tvtime" to make the tests.
> 
> Do you know what could be wrong?
> 

I'm getting slightly confusing reports on this modest attempt to improve
it for that card.

Did you apply the patch to 2.6.25.5 or recent mercurial v4l-dvb?
Only since yesterday, after an improvement for enum standard by Hans
after the ioctl2 conversion, all kind of subnorms are selectable again,
but this does not necessarily reflect what a driver is internally
capable to do.

To come back to the remote, do you mean the remote is working with that
patch after auto detection or do you force the new card number?

For s-video, which kind of s-video you try to use?

IIRC, PAL_N, which you should have on FreeToAir broadcasts, is still not
supported, but PAL_Nc on cable is known to work since long.

If you force card=78, still no s-video?

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
