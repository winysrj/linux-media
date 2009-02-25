Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173005pub.verizon.net ([206.46.173.5]:19126 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZBYABb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 19:01:31 -0500
Received: from [192.168.2.10] ([173.50.255.29]) by vms173005.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KFL0068HHDNS0L2@vms173005.mailsrvcs.net> for
 linux-media@vger.kernel.org; Tue, 24 Feb 2009 18:01:05 -0600 (CST)
Message-id: <49A48A3B.4090509@foo-projects.org>
Date: Tue, 24 Feb 2009 16:00:59 -0800
From: Auke Kok <auke@foo-projects.org>
MIME-version: 1.0
To: moinejf@free.fr, rossi.f@inwind.it, mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: Re: zc3xx: "Creative Webcam Live!" never worked with in-tree driver
References: <49A4616A.10207@foo-projects.org>
In-reply-to: <49A4616A.10207@foo-projects.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Auke Kok wrote:
> 
> All,
> 
> I have a "Creative Technology, Ltd Webcam Live!/Live! Pro" that until 
> recently worked fine with the out-of-tree gspcav1 driver 
> (gspcav1-20071224.tar.gz is the latest version I used unti 2.6.26).
> 
> Since this driver (basically) got merged in the kernel I got my hopes up 
> that the in-kernel gspca_zc3xx drivers would work. However, that does 
> not provide a usable video0 device - mplayer tv:// crashes with 'No 
> stream found.' for instance:
> 
> Playing tv://.
> Cache fill:  0.00% (0 bytes)
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: WebCam Live!
>  Capabilites:  video capture  read/write  streaming
>  supported norms:
>  inputs: 0 = zc3xx;
>  Current input: 0
>  Current format: unknown (0x4745504a)
> tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
> v4l2: ioctl enum norm failed: Invalid argument
> Error: Cannot set norm!
> Selected input hasn't got a tuner!
> v4l2: ioctl set mute failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> v4l2: ioctl query control failed: Invalid argument
> FPS not specified in the header or invalid, use the -fps option.
> No stream found.
> 
> v4l2: ioctl set mute failed: Invalid argument
> v4l2: 0 frames successfully processed, 0 frames dropped.
> 
> Exiting... (End of file)
> 
> 
> I've regressed back to the original import of the spca driver in the 
> kernel tree and this doesn't fix it, so I'm assuming that the driver 
> were not merged correctly for my particular device.
> 
> Basically the driver probes and load fine as is right now, no unusual 
> message in dmesg as far as I can see:
> 
> zc0301: V4L2 driver for ZC0301[P] Image Processor and Control Chip v1:1.10
> usbcore: registered new interface driver zc0301
> usbcore: deregistering interface driver zc0301
> gspca: probing 041e:4036
> zc3xx: probe 2wr ov vga 0x0000
> zc3xx: probe sensor -> 11
> zc3xx: Find Sensor HV7131R(c)
> gspca: probe ok
> usbcore: registered new interface driver zc3xx
> zc3xx: registered
> 
> 
> I can post the output of the gspcav1 module with debug=5 for the 
> register writes/reads if that is interesting, or anything else for that 
> matter - I'd really like to keep this webcam working and staying at 
> kernel 2.6.25 is not an option.
> 
> is there a way to get the gspca_zc3xx driver dump register read/writes? 
> this would be a quick way to compare the two drivers and look at the 
> differences.
> 
> Cheers,
> 
> Auke
> 
> 


seems I just found the v4lcompat.so stuff, which (apart from being a 
pain in the rear) makes the webcam work again...

Cheers,

Auke

