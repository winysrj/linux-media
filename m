Return-path: <linux-media-owner@vger.kernel.org>
Received: from b-painless.mh.aa.net.uk ([81.187.30.52]:44188 "EHLO
        b-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdBFPCn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 10:02:43 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net> <20170203165909.65aa0e35@vento.lan>
 <f68d1a05-60e2-48eb-52c1-401cfeccd45e@destevenson.freeserve.co.uk>
 <20170206103716.0a105069@vento.lan>
Cc: Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Message-ID: <c2dbdb5f-6e1b-f181-7cf3-260c926573c4@destevenson.freeserve.co.uk>
Date: Mon, 6 Feb 2017 15:01:53 +0000
MIME-Version: 1.0
In-Reply-To: <20170206103716.0a105069@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro.

Can I just say that I'm not attempting to upstream this, others are. 
I've just answered questions raised.

On 06/02/17 12:37, Mauro Carvalho Chehab wrote:
> Em Sun, 5 Feb 2017 22:15:21 +0000
> Dave Stevenson <linux-media@destevenson.freeserve.co.uk> escreveu:
>
>
> If the goal was to protect some IP related to the sensors, I guess
> this is not going to protect anything, as there are recent driver
> submissions on linux-media for the ov5647 driver:
>
> https://patchwork.kernel.org/patch/9472441/
>
> There are also open source drivers for the Sony imx219 camera
> floating around for android and chromeOS:
>
> 	https://chromium.googlesource.com/chromiumos/third_party/kernel/+/factory-ryu-6486.14.B-chromeos-3.14/drivers/media/i2c/soc_camera/imx219.c
> 	https://android.googlesource.com/kernel/bcm/+/android-bcm-tetra-3.10-lollipop-wear-release/drivers/media/video/imx219.c
>
> Plus, there's a datasheet (with another driver) available at:
> 	https://github.com/rellimmot/Sony-IMX219-Raspberry-Pi-V2-CMOS
>
> So, you're not really protecting IP here.

None of the ISP processing, control loops, or tuning are open.
Yes there are kernel drivers kicking around for OV5647 and IMX219 now, 
but very little will consume raw Bayer.
That is also Omnivision or Sony IP, not Broadcom IP.

> If the goal is to protect some proprietary algorithm meant to enhance
> the camera captured streams, doing things like (auto-focus, auto-white
> adjustments, scaling, etc), and/or implementing codec encoders, you should,
> instead, restructure such codecs as mem2mem V4L2 drivers. There are a bunch
> of such codecs already for other SoC where such functions are implemented
> on GPU.
>
> If you add DMABUF capabilities and media controller to the capture
> driver and to the mem2mem drivers, userspace can use the V4L2 APIs
> to use those modules using the arrangements they need, without
> performance impacts.
>
> So, by obfuscating the code, you're not protecting anything. Just making
> harder for RPi customers to use, as you're providing a driver that is
> limited.
>
>>

<snip>

>>> Greg was kick on merging it on staging ;) Anyway, the real review
>>> will happen when the driver becomes ready to be promoted out of
>>> staging. When you address the existing issues and get it ready to
>>> merge, please send the patch with such changes to linux-media ML.
>>> I'll do a full review on it by then.
>>
>> Is that even likely given the dependence on VCHI? I wasn't expecting
>> VCHI to leave staging, which would force this to remain too.
>
> I didn't analyze the VCHI driver. As I said before, if you rewrite
> the driver in a way that the Kernel can actually see the sensors
> via an I2C interface, you probably can get rid of the VCHI interface
> for the capture part.
>
> You could take a look on the other mem2mem drivers and see if are
> there some way to provide an interface for the GPU encoders in a
> similar way to what those drivers do.

I will be looking at a sub dev driver for just the CCP2/CSI1/CSI2 
receiver as Broadcom did manage to release (probably unintentionally) a 
bastardised soc-camera driver for it and therefore the info is in the 
public domain.

It would be possible to write a second sub dev driver that was similar 
to this in using VCHI/MMAL to create another mem2mem device to wrap the 
ISP, but that would just be an image processing pipe - control loops 
would all be elsewhere (userspace).
I haven't seen a sensible mechanism within V4L2 for exporting image 
statistics for AE, AWB, AF, or histograms to userspace so that 
appropriate algorithms can be run there. Have I missed them, or do they 
not exist?

<snip>

>>>
>>> That seems a terrible hack! let the user specify the resolution via
>>> modprobe parameter... That should depend on the hardware capabilities
>>> instead.
>>
>> This is sitting on top of an OpenMaxIL style camera component (though
>> accessed via MMAL - long story, but basically MMAL removed a bundle of
>> the ugly/annoying parts of IL).
>> It has the extension above V1.1.2 that you have a preview port, video
>> capture port, and stills capture port. Stills captures have additional
>> processing stages to improve image quality, whilst video has to maintain
>> framerate.
>
> I see.
>
>> If you're asked for YUV or RGB frame, how do you choose between video or
>> stills? That's what is being set with these parameters, not the sensor
>> resolution. Having independent stills and video processing options
>> doesn't appear to be something that is supported in V4L2, but I'm open
>> to suggestions.
>
> At the capture stage:
>
> Assuming that the user wants to use different resolutions for video and
> stills (for example, you're seeing a real time video, then you "click"
> to capture a still image), you can create two buffer groups, one for
> low-res video and another one for high-res image. When the button is
> clicked, it will stop the low-res stream, set the parameters for the
> high-res image and capture it.
>
> For post-processing stage:
>
> Switch the media pipeline via the media controller adding the post
> processing codecs that will enhance the image.
>
> We're discussing for a while (and there are patches floating around)
> ways to improve it via the request API (with would allow different
> configs to be ready to be use allowing to switch between those
> settings in an atomic way, reducing the time to switch from different
> configs).
>
>> There were thoughts that they could be exposed as different /dev/videoN
>> devices, but that then poses a quandry to the client app as to which
>> node to open, so complicates the client significantly. On the plus side
>> it would then allow for things like zero shutter lag captures, and
>> stills during video, where you want multiple streams (apparently)
>> simultaneously, but is that worth the complexity? The general view was no.
>
> IMHO, that's the best option if you want to give flexibility to
> user apps. Those that don't want/need it, could just setup the
> pipeline via media-ctl and use any V4L application to get images from
> a single /dev/videoN devnode; those that want complex setups could use
> multiple /dev/videoN nodes.

All this provides wonderful flexibility, but most apps don't care or 
want to get involved in media-ctl. If opening /dev/video0 doesn't give 
them images then they won't change it, and will claim that the platform 
is broken.
How do you address those users?

>>
>>>> +
>>>> +/* Gstreamer bug https://bugzilla.gnome.org/show_bug.cgi?id=726521
>>>> + * v4l2src does bad (and actually wrong) things when the vidioc_enum_framesizes
>>>> + * function says type V4L2_FRMSIZE_TYPE_STEPWISE, which we do by default.
>>>> + * It's happier if we just don't say anything at all, when it then
>>>> + * sets up a load of defaults that it thinks might work.
>>>> + * If gst_v4l2src_is_broken is non-zero, then we remove the function from
>>>> + * our function table list (actually switch to an alternate set, but same
>>>> + * result).
>>>> + */
>>>> +static int gst_v4l2src_is_broken;
>>>> +module_param(gst_v4l2src_is_broken, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>>>> +MODULE_PARM_DESC(gst_v4l2src_is_broken, "If non-zero, enable workaround for Gstreamer");
>>>
>>> Not sure if I liked this hack here. AFAIKT, GStreamer fixed the bug with
>>> V4L2_FRMSIZE_TYPE_STEPWISE already.
>>
>> I will double check on Monday. The main Raspberry Pi distribution is
>> based on Debian, so packages can be quite out of date. This bug
>> certainly affected Wheezy, but I don't know for certain about Jessie.
>> Sid still hasn't been adopted.
>
> Well, at the RPi distro, the best would be to backport the gst patches
> that fixed the bug instead, as it would affect other V4L2 hardware
> connected via USB too.

I have yet to see a USB webcam that claims to support 
V4L2_FRMSIZE_TYPE_STEPWISE.
Any camera that claimed V4L2_FRMSIZE_TYPE_DISCRETE was fine.

>> Also be aware that exactly the same issue of not supporting
>> V4L2_FRMSIZE_TYPE_STEPWISE affects Chromium for WebRTC, and they seem
>> not to be too bothered about fixing it -
>> https://bugs.chromium.org/p/chromium/issues/detail?id=249953
>> Now admittedly it's not the kernel's responsibility to work around
>> application issues, but if it hobbles a board then that is an issue.
>
> Those lazy maintainers... :-)

It's the downside of it only affecting a very few cameras - it makes the 
priority pretty low to fix them.

<snip>

>>>> +	for (k = 0; k < ARRAY_SIZE(formats); k++) {
>>>> +		fmt = &formats[k];
>>>> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	if (k == ARRAY_SIZE(formats))
>>>> +		return NULL;
>>>
>>> Again, doesn't the formats depend on the camera sensor module?
>>
>> Not in this case.
>> You're at the end of a full ISP processing pipe, and there is the option
>> for including either JPEG, MJPEG, or H264 encoding on the end. It is
>> supported to ask the camera component which formats it supports, but
>> you'll still need a conversion table from those MMAL types to V4L2
>> enums, and options for adding the encoded formats.
>
> The better would be to split those GPU encoders on a mem2mem driver.
> This way, if all the userspace want is the raw images, they can
> get it without passing though a GPU pipeline.

Raw Bayer images are not available from this driver, therefore anything 
has to go through some level of GPU pipe.

> The big problem here is that the user doesn't really know what
> formats are produced by the camera from those that are post-processed.
>
> On applications that require low latency, that could have a big
> impact. For example, if someone is using a RPi on a robot or on
> a self-piloted drone, the lowest latency the better.

mem2mem devices would be actually INCREASING the latency.
The GPU solution is currently starting to process the Bayer frame as it 
comes in from the sensor, so the last line of the fully processed YUV 
image is typically available about 4ms after the frame end.
V4L2 appears not to have a mechanism to pass stripes down the line, so 
the ISP can't start on the frame until the frame end. Please correct me 
if I'm wrong.


And with all due respect, how many apps actually set up a chain of V4L2 
devices?
The majority of users just want to get images. The framework may offer 
all the bells and whistles, but if they're too complex to use then most 
clients ignore them.
The majority of users seem to just pick up off-the-shelf apps and expect 
them to work off /dev/video0.

<snip>

>>>> +					 (int)dev->capture.kernel_start_ts.
>>>> +					 tv_sec,
>>>> +					 (int)dev->capture.kernel_start_ts.
>>>> +					 tv_usec,
>>>> +					 dev->capture.vc_start_timestamp, pts,
>>>> +					 (int)timestamp.tv_sec,
>>>> +					 (int)timestamp.tv_usec);
>>>> +				buf->vb.vb2_buf.timestamp = timestamp.tv_sec * 1000000000ULL +
>>>> +					timestamp.tv_usec * 1000ULL;
>>>
>>> Not sure if I understood the above logic... Why don't you just do
>>> 	buf->vb.vb2_buf.timestamp = ktime_get_ns();
>>
>> What's the processing latency through the ISP and optional
>> H264/MJPG/JPEG encode to get to this point? Typically you're looking at
>> 30-80ms depending on exposure time and various other factors, which
>> would be enough to put A/V sync out if not compensated for.
>>
>> The GPU side is timestamping all buffers with the CSI frame start
>> interrupt timestamp, but based on the GPU STC. There is a MMAL call to
>> read the GPU STC which is made at streamon (stored in
>> dev->capture.vc_start_timestamp), and therefore this is taking a delta
>> from there to get a more accurate timestamp.
>
> Ah, so this is due to the extra latency introduced by GPU.

To account for processing time, yes.
The spec says timestamp is meant to be
"For capture streams this is time when the first data byte was captured, 
as returned by the clock_gettime()"
so that is what you're getting.

>> (An improvement would be to reread it every N seconds to ensure there
>> was no drift, but the Linux kernel tick is actually off the same clock,
>> so it is only clock corrections that would introduce a drift).
>> As I understand it UVC is doing a similar thing, although it is trying
>> to compensate for clock drift too.
>
> What happens when daylight saving time changes is applied? Will it
> indicate an one hour latency?

I was expecting nothing.
 From the man page for clock_gettime()
CLOCK_MONOTONIC
        Clock that cannot be set and represents monotonic time since
        some unspecified starting point.  This clock is not affected
        by discontinuous jumps in the system time (e.g., if the system
        administrator manually changes the clock), but is affected by
        the incremental adjustments performed by adjtime(3) and NTP.
Isn't daylight savings time a discontinuous jump in system time, so 
shouldn't affect CLOCK_MONOTONIC? Or is it going to slew the clock until 
it accounts for it?
If slewed then rereading every N seconds would compensate.

>> Now one could argue that ideally you want the timestamp for the start of
>> exposure, but there is no event outside of the sensor to trigger that.
>> You could compute it, but the exposure time control loop is running on
>> the GPU so the kernel doesn't know the exposure time. It's also a bit of
>> a funny thing anyway when dealing with rolling shutter sensors and
>> therefore considering which line you want the start of exposure for.

Rereading the spec for the struct v4l2_buffer timestamp field I see that 
it is specified as the first byte, so the implementation is correct.

<snip>

>>>
>>> It seems that you're fixing the bug at the steps used by
>>> v4l_bound_align_image() by rounding up the buffer size. That's wrong!
>>> Just ensure that the width/height will be a valid resolution and
>>> remove this hack.
>>
>> No, this is working around the fact that very few clients respect
>> bytesperline (eg QV4L2 and libv4lconvert for many of the formats).
>
> If you find a bug on any clients that we maintain (qv4l2, libv4l,
> tvtime, xawtv), please submit us a patch. If this issue was fixed
> when you noticed (in 2013, as you're saying below), then we wouldn't
> need to concern about it nowadays ;)

You may fix your maintained apps (or request patches to fix them), but 
there are so many others that aren't supported by yourselves.
Memory says that those weren't the specific apps I was needing to get 
working back in 2013, I've only observed the issues in the last week as 
I was trying to remove this nastiness.

I do have patches for libv4lconvert to handle VYUY (the only one of the 
YUYV family that wasn't supported) and also NV12/NV21. They should both 
handle bytesperline correctly as well.
I'll double check them and submit it soon.

>> The ISP needs to be writing to buffers with the stride being a multiple
>> of 32, and height a multiple of 16 (and that includes between planes of
>> YUV420). V4L2 appears not to allow that, therefore there is then a
>> second operation run in-place on the buffer to remove that padding, but
>> the buffer needs to be sized sufficiently to handle the padded image first.
>>
>> I had a conversation with Hans back in 2013 with regard this, and there
>> wasn't a good solution proposed. It could potentially be specified using
>> the cropping API, but that pushes the responsibility back onto every
>> client app to drive things in a very specific manner. If they don't
>> respect bytesperline they are even less likely to handle cropping.
>> You could restrict the resolution to being a multiple of 32 on the width
>> and 16 on the height, but in doing so you're not exposing the full
>> capabilities.
>>
>> I'm open to suggestions as to how V4L2 can do this without just beating
>> up client apps who do the wrong thing.
>>
>> Multiplanar formats seem not to be an option as the ISP is expecting one
>> contiguous buffer to be provided to take all the planes, but the
>> multiplanar stuff supplies multiple independent buffers. Again please
>> correct me if I'm wrong on that.
>
> Not sure if I fully understand what happens there... Does it add
> alignment pads in the middle of the image, or just at the end of
> the buffer? If such pads are added in the middle of the image, it
> is actually violating the fourcc formats, as they're not meant to
> have PADs inside it.

Example of a YUV420 image with 636x478 (ie just under VGA, and not nice 
multiples).
For the hardware, bytesperline needs to be a multiple of 32, so 640 (and 
would be left at that if every possible client observed bytesperline).
The height has to be a multiple of 16, so 480. The buffer is then:
640x480 = 307200 bytes of Y
320x240 = 76800 bytes of U
320x240 = 76800 bytes of V.
460800 bytes total.

So yes, there are 640*2 bytes of padding between the Y&U, and 320*1 
bytes between U&V. That is indeed violating the fourcc for 
V4L2_PIX_FMT_YUV420, therefore the GPU is memcpying the U & V planes to 
remove it. The buffer is allocated at 460800 bytes so that it is large 
enough to take the padded image before being copied. bytesused in the 
v4l2_buffer struct should be correctly set to 636*478*1.5 = 456012 bytes.
When the bytesperline isn't a multiple of 32 then the GPU is memcpying 
line by line to remove the padding on the end of each line as clients 
ignore it.
It's a painful operation, but if the framework has no mechanism to deal 
with that then it is necessary.


<snip>

>>>> +	/* format dependant port setup */
>>>> +	switch (mfmt->mmal_component) {
>>>> +	case MMAL_COMPONENT_CAMERA:
>>>> +		/* Make a further decision on port based on resolution */
>>>> +		if (f->fmt.pix.width <= max_video_width
>>>> +		    && f->fmt.pix.height <= max_video_height)
>>>> +			camera_port = port =
>>>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>>>> +			    output[MMAL_CAMERA_PORT_VIDEO];
>>>> +		else
>>>> +			camera_port = port =
>>>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>>>> +			    output[MMAL_CAMERA_PORT_CAPTURE];
>>>
>>> Not sure if I got this... What are you intending to do here?
>>
>> As noted above, what do you consider a still when dealing with raw RGB
>> or YUV buffers. This is switching between video and stills quality
>> processing based on resolution.
>
> That sounds an ugly hack. Unlikely to be accepted upstream.

I'm not the one trying to upstream this ;-)

<snip>

>>>> +static int set_camera_parameters(struct vchiq_mmal_instance *instance,
>>>> +				 struct vchiq_mmal_component *camera,
>>>> +				 struct bm2835_mmal_dev *dev)
>>>> +{
>>>> +	int ret;
>>>> +	struct mmal_parameter_camera_config cam_config = {
>>>> +		.max_stills_w = dev->max_width,
>>>> +		.max_stills_h = dev->max_height,
>>>> +		.stills_yuv422 = 1,
>>>> +		.one_shot_stills = 1,
>>>> +		.max_preview_video_w = (max_video_width > 1920) ?
>>>> +						max_video_width : 1920,
>>>> +		.max_preview_video_h = (max_video_height > 1088) ?
>>>> +						max_video_height : 1088,
>>>
>>> Hmm... why do you need to limit the max resolution to 1920x1088? Is it
>>> a limit of the MMAL/firmware?
>>
>> Memory usage.
>> Video mode runs as an optimised pipeline so requires multiple frame buffers.
>> Stills mode typically has to stop the sensor, reprogram for full res
>> mode, stream for one frame, and then stops the sensor again, therefore
>> only one stills res buffer is required.
>> If you've specified video mode to run at more than 1080P, then the GPU
>> needs to be told up front so that it can allocate the extra memory.
>
> I see. One additional reason why it would be good if the capture
> driver could run independently from GPU. That way, only the
> encoding codecs would have such restriction.

No, the ISP would have that limitation.

   Dave


