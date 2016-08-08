Return-path: <linux-media-owner@vger.kernel.org>
Received: from cloudserver096301.home.net.pl ([79.96.179.35]:45815 "HELO
	cloudserver096301.home.net.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750979AbcHHXCj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 19:02:39 -0400
Date: Tue, 9 Aug 2016 01:02:31 +0200
From: Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>
To: linux-media@vger.kernel.org,
	"linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
	Thomas Johnson <tjohnson@motionfigures.com>,
	George Saliba <grgsaliba@gmail.com>
Cc: Igor =?utf-8?B?UGXEjW92bmlr?= <notifications@github.com>,
	hdegoede@redhat.com
Subject: Re: uvcvideo: Failed to submit URB 0 (-28) with Cam Sync HD VF0770
 (041e:4095)
Message-ID: <20160808230231.pxnv6vwhoyqkss7u@haysend>
References: <20160806140022.rgy6f63xtx6667lg@haysend>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160806140022.rgy6f63xtx6667lg@haysend>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 06, 2016 at 04:00:22PM +0200, Piotr Król wrote:
> Hi all,

Hi Hans, Igor,
I found your discussion about very similar issue here [5]. It looks
like musb driver in host mode doesn't give enough bandwidth for USB
camera in my case.

We tested USB device and getting not so bad results for bulk endpoint
read (15MB/s) and write (1.8MB/s). I'm not sure, if this numbers make
sense for isochronous endpoint, but it seems there is enough bandwidth
for video data transfer.

Full dmesg can be found here [6]

Have you got any ideas what maybe wrong ? Does it make sense to use musb
in host mode to transfer video stream ?

Any help appreciated.

> We have custom Allwinner A20 based hardware on which we try to utilize
> USB DRD (configured in device tree as host [1]) to connect Creative web
> camera [2].
> 
> We use 4.7 kernel release built using buildroot. Hardware configuration can
> be described like that:
> 
> A20 mainboard -> LAN9514i -> Creative web camera
> 
> I tried v4l2grab and fswebcam, but both application result in
> "uvcvideo: Failed to submit URB 0 (-28)" and further complaining that
> there is no space left on device, despite there is planty of free
> space [3]. We also tried to capture in /tmp with the same result.
> 
> v4l2grab output:
> # v4l2grab -d /dev/video0 -o image.jpg
> [ 1802.800160 ] uvcvideo: Failed to submit URB 0 (-28).
> libv4l2: error turning on stream: No space left on device
> VIDIOC_STREAMON error 28, No space left on device
> 
> fswebcam output:
> # fswebcam -r 1280x720 --jpeg 95 -D 1 image.jpg
> --- Opening /dev/video0...
> Trying source module v4l2...
> /dev/video0 opened.
> No input was specified, using the first.
> Delaying 1 seconds.
> [  432.952080 ] uvcvideo: Failed to submit URB 0 (-28).
> Error starting stream.
> VIDIOC_STREAMON: No space left on device
> Unable to use mmap. Using read instead.
> Unable to use read.
> 
> What we also tried is checking camera with Raspberry Pi Compute Module
> in that way:
> 
> RPICM -> LAN9514i -> LAN9514i -> Creative web camera
> 
> And this works without problem.
> 
> We proved that USB was correctly configured in host mode by trying
> usb-storage, usbhid and ftdi driver, what can be found in dmesg [4].
> 
> I have hard time with finding from what code -28 came from, since calls
> are nested in usb subsystem. What this error means ? How it can be
> avoided ?
> 
> Any other ideas how to debug this issue further are welcome.
> 
> [1] http://paste.ubuntu.com/22446905/
> [2] http://www.scanmalta.com/scanshop/creative-live-cam-sync-1-3mp-hd-webcam.html
> [3] http://paste.ubuntu.com/22448114/
> [4] http://paste.ubuntu.com/22446585/

[5] https://groups.google.com/d/msg/linux-sunxi/-O3GckFuje8/aTAkPk1JCQAJ
[6] http://paste.ubuntu.com/22747309/
> 
> -- 
> Best Regards,
> Piotr Król
> Embedded Systems Consultant
> http://3mdeb.com | @3mdeb_com

-- 
Best Regards,
Piotr Król
Embedded Systems Consultant
http://3mdeb.com | @3mdeb_com
