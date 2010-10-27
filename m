Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0J0JEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 05:04:33 -0400
Message-ID: <4CC7EC13.1080008@redhat.com>
Date: Wed, 27 Oct 2010 11:08:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mitar <mmitar@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Too slow libv4l MJPEG decoding with HD cameras
References: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com>
In-Reply-To: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 10/27/2010 01:51 AM, Mitar wrote:
> Hi!
>
> On Sun, Oct 24, 2010 at 6:04 PM, Mitar<mmitar@gmail.com>  wrote:
>> Has anybody tried to improve MJPEG support in libv4l? With newer
>> cameras this becomes important.
>
> I have made a patch which makes libv4l uses ffmpeg's avcodec library
> for MJPEG decoding. Performance improvements are unbelievable.
>

Thanks for the patch!

> I have been testing with Logitech HD Pro Webcam C910 and
> 2.6.36-rc6-amd64 and Intel(R) Core(TM)2 Quad CPU Q9400 @ 2.66GHz.
> Camera supports 2592x1944 at 10 FPS MJPEG stream.
>
> With using original MJPEG code it takes my computer on average 129.614
> ms to decode the frame what is 0.0257 us per pixel.
>
> With using ffmpeg MJPEG decoding it takes my computer on average
> 43.616 ms to decode the frame what is 0.0087 us per pixel.

That is a great improvement, but using ffmpeg in libv4l is not an option
for multiple reasons:

1) It is GPL licensed not LGPL
2) It has various other legal issues which means it is not available
    in most distro's main repository.

So I'm afraid that using ffmpeg really is out of the question. What
would be interesting is to see how libjpeg performs and then esp. the
turbo-libjpeg version:
http://libjpeg-turbo.virtualgl.org/

I would love to see a patch to use that instead of tiny jpeg, leaving
tinyjpeg usage only for the pixart jpeg variant stuff.

Note that some cameras generate what I call planar jpeg, this means
that they send 3 SOS markers with one component per scan. I don't know
if libjpeg will grok this (I had to patch libv4l's tinyjpeg copy for
this). But first lets see how libjpeg performs, and then we can always
use tinyjpeg to parse the header and depending on the header decide to
use tinyjpeg or libjpeg.

Sorry about nacking your ffmpeg patch, I hope that you are willing to
do a patch to switch to libjpeg, as I'm afraid I currently don't have
time to look into this.

Oh and a hint when using libjpeg for in memory images, please
use the jpeg_mem_src code from here:
http://gphoto.svn.sourceforge.net/viewvc/gphoto/branches/libgphoto2-2_4/libgphoto2/camlibs/ax203/jpeg_memsrcdest.c?revision=13328&view=markup

This code was specifically written to be API compatible with the
one introduced in newer libjpeg versions (8), while providing
memory src support when working with libjpeg versions which
do not ship with a memory src themselves like the version 6b
shipped by most distros (and used as a basis for libjpeg turbo).

So by using this memory src code, the libv4l libjpeg support can
work with libjpeg6-8 and libjpeg-turbo without needing any
ifdef's other then the one in that .c file.

Thanks & Regards,

Hans
