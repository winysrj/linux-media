Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88AGUoO009347
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 06:16:30 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n88AGFdq003794
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 06:16:16 -0400
Date: Tue, 8 Sep 2009 12:16:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uzl95vjum.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909081214040.4550@axis700.grange>
References: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909080931160.4550@axis700.grange>
	<u1vmhx20t.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909081057570.4550@axis700.grange>
	<uzl95vjum.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/4] soc-camera: tw9910: hsync_ctrl can control from
 platform
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

On Tue, 8 Sep 2009, Kuninori Morimoto wrote:

> > Hm, I don't think this has anything to do with the LCD size. What happens 
> > if you use a "wrong" HSYNC start? Are you testing both migor and your new 
> > system with the same signal source?
> 
> Now I try to use current v4l2-linux-next git.
> Does tw9910 on MigoR works well ?
> It doesn't work for me now.

What problem are you getting? Not sure if there has been an issue, in any 
case it would be better, if you could base on v4l2-linux-next plus my 
imagebus patches. In that state tw9910 should work.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
