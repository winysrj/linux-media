Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9L7Zq9G002157
	for <video4linux-list@redhat.com>; Wed, 21 Oct 2009 03:35:52 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9L7ZdD7013545
	for <video4linux-list@redhat.com>; Wed, 21 Oct 2009 03:35:40 -0400
Date: Wed, 21 Oct 2009 09:35:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uws2p437l.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910210934030.4163@axis700.grange>
References: <uws2p437l.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Question about v4l-dvb capture-example
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

Hello Morimoto-san,

On Wed, 21 Oct 2009, Kuninori Morimoto wrote:

> Dear all
> 
> Does 2.6.32-rcX git can use v4l-dvb capture-example ?
> I can not get correct image on EcoVec + ov772x

You're talking about arch/sh/boards/mach-ecovec24, right? AFAICS, the 
mainline version doesn't have any camera support. Could you, please, 
verify this with migor? If the problem is also present on it, it 
definitely has to be fixed.

> # I get correct image if I use mplayer

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
