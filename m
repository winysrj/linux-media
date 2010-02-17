Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:45206 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab0BQTRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 14:17:35 -0500
Message-ID: <4B7C40CB.7010907@chocky.org>
Date: Wed, 17 Feb 2010 11:17:31 -0800
From: Peter Naulls <peter@chocky.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: V4L on Blackfin, non-MMU issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Apologies for any ignorance here, I have been out of kernel/V4l
development for some time, and non-MMU kernel development is
relatively new to me.  I am awaiting approval for the uclinux
mailing list, so haven't CCed there.   I cover a lot of ground in
this post, so bear with me.

I'm trying to stream video from a Blackfin board - either
via USB initially, or a PPI connected camera.  c.f.:

http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:usb_video_device_class
http://docs.blackfin.uclinux.org/doku.php?id=uclinux-dist:ffmpeg

I am using trunk uclinux sources.  It should be obvious from the above that this
once worked.

The camera I actually want to use is an OV7725, however for hardware reasons I
needn't go into here, that isn't immediately possible.  So, I switched to a USB
Logitech Quickcam chat, which has an unusual pixel format, that seems to be only 
supported by vlc, and not ffmpeg.

The camera I have now is a Chicony chipset using the uvcvideo driver.  which
behaves as expected under x86 Linux with ffmpeg streaming, etc.

For blackfin/nommu, there seem to be some unresolved problems with uvcvideo:

http://www.mail-archive.com/linux-uvc-devel@lists.berlios.de/msg03530.html

That is, attempts to mmap the uvcvideo device fail.   With the above message
in mind, I put in a get_unmapped function into uvc_v4l.c, with code similar
to that in the mmap call.   This seemed to do the right thing, although
the problem now was that I ran into:

http://lists.berlios.de/pipermail/linux-uvc-devel/2008-December/004346.html

In particular, the "uvcvideo: Failed to submit URB 0 (-90)"

As best I can tell, comprehensive highspeed patches for musb have been submitted
a few times, but rejected for various reasons, although there's some
partial support.  Please correct me if I'm wrong.

As for the get_unmapped function, the only other v4l driver that has this
function seems to blackfin_cam.c, so it looks like an idea that was
taken up, then later forgotten about.

And so, with little else to try, I took a look at the vivi driver:

ffmpeg -v 0 -f video4linux2 -r 10 -s 320x240 -i /dev/video0 -an -qscale
...
[video4linux2 @ 0x1112010]mmap: No such device 

/dev/video0: I/O error occurred

Which I think is the same get_unmapped thing above.  I have no yet
tried a function here for this.

And then:

ffmpeg -v 0 -f video4linux -r 10 -s 320x240 -i /dev/video0 -an -qscale 2
...
INFO: task ffmpeg:459 blocked for more than 120 seconds.
...
    frame  1 : <0x004433fc> { _schedule + 0x28c } 

    frame  2 : <0x00444272> { ___down_write_nested + 0x66 } 

     address : <0x0023f26e> { _vmalloc_user + 0x2a } 

     address : <0x00442e48> { _printk + 0x10 } 

     address : <0x00392a04> { ___videobuf_iolock + 0x84 } 

     address : <0x00393962> { _buffer_prepare + 0xc2 } 

     address : <0x0039223e> { ___videobuf_read_start + 0x7a } 

     address : <0x0039253c> { _videobuf_read_stream + 0x16c } 

     address : <0x00394190> { _vivi_read + 0x38 } 

     address : <0x0023eb9c> { _do_mmap_private + 0x10c } 

     address : <0x0023ee44> { _do_mmap_pgoff + 0x134 } 

     address : <0x0023c230> { _sys_mmap_pgoff + 0x4c } 

     address : <0xffa0089e> { _system_call + 0x6a } 

     address : <0x02743202> /* kernel dynamic memory */ 

     address : <0xffa00fb8> { _evt_system_call + 0x64 }

So, can anyone shed any light on any of these?





