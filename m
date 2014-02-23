Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaBWNvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 08:51:45 -0500
Message-ID: <5309FCED.2080203@redhat.com>
Date: Sun, 23 Feb 2014 14:51:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hps@bitfrost.no>, linux-media@vger.kernel.org
Subject: Re: [APP-BUG] UVC camera not working with skype
References: <5309E460.6020301@bitfrost.no>
In-Reply-To: <5309E460.6020301@bitfrost.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/23/2014 01:06 PM, Hans Petter Selasky wrote:
> Hi,
> 
> I have debugged why a USB video class camera doesn't work with skype.
> 
> Skype finds the device and opens /dev/video0.
> 
> Skype tries to enumerate the device, but apparently does not care about the return value from the VIDIOC_ENUM_FRAMEINTERVALS. It finds the correct resolution and so on, but I suspect the FPS value is not matching what it expects.
> 
> drivers/media/usb/uvc/uvc_v4l2.c:
> 
>         case VIDIOC_ENUM_FRAMEINTERVALS:
>         {
> 
> struct v4l2_frmivalenum *fival = arg;
> 
>                 if (frame->bFrameIntervalType) {
>                         if (fival->index >= frame->bFrameIntervalType)
>                                 return -EINVAL;    // CPU goes here
> 
>                         fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>                         fival->discrete.numerator =
> 
> I see "fival->index" goes far beyond "frame->bFrameIntervalType" leading me to believe that skype tries to search for a specific setting, and if it doesn't find that it simply while's one.
> 
> Using another UVC based camera with skype works fine. I've attached the USB descriptor dump for the non-working USB camera.
> 
> I can test suggestions and patches.
> 
> Solution:
> 
> Possibly the UVC driver should provide some standard settings regardless of what the USB descriptors say. Might also be task for libv4l, Hans CC'ed.

Ugh, if we add special code to libv4l for this the amount of libv4l skype specific
fixes is going to become ridiculous (we also fake all cams doing 320x240 for skype).
Have you tried contacting skype about this ?

Please first try to get skype to "fix their shit", if that does not work I'm
willing to review a patch to work around this in libv4l. No promises I'll
actually apply it, but if it is sane enough I probably will, skype is used
by too much people, now if only it was not so totally completely broken in
how it uses the v4l2 API :|

Regards,

Hans
