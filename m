Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54272 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbbFHKC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 06:02:28 -0400
Message-ID: <5575682E.3000209@xs4all.nl>
Date: Mon, 08 Jun 2015 12:02:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org
CC: dale.hamel@srvthe.net, michael@stegemann.it
Subject: Re: [PATCH v2 0/2] stk1160: Frame scaling and "de-verbosification"
References: <1433629618-1833-1-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1433629618-1833-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 06/07/2015 12:26 AM, Ezequiel Garcia wrote:
> I've removed the driver verbosity and fixed the frame scale implementation.
> In addition to the usual mplayer/vlc/qv4l2, it's tested with v4l2-compliance
> on 4.1-rc4.

I recommend you use the media_tree.git master branch: v4l2-compliance is always
in sync with that one.

I'm not getting the issues you show below with v4l2-compliance -s (although once
it starts streaming I get sequence errors, see the patch I posted that fixes that).

So use the media_tree master branch and use the latest v4l2-compliance. If you still
get the error you see below, then that needs to be investigated further, since I
don't see it.

However, testing with v4l2-compliance -f (which tests scaling) just stalls:

Test input 0:

Stream using all formats:
        test MMAP for Format UYVY, Frame Size 6x4:

It sits there until I press Ctrl-C.

This is NTSC input, BTW.

Regards,

	Hans

> 
> v4l2-compliance passes:
> Total: 111, Succeeded: 111, Failed: 0, Warnings: 5
> 
> v4l2-compliance -s shows some failures, but AFAICS it's not the
> driver's fault as the failing ioclt are handled by generic
> implementations (vb2_ioctl_reqbufs):
> 
> 	test MMAP: FAIL
> 		VIDIOC_QUERYCAP returned 0 (Success)
> 		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
> 		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
> 		VIDIOC_QUERYCTRL returned 0 (Success)
> 		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)
> 		VIDIOC_REQBUFS returned -1 (Device or resource busy)
> 		fail: v4l2-test-buffers.cpp(976): ret != EINVAL
> 	test USERPTR: FAIL
> 		VIDIOC_QUERYCAP returned 0 (Success)
> 		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
> 		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
> 		VIDIOC_QUERYCTRL returned 0 (Success)
> 		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)
> 		VIDIOC_REQBUFS returned -1 (Invalid argument)
> 	test DMABUF: OK (Not Supported)
> 		VIDIOC_QUERYCAP returned 0 (Success)
> 		VIDIOC_QUERY_EXT_CTRL returned 0 (Success)
> 		VIDIOC_TRY_EXT_CTRLS returned 0 (Success)
> 		VIDIOC_QUERYCTRL returned 0 (Success)
> 		VIDIOC_G_SELECTION returned -1 (Inappropriate ioctl for device)
> 
> Total: 115, Succeeded: 113, Failed: 2, Warnings: 5
> 
> Thanks,
> 
> Ezequiel Garcia (2):
>   stk1160: Reduce driver verbosity
>   stk1160: Add frame scaling support
> 
>  drivers/media/usb/stk1160/stk1160-core.c |   5 +-
>  drivers/media/usb/stk1160/stk1160-reg.h  |  34 ++++++
>  drivers/media/usb/stk1160/stk1160-v4l.c  | 203 +++++++++++++++++++++++++------
>  drivers/media/usb/stk1160/stk1160.h      |   1 -
>  4 files changed, 202 insertions(+), 41 deletions(-)
> 

