Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32K7PYP022298
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 16:07:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32K7Dgd004945
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 16:07:13 -0400
Date: Wed, 2 Apr 2008 17:06:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080402170629.30b81556@gaivota>
In-Reply-To: <20080402185423.GA7281@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
	<20080331153555.6adca09b@gaivota>
	<20080331192618.GA21600@plankton.ifup.org>
	<20080331183136.3596bfb3@gaivota>
	<20080401031130.GA18963@plankton.ifup.org>
	<20080401174919.4bdc3c54@gaivota>
	<20080402185423.GA7281@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 9] videobuf fixes
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

> On saa7134 I can't start more than one application streaming at once.
> The other application gets -EBUSY when it tries to do streamon.

The resource lock won't let you open two applications trying to read using the
same method.

> I tried with mplayer and fswebcam and combinations of them.
> 
> I did get fswebcam using read() and mplayer using mmap() and it worked
> fine, although each application was only getting half the frames.

Weird. You should be able to get the entire frame on each.

> How do you use ffmpeg/mencoder with v4l2 devices?  I Googled around but
> couldn't find anything that worked.

There's a small script at V4L/DVB tree, at:

v4l2-apps/util/v4l_rec.pl

It calls mencoder. Also there is inside a commented is a line for it usage with ffmpeg.

The syntax is about the same as when you activate record inside xawtv or xdtv.
 
> Updated with Jon's comments too and I just removed the copyright updates
> for vivi- too much trouble: http://ifup.org/hg/v4l-dvb

Ok, I've merged it at master.

People,

Please test.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
