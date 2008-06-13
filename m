Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5D8BeFb017899
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 04:12:02 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5D83922029410
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 04:03:14 -0400
Received: by ik-out-1112.google.com with SMTP id c30so3269841ika.3
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 01:02:59 -0700 (PDT)
Date: Fri, 13 Jun 2008 18:05:16 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: gert.vervoort@hccnet.nl
Message-ID: <20080613180516.211a27a9@glory.loctelecom.ru>
In-Reply-To: <2a93ca18e1d9bc5726b7f1fd60da1852.squirrel@webmail.hccnet.nl>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
	<20080612194426.0e33d92c@glory.loctelecom.ru>
	<2a93ca18e1d9bc5726b7f1fd60da1852.squirrel@webmail.hccnet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

Ho Gert,

> > I found strange effect. When I start common TV watching with
> > mplayer. I can see TV video. When I start cat /dev/video1 (i try
> > get MPEG stream of TV) on the TV screen I see sometimes
> > big white square. After stopped cat from /dev/video1 this squares
> > no more.
> >
> >
> > What is it??
> >
> 
> What video format is being used for the TV video?

modprobe saa7134 alsa=1 secam=d tsbufs=15 ts_nr_packets=312

mplayer tv:// -tv
driver=v4l2:fps=25:outfmt=i420:width=720:height=576:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:immediatemode=0:freq=175.0:normid=6
-aspect 4:3 -vf kerndeint

> I remember that the SAA7134 can not use a planar video format and TS
> capture at the same time.

No. Our programmer of drivers for Windows said it is possible. All of this parts is independent.

> When I added the original TS capture code, I did not deal with this
> situation, but I'm not sure if that is still the case.

I think it is problem with buffer working.

Other problem is incorrect work with PAT table.
Don`t need touch address of PAT in saa7134 when TS started because this chip sometimes make prefetch. When
module change PAT table like now saa7134 can crash if try prefetch (sorry my English). More correct 
change entry in PAT table.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
