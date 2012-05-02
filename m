Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:52323 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672Ab2EBNxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 09:53:12 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Date: Wed, 2 May 2012 16:52:17 +0300
Subject: RE: SoC i.mx35 userptr method failure while running capture-example
 utility
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC9525493@MEP-EXCH.meprolight.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Guennadi,

Thanks for your quick response.

> ./capture-example -u -f -d /dev/video0
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> Failed acquiring VMA for vaddr 0x76cd9008
> VIDIOC_QBUF error 22, Invalid arg

>> It doesn't surprise me, that this doesn't work. capture-example allocates
>> absolutely normal user-space buffers, when called with USERPTR, and those
>> buffers are very likely discontiguous. Whereas mx3-camera needs physically
>> contiguous buffers, so, this can only fail. This means, you either have to
>> use MMAP or you need to allocate USERPTR buffers in a special way to
>> guarantee their contiguity.

I have a little progress:-) 
In thread "i.mx35 live video" you and Sylvester gave me advice on how to get the live video
with using the display panning method ... thanks for this invaluable support :-)
I took note of this and I'm currently trying to implement this.

Instead of discontiguous memory allocation I use framebuffer memory allocation
to userspace and this solves the problem.
 
Now I'm starting to see a live video for 3 seconds, after this video freezes
(it looks like a flickering pause), but the application continues to run without errors.

can see bellow my strace diagnostic:  

ioctl(3, VIDIOC_STREAMON, 0x7ece99f0)   = 0
select(4, [3], NULL, NULL, {2, 0})      = 1 (in [3], left {1, 884508})
ioctl(3, VIDIOC_DQBUF, 0x7ece990c)      = 0
ioctl(4, FBIOPAN_DISPLAY, 0x7ece9854)   = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0x7ece990c) = 0
select(4, [3], NULL, NULL, {2, 0})      = 1 (in [3], left {1, 919066})
ioctl(3, VIDIOC_DQBUF, 0x7ece990c)      = 0
ioctl(4, FBIOPAN_DISPLAY, 0x7ece9854)   = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0x7ece990c) = 0
select(4, [3], NULL, NULL, {2, 0})      = 1 (in [3], left {1, 918928})
ioctl(3, VIDIOC_DQBUF, 0x7ece990c)      = 0
ioctl(4, FBIOPAN_DISPLAY, 0x7ece9854)   = 0

[snip] 

ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0x7ece990c) = 0
select(4, [3], NULL, NULL, {2, 0})      = 1 (in [3], left {1, 999987})
ioctl(3, VIDIOC_DQBUF, 0x7ece990c)      = 0
ioctl(4, FBIOPAN_DISPLAY, 0x7ece9854)   = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0x7ece990c) = 0
select(4, [3], NULL, NULL, {2, 0})      = 1 (in [3], left {1, 999988})
ioctl(3, VIDIOC_DQBUF, 0x7ece990c)      = 0
ioctl(4, FBIOPAN_DISPLAY, 0x7ece9854)   = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0x7ece990c) = 0

I do not understand what's the problem, maybe need to implement 
FBIO_WAITFORVSYNC ioctl for mx3fb ? 

Thanks,
Alex
 
 
