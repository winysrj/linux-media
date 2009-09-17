Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbZIQRjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 13:39:12 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: =?iso-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 17 Sep 2009 12:39:11 -0500
Subject: RE: RFC: V4L - Support for video timings at the input/output
 interface
Message-ID: <A69FA2915331DC488A831521EAE36FE401551574D4@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
 <4AAF68E1.9090100@cynove.com>
In-Reply-To: <4AAF68E1.9090100@cynove.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Philippe François,

>>
>> Component analog input/output interface - ED/HD video
>> DVI - Digital only, ANALOG only, DVI integrated that support Digital and
>> 	Analog; Dual Link - Where second data link is used for higher
>> 	bandwidth
>> SDI - Serial digital interface standardized by SMPTE
>> HDMI - HD video and Audio
>> DisplayPort - digital audio/video interconnect by VESA
>>
>I would like to say that all capture devices are not necessary used in a
>video chain or video system.
>When it comes to machine vision, resolution and image quality can be
>more interesting than timings.
>
I will postpone the discussion to your next point...

>---- snip ---
>> /* timing data values specified by various standards such as BT.1120,
>BT.656 etc. */
>>
>> /* bt.656/bt.1120 timing data */
>> struct v4l2_bt_timings {
>>     __u32 interlaced;
>>     __u64 pixelclock;
>>     __u32 width, height;
>>     __u32 polarities;
>>     __u32 hfrontporch, hsync, htotal;
>>     __u32 vfrontporch, vsync, vtotal;
>>     /* timings for bottom frame for interlaced formats */
>>     __u32 il_vtotal;
>>     __u32 reserved[16];
>> };
>>
>>
>> interlaced - Interlaced or progressive. use following values:-
>>
>> #define V4L2_DV_INTERLACED     0
>> #define V4L2_DV_PROGRESSIVE    1
>>
>> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.
>> width - number of pixels in horizontal direction
>> height - number of lines in vertical direction
>> polarities - Bit mask for following polarities to begin with
>>
>> #define V4L2_DV_VSYNC_POS_POL    0x1
>> #define V4L2_DV_VSYNC_NEG_POL    0x2
>> #define V4L2_DV_HSYNC_POS_POL    0x3
>> #define V4L2_DV_HSYNC_NEG_POL    0x4
>>
>> hfrontporch,hsync, and htotal for horizontal direction and
>vfrontporch,vsync, and vtotal for vertical direction. il_vtotal is the
>number of vertical lines for interlaced video for bottom field.
>>
>> To define a particular timing type, following enum is used:-
>>
>> enum v4l2_dv_timings_type {
>>         V4L2_DV_BT_656_1120,
>> };
>>
>> This will allow adding new timing types in the future.
>>
>
>Let's say we have a CMOS sensor, with a driver implementing this various
>  timings, because the driver writer was "video oriented".
>Now here comes another person, who is interested in another set of
>features :
>width,
>height
>col_start
>row_start
>
>And he wants autoexposure and don't care about the framerate.
>How does he extends the driver ?
>Is there a way to set the resolution without going through a standard.
>What should he do ?
>Add another timing_type ?

Yes. I realized that the RFC doesn't address the camera requirement.
I am using MT9T031/MT9T001/MT9P031 in my response below because that is
what I am familiar with. In these sensors there are two mode of operation, continuous mode and Snapshot mode.

The video timing is relevant to continuous mode where the rows and columns
are read out along with pixel clock, hsync and vsync signals to the output bus. So video timing is quite relevant here. Even though there are no
input interface for this similar to video decoders, the output timing to
the bus is still based the settings for row size, column size, blanking
interval etc. In TI's internal release, we have following parameters
for sensor driver as a static table for each of the resolution frames
output to bus. We maintain following values for a given resolution and fps

column_size, row_size, h_blank, v_blank, shutter_width, row_addr_mode,
col_addr_mode, row_start, col_start etc

So when a particular resolution capture is set by user, driver will configure sensor with these values (done using S_STD currently).

In the MT9T031 driver available in v4l2 sub system today, my understanding is that some of these values are taken from S_FMT such as width (column_size), height (row_size). row_start and col_start comes form S_CROP. Some of these values are fixed such as h_blank and v_blank. So I think Hans proposal will work to support both these cases.

Also there are sensors that can support BT timing as well. So these will be
able to use preset or dv_timigs.

Based on the feedback so far, So I propose to make following additions/modifications to the RFC. we define following capabilities:- 

case 1) Analog TVs at input/output

add following capability flag for existing v4l2_std_id,

#define V4L2_IO_CAP_STD		0x00000001

This way application knows driver supports standard STD ids for NTSC/PAL/SECAM

case 2) Video timings presets at output/input

To support preset add following capability flag.

#define V4L2_IO_CAP_PRESETS	0x00000002

struct v4l2_dv_preset {
    __u32 preset;
    __u32 reserved[4];
};

case 3) Camera where frame rate changes with exposure & where frame_rate
is fixed (pre-defined in the driver). Both these needs frame size (width and height). In former case frame rate is based on other factors such as exposure, shutter width etc.


To support camera timing that can be based on width, height, frame rate add following capability flag:-

/* where only width and height can be assured, but not frame rate */
#define V4L2_IO_CAP_FRAME_SIZE	0x00000004

/* where frame rate is fixed (prefined set of resolution and frame rate) or
   driver can calculate the frame rate */
#define V4L2_IO_CAP_FRAME_RATE	0x00000008

So if a driver can support both frame size and rate, it can set both flags

struct v4l2_frame_timings {
    __u32 width;
    __u32 height;
	/* nominal frame rate with nominal exposure */
	v4l2_fract frame_rate;
    __u32 reserved[4];
};

Add new timing type in

enum v4l2_dv_timings_type {
        V4L2_DV_BT_656_1120,
	  V4L2_FRAME_TIMINGS
};

To support BT timing (includes sensors that can set detailed timing)
#define V4L2_IO_CAP_BT_TIMINGS	0x00000010

/* bt.656/bt.1120 timing data */
struct v4l2_bt_timings {
    __u32 interlaced;
    __u64 pixelclock;
    __u32 width, height;
    __u32 polarities;
    __u32 hfrontporch, hsync, htotal;
    __u32 vfrontporch, vsync, vtotal;
    /* timings for bottom frame for interlaced formats */
    __u32 il_vtotal;
    __u32 reserved[16];
};

Some of these parameters applicable for sensors as well.

Some of the sensors can do interlaced or progressive scan type of read out.
width and height refers to the sizes on the sensors output bus. There is 
vblank and hblank settings on sensor as well.

case 4) Snapshot mode for camera sensor

In this case, sensor readout happens on a trigger. I think this is covered by case 3 where driver just set the V4L2_IO_CAP_FRAME_SIZE flag and ignore the frame rate in DV_TIMING ioctl.

Let me know if any case is not handled here.

>Use the S_FMT, G_FMT, TRY_FMT ioctl ?

I think we are misusing the API for sensors here. The sensor itself is
only giving an output bus that carries the read out data from rows
and colums with a set of timings that include pixel clock, vertical
blanking & horizontal blanking etc (last two applicable only when frames
are output continuously). There is going to be a host device which sinks this bus and write data to memory using a DMA engine. So there may
be additional capabilities here to pack the data differently (There
is another RFC from Hans that talks about data format on this bus).
So that is where all of S_FMT/G_FMT/TRY_FMT applies. At the sensor,
you just set the output frame size and timings (if doing streaming)
and this RFC address that. 

>But then what happens when one does a G_DV_TIMINGS ?
>
>Should a new v4l2_dv_timings_type be defined ?
>But it is not a timing we are talking about, it is a geometry.
>
Yes, the geometry is specified by v4l2_frame_timings structure
where frame rate can be zeros. The driver will indicate that
capability using a flag as suggested above.

>CMOS sensor presents overlapping feature sets :
>Resolution + timing is one.


Can be supported using case  & 3) or 4) for sensors. In my view, for sensors, timing refers to the timing at the output bus of sensor.

>Resolution + windows position + exposure is another.
I think what you are referring as window position is the row_start and
column_start of the field of view, right? 

Case 3) above can be used to set the frame size at the output bus, but frame rate depends on exposure and final frame size output which in term depends or resize/cropping values used. So this is possible to handle using the new ioctls along with S_CROP and control for exposure.

>Resolution + zoom level is yet another

Zoom is another case of resize IMO. You are specifying the capture
area using S_CROP. In the case of sensor, this will set the row_start
and column_start and row size and column size. So based on final frame size at the output, driver can calculate the zoom factor internally. If host
device can do additional zooming, similar thing happens at the capture
node.  

>
>Let's say a driver is written using the VIDIOC_S/G_DV_TIMINGS.
>It should be easy to use the same driver with S/G_FMT or S/G_CROP, even
>if it leads to a format you can't describe with VIDIOC_S/G_DV_TIMINGS.
>
>I mean, we are heading to a situation where you can set :
>hfrontporch, vfrontporch, htotal, vtotal.
>
>But if you want to set :
>row_start, col_start, shutter_width, bining or decimation, you have to
>write some custom control.
>

Why do we need this? S_CROP can be used to set row_start and column_start
etc at the sensor. I know currently all these commands go through the
bridge/host device and it has to decide if scaling/cropping to be at the host device or sub device. I think with the media controller RFC, this can be passed to the sensor directly. shutter width can be changed through a control ioctl, bining/decimation can be used to get the frame timing as specified by the VIDIOC_S_DV_PRESET/VIDIOC_S_DV_TIMINGS ioctl.

>Now if you look at video capture port and cmos sensor :
>- video capture hardware cares about polarities, interlacing, and
>pixelcount. They don't care about hfrontporch & htotal, as long as it is
>over some minimum value.
>
For some cases, these are fixed. So driver can use presets. Other cases detailed timings can be set by hardware for the same. On the output for VESA timing, video hardware do care about hfrontporch & htotal

>- CMOS sensor gives you custom size and windows position, bining and
>skipping, shutter width.
>They give some control over vsync. but not always.
>
>This timings might be interesting when it comes to display and output,
>It might be a relevant feature set, but it is not the only one,
>especially when it comes to CMOS sensor capture. I hope adopting these
>ioctls won't give a higher priority to timing parameters over other
>sensible parameters.

IMO, We should use a common IOCTL, but naming can be adjusted to mean
it is not timing, but rather a frame size for camera devices ( the new
capabilities flag might be enough). If there are settings not controlled by these, MC RFC can be used to change sensor specific settings as a control
or configuration.

>

