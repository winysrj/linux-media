Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2C0Vhxv006727
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 20:31:43 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2C0VAo5029426
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 20:31:10 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0803112257260.9070@axis700.grange>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
	<47D3A2AA.7040608@claranet.fr>
	<Pine.LNX.4.64.0803091204060.3408@axis700.grange>
	<Pine.LNX.4.64.0803112257260.9070@axis700.grange>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 01:23:12 +0100
Message-Id: <1205281392.5927.117.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

Am Dienstag, den 11.03.2008, 23:04 +0100 schrieb Guennadi Liakhovetski:
> Hi Mauro,
> 
> On Sun, 9 Mar 2008, Guennadi Liakhovetski wrote:
> 
> > caused by a race with the interrupt handler? Can the problem be, that 
> > cx88/cx88-video.c::buffer_release() is called from multiple places: as 
> > cx8800_video_qops.buf_release(), and from video_release(), which is the 
> > release method in video_fops and radio_fops. In the Oops above it is 
> > called from cx8800_video_qops.buf_release().
> > 
> > Hm, video_release calls buffer_release() first directly, then it calls 
> > videobuf_stop -> __videobuf_streamoff -> videobuf_queue_cancel -> 
> > q->ops->buf_release... Is it good?...
> 
> as you see, more and more people are getting problems with the cx88 driver 
> after my patch. Is my above suspicion correct? I could not directly 
> propose a fix for that, firstly, due to the lack of time, secondly, of the 
> hardware, and thirdly, experience with this kind of drivers. I haven't 
> found a separate record in MAINTAINERS for this driver. Could you or 
> someone else have a look at these few functions? I definitely will not 
> have time for this tomorrow, I might have some time in the next couple of 
> days, but unfortunately I cannot promise anything.
> 
> Thanks
> Guennadi


Hi Guennadi,

you are definitely going into the right direction, as it was meant
already years back and also like Mauro did pick it up.

Don't take any rants seriously, but we just need something to settle
down in between safely until the next steps can be achieved.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
