Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n04KQ0U1007471
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 15:26:00 -0500
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n04KPjsg028387
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 15:25:45 -0500
Date: Sun, 4 Jan 2009 12:25:43 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
In-Reply-To: <200901041157.59503.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.58.0901041217381.25853@shell2.speakeasy.net>
References: <20090104104433.C996.WEIYI.HUANG@gmail.com>
	<200901041157.59503.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, Huang Weiyi <weiyi.huang@gmail.com>,
	video4linux-list@redhat.com, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [VIDEO4LINUX] removed unused #include
 <version.h>'s
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

On Sun, 4 Jan 2009, Laurent Pinchart wrote:
> On Sunday 04 January 2009, Huang Weiyi wrote:
> > Removed unused #include <version.h>'s in files below,
> >   drivers/media/video/cs5345.c
> >   drivers/media/video/pwc/pwc-if.c
> >   drivers/media/video/saa717x.c
> >   drivers/media/video/upd64031a.c
> >   drivers/media/video/upd64083.c
> >   drivers/media/video/uvc/uvc_ctrl.c
> >   drivers/media/video/uvc/uvc_driver.c
> >   drivers/media/video/uvc/uvc_queue.c
> >   drivers/media/video/uvc/uvc_video.c
>
> You can remove it from drivers/media/video/uvc/uvc_status.c as well.
>
> Mauro, the #include <linux/version.h> are required for backward compatibility
> in the Mercurial tree, but are not needed (except in uvc_v4l2.c) in the
> mainline git kernel tree. Can that be handled by your Mercurial -> git export
> scripts ?

The version.h includes should not be needed for backward compatibility in
the Hg tree.  There was always a problem with version.h appearing to not be
necessary in the git code, so I modified the v4l-dvb build system to add
version.h with a gcc -include option.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
