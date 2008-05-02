Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m420slhN026147
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 20:54:47 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m420sFp4000743
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 20:54:15 -0400
From: Andy Walls <awalls@radix.net>
To: G Maus <mausmang@yahoo.com>
In-Reply-To: <470634.2977.qm@web55009.mail.re4.yahoo.com>
References: <470634.2977.qm@web55009.mail.re4.yahoo.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:50:16 -0400
Message-Id: <1209689416.3262.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-users@ivtvdriver.org
Subject: Re: cx18 HVR-1800
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

On Thu, 2008-05-01 at 17:19 -0700, G Maus wrote:
> I noticed that http://linuxtv.org/hg/~gliakhovetski/v4l-dvb was merged
> into v4l-dvb a couple of days ago.  I assume this means that this
> project is no longer in development and is now in the 'regular'
> sources?

Yup.  It's getting there.


In this message:

http://ivtvdriver.org/pipermail/ivtv-users/2008-May/008122.html

Sander Sweers recommends using:

http://linuxtv.org/hg/v4l-dvb/


You can also try:

http://linuxtv.org/hg/~hverkuil/v4l-dvb/

as Hans' repository is where the bleeding edge cx18 stuff should be.


> Since the project was merged, I am no longer able to setup my
> HVR-1800.  After compiling the drivers I 'modprobe cx18' which creates
> video0, video24 and video34. I have no adapters under /dev/dvb. dmesg
> tells me that "DVB & VBI are not yet supported".

Yeah, the mxl500x frontend module isn't quite ready to be merged into
the kernel yet, so you'll notice some "#ifdef HAVE_MXL500X" blocks in
the cx18-dvb.c file commenting things out.

There is ongoing work to get the mxl500x module merged into the kernel
as well.


>   I also have no audio in the mpeg stream on Video0.

I've noticed a bug that happens on the first analog capture after the
modprobe: sound with lost frames (resulting in choppy/fast playback) or
no sound initially with late onset of sound (resulting in fast/choppy
playback).

Stop the capture and restart the capture.  Things are fine for me after
that.

In my limited testing, the bug seems to be caused by the load and
re-load of firmware on modprobe.  Steve did this to overcome some
silicon bug he knew of.  This firmware reload does make captures go
smoother in my experience - except for the first one of course.


> Have the installation instructions changed with this move to v4l-dvb?
> Should I be looking elsewhere for the driver? I've Googled and come up
> empty.

Sander modified the wiki page already:

http://www.ivtvdriver.org/index.php/Cx18
  

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
