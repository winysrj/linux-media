Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43955 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZIQJt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 05:49:28 -0400
Received: by bwz19 with SMTP id 19so173221bwz.37
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2009 02:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
Date: Thu, 17 Sep 2009 11:49:29 +0200
Message-ID: <eb77d7060909170249k7fb4fa55p31abc70d973f4289@mail.gmail.com>
Subject: Re: RFC: V4L - Support for video timings at the input/output
	interface
From: Jorge Luis Zapata Muga <jorgeluis.zapata@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 3:51 PM, Karicheri, Muralidharan
<m-karicheri2@ti.com> wrote:
> RFC: V4L - Support for video timings at the input/output interface
>
> Thanks to Hans Verkuil for his initial proposal and feedbacks to help write this RFC.
>
> Version : 1.0
>
> Background
> -----------
>
> Currently v4l2 specification supports capturing video frames from TV signals using tuners (input type V4L2_INPUT_TYPE_TUNER) and baseband TV signals (V4L2_INPUT_TYPE_CAMERA) and sensors. Similarly on the output side, the signals could be TV signal (V4L2_OUTPUT_TYPE_MODULATOR), baseband TV signal (V4L2_OUTPUT_TYPE_ANALOG) or hybrid analog VGA overlay (V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY) which output from a graphics card and
> then use chromakeying to replace part of the picture with the video. V4L2_OUTPUT_TYPE_ANALOG & V4L2_INPUT_TYPE_CAMERA are for analog interfaces that includes composite, S-Video and VGA (for output only). Note that even though VGA is a supported output, we don't have anyway to set the standard or timing on the output. Standard ids are only defined for TVs using
> v4l2_std_id and a set of bit masks  defined for analog TV standards.
>
> Today we have a wide variety of different interfaces available to transmit/receive video or graphics content between source device and destination device. Following are some of the interfaces used in addition to the ones described in the v4l2 specification.
>
> Component analog input/output interface - ED/HD video
> DVI - Digital only, ANALOG only, DVI integrated that support Digital and
>        Analog; Dual Link - Where second data link is used for higher
>        bandwidth
> SDI - Serial digital interface standardized by SMPTE
> HDMI - HD video and Audio
> DisplayPort - digital audio/video interconnect by VESA
>
> V4L2 specification currently defined NTSC/PAL/SECAM (all variants) standards for describing the timing of the signal transmitted over these interfaces. Even though the specification defined ANALOG output type for VGA, there are no ways to set the timings used for output to VGA or LCD display monitors. Some of the proprietary implementations used existing standards IOCTL, VIDIOC_S_STD, to set these timings over these interfaces.
> For example, TI has Video Processing Back End (VPBE) on various media SOCs
> (Eg, DM6446, DM355 etc) that can output signal for Analog TV and VGA interfaces (using Digital LCD port) and support timing for displaying SD and HD videos (1080i, 1080p and 720p) as well as over VGA interface to a CRT or LCD display monitor. So we need to enhance the v4l2 specification to allow applications to set these timings in the capture or output devices. This RFC proposes to add new IOCTLs for setting/getting timings over the different interfaces described above and freeze the the use of existing standards
> IOCTL and standards IDs for analog TVs only.
>
> Timings
> -------
>
> The timing at the analog or digital interface that are not covered by the v4l2_std_id can be defined using a set of preset timings that are used by the hardware where these timings are predefined or by a set of timing values which can be configured at the hardware to generate the signal expected at the interface. The former will be used for hardware like TVP7002/THS8200 which specifies preset timing required for output HD video such 1080i50/60, 720p50/60 etc. The latter can be used for hardware that require configuration of frame timing such as front porch, hsync length, vsync length, pixel clock etc. For example the earlier mentioned TI SOCs has a Digital LCD port that can be configured to output different timing values expected by LCD Display monitors.
>

The proposal seems good, given that v4l2 supports output (input)
devices, it was kind of strange that v4l2 didnt have a way to setup
custom timings on such devices, even so i have some concerns.

For the output device and timings, there's already an API which
supports that on the kernel, the FB API. The framebuffer system can be
seen as an independent system but with some intersection with the v4l2
output device. Some of the differences are modedb, timings, bitblt
acceleration, EDID handling, even a video output switcher via sysfs,
etc and some of the them are now needed for v4l. Also the FB API
suffers on other areas, like YUV planes (as the depth definitions
doesnt support that), chroma key, etc (this are handled by private
ioctls on some fb drivers).

Also the DRM people is adding support for KMS (kernel mode setting)
which also uses a timing definition for that and EDID handling. So,
from a kernel developer/application developer POV, this is a mess. We
have three different API for the same devices/tasks. IMO this RFC is a
good thing, but we need a way to stabilize the kernel graphics area
somehow, maybe share this RFC among the other subsystems (fb, drm)?

Regards


> Preset timings (defined by VESA, SMPTE or BT.656/BT.1120 or others) can be defined by the following structure:-
>
> struct v4l2_dv_preset {
>    __u32 preset;
>    __u32 reserved[4];
> };
>
> Where preset is one of the following values:-
>
> #define   V4L2_DV_CUSTOM        0x00000000
> #define       V4L2_DV_480I59_94     0x00000001
> #define       V4L2_DV_480I60        0x00000002
> #define       V4L2_DV_480P23_976    0x00000003
> #define       V4L2_DV_480P24        0x00000004
> #define       V4L2_DV_480P29_97     0x00000005
> #define       V4L2_DV_480P30        0x00000006
> #define       V4L2_DV_576I50        0x00000007
> #define       V4L2_DV_576P25        0x00000008
> #define       V4L2_DV_576P50        0x00000009
> #define       V4L2_DV_720P23_976    0x0000000A
> #define       V4L2_DV_720P24        0x0000000B
> #define       V4L2_DV_720P25        0x0000000C
> #define       V4L2_DV_720P29_97     0x0000000C
> #define       V4L2_DV_720P30        0x0000000D
> #define       V4L2_DV_720P50        0x0000000E
> #define       V4L2_DV_720P59_94     0x0000000F
> #define       V4L2_DV_720P60        0x00000010
> #define       V4L2_DV_1080I50       0x00000011
> #define       V4L2_DV_1080I59_94    0x00000012
> #define       V4L2_DV_1080I60       0x00000013
> #define       V4L2_DV_1080P23_976   0x00000014
> #define       V4L2_DV_1080P24       0x00000015
> #define       V4L2_DV_1080P25       0x00000016
> #define       V4L2_DV_1080P29_97    0x00000017
> #define       V4L2_DV_1080P30       0x00000018
> #define       V4L2_DV_1080P60       0x00000019
>
>
> /* Following preset value is used by driver to indicate there is no signal
>  detected or could not lock to the signal for VIDIOC_QUERY_DV_PRESET.
> */
> #define       V4L2_DV_INVALID       0xFFFFFFFF
>
>
> This list is expected grow over time. So a bit mask is not used for this
> (Unlike analog TV standards) so that many presets can be defined as needed in the future.
>
> To enumerate the DV preset timings available, applications call VIDIOC_ENUM_DV_PRESETS
> using the following structure:-
>
> struct v4l2_dv_enum_presets {
>        __u32 index;
>        __u32   preset;
>        __u8    name[32]; /* Name of the preset timing */
>        __u32   reserved[4];
> };
>
> Application set/get the preset by calling VIDIOC_S/G_DV_PRESET using v4l2_dv_preset structure.
>
> Also add a capabilities field in the input and output structure to support presets
>
> /*
>  *      V I D E O   I N P U T S
>  */
> struct v4l2_input {
>        __u32        index;             /*  Which input */
>        __u8         name[32];          /*  Label */
>        __u32        type;              /*  Type of input */
>        __u32        audioset;          /*  Associated audios (bitfield) */
>        __u32        tuner;             /*  Associated tuner */
>        v4l2_std_id  std;
>        __u32        status;
>        __u32          capabilities;
>        __u32        reserved[3];
> };
>
> /*
>  *      V I D E O   O U T P U T S
>  */
> struct v4l2_output {
>        __u32        index;             /*  Which output */
>        __u8         name[32];          /*  Label */
>        __u32        type;              /*  Type of output */
>        __u32        audioset;          /*  Associated audios (bitfield) */
>        __u32        modulator;         /*  Associated modulator */
>        v4l2_std_id  std;
>        __u32        capabilities;
>        __u32        reserved[3];
> };
>
> where capabilities are:-
>
> #define V4L2_SUPPORTS_PRESETS        0x00000001
> #define V4L2_SUPPORTS_CUSTOM_TIMINGS 0x00000002
>
> For setting custom timing at the device, following structure is used which defines the complete set of timing values required at the input and output interface:-
>
> /* timing data values specified by various standards such as BT.1120, BT.656 etc. */
>
> /* bt.656/bt.1120 timing data */
> struct v4l2_bt_timings {
>    __u32 interlaced;
>    __u64 pixelclock;
>    __u32 width, height;
>    __u32 polarities;
>    __u32 hfrontporch, hsync, htotal;
>    __u32 vfrontporch, vsync, vtotal;
>    /* timings for bottom frame for interlaced formats */
>    __u32 il_vtotal;
>    __u32 reserved[16];
> };
>
>
> interlaced - Interlaced or progressive. use following values:-
>
> #define V4L2_DV_INTERLACED     0
> #define V4L2_DV_PROGRESSIVE    1
>
> pixelclock - expressed in HZ. So for 74.25MHz, use 74250000.
> width - number of pixels in horizontal direction
> height - number of lines in vertical direction
> polarities - Bit mask for following polarities to begin with
>
> #define V4L2_DV_VSYNC_POS_POL    0x1
> #define V4L2_DV_VSYNC_NEG_POL    0x2
> #define V4L2_DV_HSYNC_POS_POL    0x3
> #define V4L2_DV_HSYNC_NEG_POL    0x4
>
> hfrontporch,hsync, and htotal for horizontal direction and vfrontporch,vsync, and vtotal for vertical direction. il_vtotal is the number of vertical lines for interlaced video for bottom field.
>
> To define a particular timing type, following enum is used:-
>
> enum v4l2_dv_timings_type {
>        V4L2_DV_BT_656_1120,
> };
>
> This will allow adding new timing types in the future.
>
> If the driver supports a set of custom timing, it can be set/get using VIDIOC_S/G_DV_TIMINGS
> IOCTL and specifying timings using the structure
>
> struct v4l2_dv_timings {
>        enum v4l2_dv_timings_type type;
>        union {
>                struct v4l2_bt_timings bt;
>                __u32 reserved[32];
>        };
> };
>
>
> If the driver supports custom timing as well as Presets, it will return V4L2_DV_CUSTOM along with other preset timings for the VIDIOC_ENUM_DV_PRESETS IOCTL call. Application can then call VIDIOC_S/G_TIMING to get/set custom timings at the driver.
>
> To detect a preset timing at the input application calls VIDIOC_QUERY_DV_PRESET which returns the preset using the v4l2_dv_preset structure.
>
> Summary of new ioctls added by this RFC.
>
> #define VIDIOC_ENUM_DV_PRESETS   _IOWR('V', 79, struct v4l2_dv_enum_presets)
> #define VIDIOC_S_DV_PRESET       _IOWR('V', 80, struct v4l2_dv_preset)
> #define VIDIOC_G_DV_PRESET       _IOWR('V', 81, struct v4l2_dv_preset)
> #define VIDIOC_QUERY_DV_PRESET   _IOR('V',  82, struct v4l2_dv_preset)
> #define VIDIOC_S_DV_TIMINGS      _IOWR('V', 83, struct v4l2_dv_timings)
> #define VIDIOC_G_DV_TIMINGS      _IOWR('V', 84, struct v4l2_dv_timings)
>
> Open issues
> -----------
>
> 1.How to handle an HDMI transmitter? It can be put in two different modes: DVI compatible
> or HDMI compatible. Some of the choices are
>        a) enumerate them as two different outputs when enumerating.
>        b) adding a status bit on the input.
>        c) change it using a control
>
> 2. Detecting whether there is an analog or digital signal on an DVI-I input:
>        a) add new status field value for v4l2_input ?
>           #define  V4L2_IN_ST_DVI_ANALOG_DETECTED    0x10000000
>           #define  V4L2_IN_ST_DVI_DITIGITAL_DETECTED 0x20000000
>
> 3. Detecting an EDID.
>        a) adding a status field in v4l2_output and two new ioctls that can
>         set the EDID for an input or retrieve it for an output. It should
>         also be added as an input/output capability.
>
> 4. ATSC bits in v4l2_std_id: how are they used? Are they used at all for
>   that matter?
>
>
> 6. HDMI requires additional investigation. HDMI defines a whole bunch of
>   infoframe fields. Most of these can probably be exported as controls?? Is
>   HDMI audio handled by alsa?
>
>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
