Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44836 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2KLMK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 07:10:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: V4L2 dma-buf support test with UVC + i915 test application
Date: Mon, 12 Nov 2012 13:11:20 +0100
Message-ID: <2061397.p0x1F1SJ0J@avalon>
In-Reply-To: <20121109095111.0e67be9c@gaivota.chehab>
References: <16907395.g8mkYBicR5@avalon> <1747552.HEbrOk0BKB@avalon> <20121109095111.0e67be9c@gaivota.chehab>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 09 November 2012 09:51:11 Mauro Carvalho Chehab wrote:
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
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
> > > (http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/devel/
> > > v4l2-clock)
> > > 
> > > Don't forget to enable dma-buf and UVC support when compiling the
> > > kernel.
> > > 
> > > The userspace code is based on the v4l2-drm-example application written
> > > by Tomasz (the original code is available at
> > > git://git.infradead.org/users/kmpark/public-apps). I need to clean up my
> > > modifications to push them back to the repository, in the meantime the
> > > code is attached to this e-mail.
> > > 
> > > To compile the application, just run make with the KDIR variable set to
> > > the path to your Linux kernel tree with the dma-buf patches applied.
> > > Don't forget to make headers_install in the kernel tree as the Makefile
> > > will look for headers in $KDIR/usr.
> > > 
> > > You will need a recent version of libdrm with plane support available.
> > > 2.4.39 should do.
> > > 
> > > The following command line will capture VGA YUYV data from the webcam
> > > and display it on the screen. You need to run it in a console as root
> > > without the X server running.
> > > 
> > > ./dmabuf-sharing -M i915 -o 7:3:1600x900 -i /dev/video0 -S 640,480
> > > -f YUYV -F YUYV -s 640,480@0,0 -t 640,480@0,0 -b 2
> > 
> > I forgot to mention that the -o parameter takes the connector ID, CRTC ID
> > and mode as parameters. The mode is easy to find, but the connector and
> > CRTC IDs are a bit more tricky. You can run the modetest application
> > (part of libdrm but not installed by most distributions, so a manual
> > compilation is needed) to dump all CRTC, encoder and connector
> > information to the console. Pick the connector associated with your
> > display, and the CRTC associated with the encoder associated with that
> > connector.
> 
> Didn't work:
> $ sudo ./modetest
> trying to load module i915...failed.
> trying to load module radeon...failed.
> trying to load module nouveau...failed.
> trying to load module vmwgfx...failed.
> trying to load module omapdrm...failed.
> failed to load any modules, aborting.
> 
> 
> Even so,
> 
> $ sudo /usr/bin/dristat
> /dev/dri/card0
> 
> and:
> 
> $ lsmod|grep i915
> i915                  530346  2
> video                  18936  1 i915
> i2c_algo_bit           13257  1 i915
> drm_kms_helper         44701  1 i915
> drm                   255010  3 i915,drm_kms_helper
> i2c_core               38314  5
> drm,i915,i2c_i801,drm_kms_helper,i2c_algo_bit
> 
> The GPU on this notebook is this one:
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (primary) (rev 0c) (prog-if 00 [VGA
> controller])

There's the explanation. Your graphics controller doesn't support planes :-( 
Any chance to have access to a computer based on an Ironlake, Sandy Bridge, 
Ivy Bridge or Haswell ?

> 	Subsystem: Dell Device 026f
> 	Flags: bus master, fast devsel, latency 0, IRQ 45
> 	Memory at f8000000 (64-bit, non-prefetchable) [size=1M]
> 	Memory at d0000000 (64-bit, prefetchable) [size=256M]
> 	I/O ports at 1800 [size=8]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> 	Capabilities: [d0] Power Management version 3
> 	Kernel driver in use: i915

-- 
Regards,

Laurent Pinchart

