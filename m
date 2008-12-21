Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBL34c6D026978
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 22:04:38 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBL34MAj029753
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 22:04:22 -0500
From: Andy Walls <awalls@radix.net>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
In-Reply-To: <e5df86c90812201719y3a633dfdg2f836e6b7cd1861f@mail.gmail.com>
References: <8ffeff430812010520v5e37c21bu784798e3a7482093@mail.gmail.com>
	<64cb1ad0812011321v3406f2c3va86d536f4e0c4d08@mail.gmail.com>
	<8ffeff430812011353k253e8a25tf09e231d4f484eba@mail.gmail.com>
	<1228177537.3117.14.camel@palomino.walls.org>
	<8ffeff430812020707g458688f2g5390016fa09a995f@mail.gmail.com>
	<COL107-W456D1FD3E2739520ED2875CE000@phx.gbl>
	<8ffeff430812201215y30d45065idd2f26d88554bd75@mail.gmail.com>
	<1229812414.3109.5.camel@palomino.walls.org>
	<8ffeff430812201646p3ed218e1xc1b9c7c807fe0751@mail.gmail.com>
	<e5df86c90812201719y3a633dfdg2f836e6b7cd1861f@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 22:02:28 -0500
Message-Id: <1229828548.3109.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: [ivtv-users] hvr-1600 update
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

On Sat, 2008-12-20 at 19:19 -0600, Mark Jenks wrote:
> On Sat, Dec 20, 2008 at 6:46 PM, Al McIntosh <al@allanmcintosh.com>
> wrote:
>         Oh, wow! Okay, I was wondering what kind of testing or data
>         would be
>         helpful but sounds as though it's all covered. Impressive
>         work  Andy.
>         
>         Al

Al,

Don't thank me, thank Mike and Jeff for the reporting and debugging.
The "hard" part for me was building a spreadsheet to compute the correct
PLL parameter values - that was pretty mechanical.

>         > Jeff Campbell and Mike Bradley have been doing extensive (!)
>         > investigation and pointed out problem areas too me.  Due to
>         their
>         > prompting and what they've found, I've got some fixes in
>         progress this
>         > weekend that should be good enough for the average user.  It
>         should make
>         > SVideo and CVBS watchable with buffering.
>         >
>         > The problems are mostly audio and clock related.  Maybe by
>         Sunday night
>         > I'll have something checked into my v4l-dvb repo.
>         >
>         > Regards,
>         > Andy
>         >
>         >
>         >> Al
> 
> Hey Al!
> 
> I was working on setting up a hvr-1600 today with svideo/audio
> capturing to mpeg for mythv from a SA4250HD.  Everything went great
> except for the video skipping issue that I could not get rid of.  I
> was very happy to find this thread and I am extremely glad to see that
> a fix might be right around the corner for this.
> 
> I would of picked up a pvr-250, if they were easier to find, but I
> heard that this card would work. (it does, except for that one
> glitch).
> 
> I am awaiting directions to try out your patch when it shows up.  If
> you need me to run a test on it, it might take me a few days, but I
> can get it for you.

Mark and Al,

If you really want to test something, look in

http://linuxtv.org/hg/~awalls/v4l-dvb

the two latest changes should give you something decent for SVideo and
CVBS.  The first analog capture after modprobe will be goofy as always.
(Still working on that one...)

If you set the stream type to TS instead of the default PS, you may be
able to run with unbuffered playback  Although you may want to set the
enc_mpg_bufsize=16 parameter, as the default of a 32 kB individual
buffer sizes may seem a little jumpy if played back unbuffered.

This might be the only changes I get done this weekend, due to holiday
plans and obligations.

Regards,
Andy

> FYI, it's running a M3N78 Pro motherboard, quadcore,4gb of ram w/ HDMI
> video & audio out.
> 
> -Mark 



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
