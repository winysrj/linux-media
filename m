Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5J2QECr023358
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 22:26:14 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5J2Q0VJ017518
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 22:26:01 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080618091650.0bd7e2ae@glory.loctelecom.ru>
References: <20080414114746.3955c089@glory.loctelecom.ru>
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
	<20080613180516.211a27a9@glory.loctelecom.ru>
	<1213388868.2758.78.camel@pc10.localdom.local>
	<20080618091650.0bd7e2ae@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 04:23:39 +0200
Message-Id: <1213842219.2554.16.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gert.vervoort@hccnet.nl,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hi Dmitri,

Am Mittwoch, den 18.06.2008, 09:16 +1000 schrieb Dmitri Belimov:
> Hi All
> 
> I found next problems with empress :)))
> 
> I can`t get via v4l2-ctl list of external control for control MPEG settings via this tool.
> --list-ctrls and --list-ctrls-menus
> In debug log I can see only one call empress_querycap nothink vidioc_g_ext_ctrls/empress_g_ext_ctrls calls.
> Didn`t work v4l2-ctl --log-status

just a late/early note on this, I'm still without a working empress
device.

After you have fixed several bugs on the empress ioctl2 conversion, you
are still the first user after years and now hit mpeg extended controls,
Hans from the ivtv project kindly introduced, but he is also without any
such device and the stuff is completely untested.

As far I know, there are no handlers yet to modify the parameters.

Hopefully Beholder sees, in what kind of field you are operating,
but for sure there is no doubt about, what was already thrown in.

Thanks,
Hermann

> ./v4l2-ctl --list-ctrls-menus -d /dev/video1
> 
>                      brightness (int)  : min=0 max=255 step=1 default=128 value=0
>                        contrast (int)  : min=0 max=127 step=1 default=68 value=0
>                      saturation (int)  : min=0 max=127 step=1 default=64 value=0
>                             hue (int)  : min=-128 max=127 step=1 default=0 value=0
>                          volume (int)  : min=-15 max=15 step=1 default=0 value=0
>                            mute (bool) : default=0 value=0
>                          mirror (bool) : default=0 value=0
>                          invert (bool) : default=0 value=0
>              y_offset_odd_field (int)  : min=0 max=128 step=0 default=0 value=0
>             y_offset_even_field (int)  : min=0 max=128 step=0 default=0 value=0
>                        automute (bool) : default=1 value=0
> 
> It`s debug data in log 
> 
> DEBUG: ts_open() start
> DEBUG: ts_open() stop
> DEBUG: empress_querycap() start
> DEBUG: empress_querycap() stop
> DEBUG: ts_release() start
> DEBUG: ts_reset_encoder() start
> DEBUG: ts_release() stop
> 
> With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
