Return-path: <mchehab@pedra>
MIME-Version: 1.0
In-Reply-To: <000301cbbf21$116c7e60$34457b20$@com>
References: <AANLkTindYgatAuWoVog0dnVKkhUHWO9-MaOC39oAMQgK@mail.gmail.com>
	<20110127092248.18877dx8p3qe0k0o@webmail.hebergement.com>
	<AANLkTimNr=87qc7TKwJu6c3grphfbToD2tpQcpnXHv3w@mail.gmail.com>
	<20110128094254.11965b0zcrkqshhq@webmail.hebergement.com>
	<AANLkTiniyqtmzv7UUC9AiDQYcOb1Sa+aKDbdvB0ioS=M@mail.gmail.com>
	<2dac589a6c232e004c3f29de4252b883.squirrel@sensoray.com>
	<20110128173627.GL25038@beta.zimage.com>
	<000301cbbf21$116c7e60$34457b20$@com>
From: chetan patil <chtpatil@gmail.com>
Date: Sat, 29 Jan 2011 01:00:42 +0530
Message-ID: <AANLkTimqcWk2qXSzOeTk8PjTQCJPn2ELaaEOziBJxEYm@mail.gmail.com>
Subject: Re: DM6446
To: "Charlie X. Liu" <charlie@sensoray.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <linux-media.vger.kernel.org>

Actually i want to capture input from Videon input on board and display it
on to screen.

Wanted to cross compile Xawtv for the board and check whether the Xawtv can
fetch
video from video in and display it.

I'm trying to compile XAWTV 3.95 for arm board.

Setting configure as: ./configure
--prefix=/home/chetanpatil/workdir/filesys/ CC=arm_v5t_le-gcc --host=arm

But while doing make.
I'm getting error as:

console/fbtv.c:339: error: dereferencing pointer to incomplete type
console/fbtv.c:340: error: dereferencing pointer to incomplete type
console/fbtv.c: In function `do_capture':
console/fbtv.c:405: error: dereferencing pointer to incomplete type
console/fbtv.c:406: error: dereferencing pointer to incomplete type
console/fbtv.c:443: error: dereferencing pointer to incomplete type
console/fbtv.c:444: error: dereferencing pointer to incomplete type
console/fbtv.c: In function `main':
console/fbtv.c:755: error: dereferencing pointer to incomplete type
console/fbtv.c:773: error: dereferencing pointer to incomplete type
make: *** [console/fbtv.o] Error 1



Hope you got what my main problem is!!


Thanks.!


On Sat, Jan 29, 2011 at 12:55 AM, Charlie X. Liu <charlie@sensoray.com>wrote:

> 1) Is your driver for ASUS TV tuner right?
> 2) tvtime ( http://tvtime.sourceforge.net/ ) may work for you better, as
> it's designed for TV tuner type of capture cards.
> 3) For V4L/V4L2 compliance test, I like Xawtv better (personally). Though
> it's old, it's mature and stable.
>
> Best regards,
>
> Charlie X. Liu @ Sensoray Co.
>
>
> -----Original Message-----
> From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Phillip Pi
> Sent: Friday, January 28, 2011 9:36 AM
> To: video4linux-list@redhat.com
> Subject: Re: DM6446
>
> Wow, these are old. Did Xawtv project die or something? Is there an
> updated fork or anything? I never got my old ASUS TV tuner to work
> with it. :(
>
>
> On Fri, Jan 28, 2011 at 11:25:48AM -0600, charlie@sensoray.com wrote:
> > It's in:
> >
> > http://rbytes.net/linux/xawtv-review/
> > http://linux.wareseeker.com/Multimedia/xawtv-3.95.zip/322997
> > http://nixbit.com/cat/multimedia/video/xawtv/
> >
> >
> > > Does any one has resources/source of XAWTV ?!
> --
> Quote of the Week: "A coconut shell full of water is a(n) sea/ocean to an
> ant." --Indians
>  /\___/\          Phil./Ant @ http://antfarm.ma.cx (Personal Web Site)
>  / /\ /\ \                 Ant's Quality Foraged Links: http://aqfl.net
> | |o   o| |                 E-mail: philpi@earthlink.net/ant@zimage.com
>   \ _ /              If crediting, then please kindly use Ant nickname
>    ( )                                              and AQFL URL/link.
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Regards,

Chetan Arvind Patil,
+919970018364
<http://sites.google.com/site/chtpatil/>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
