Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63748 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFXxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 18:53:07 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so1120273eei.35
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 15:53:04 -0800 (PST)
Message-ID: <5112ECDD.6080004@gmail.com>
Date: Thu, 07 Feb 2013 00:53:01 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Alexander Nestorov <alexandernst@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Hi again
References: <CACuz9s2w28eVG8qS9FXkUYAggXn7y2deHi2fPGizcURu_Bp4wg@mail.gmail.com> <50D30F6C.7000004@gmail.com> <CACuz9s1_KKfVDCa4FvZLe9pEVWuqQzuLPX7pYX9Tw1NUQGPtzA@mail.gmail.com> <CACuz9s1waQ3VgRjdxw9CoiHX2BtfOaxTosqLDwhX+O7px0=JXg@mail.gmail.com> <50D31BF8.8040301@gmail.com> <CACuz9s3xtCndC2jks4T-ytSWxwTBjLbXUrehEtsNwm7H=wJC1Q@mail.gmail.com> <50D31F63.6090304@gmail.com> <CACuz9s06v5nXNze+AAZyPTyxib4OXmqRi9E_Hw4SqBoprym0UA@mail.gmail.com> <50D85D93.7060201@gmail.com> <CACuz9s19ssgPkVM3fB+3JQ5EOp9rTTOncaZro_rA=4c98DJGZQ@mail.gmail.com> <CACuz9s1Bs4W8Nq_2R3uMQn4dJVahtrqWhfEAVH1PGwguZWALEA@mail.gmail.com> <50E081DE.5070208@gmail.com> <CACuz9s30Om4DTqy8=VVQma=+GEC0=vmbK_n1+ic4v6YiCfdYQQ@mail.gmail.com> <50E359D2.4080105@gmail.com> <CACuz9s3_+MsDcwNdPeyaTaPC3zvknCe0sZ6vGCENUcQdfz6ZJg@mail.gmail.com> <5109A415.8090300@gmail.com> <CACuz9s3nrTYsSvDSecV3OO4U22DmEVynmixkkJ6BQX83smNL1A@mail.gmail.com> <CACuz9s2MwexhTuNYf2rN5QSaN=Q0FZ2qJXK2Ud7ytkr-rUoQ6w@mail.gmail.com>
In-Reply-To: <CACuz9s2MwexhTuNYf2rN5QSaN=Q0FZ2qJXK2Ud7ytkr-rUoQ6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexander,

Thanks for the update ;)

On 02/05/2013 11:50 PM, Alexander Nestorov wrote:
> Hi Sylwester :)
>
>
> I have been working wth 2 guys from Collabora (company behind
> GStreamer/Farstream) and there has been
> some progress.
>
> We saw that if I run gst-launch v4l2src ! dfbvideosink (without any
> caps) then gstreamer won't show anything at all.
> But as soon as I force caps, like v4l2src !
> video/x-raw-rgb,width=XXX,height=YYY,bpp=16 ! dfbvideosink everything
> starts working.
>
> Same way, if I launch my Farstream app without any parameters, it
> crashes. But if I specify bpp and depth then
> it starts working.
>
> I don't want to confuse you so I'll copy exactly what one of the guys said:
>
> [23:02]<alexandernst_>  KaKaRoTo: I have another question regarding
> the CMOS and the caps "hack"
> [23:03]<alexandernst_>  we're setting bpp and depth because the driver
> isn't returning: a) anything at all  b) invalid values  c) ???
> [23:06]<KaKaRoTo>  alexandernst_, because the driver is reporting big
> endian for 16 bits, and it could easily be a gstreamer issue not
> supporting big endian 16bits rgb.. or the driver is reporting the
> endianness wrong...
> [23:06]<KaKaRoTo>  alexandernst_, the other reason is because the
> driver isn't giving us the capabilities of the CMOS, so we don't knowh

Yes, the driver doesn't implement VIDIOC_ENUM_FRAMESIZES ioctl at
/dev/video? device node. These parameters are supposed to be retrieved
by a driver-specific plugin at the libv4l [1] (it still don't exists
yet..) library. And applications (e.g. v4l2src) should use v4l2_* calls
from this library, rather than plain ioctl(). Until the plugin for the
s3c-camif driver (or a generic Media Controller plugin) is added to
libv4l there is no way v4l2src can query the list of supported resolutions
by the CMOS sensor. Well, it could be hacked in the driver, but I don't
want to do that. I could send you a patch for your own use if you wish,
and if I find some time to write it. ;)

> which resolutions it supports, so we're forced to manually setting it,
> otherwise it tries to do 2048x4096 and it doesn't work..

This looks suspicious, let me check it...

Hmm, no, its GStreamer that forces the s3c-camif driver to use its maximum
supported resolution at /dev/video?.

root@mini2440:~ v4l2-ctl -d /dev/video0 --all
Driver Info (not using libv4l2):
         Driver name   : s3c-camif
         Card type     : s3c-camif
         Bus info      : platform:s3c2440-camif.0
         Driver version: 3.8.0
         Capabilities  : 0x84000001
                 Video Capture
                 Streaming
                 Device Capabilities
         Device Caps   : 0x04000001
                 Video Capture
                 Streaming
Format Video Capture:
         Width/Height  : 1280/1024
         Pixel Format  : '422P'
         Field         : None
         Bytes per Line: 1280
         Size Image    : 614400
         Colorspace    : JPEG (JFIF/ITU601)
Selection: compose, Left 0, Top 0, Width 1280, Height 1024
Selection: compose_default, Left 0, Top 0, Width 1280, Height 1024
Selection: compose_bounds, Left 0, Top 0, Width 1280, Height 1024
Video input : 0 (OV9650: ok)
Priority: 2

The default resolution is 1280/1024.

The problem is that there is not enough memory in your system to allocate
all 2048x4096 buffers (it's 16 MB each, 2 bytes per pixel for 422P format).
The driver doesn't enforce any policy on memory allocation, i.e. there is
no limit in the driver. I could add some module parameter for that if
required. But in general it's the v4l2 memory allocator that should return
an allocation error and it should be propagated up to v4l2 videobuf2 layer
and to GStreamer (e.g. through VIDIOC_REQBUFS ioctl).

IIRC there were some issues in the videobuf2 about reporting memory
allocation errors back to user space. Not sure if this is already fixed.
I'll investigate it and will let you know.

I have enabled debug in videobuf2 and got something like below, which
looks like something unexpected:

root@mini2440:~ echo 100 > /sys/module/videobuf2_core/parameters/debug

root@mini2440:~ gst-launch -v v4l2src device=/dev/video0 queue-size=2
  ! video/x-raw-yuv,format='(fourcc)'YV12 ! ffmpegcolorspace ! fbdevsink

root@mini2440:~ dmesg -c
[ 1907.110000] s3c-camif s3c2440-camif: dma_alloc_coherent of size 
12582912 failed
[ 1907.115000] vb2: Failed allocating memory for buffer 1

The error is ignored here, it should all fail at this point.

[ 1907.120000] vb2: Buffer 0, plane 0 offset 0x00000000
[ 1907.125000] vb2: Allocated 1 buffers, 1 plane(s) each
[ 1907.220000] vb2: Buffer 0, plane 0 successfully mapped
[ 1907.225000] vb2: qbuf of buffer 0 succeeded
[ 1907.230000] vb2: Streamon successful


> [23:07]<KaKaRoTo>  which is also why it freezes (doesn't output
> buffers) instead of giving an error when you try to set that
> resolution
>
> I made a bug report here, and there are 2 REs which might be really
> helpful: https://bugzilla.gnome.org/show_bug.cgi?id=693175
>
>
> On the other hand, I haven't noticed till now because I compile with
> -j9, but I get this when I compile the kernel:
>
> CC      drivers/media/platform/s3c-camif/camif-capture.o
> drivers/media/platform/s3c-camif/camif-capture.c: In function
> 's3c_camif_subdev_set_fmt':
> drivers/media/platform/s3c-camif/camif-capture.c:1281:25: warning:
> array subscript is below array bounds
>
> Maybe that is somehow related to the bug I'm having?

This looks like a real bug, but I doubt it is much related to your
issues as above. Thanks for reporting it. I will prepare a patch for
this for v3.9-rc.

And please note that you should set resolution and frame rate
with e.g. media-ctl tool for optimal results. The libv4l plugin
would let us to do these things from the GStreamer level.

Let me answer your previous e-mail, but can do it only tomorrow...
Need more sleeeeping... ;)

--

Regards,
Sylwester

[1] http://git.linuxtv.org/v4l-utils.git
