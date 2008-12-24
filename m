Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOHgkp1024058
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:42:46 -0500
Received: from relay-pt1.poste.it (relay-pt1.poste.it [62.241.4.164])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOHgLTn006718
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 12:42:21 -0500
Received: from geppetto.reilabs.com (78.15.202.84) by relay-pt1.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 495189D800006443 for video4linux-list@redhat.com;
	Wed, 24 Dec 2008 18:42:21 +0100
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1LFXig-00021v-PY
	for video4linux-list@redhat.com; Wed, 24 Dec 2008 18:40:30 +0100
Date: Wed, 24 Dec 2008 18:40:30 +0100
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Message-ID: <20081224174030.GC31194@geppetto>
References: <20081224160038.GD475@geppetto>
	<1230137224.1700.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230137224.1700.10.camel@localhost>
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

On date Wednesday 2008-12-24 17:47:04 +0100, Jean-Francois Moine wrote:
> On Wed, 2008-12-24 at 17:00 +0100, Stefano Sabatini wrote:
> > Hi all,
> 
> Hi Stefano,
> 
> > I'm using linux 2.6.26 and the Debian gspca module, and I'm getting
> > ioctl(VIDIOC_QUERYCAP) return -1 after the device is opened.
> 	[snip]
> > stefano@geppetto ~/s/ffmpeg> sudo modinfo gspca 
> > filename:       /lib/modules/2.6.26-1-686/kernel/drivers/usb/media/gspca.ko
> > author:         Michel Xhaard <mxhaard@users.sourceforge.net> based on spca50x driver by Joel Crisp <cydergoth@users.sourceforge.net>,ov511 driver by Mark McClelland <mwm@i.am>
> > description:    GSPCA/SPCA5XX USB Camera Driver
> 	[snip]
> 
> You use the gspca version 1. This one is obsoleted by the gspca v2 which
> is included in the latest linux kernels (>= 2.6.27). You should try the
> stable or development versions at LinuxTv.org. Look at my page (see
> below) for more information.

Many thanks Jean-Francois,

indeed it was what I suspected, but the line I found in dmesg was misleading:

[38586.942147] Linux video capture interface: v2.00

BTW, would be possible to get a more informative error message from
the module (either in the kernel log either in the strerror string)?,
also I expected to get a different ioctl() code in that case (namely
ENOIOCTLCMD).

Check for example the code in libavdevice/v4l2.c of FFmpeg:

    res = ioctl(fd, VIDIOC_QUERYCAP, &cap);
    // ENOIOCTLCMD definition only availble on __KERNEL__
    if (res < 0 && errno == 515) {
        av_log(ctx, AV_LOG_ERROR, "QUERYCAP not implemented, probably V4L device but not supporting V4L2\n");
        close(fd);

        return -1;
    }
    if (res < 0) {
        av_log(ctx, AV_LOG_ERROR, "ioctl(VIDIOC_QUERYCAP): %s\n",
                 strerror(errno));
        close(fd);

        return -1;
    }

This is supposed to nicely warn the user if the device doesn't support
V4L2.

Is this a problem with V4L* or is the ENOIOCTLCMD assumption wrong?

Again thanks in advance.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
