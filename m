Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2KIQsm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Nov 2012 11:48:42 -0500
Date: Fri, 9 Nov 2012 17:48:34 +0100
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: V4L2 dma-buf support test with UVC + i915 test application
Message-ID: <20121109174834.5d21e317@gaivota.chehab>
In-Reply-To: <20121109173742.2a35fcfc@gaivota.chehab>
References: <16907395.g8mkYBicR5@avalon>
	<1747552.HEbrOk0BKB@avalon>
	<20121109173742.2a35fcfc@gaivota.chehab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 9 Nov 2012 17:37:42 +0100
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Thu, 08 Nov 2012 19:34:14 +0100
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > On Thursday 08 November 2012 19:14:18 Laurent Pinchart wrote:
> > > Hi Mauro,
> > > 
> > > Here's the application I've used to test V4L2 dma-buf support with a UVC
> > > webcam and an Intel GPU supported by the i915 driver.
> > > 
> > > The kernel code is available in my git tree at
> > > 
> > > git://linuxtv.org/pinchartl/media.git devel/dma-buf-v10
> > > 
> > > (http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/devel/v4l2-
> > > clock)
> > > 
> > > Don't forget to enable dma-buf and UVC support when compiling the kernel.
> > > 
> > > The userspace code is based on the v4l2-drm-example application written by
> > > Tomasz (the original code is available at
> > > git://git.infradead.org/users/kmpark/public-apps). I need to clean up my
> > > modifications to push them back to the repository, in the meantime the code
> > > is attached to this e-mail.
> > > 
> > > To compile the application, just run make with the KDIR variable set to the
> > > path to your Linux kernel tree with the dma-buf patches applied. Don't
> > > forget to make headers_install in the kernel tree as the Makefile will look
> > > for headers in $KDIR/usr.
> > > 
> > > You will need a recent version of libdrm with plane support available.
> > > 2.4.39 should do.
> > > 
> > > The following command line will capture VGA YUYV data from the webcam and
> > > display it on the screen. You need to run it in a console as root without
> > > the X server running.
> > > 
> > > ./dmabuf-sharing -M i915 -o 7:3:1600x900 -i /dev/video0 -S 640,480 -f YUYV
> > > -F YUYV -s 640,480@0,0 -t 640,480@0,0 -b 2
> > 
> > I forgot to mention that the -o parameter takes the connector ID, CRTC ID and 
> > mode as parameters. The mode is easy to find, but the connector and CRTC IDs 
> > are a bit more tricky. You can run the modetest application (part of libdrm 
> > but not installed by most distributions, so a manual compilation is needed) to 
> > dump all CRTC, encoder and connector information to the console. Pick the 
> > connector associated with your display, and the CRTC associated with the 
> > encoder associated with that connector.
> 
> Got modetest running, but I didn't figure out what of the values below should be
> used for the -o parameter:
> 
> trying to load module i915...success.
> Encoders:
> id	crtc	type	possible crtcs	possible clones	
> 6	3	LVDS	0x00000003	0x00000001
> 13	0	DAC	0x00000003	0x00000002
> 15	0	TVDAC	0x00000003	0x00000004
> 
> Connectors:
> id	encoder	status		type	size (mm)	modes	encoders
> 5	6	connected	LVDS	290x180		1	6
>   modes:
> 	name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot)
>   1280x800 60 1280 1328 1360 1448 800 803 809 823 flags: nhsync, nvsync; type: preferred, driver
>   props:
> 	1 EDID:
> 		flags: immutable blob
> 		blobs:
> 
> 		value:
> 			00ffffffffffff0006af241400000000
> 			01110103801d12780a87f594574f8c27
> 			27505400000001010101010101010101
> 			010101010101ee1b00a8502017303020
> 			360022b410000019ee1b00a850201730
> 			3020360022b410000000000000fe0044
> 			573930398042313333455731000000fe
> 			00000000000000000001010a20200022
> 	2 DPMS:
> 		flags: enum
> 		enums: On=0 Standby=1 Suspend=2 Off=3
> 		value: 0
> 	7 scaling mode:
> 		flags: enum
> 		enums: None=0 Full=1 Center=2 Full aspect=3
> 		value: 3
> 12	0	disconnected	VGA	0x0		0	13
> 14	0	disconnected	s-video	0x0		0	15
> 
> CRTCs:
> id	fb	pos	size
> 3	9	(0,0)	(0x0)
>   1280x800 60 1280 1328 1360 1448 800 803 809 823 flags: nhsync, nvsync; type: preferred, driver
>   props:
> 4	0	(0,0)	(0x0)
>    0 0 0 0 0 0 0 0 0 flags: ; type: 
>   props:
> 
> Planes:
> id	crtc	fb	CRTC x,y	x,y	gamma size
> 
> Frame buffers:
> id	size	pitch


FYI, this is that I'm getting there: 

# ./dmabuf-sharing -M i915 -o 5:3:1280x800 -i /dev/video0 -S 640,480 -f YUYV -F YUYV -s 640,480@0,0 -t 640,480@0,0 -b 2

G_FMT(start): width = 640, height = 480, 4cc = YUYV
G_FMT(final): width = 640, height = 480, 4cc = YUYV
size = 614400 pitch = 1280
bo 1 640x480 bpp 16 size 614400 (614400)
dbuf_fd = 5
bo 2 640x480 bpp 16 size 614400 (614400)
dbuf_fd = 6
buffers ready
WARN(dmabuf-sharing.c:278): connector 5 is not supported
ERROR(dmabuf-sharing.c:441) : failed to find valid mode

Cheers,
Mauro
