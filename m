Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n06BikTC023953
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 06:44:46 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n06BhZgK006828
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 06:43:35 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: v4l-dvb-maintainer@linuxtv.org
Date: Tue, 6 Jan 2009 12:43:33 +0100
References: <20090104104433.C996.WEIYI.HUANG@gmail.com>
	<200901041157.59503.laurent.pinchart@skynet.be>
	<Pine.LNX.4.58.0901041217381.25853@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0901041217381.25853@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061243.33860.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Huang Weiyi <weiyi.huang@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>, mchehab@infradead.org
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

On Sunday 04 January 2009, Trent Piepho wrote:
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
> > Mauro, the #include <linux/version.h> are required for backward
> > compatibility in the Mercurial tree, but are not needed (except in
> > uvc_v4l2.c) in the mainline git kernel tree. Can that be handled by your
> > Mercurial -> git export scripts ?
>
> The version.h includes should not be needed for backward compatibility in
> the Hg tree.  There was always a problem with version.h appearing to not be
> necessary in the git code, so I modified the v4l-dvb build system to add
> version.h with a gcc -include option.

Thanks for the information.

Huang, can you please resubmit a patch with #include <linux/version.h> removed 
from drivers/media/video/uvc/uvc_status.c as well ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
