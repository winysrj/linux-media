Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44396 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2FKOeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 10:34:25 -0400
Received: by weyu7 with SMTP id u7so2115733wey.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 07:34:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD3BB42.2010803@redhat.com>
References: <CAFxvmmfFqCQg3QxirmPazdqNuBq6SxbezUR9T1bo+SRRL9-hBA@mail.gmail.com>
	<4FD3BB42.2010803@redhat.com>
Date: Mon, 11 Jun 2012 14:34:23 +0000
Message-ID: <CAFxvmmdUp8-JuPuL=wdZyPkUZ9NEPucwS6ZQf_M0CuWs_bZm+g@mail.gmail.com>
Subject: Re: PWC ioctl inappropriate for device (Regression)
From: Bernard GODARD <bernard.godard@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your reply.

I will try to do the fix in qastrocam-g2 myself as this program does
not currently have a maintainer.

Regards,

On Sat, Jun 9, 2012 at 9:08 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 06/09/2012 07:06 PM, Bernard GODARD wrote:
>>
>> Dear all,
>>
>> I am using a Philips Toucam Pro 2 webcam with the program qastrocam-g2
>> (astronomy program that use some specific functions of the PWC
>> driver).
>> I have been using this program with this camera for a long time on
>> different Linux distributions without a problem.
>>
>> With Ubuntu 12.04, I now get a kernel oops. See bug report:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1010028
>>
>> I have installed mainline kernel 3.4rc6 on my Ubuntu box to check if
>> the oops was fixed upstream. Now I am not getting the oops anymore
>
>
> Good!
>
>
>> but the IOCTL used to get/set the camera parameters are failing:
>>
>>
>>
>> astro@saturn:~$ qastrocam-g2
>> <init> : Avifile RELEASE-0.7.48-120122-05:53-../src/configure
>> <init> : Available CPU flags: fpu vme de pse tsc msr pae mce cx8 apic
>> sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall
>> nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid
>> pni cx16 la
>> <init> : 2200.00 MHz AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
>> detected
>> Getting Standard: Inappropriate ioctl for device
>> setWhiteBalance: Inappropriate ioctl for device
>> getWhiteBalance: Inappropriate ioctl for device
>> getWhiteBalance: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> ioctl (VIDIOCGWIN): Inappropriate ioctl for device
>> mmap: Invalid argument
>> VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
>> VIDIOCPWCGCONTOUR: Inappropriate ioctl for device
>> VIDIOCPWCSCONTOUR: Inappropriate ioctl for device
>> VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
>> VIDIOCPWCGCONTOUR: Inappropriate ioctl for device
>> VIDIOCPWCGDYNNOISE: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCSAGC: Inappropriate ioctl for device
>> getWhiteBalance: Inappropriate ioctl for device
>> VIDIOCPWCSAGC: Inappropriate ioctl for device
>> VIDIOCPWCSSHUTTER: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> getWhiteBalance: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>> VIDIOCPWCGAGC: Inappropriate ioctl for device
>
>
> As the names of the ioctls imply these are (were) custom pwc
> ioctls, these were added in the v4l1 days as the v4l1 api did not
> have a way to expose the desired functionality in a standard manner.
>
> Support for the v4l1 API has been removed a number of kernel releases
> ago and at the same time the pwc specific ioctls have been marked
> as deprecated. And with kernel 3.2 they have finally been removed.
>
> The same results can be achieved with the standard v4l2
> VIDIOC_S_CTRL and VIDIOC_G_CTRL ioctls. I'm sorry to hear that the
> removal of the custom pwc ioctls is causing problems for you, but
> we really don't want to have any unneeded driver specific ioctls
> with v4l2 devices.
>
> So the qastrocam-g2 program needs to be modified to use the standard
> controls interface to modify these settings on newer kernels.
>
> Can you please send a bug report to qastrocam-g2 about this and add
> me in the CC ?
>
> Thanks,
>
> Hans
