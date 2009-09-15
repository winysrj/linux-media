Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:59524 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZIOKN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 06:13:59 -0400
Message-ID: <4AAF68E1.9090100@cynove.com>
Date: Tue, 15 Sep 2009 12:13:53 +0200
From: =?ISO-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: RFC: V4L - Support for video timings at the input/output interface
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan a écrit :
> RFC: V4L - Support for video timings at the input/output interface
> 
> Thanks to Hans Verkuil for his initial proposal and feedbacks to help write this RFC.
> 
> Version : 1.0
> 
Thank you for this work.
I have a few questions, regarding the other parameters or existing control.

> Background
> -----------
> 
> Currently v4l2 specification supports capturing video frames from TV signals using tuners (input type V4L2_INPUT_TYPE_TUNER) and baseband TV signals (V4L2_INPUT_TYPE_CAMERA) and sensors. Similarly on the output side, the signals could be TV signal (V4L2_OUTPUT_TYPE_MODULATOR), baseband TV signal (V4L2_OUTPUT_TYPE_ANALOG) or hybrid analog VGA overlay (V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY) which output from a graphics card and
> then use chromakeying to replace part of the picture with the video. V4L2_OUTPUT_TYPE_ANALOG & V4L2_INPUT_TYPE_CAMERA are for analog interfaces that includes composite, S-Video and VGA (for output only). Note that even though VGA is a supported output, we don't have anyway to set the standard or timing on the output. Standard ids are only defined for TVs using
> v4l2_std_id and a set of bit masks  defined for analog TV standards.
> 
> Today we have a wide variety of different interfaces available to transmit/receive video or graphics content between source device and destination device. Following are some of the interfaces used in addition to the ones described in the v4l2 specification.
> 
> Component analog input/output interface - ED/HD video
> DVI - Digital only, ANALOG only, DVI integrated that support Digital and 
> 	Analog; Dual Link - Where second data link is used for higher
> 	bandwidth
> SDI - Serial digital interface standardized by SMPTE
> HDMI - HD video and Audio
> DisplayPort - digital audio/video interconnect by VESA
>
I would like to say that all capture devices are not necessary used in a 
video chain or video system.
When it comes to machine vision, resolution and image quality can be 
more interesting than timings.

---- snip ---
> /* timing data values specified by various standards such as BT.1120, BT.656 etc. */
> 
> /* bt.656/bt.1120 timing data */
> struct v4l2_bt_timings {
>     __u32 interlaced;
>     __u64 pixelclock;
>     __u32 width, height;
>     __u32 polarities;
>     __u32 hfrontporch, hsync, htotal;
>     __u32 vfrontporch, vsync, vtotal;
>     /* timings for bottom frame for interlaced formats */
>     __u32 il_vtotal;
>     __u32 reserved[16];
> };
> 
> 
> interlaced - Interlaced or progressive. use following values:-
> 
> #define V4L2_DV_INTERLACED     0
> #define V4L2_DV_PROGRESSIVE    1
> 
> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.
> width - number of pixels in horizontal direction
> height - number of lines in vertical direction
> polarities - Bit mask for following polarities to begin with
> 
> #define V4L2_DV_VSYNC_POS_POL    0x1
> #define V4L2_DV_VSYNC_NEG_POL    0x2
> #define V4L2_DV_HSYNC_POS_POL    0x3
> #define V4L2_DV_HSYNC_NEG_POL    0x4
> 
> hfrontporch,hsync, and htotal for horizontal direction and vfrontporch,vsync, and vtotal for vertical direction. il_vtotal is the number of vertical lines for interlaced video for bottom field. 
> 
> To define a particular timing type, following enum is used:-
> 
> enum v4l2_dv_timings_type {
>         V4L2_DV_BT_656_1120,
> };
> 
> This will allow adding new timing types in the future.
>

Let's say we have a CMOS sensor, with a driver implementing this various 
  timings, because the driver writer was "video oriented".
Now here comes another person, who is interested in another set of 
features :
width,
height
col_start
row_start

And he wants autoexposure and don't care about the framerate.
How does he extends the driver ?
Is there a way to set the resolution without going through a standard.
What should he do ?
Add another timing_type ?
Use the S_FMT, G_FMT, TRY_FMT ioctl ?
But then what happens when one does a G_DV_TIMINGS ?

Should a new v4l2_dv_timings_type be defined ?
But it is not a timing we are talking about, it is a geometry.

CMOS sensor presents overlapping feature sets :
Resolution + timing is one.
Resolution + windows position + exposure is another.
Resolution + zoom level is yet another

Let's say a driver is written using the VIDIOC_S/G_DV_TIMINGS.
It should be easy to use the same driver with S/G_FMT or S/G_CROP, even 
if it leads to a format you can't describe with VIDIOC_S/G_DV_TIMINGS.

I mean, we are heading to a situation where you can set :
hfrontporch, vfrontporch, htotal, vtotal.

But if you want to set :
row_start, col_start, shutter_width, bining or decimation, you have to
write some custom control.

Now if you look at video capture port and cmos sensor :
- video capture hardware cares about polarities, interlacing, and 
pixelcount. They don't care about hfrontporch & htotal, as long as it is 
over some minimum value.

- CMOS sensor gives you custom size and windows position, bining and 
skipping, shutter width.
They give some control over vsync. but not always.

This timings might be interesting when it comes to display and output,
It might be a relevant feature set, but it is not the only one, 
especially when it comes to CMOS sensor capture. I hope adopting these 
ioctls won't give a higher priority to timing parameters over other 
sensible parameters.

Thank you for reading this

Jean-Philippe François

> 
> Summary of new ioctls added by this RFC.
> 
> #define VIDIOC_ENUM_DV_PRESETS   _IOWR('V', 79, struct v4l2_dv_enum_presets)
> #define VIDIOC_S_DV_PRESET       _IOWR('V', 80, struct v4l2_dv_preset)
> #define VIDIOC_G_DV_PRESET       _IOWR('V', 81, struct v4l2_dv_preset)
> #define VIDIOC_QUERY_DV_PRESET   _IOR('V',  82, struct v4l2_dv_preset)
> #define VIDIOC_S_DV_TIMINGS      _IOWR('V', 83, struct v4l2_dv_timings)
> #define VIDIOC_G_DV_TIMINGS      _IOWR('V', 84, struct v4l2_dv_timings)
> 
> Open issues
> -----------
> 
> 1.How to handle an HDMI transmitter? It can be put in two different modes: DVI compatible
> or HDMI compatible. Some of the choices are 
> 	a) enumerate them as two different outputs when enumerating.
>         b) adding a status bit on the input. 
>         c) change it using a control
> 
> 2. Detecting whether there is an analog or digital signal on an DVI-I input: 
> 	a) add new status field value for v4l2_input ?
> 	   #define  V4L2_IN_ST_DVI_ANALOG_DETECTED    0x10000000
> 	   #define  V4L2_IN_ST_DVI_DITIGITAL_DETECTED 0x20000000
>        
> 3. Detecting an EDID. 
> 	a) adding a status field in v4l2_output and two new ioctls that can 
>          set the EDID for an input or retrieve it for an output. It should 
>          also be added as an input/output capability.
> 
> 4. ATSC bits in v4l2_std_id: how are they used? Are they used at all for 
>    that matter?
> 
> 
> 6. HDMI requires additional investigation. HDMI defines a whole bunch of 
>    infoframe fields. Most of these can probably be exported as controls?? Is 
>    HDMI audio handled by alsa? 
> 
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

