Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZDPJVq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 05:21:46 -0400
Message-ID: <49E6F972.5070309@redhat.com>
Date: Thu, 16 Apr 2009 11:25:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gilles Gigan <gilles.gigan@gmail.com>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl> <78877a450904152316s7fb3282m9ac9374a52877ecb@mail.gmail.com>
In-Reply-To: <78877a450904152316s7fb3282m9ac9374a52877ecb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/16/2009 08:16 AM, Gilles Gigan wrote:
> Hans,
> I have tested libv4lconvert with a PCI hauppauge hvr1300 DVB-T and
> found that v4lconvert_create() returns NULL. The problem comes from
> the shm_open calls in v4lcontrol_create() in libv4lcontrol.c (lines
> 187&  190). libv4lconvert constructs the shared memory name based on
> the video device's name. And in this case the video device's name
> (literally "Hauppauge WinTV-HVR1300 DVB-T/H") contains a slash, which
> makes both calls to shm_open() fail. I can put together a quick patch
> to replace '/' with '-' or white spaces if you want.
> Gilles
>

Hi,

Thanks for reporting this! Can you please test the attached patch to see if it
fixes this?

Thanks,

Hans


>
> On Wed, Apr 15, 2009 at 10:36 PM, Hans de Goede<j.w.r.degoede@hhs.nl>  wrote:
>> Hi All,
>>
>> As the version number shows this is a beta release of the 0.6.x series,
>> the big change here is the addition of video processing to libv4l
>> currently this only does whitebalance and normalizing (which turns out
>> to be useless for most cams) but the basic framework for doing video
>> processing, and being able to control it through fake v4l2 controls using
>> for example v4l2ucp is there.
>>
>> Currently only whitebalancing is enabled and only on Pixarts (pac) webcams
>> (which benefit tremendously from this). To test this with other webcams
>> (after instaling this release) do:
>>
>> export LIBV4LCONTROL_CONTROLS=15
>> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>>
>> Notice the whitebalance and normalize checkboxes in v4l2ucp,
>> as well as low and high limits for normalize.
>>
>> Now start your favorite webcam viewing app and play around with the
>> 2 checkboxes. Note normalize seems to be useless in most cases. If
>> whitebalancing makes a *strongly noticable* difference for your webcam
>> please mail me info about your cam (the usb id), then I can add it to
>> the list of cams which will have the whitebalancing algorithm (and the v4l2
>> control to enable/disable it) enabled by default.
>>
>> Unfortunately doing videoprocessing can be quite expensive, as for example
>> whitebalancing is quite hard todo in yuv space, so doing white balancing
>> with the pac7302, with an apps which wants yuv changes the flow from
>> pixart-jpeg ->  yuv420 ->  rotate90
>> to:
>> pixart-jpeg ->  rgb24 ->  whitebalance ->  yuv420 ->  rotate90
>>
>> This is not a problem for cams which deliver (compressed) raw bayer,
>> as bayer is rgb too, so I've implemented a version of the whitebalancing
>> algorithm which operates directly on bayer data, so for bayer cams
>> (like the pac207) it goes from:
>> bayer->  yuv
>> to:
>> bayer ->  whitebalance ->  yuv
>>
>> For the near future I plan to change the code so that the analyse phase
>> (which does not get done every frame) creates per component look up tables,
>> this will make it easier to stack multiple "effects" in one pass without
>> special casing it as the current special normalize+whitebalance in one
>> pass code. Then we can add for example gamma correction with a negligible
>> performance impact (when already doing white balancing that is).
>>
>>
>> libv4l-0.5.97
>> -------------
>> * As the version number shows this is a beta release of the 0.6.x series,
>>   the big change here is the addition of video processing to libv4l
>>   currently this only does whitebalance and normalizing (which turns out
>>   to be useless for most cams) but the basic framework for doing video
>>   processing, and being able to control it through fake v4l2 controls using
>>   for example v4l2ucp is there.
>>   The initial version of this code was written by 3 of my computer science
>>   students: Elmar Kleijn, Sjoerd Piepenbrink and Radjnies Bhansingh
>> * Currently whitebalancing gets enabled based on USB-ID's and it only gets
>>   enabled for Pixart webcam's. You can force it being enabled with other
>>   webcams by setting the environment variable LIBV4LCONTROL_CONTROLS, this
>>   sets a bitmask enabling certain v4l2 controls which control the video
>>   processing set it to 15 to enable both whitebalancing and normalize. You
>>   can then change the settings using a v4l2 control panel like v4l2ucp
>> * Only report / allow supported destination formats in enum_fmt / try_fmt /
>>   g_fmt / s_fmt when processing, rotating or flipping.
>> * Some applications / libs (*cough* gstreamer *cough*) will not work
>>   correctly with planar YUV formats when the width is not a multiple of 8,
>>   so crop widths which are not a multiple of 8 to the nearest multiple of 8
>>   when converting to planar YUV
>> * Add dependency generation to libv4l by: Gilles Gigan
>> <gilles.gigan@gmail.com>
>> * Add support to use orientation from VIDIOC_ENUMINPUT by:
>>   Adam Baker<linux@baker-net.org.uk>
>> * sn9c20x cams have occasional bad jpeg frames, drop these to avoid the
>>   flickering effect they cause, by: Brian Johnson<brijohn@gmail.com>
>> * adjust libv4l's upside down cam detection to also work with devices
>>   which have the usb interface as parent instead of the usb device
>> * fix libv4l upside down detection for the new v4l minor numbering scheme
>> * fix reading outside of the source memory when doing yuv420->rgb conversion
>>
>>
>> Get it here:
>> http://people.atrpms.net/~hdegoede/libv4l-0.5.97.tar.gz
>>
>> Regards,
>>
>> Hans
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
