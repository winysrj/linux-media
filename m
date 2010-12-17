Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:23249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0LQRJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 12:09:44 -0500
Message-ID: <4D0B9953.7090202@redhat.com>
Date: Fri, 17 Dec 2010 15:09:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012141155.20714.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012141155.20714.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Laurent,

Em 14-12-2010 08:55, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> Please don't forget this pull request for 2.6.37.

Pull request for upstream sent today. 

I didn't find any regressions at the BKL removal patches, but I noticed a few 
issues with qv4l2, not all related to uvcvideo. The remaining of this email is an
attempt to document them for later fixes.

They don't seem to be regressions caused by BKL removal, but the better would be 
to fix them later.

- with uvcvideo and two video apps, if qv4l2 is started first, the second application 
doesn't start/capture. I suspect that REQBUFS (used by qv4l2 to probe mmap/userptr
capabilities) create some resource locking at uvcvideo. The proper way is to lock
the resources only if the driver is streaming, as other drivers and videobuf do.

- with saa7134 and qv4l2 (and after a fix for input capabilities): saa7134 and/or
qv4l2 doesn't seem to work fine if video format is changed to a 60HZ format (NTSC or
PAL/M). It keeps trying to use 576 lines, but the driver only works with 480 lines
for those formats. So, if qv4l2 tries to capture with STD/M, it fails, except if the
number of lines is manually fixed by the user.

- at least with the saa7134 board I used for test, video capture fails on some
conditions. This is not related to BKL patches. I suspect it may be some initialization
failure with the tuner (tda8275/tda8290), but I didn't have time to dig into it, nor
to test with a simpler saa7134 device. The device I used was an Avermedia m135.

> 
> On Monday 29 November 2010 11:15:10 Laurent Pinchart wrote:
>> Hi Mauro,
>>
>> The following changes since commit
>> c796e203229c8c08250f9d372ae4e10c466b1787:
>>
>>   [media] kconfig: add an option to determine a menu's visibility
>> (2010-11-22 10:37:56 -0200)
>>
>> are available in the git repository at:
>>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable
>>
>> They complete the BKL removal from the uvcvideo driver. Feedback received
>> from Hans during review has been integrated.



>>
>> Laurent Pinchart (5):
>>       uvcvideo: Lock controls mutex when querying menus
>>       uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
>>       uvcvideo: Move mmap() handler to uvc_queue.c
>>       uvcvideo: Lock stream mutex when accessing format-related information
>>       uvcvideo: Convert to unlocked_ioctl
>>
>>  drivers/media/video/uvc/uvc_ctrl.c  |   48 +++++++++-
>>  drivers/media/video/uvc/uvc_queue.c |  133 +++++++++++++++++++++-----
>>  drivers/media/video/uvc/uvc_v4l2.c  |  185
>> +++++++++++----------------------- drivers/media/video/uvc/uvc_video.c |  
>>  3 -
>>  drivers/media/video/uvc/uvcvideo.h  |   10 ++-
>>  5 files changed, 222 insertions(+), 157 deletions(-)
> 

