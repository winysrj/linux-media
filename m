Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0601FXB013559
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 19:01:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0600TuG023169
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 19:00:30 -0500
Date: Mon, 5 Jan 2009 21:59:57 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Message-ID: <20090105215957.479b7ba2@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901041217381.25853@shell2.speakeasy.net>
References: <20090104104433.C996.WEIYI.HUANG@gmail.com>
	<200901041157.59503.laurent.pinchart@skynet.be>
	<Pine.LNX.4.58.0901041217381.25853@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, Huang Weiyi <weiyi.huang@gmail.com>,
	video4linux-list@redhat.com
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

On Sun, 4 Jan 2009 12:25:43 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Sun, 4 Jan 2009, Laurent Pinchart wrote:
> > On Sunday 04 January 2009, Huang Weiyi wrote:
> > > Removed unused #include <version.h>'s in files below,
> > >   drivers/media/video/cs5345.c
> > >   drivers/media/video/pwc/pwc-if.c
> > >   drivers/media/video/saa717x.c
> > >   drivers/media/video/upd64031a.c
> > >   drivers/media/video/upd64083.c
> > >   drivers/media/video/uvc/uvc_ctrl.c
> > >   drivers/media/video/uvc/uvc_driver.c
> > >   drivers/media/video/uvc/uvc_queue.c
> > >   drivers/media/video/uvc/uvc_video.c
> >
> > You can remove it from drivers/media/video/uvc/uvc_status.c as well.
> >
> > Mauro, the #include <linux/version.h> are required for backward compatibility
> > in the Mercurial tree, but are not needed (except in uvc_v4l2.c) in the
> > mainline git kernel tree. Can that be handled by your Mercurial -> git export
> > scripts ?
> 
> The version.h includes should not be needed for backward compatibility in
> the Hg tree.  There was always a problem with version.h appearing to not be
> necessary in the git code, so I modified the v4l-dvb build system to add
> version.h with a gcc -include option.

Yes. You just need to add version.h at the file where the V4L2 API is
implemented (due to VIDIOC_QUERYCTL).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
