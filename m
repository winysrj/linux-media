Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48714 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaI1XAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 19:00:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matt Wells <phanoko@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mark Ryan <mark.d.ryan@linux.intel.com>
Subject: Re: Dell XPS 12 Camera issues
Date: Mon, 29 Sep 2014 02:00:49 +0300
Message-ID: <1614008.QuBRSios4a@avalon>
In-Reply-To: <CA+aiKi+F_qDZxcL3NCWz4WSXn033cPEWW3akuZ+qQdGyQ4GZPQ@mail.gmail.com>
References: <CA+aiKi+F_qDZxcL3NCWz4WSXn033cPEWW3akuZ+qQdGyQ4GZPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

(CC'ing the linux-media mailing list and Mark Ryan from Intel)

Sorry for the late reply.

On Monday 01 September 2014 12:54:02 Matt Wells wrote:
> I'm sure you guys get this a bit.  It's on the Dell XPS Camera.  As
> far as I can tell, it's the Omniview camera and requires a rebuild of
> the UVC driver to enable MJPEG compression?

Why would you need that ? Where have you got that information from ?

> I've been banging on this one for a big but with no luck.  Any help
> you can give would be fantastic.
> Using "Cheese" as my testing app -
> Launching has the green lines and dies quickly.
> $ cheese
> 
> (cheese:3950): GLib-GObject-WARNING **: value "5.000000" of type
> 'gdouble' is invalid or out of range for property 'delaytime' of type
> 'gdouble'
> libv4l2: error got 4 consecutive frame decode errors, last error:
> v4l-convert: libjpeg error: End Of Image
> 
> (cheese:3950): cheese-WARNING **: Internal data flow error.:
> gstbasesrc.c(2865): gst_base_src_loop ():
> /GstCameraBin:camerabin/GstWrapperCameraBinSrc:camera_source/GstBin:bin34/Gs
> tV4l2Src:video_source: streaming task paused, reason error (-5)
> 
> 
> 
> So the important stuff.

[snip]

> I was able to add
> # echo "options uvcvideo nodrop=1 " > /etc/modprobe.d/uvcvideo.conf
> # restorecon /etc/modprobe.d/uvcvideo.conf
> # rmmod uvcvideo ; modprobe uvcvideo
> # dmesg | tail -10
> [ 1565.576374] usbcore: deregistering interface driver uvcvideo
> [ 1565.654215] uvcvideo: Found UVC 1.00 device Integrated Webcam (0bda:5716)
> [ 1565.823637] input: Integrated Webcam as
> /devices/pci0000:00/0000:00:14.0/usb2/2-5/2-5:1.0/input/input16
> [ 1565.823858] usbcore: registered new interface driver uvcvideo
> [ 1565.823861] USB Video Class driver (1.1.1)
> [ 2122.380574] usbcore: deregistering interface driver uvcvideo
> [ 2122.459860] uvcvideo: Found UVC 1.00 device Integrated Webcam (0bda:5716)
> [ 2122.630400] input: Integrated Webcam as
> /devices/pci0000:00/0000:00:14.0/usb2/2-5/2-5:1.0/input/input17
> [ 2122.630675] usbcore: registered new interface driver uvcvideo
> [ 2122.630679] USB Video Class driver (1.1.1)
> 
> 
> $ cheese
> 
> (cheese:3995): GLib-GObject-WARNING **: value "5.000000" of type
> 'gdouble' is invalid or out of range for property 'delaytime' of type
> 'gdouble'
> 
> and it doesn't die but still get's the lines.
> 
> Now here's the "ggrrrr" area.
> 
> Application - guvcview and VLC; no issues at all.
> I've also tested with Skype and Hangouts and they give the same errors
> as Cheese.
> I also tested with a live USB of Ubuntu, Mint and Fedora 19, all the
> same issues.
> Based on the VLC/gucview maybe it's related to some codec?

Your device seems to support three formats, YUYV, MJPEG and M420. Cheese seems 
to try to capture frames in MJPEG, how about guvcview and VLC ?

> I had a Latitude E7240 i7 at work to test with the same kernel module
> and no issues, so I know it's something to do with the i5.

Does it have the exact same webcam model ?

> I searched here for some time before posting and haven't found the
> answer as of yet. Perhaps my search'foo isn't really there and to tell
> you the truth cameras and what not are a weak spot for me. Never
> really cared about them until now.
> 
> Man I just need some ideas. So far the first 9 pages of google are
> purple (clicked) links.
> I've 5 pages of strace that I'm going through tonight.
> 
> Anyone else out there have this issue with the XPS line?
> 
> Any direction is much appreciated. I'll feel like a real idiot if a
> quick post and a link resolves it.

This mail thread might be related: http://www.spinics.net/lists/linux-media/msg73460.html

Mark, have you managed to finish carrying on your investigations ?

-- 
Regards,

Laurent Pinchart

