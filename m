Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([193.252.22.30]:50057 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZBZJQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 04:16:35 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2328.orange.fr (SMTP Server) with ESMTP id 437647000089
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 10:16:32 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-68-100.w81-249.abo.wanadoo.fr [81.249.62.100])
	by mwinf2328.orange.fr (SMTP Server) with ESMTP id E16A87000093
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 10:16:31 +0100 (CET)
Message-ID: <49A65DFA.8030202@libertysurf.fr>
Date: Thu, 26 Feb 2009 10:16:42 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: zc3xx: "Creative Webcam Live!" never worked with in-tree driver
References: <49A4616A.10207@foo-projects.org>	<49A48A3B.4090509@foo-projects.org>	<20090224211916.249e15cf@pedra.chehab.org> <20090226092058.35ab847c@free.fr> <49A65827.9040306@foo-projects.org>
In-Reply-To: <49A65827.9040306@foo-projects.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Auke Kok a écrit :
> Jean-Francois Moine wrote:
>> On Tue, 24 Feb 2009 21:19:16 -0300
>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>> On Tue, 24 Feb 2009 16:00:59 -0800
>>> Auke Kok <auke@foo-projects.org> wrote:
>>>
>>>> Auke Kok wrote:
>>>>> All,
>>>>>
>>>>> I have a "Creative Technology, Ltd Webcam Live!/Live! Pro" that
>>>>> until recently worked fine with the out-of-tree gspcav1 driver
>>>>> (gspcav1-20071224.tar.gz is the latest version I used unti
>>>>> 2.6.26).
>>>>>
>>>>> Since this driver (basically) got merged in the kernel I got my
>>>>> hopes up that the in-kernel gspca_zc3xx drivers would work.
>>>>> However, that does not provide a usable video0 device - mplayer
>>>>> tv:// crashes with 'No stream found.' for instance:
>>>>>
>>>>> Playing tv://.
>>>>> Cache fill:  0.00% (0 bytes)
>>>>> TV file format detected.
>>>>> Selected driver: v4l2
>>>>>  name: Video 4 Linux 2 input
>>>>>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>>>>>  comment: first try, more to come ;-)
>>>>> Selected device: WebCam Live!
>>>>>  Capabilites:  video capture  read/write  streaming
>>>>>  supported norms:
>>>>>  inputs: 0 = zc3xx;
>>>>>  Current input: 0
>>>>>  Current format: unknown (0x4745504a)
>>>>> tv.c: norm_from_string(pal): Bogus norm parameter, setting
>>>>> default. v4l2: ioctl enum norm failed: Invalid argument
>>>>> Error: Cannot set norm!
>>>>> Selected input hasn't got a tuner!
>>>>> v4l2: ioctl set mute failed: Invalid argument
>>>>> v4l2: ioctl query control failed: Invalid argument
>>>>> v4l2: ioctl query control failed: Invalid argument
>>>>> FPS not specified in the header or invalid, use the -fps option.
>>>>> No stream found.
>>>>>
>>>>> v4l2: ioctl set mute failed: Invalid argument
>>>>> v4l2: 0 frames successfully processed, 0 frames dropped.
>>>>>
>>>>> Exiting... (End of file)
>>>>>
>>>>>
>>>>> I've regressed back to the original import of the spca driver in
>>>>> the kernel tree and this doesn't fix it, so I'm assuming that the
>>>>> driver were not merged correctly for my particular device.
>>>>>
>>>>> Basically the driver probes and load fine as is right now, no
>>>>> unusual message in dmesg as far as I can see:
>>>>>
>>>>> zc0301: V4L2 driver for ZC0301[P] Image Processor and Control
>>>>> Chip v1:1.10 usbcore: registered new interface driver zc0301
>>>>> usbcore: deregistering interface driver zc0301
>>>>> gspca: probing 041e:4036
>>>>> zc3xx: probe 2wr ov vga 0x0000
>>>>> zc3xx: probe sensor -> 11
>>>>> zc3xx: Find Sensor HV7131R(c)
>>>>> gspca: probe ok
>>>>> usbcore: registered new interface driver zc3xx
>>>>> zc3xx: registered
>>>>>
>>>>>
>>>>> I can post the output of the gspcav1 module with debug=5 for the
>>>>> register writes/reads if that is interesting, or anything else
>>>>> for that matter - I'd really like to keep this webcam working and
>>>>> staying at kernel 2.6.25 is not an option.
>>>>>
>>>>> is there a way to get the gspca_zc3xx driver dump register
>>>>> read/writes? this would be a quick way to compare the two drivers
>>>>> and look at the differences.
>>>>>
>>>> seems I just found the v4lcompat.so stuff, which (apart from being
>>>> a pain in the rear) makes the webcam work again...
>>> This seems to be a very common error. IMO, we should write message
>>> when loading a gspca that would require libv4l in order to work.
>>
>> First, it is strange that mplayer does not work: the v4l2 interface
>> seems recognized, but why does it say:
>>
>>     Current format: unknown (0x4745504a)
>>
>> while this is JPEG and it knows well how to handle it?
>>
>> Then, at probe time, there is:
>>
>>     zc0301: V4L2 driver for ZC0301[P] Image Processor and Control
>
> I pasted too much there, as you can see below I unloaded that driver:
>
>  zc0301: V4L2 driver for ZC0301[P] Image Processor and Control
>  Chip v1:1.10 usbcore: registered new interface driver zc0301
>  usbcore: deregistering interface driver zc0301
>
>
>>
>> This means that an other driver wants to handle the webcam. This may
>> raise problems.
>>
>> Eventually, the v4l library is needed when using any v4l2 driver, not
>> only gspca. Hopefully, many popular applications now use it natively,
>> as vlc 0.9.x.
>
> interesting, but I can't get vlc to understand either tv:// or
> /dev/video0... any hints?

Hi,
With mplayer I use :

mplayer -fps 30 -tv driver=v4l2:width=640:height=480:device=/dev/video0
tv://

and it works well with my Labtec webcam Pro : zc3xx

Michel.

>
> Auke
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


