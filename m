Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n161cIlf009861
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 20:38:18 -0500
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n161bvIF023120
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 20:37:58 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Denio Hsiao <deniohsiao@gmail.com>
In-Reply-To: <f83cfa0a0902051729h310f038fi3436edc0807ad88f@mail.gmail.com>
References: <147fc4b90902050823i15baa12fjb3ac7493bc473e0@mail.gmail.com>
	<f83cfa0a0902051729h310f038fi3436edc0807ad88f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 02:38:50 +0100
Message-Id: <1233884330.2689.14.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: tv recording/preview software for saa7130 analogue PAL tv.
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

Am Freitag, den 06.02.2009, 09:29 +0800 schrieb Denio Hsiao:
> Hi, Richard,
> How about Tvtime?
> 
> http://tvtime.sourceforge.net/

tvtime is a great app, but never did record anything.

Cheers,
Hermann

> 
> Denio
> 
> 2009/2/6 richard cinema <richard.cinema@gmail.com>:
> > debian, latest sid update, kernel 2.6.28, saa713X analogue tv card. amd x2
> > 3600+8500GT 512M+3G RAM
> >
> > i should mention here, my tv card+pc can do tv recording to mpg4 in PAL SD
> > size very well in windows, so there is no
> > hardware limition, i think.
> >
> > so, for recording tv in linux, i have tried these software:
> >
> > 1.xawtv: can record , have audiobuffer errors when selecting some modern
> > codecs, but the big problem is there is no codec bitrate settings.
> >
> > 2.mencoder: picture is ok, no sync issues when recording in SD resolution,
> > but can't preview at the same time.
> >
> >                   2.1.  mencoder xxx...xxx -o >( tee test.avi | mplayer -)
> > not work, it just sit there, no output, no recording.
> >
> > 3. transcode: sometimes works, sometimes not, no preview funtion, haven't
> > tried the tee trick.
> >
> > 4. pvr: old/new version not work,  lots of options are grey out in the
> > setting window( in root/user mode).
> >
> > 5. mythtv: what i want is just a simple recording software with record
> > monitor function, not a big MCE like monster. have tried to installed but
> > the mysql setup is really a mess to me.
> >
> > 6.cupid: this one looks promising, but is stopped development now. require
> > old gstream0.8, i don't know how to make it use the gstream0.10, anyone
> > knows?
> >
> > 7. chease: maybe the same programmer as 6, this one can record, but the
> > final file is out of sync, picture is like slideshow, also no bitrate/codec
> > settings.
> >
> > 8+9+10=vlc+ffmpeg+gst-launch? not confidient about them, will continuing my
> > trial and error.
> >
> > besides of above 10, are there other softwares can finish this task ?


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
