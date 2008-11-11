Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABB4h4S019684
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 06:04:43 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABB4VL7026569
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 06:04:31 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<874p2fkwh5.fsf@free.fr>
	<Pine.LNX.4.64.0811110834140.4565@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 11 Nov 2008 12:04:29 +0100
In-Reply-To: <Pine.LNX.4.64.0811110834140.4565@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	11 Nov 2008 09\:18\:41 +0100 \(CET\)")
Message-ID: <87k5bar0aq.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
	synthesized formats
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> Isn't that the second time you're looking for a format the same way, with only a
>> printk making a difference ? Shouldn't that be grouped in a function
>> (pxa_camera_find_format(icd, pixfmt) ?) ...
>
> No, the real difference between them is the comment:
>
> +					/* TODO: synthesize... */
True. But the 30 or so lines of code are the same. I still think this should be
in a unique function, doing translation or not (think function parameter here).

>> More globally, all camera hosts will implement the creation of this formats
>> table.
>
> That's what I am not sure about
>
>> Why did you choose to put that in pxa_camera, and not in soc_camera to
>> make available to all host drivers ?
>> I had thought you would design something like :
>> 
>>  - soc_camera provides a format like :
>> 
>> struct soc_camera_format_translate {
>>        u32 host_pixfmt;
>>        u32 sensor_pixfmt;
>> };
>> 
>>  - camera host provide a static table like this :
>> struct soc_camera_format_translate pxa_pixfmt_translations[] = {
>>        { V4L2_PIX_FMT_YUYV, V4L2_PIX_FMT_YUYV },
>>        { V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_UYVY },
>>        ...
>>        { V4L2_PIX_FMT_YUV422P, V4L2_PIX_FMT_UYVY},
>> };
>
> Hm, I don't think you want to list all possible formats you can pull 
> through this camera host. AFAIU, camera hosts can transfer data from 
> cameras to destination (memory / framebuffer / output device...) in three 
> ways:
Oh yes, you should list them all : that's what you'll end up doing once the
function format_supported() is fully implemented anyway, wouldn't you ?
format_supported() will compare a list of known formats to the sensor output
formats, and keep only known ones (ie. drop RGB32, or YUV 4:2:0, etc ...)

> 1. generic: just pack what appears on the camera bus in output buffers. 
> Only restrictions here are bus-width, frame-size...
>
> 2. 1-to-1: like pxa packed support for YUV / RGB. You get the same format 
> on the output as on input, but re-packed, maybe scaled / rotated / 
> otherwise transformed.
>
> 3. translated: like pxa UYUV to YUV422P - a different format on output 
> than on input.
>
> So far we only supported 1 and 2. For which we just used pixel format 
> tables provided by the camera-sensor. But the easiest case is 1, this is 
> what we currently use for Bayer and monochrome formats. And you do not 
> want to create a table like above of all possible formats for each host 
> that supports it. That's why I create two tables per device - one for 
> sensor-native formats we just pass 1-to-1, and one list for synthesised 
> formats.
>
> For 1 and 2 we now export soc_camera_format_by_fourcc() (see 
> sh_mobile_ceu_camera.c). For hosts only supporting these two modes, we can 
> provide a default .enum_fmt(), maybe .set_fmt().
>
> For 3 - as I wrote, camera supported pixel formats seem to be statis, and 
> I just think, that SoC designers are a little bit more creative than CMOS 
> camera designers, so that creating a generic approach might be too 
> difficult.
>
> In any case, in the beginning I put quite a lot of functionality in 
> soc_camera.c. Now we notice, that we need more and more special-casing, 
> and the functionality is migrating into respective camera or host drivers. 
> Now I'd like to avoid this. Instead of guessing how to support "all" 
> hosts, I would first implement functionality inside host drivers, and 
> then, if there is too much copy-paste, extract it into common code. Yes, 
> this approach has its disadvantages too...
Yes, amongst them let loose coders of each host ...
>
> Also, a probably better approach than what you suggested above (if I 
> understood it right) would be not to use a static translation table, but 
> to generate one dynamically during .add() and have them per-device, not 
> per-host.
The translation table will be per-host static (it's hardwired in the chip), but
the generated supported formats will be dynamically generated by the host on
sensor attachment (ie. computed), and for each device.

>> Is there a reason you chose to fully export the formats computation to hosts ?
>
> In short: I'd prefer to first keep this in pxa-camera, and then see as new 
> host drivers arrive, whether we can make portions of the code generic. 
> Makes sense?
I understand your thinking. I don't think it's the good way to go, but you're
the maintainer, you decide. We'll see soon enough, once TI and Qualcomm embedded
devices will be enough documented, who was right.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
