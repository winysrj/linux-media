Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ0vJsO016755
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 19:57:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ0v5BM022250
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 19:57:05 -0500
Date: Thu, 18 Dec 2008 20:57:06 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081218205706.60bf1526@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812190026180.8046@axis700.grange>
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
	<20081218160841.GA13851@linux-sh.org>
	<Pine.LNX.4.64.0812181717320.5510@axis700.grange>
	<20081218162439.GA27151@linux-sh.org>
	<Pine.LNX.4.64.0812181730080.5510@axis700.grange>
	<20081218191839.78cb627d@caramujo.chehab.org>
	<Pine.LNX.4.64.0812190026180.8046@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: A patch got applied to v4l bypassing v4l lists
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

On Fri, 19 Dec 2008 00:30:05 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> > A side note: maybe the design of pxa_camera could be improved to avoid needing
> > to be touched as architecture changes. This is the only v4l driver that includes
> > asm/arch header files.
> 
> The patch in question was for sh_mobile_ceu_camera.c - not for pxa, and 
> even though that one doesn't include any asm headers, as you see, it is 
> also tied pretty closely with respective platform code.

> As for including asm headers in pxa_camera.c - it wouldn't be easy to get 
> rid of them, one of the main obstacles is the use of the pxa-specific 
> dma-channel handling API.

Ok. I dunno the specific details of the sh and pxa bindings, but it would be
better to have it more independent from architecture specific implementation
details.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
