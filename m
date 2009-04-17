Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:64699
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbZDQWNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 18:13:53 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
Date: Fri, 17 Apr 2009 23:13:47 +0100
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49E5D4DE.6090108@hhs.nl> <200904162146.59742.linux@baker-net.org.uk> <49E843CB.6050306@redhat.com>
In-Reply-To: <49E843CB.6050306@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_b8P6JUBmBxooesw"
Message-Id: <200904172313.47532.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_b8P6JUBmBxooesw
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 17 Apr 2009, Hans de Goede wrote:
> > I've tested it by plugging in the sq905 camera, verifying the
> > whitebablance control is present and working, unplugging the sq905 and
> > plugging in the pac207 and using up arrow to restart v4l2ucp and svv so I
> > think I've eliminated most finger trouble possibilities. The pac207 is id
> > 093a:2460 so not the problem id. I'll have to investigate more thoroughly
> > later.
>
> Does the pac207 perhaps have a / in its "card" string (see v4l-info output)
> ? if so try out this patch:
> http://linuxtv.org/hg/~hgoede/libv4l/rev/1e08d865690a
>

No, no / in the device name.

I've tried enabling the logging option in libv4l while running v4l2-ctl -l to 
list the controls present on each camera but I can't see any significant 
looking differences in the log other than the the fact the sq905 seems to get 
many more unsuccessful VIDIOC_QUERYCTRL requests. Unless you have a better 
idea my next step would be to extend the logging to include the parameters on 
the VIDIOC_QUERYCTRL ioctls, however my gut feel is that it is related the 
camera having controls that have CIDs both lower and higher than the ones 
libv4l adds and libv4l doesn't do anything with the driver returned values if 
V4L2_CTRL_FLAG_NEXT_CTRL is set.

Adam


--Boundary-00=_b8P6JUBmBxooesw
Content-Type: text/plain;
  charset="UTF-8";
  name="v4l2-ctl.sq905"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l2-ctl.sq905"

            normalize_low_bound (int)  : min=0 max=127 step=1 default=0 value=0
                   whitebalance (bool) : default=1 value=1
                      normalize (bool) : default=0 value=0
           normalize_high_bound (int)  : min=128 max=255 step=1 default=255 value=255

--Boundary-00=_b8P6JUBmBxooesw
Content-Type: text/plain;
  charset="UTF-8";
  name="v4l2-ctl.pac207"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="v4l2-ctl.pac207"

                     brightness (int)  : min=0 max=255 step=1 default=4 value=4
                       exposure (int)  : min=5 max=26 step=1 default=5 value=5
                      auto_gain (bool) : default=1 value=1
                           gain (int)  : min=0 max=31 step=1 default=9 value=9

--Boundary-00=_b8P6JUBmBxooesw
Content-Type: text/plain;
  charset="UTF-8";
  name="libv4l2.log.sq905"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libv4l2.log.sq905"

libv4l2: open: 3
libv4l2: open 3: setting pixelformat to RGB24
VIDIOC_S_FMT app requesting: RGB3
VIDIOC_S_FMT converting from: BA81
request == VIDIOC_S_FMT
  pixelformat: RGB3 320x240
  field: 1 bytesperline: 960 imagesize230400
  colorspace: 8, priv: 0
result == 0
libv4l2: open 3: done setting pixelformat
request == VIDIOC_QUERYCAP
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
libv4l2: v4l2 unknown munmap 0xb806d000, 4096
libv4l2: close: 3

--Boundary-00=_b8P6JUBmBxooesw
Content-Type: text/plain;
  charset="UTF-8";
  name="libv4l2.log.pac207"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libv4l2.log.pac207"

libv4l2: open: 3
libv4l2: open 3: setting pixelformat to RGB24
VIDIOC_S_FMT app requesting: RGB3
VIDIOC_S_FMT converting from: P207
request == VIDIOC_S_FMT
  pixelformat: RGB3 352x288
  field: 1 bytesperline: 1056 imagesize304128
  colorspace: 8, priv: 0
result == 0
libv4l2: open 3: done setting pixelformat
request == VIDIOC_QUERYCAP
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == 0
request == VIDIOC_G_CTRL
result == 0
request == VIDIOC_QUERYCTRL
result == -1 (Invalid argument)
libv4l2: v4l2 unknown munmap 0xb7ef2000, 4096
libv4l2: close: 3

--Boundary-00=_b8P6JUBmBxooesw--
