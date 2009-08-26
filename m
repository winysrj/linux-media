Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx06.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7QAwnZu022091
	for <video4linux-list@redhat.com>; Wed, 26 Aug 2009 06:58:49 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n7QAwYah016994
	for <video4linux-list@redhat.com>; Wed, 26 Aug 2009 06:58:34 -0400
Date: Wed, 26 Aug 2009 12:58:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uhbvuhn8f.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0908261257030.6737@axis700.grange>
References: <u1vnorpbi.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0908261053050.5167@axis700.grange>
	<uhbvuhn8f.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/2 v3] sh_mobile_ceu: add soft reset function
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

On Wed, 26 Aug 2009, Kuninori Morimoto wrote:

> 
> Dear Guennadi
> 
> > I've updated both your patches on the top of my current tree and slightly 
> > cleaned them up - mainly multi-line comments. Also fixed one error in 
> > sh_mobile_ceu_add_device() (see below). Please, check if the stack at 
> > http://download.open-technology.de/soc-camera/20090826/ looks ok and still 
> > works for you. As usual, you find instructions on which tree and branch to 
> > use in 0000-base.
> 
> Thank you for your hard work.
> It looks OK for me.
> But I wounder that does your and Paul's git can merge correctly ?
> I can find Magnus patch on sh_mobile_ceu_camera.c in latest Paul's git

That will be handled when the time comes:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
