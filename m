Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FIl3eO015076
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:47:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FIkgbA032535
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:46:42 -0500
Date: Fri, 15 Feb 2008 16:46:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Martin Michlmayr <tbm@cyrius.com>
Message-ID: <20080215164621.7f834e6b@gaivota>
In-Reply-To: <20080214125930.GA5675@deprecation.cyrius.com>
References: <20080214125930.GA5675@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, tzachi@marvell.com,
	Rainer Johanni <Rainer@Johanni.de>,
	v4l-dvb-maintainer@linuxtv.org, nico@cam.org, buytenh@wantstofly.org
Subject: Re: [v4l-dvb-maintainer] zoran: compilatation failure on ARM Orion
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

On Thu, 14 Feb 2008 13:59:30 +0100
Martin Michlmayr <tbm@cyrius.com> wrote:

> The zoran driver fails to compile on the ARM Orion platform with:
> 
> In file included from drivers/media/video/zoran_procfs.c:50:
> drivers/media/video/zoran.h:232: error: expected identifier before numeric constant
> 
> The reason is that drivers/media/video/zoran.h defines an enum with
> GPIO_MAX in it, but Orion contains a #define GPIO_MAX 32 in
> include/asm-arm/arch-orion/orion.h
> 
> I think it would be good if zoran.h would prefix these very generic
> GPIO names with something.
> 
Ok, I've wrote a fix for Zoran, doing:
	s/GPIO_/ZR_GPIO_/g

Yet, as Trent noticed, the better would be if arch-orion also to avoid using
such generic names.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
