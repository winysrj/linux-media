Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBE1LitG017866
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 20:21:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBE1LU8s001532
	for <video4linux-list@redhat.com>; Sat, 13 Dec 2008 20:21:30 -0500
Date: Sat, 13 Dec 2008 23:21:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081213232105.14e18a03@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812132252090.10954@axis700.grange>
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
	<20081210074457.5727.59206.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0812132252090.10954@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 03/03] sh_mobile_ceu: add NV16 and NV61 support
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

On Sat, 13 Dec 2008 22:56:37 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Wed, 10 Dec 2008, Magnus Damm wrote:
> 
> > From: Magnus Damm <damm@igel.co.jp>
> > 
> > This patch adds NV16/NV61 support to the sh_mobile_ceu driver.
> 
> I guess I cannot apply / push this patch befor your NV16 / NV61 is 
> applied, or shall I pull that patch too, Mauro?
> 
Guennadi,

You can apply it on your tree. I'll then pull from you on your next pull request.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
