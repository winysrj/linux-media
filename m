Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n888xern032643
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 04:59:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n888xOg5027803
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 04:59:25 -0400
Date: Tue, 8 Sep 2009 10:59:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <u1vmhx20t.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909081057570.4550@axis700.grange>
References: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909080931160.4550@axis700.grange>
	<u1vmhx20t.wl%morimoto.kuninori@renesas.com>
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

> 
> Dear Guennadi
> 
> > Before reviewing the code - why is this needed?
> 
> Now I have new board which have tw9910.
> and the start position is not same as MigoR.
> (MigoR need +0x100, my new board needs +0xb0)
> 
> I'm not sure why (is it depend on LCDC size ?).
> Datasheet doesn't have detail explain.

Hm, I don't think this has anything to do with the LCD size. What happens 
if you use a "wrong" HSYNC start? Are you testing both migor and your new 
system with the same signal source?

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
