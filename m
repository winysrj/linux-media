Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:36434 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753533Ab2CKSKQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 14:10:16 -0400
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1S6nDj-0002Hf-Qp
	for linux-media@vger.kernel.org; Sun, 11 Mar 2012 11:10:15 -0700
Message-ID: <4F5CEA86.50202@seiner.com>
Date: Sun, 11 Mar 2012 11:10:14 -0700
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: saa7115: black image
References: <4F5CE40C.6040706@seiner.com>
In-Reply-To: <4F5CE40C.6040706@seiner.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> I have an embedded platform with a Hauppage USB Live video capture 
> dongle.  I recently upgraded to 3.0.12 and now I get no image at all - 
> a nice pure black is all I get.
>
> I am sure that the dongle is getting a signal.  This same hardware 
> used to work with an older 2.6 kernel.
>
> Partial lsmod:
>
> root@anchor:/etc# lsmod
> Module                  Size  Used by    Not tainted
> saa7115                11296  0
> usbvision              48704  0
> v4l2_common             4336  2 saa7115,usbvision
> videodev               62768  3 saa7115,usbvision,v4l2_common
> i2c_core               12240  5 
> saa7115,usbvision,v4l2_common,videodev,i2c_dev
>
> [   33.640000] usbcore: registered new interface driver usb-storage
> [   33.644000] USB Mass Storage support registered.
> [   33.708000] Linux video capture interface: v2.00
> [   34.084000] usbvision_probe: Hauppauge WinTV USB Live Pro (NTSC 
> M/N) found
> [   34.092000] USBVision[0]: registered USBVision Video device video0 
> [v4l2]
> [   34.100000] usbcore: registered new interface driver usbvision
> [   34.104000] USBVision USB Video Device Driver for Linux : 0.9.10
>
> and this shows up every time the device is opened:
>
> [  219.772000] saa7115 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
> (usbvision-3-1)
>
> I can't help but think I am missing a module, or firmware, or 
> something.... But with no messages to go on it's a bit of a mystery.
>
> And yes, I've tried different inputs on the dongle; 0 is the composite 
> in and 1 is the s-video.  I'm using input 0.
>
Here's the verbose capture using fswebcam:

root@anchor:/lib/modules/3.0.12# fswebcam -v -c /etc/fswebcam
Reading configuration from '/etc/fswebcam'...
--- Opening /dev/video0...
Trying source module v4l2...
/dev/video0 opened.
src_v4l2_get_capability,83: /dev/video0 information:
src_v4l2_get_capability,84: cap.driver: "USBVision"
src_v4l2_get_capability,85: cap.card: "Hauppauge WinTV USB Live Pro (N"
src_v4l2_get_capability,86: cap.bus_info: "usb-0000:00:02.1-1"
src_v4l2_get_capability,87: cap.capabilities=0x05020001
src_v4l2_get_capability,88: - VIDEO_CAPTURE
src_v4l2_get_capability,95: - AUDIO
src_v4l2_get_capability,97: - READWRITE
src_v4l2_get_capability,99: - STREAMING
src_v4l2_set_input,177: /dev/video0: Input 0 information:
src_v4l2_set_input,178: name = "Composite Video Input"
src_v4l2_set_input,179: type = 00000002
src_v4l2_set_input,181: - CAMERA
src_v4l2_set_input,182: audioset = 00000000
src_v4l2_set_input,183: tuner = 00000000
src_v4l2_set_input,184: status = 00000000
src_v4l2_set_pix_format,537: Device offers the following V4L2 pixel formats:
src_v4l2_set_pix_format,550: 0: [0x59455247] 'GREY' (GREY)
src_v4l2_set_pix_format,550: 1: [0x50424752] 'RGBP' (RGB565)
src_v4l2_set_pix_format,550: 2: [0x33424752] 'RGB3' (RGB24)
src_v4l2_set_pix_format,550: 3: [0x34424752] 'RGB4' (RGB32)
src_v4l2_set_pix_format,550: 4: [0x4F424752] 'RGBO' (RGB555)
src_v4l2_set_pix_format,550: 5: [0x56595559] 'YUYV' (YUV422)
src_v4l2_set_pix_format,550: 6: [0x32315659] 'YV12' (YUV420P)
Using palette RGB32
Delaying 1 seconds.
src_v4l2_set_mmap,689: mmap information:
src_v4l2_set_mmap,690: frames=3
src_v4l2_set_mmap,737: 0 length=307200
src_v4l2_set_mmap,737: 1 length=307200
src_v4l2_set_mmap,737: 2 length=307200
--- Capturing frame...
Skipping 5 frames...
Capturing 1 frames...
Captured 6 frames in 0.21 seconds. (28 fps)
--- Processing captured image...
Setting font to LiberationSans-Regular:10.
Setting output format to JPEG, quality 95
Writing JPEG image to '/tmp/.tmp.jpg'.
root@anchor:/lib/modules/3.0.12#


-- 
Honoring our vets.

http://www.bataanmarch.com/

