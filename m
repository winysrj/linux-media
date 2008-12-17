Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHAjhDM032259
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 05:45:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHAjPf6030970
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 05:45:25 -0500
Date: Wed, 17 Dec 2008 08:45:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081217084505.654dabd5@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812161051240.5450@axis700.grange>
References: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812160904131.4630@axis700.grange>
	<uej08h569.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812161001000.4630@axis700.grange>
	<ud4fsh3h6.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812161051240.5450@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH v3] Add tw9910 driver
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

On Tue, 16 Dec 2008 11:09:21 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> so, here it is trying ANY... OTOH, the comment above says the driver 
> shouldn't fail this call, and http://v4l2spec.bytesex.org/spec/r10944.htm 
> confirms that. Which also means, that vivi.c does it wrongly. Mauro, you 
> are listed as one of the authors of vivi.c, and it looks like calling 
> S_FMT on it with field != ANY && field != INTERLACED will produce -EINVAL, 
> which seems to contradict the API. What is the correct behavious? Is this 
> a bug in vivi.c?

Yes, it is a bug at vivi. Could you please provide us a patch for it?

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
