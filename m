Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOGoFgi004311
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 11:50:15 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOGnCBB012610
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 11:49:12 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Stefano Sabatini <stefano.sabatini-lala@poste.it>
In-Reply-To: <20081224160038.GD475@geppetto>
References: <20081224160038.GD475@geppetto>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 24 Dec 2008 17:47:04 +0100
Message-Id: <1230137224.1700.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list Mailing List <video4linux-list@redhat.com>
Subject: Re: gspca, linux 2.6.26 and ioctl(VIDIOC_QUERYCAP) returning -1,
	what's wrong?
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

On Wed, 2008-12-24 at 17:00 +0100, Stefano Sabatini wrote:
> Hi all,

Hi Stefano,

> I'm using linux 2.6.26 and the Debian gspca module, and I'm getting
> ioctl(VIDIOC_QUERYCAP) return -1 after the device is opened.
	[snip]
> stefano@geppetto ~/s/ffmpeg> sudo modinfo gspca 
> filename:       /lib/modules/2.6.26-1-686/kernel/drivers/usb/media/gspca.ko
> author:         Michel Xhaard <mxhaard@users.sourceforge.net> based on spca50x driver by Joel Crisp <cydergoth@users.sourceforge.net>,ov511 driver by Mark McClelland <mwm@i.am>
> description:    GSPCA/SPCA5XX USB Camera Driver
	[snip]

You use the gspca version 1. This one is obsoleted by the gspca v2 which
is included in the latest linux kernels (>= 2.6.27). You should try the
stable or development versions at LinuxTv.org. Look at my page (see
below) for more information.

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
