Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EFiAEp003339
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 10:44:10 -0500
Received: from mail6.sea5.speakeasy.net (mail6.sea5.speakeasy.net
	[69.17.117.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EFhm51004772
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 10:43:49 -0500
Date: Thu, 14 Feb 2008 07:43:42 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20080214143023.GA1403@xi.wantstofly.org>
Message-ID: <Pine.LNX.4.58.0802140734180.6264@shell2.speakeasy.net>
References: <20080214125930.GA5675@deprecation.cyrius.com>
	<20080214143023.GA1403@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, tzachi@marvell.com, nico@cam.org,
	v4l-dvb-maintainer@linuxtv.org, Rainer Johanni <Rainer@Johanni.de>,
	Martin Michlmayr <tbm@cyrius.com>
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

On Thu, 14 Feb 2008, Lennert Buytenhek wrote:
> On Thu, Feb 14, 2008 at 01:59:30PM +0100, Martin Michlmayr wrote:
>
> > The zoran driver fails to compile on the ARM Orion platform with:
> >
> > In file included from drivers/media/video/zoran_procfs.c:50:
> > drivers/media/video/zoran.h:232: error: expected identifier before numeric constant
> >
> > The reason is that drivers/media/video/zoran.h defines an enum with
> > GPIO_MAX in it, but Orion contains a #define GPIO_MAX 32 in
> > include/asm-arm/arch-orion/orion.h
> >
> > I think it would be good if zoran.h would prefix these very generic
> > GPIO names with something.
>
> Not sure who is at fault here, as they're both playing in the same
> global namespace.  I guess we could patch either.

Not entirely the same namespace, as the arch header is included far more
often than the zoran.h header, which is only used by the zoran driver.  If
zoran uses GPIO_MAX, it's still possible for any other driver to use it
too.  Just as global function naming needs more namespace care than static
function naming, it seems like global arch headers should take more care
than local driver headers.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
