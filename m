Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n888esFT021435
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 04:40:54 -0400
Received: from mail04.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n888eiEm021356
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 04:40:44 -0400
Date: Tue, 08 Sep 2009 17:40:34 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-reply-to: <Pine.LNX.4.64.0909080931160.4550@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <u1vmhx20t.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
References: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0909080931160.4550@axis700.grange>
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


Dear Guennadi

> Before reviewing the code - why is this needed?

Now I have new board which have tw9910.
and the start position is not same as MigoR.
(MigoR need +0x100, my new board needs +0xb0)

I'm not sure why (is it depend on LCDC size ?).
Datasheet doesn't have detail explain.

Best regards
--
Kuninori Morimoto
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
