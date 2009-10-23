Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46506 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZJWUod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 16:44:33 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 23 Oct 2009 15:44:34 -0500
Subject: RE: [PATCH] V4L: adding digital video timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE4015568EF61@dlee06.ent.ti.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com>
 <76889a5297f775ff3e951ae3af801f96.squirrel@webmail.xs4all.nl>
In-Reply-To: <76889a5297f775ff3e951ae3af801f96.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

>> following IOCTLS :-
>>
>>  -  verify the new v4l2_input capabilities flag added
>>  -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
>>  -  Set one of the supported preset using VIDIOC_S_DV_PRESET
>>  -  Get current preset using VIDIOC_G_DV_PRESET
>>  -  Detect current preset using VIDIOC_QUERY_DV_PRESET
>>  -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
>>     and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device.
>>
>> TODOs :
>>
>>  - Test it on a 64bit platform - I need help here since I don't have the
>> platform.
>>  - Add documentation (Can someone tell me which file to modify in the
>> kernel tree?).
>
>Use the spec in media-spec/v4l.

[MK] Where can I access this? Is this part of kernel tree (I couldn't find
it under Documentation/video4linux/ under the kernel tree? Is it just updating a text file or I need to have some tool installed to access
this documentation and update it.
>
>Please also add support to v4l2-ctl.cpp in v4l2-apps/util! That's handy
>for testing.
[MK] Are you referring to the following repository for this?

http://linuxtv.org/hg/~dougsland/tool/file/5b884b36bbab

Is there a way I can do a git clone for this?

>
>Setting the input/output capabilities should be done in v4l2-ioctl.c
>rather than in the drivers. All the info you need to set these bits is
>available in the core after all.
>

[MK] Could you explain this to me? In my prototype, I had tvp5146 that
implements S_STD and tvp7002 that implements S_PRESET. Since bridge driver
has all the knowledge about the sub devices and their capabilities, it can
set the flag for each of the input that it supports (currently I am
setting this flag in the board setup file that describes all the inputs using v4l2_input structure). So it is a matter of setting relevant cap flag in this file for each of the input based on what the sub device supports. I am not sure how core can figure this out?

>I also noticed that not all new ioctls are part of video_ops. Aren't they
>all required?
>
[MK] All new ioctls are supported in video_ops. I am not sure what you are
referring to. For sub device ops, only few are required since bridge device
can handle the rest.

>Regards,
>
>        Hans
>
>PS: Thanks for all your work! It's great to see this moving forward nicely!
>
>>
>> Please review this and let me know your comments.
>>
>> Mandatory reviewer - Hans Verkuil <hverkuil@xs4all.nl>
>>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> ---
>> Applies to V4L-DVB linux-next branch
>>
>>  drivers/media/video/v4l2-compat-ioctl32.c |    7 ++
>>  drivers/media/video/v4l2-ioctl.c          |  122
>> ++++++++++++++++++++++++++
>>  include/linux/videodev2.h                 |  136
>> ++++++++++++++++++++++++++++-
>>  include/media/v4l2-ioctl.h                |   15 +++
>>  include/media/v4l2-subdev.h               |   21 +++++
>>  5 files changed, 299 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
>> b/drivers/media/video/v4l2-compat-ioctl32.c
>> index 997975d..9277448 100644
>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>> @@ -1077,6 +1077,13 @@ long v4l2_compat_ioctl32(struct file *file,
>> unsigned int cmd, unsigned long arg)
>>      case VIDIOC_DBG_G_REGISTER:
>>      case VIDIOC_DBG_G_CHIP_IDENT:
>>      case VIDIOC_S_HW_FREQ_SEEK:
>> +    case VIDIOC_ENUM_DV_PRESETS:
>> +    case VIDIOC_S_DV_PRESET:
>> +    case VIDIOC_G_DV_PRESET:
>> +    case VIDIOC_QUERY_DV_PRESET:
>> +    case VIDIOC_S_DV_TIMINGS:
>> +    case VIDIOC_G_DV_TIMINGS:
>> +
>>              ret = do_video_ioctl(file, cmd, arg);
>>              break;
>>
>> diff --git a/drivers/media/video/v4l2-ioctl.c
>> b/drivers/media/video/v4l2-ioctl.c
>> index 30cc334..10b5678 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -284,6 +284,12 @@ static const char *v4l2_ioctls[] = {
>>      [_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
>>      [_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
>>  #endif
>> +    [_IOC_NR(VIDIOC_ENUM_DV_PRESETS)]  = "VIDIOC_ENUM_DV_PRESETS",
>> +    [_IOC_NR(VIDIOC_S_DV_PRESET)]      = "VIDIOC_S_DV_PRESET",
>> +    [_IOC_NR(VIDIOC_G_DV_PRESET)]      = "VIDIOC_G_DV_PRESET",
>> +    [_IOC_NR(VIDIOC_QUERY_DV_PRESET)]  = "VIDIOC_QUERY_DV_PRESET",
>> +    [_IOC_NR(VIDIOC_S_DV_TIMINGS)]     = "VIDIOC_S_DV_TIMINGS",
>> +    [_IOC_NR(VIDIOC_G_DV_TIMINGS)]     = "VIDIOC_G_DV_TIMINGS",
>>  };
>>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>>
>> @@ -1794,6 +1800,122 @@ static long __video_do_ioctl(struct file *file,
>>              }
>>              break;
>>      }
>> +    case VIDIOC_ENUM_DV_PRESETS:
>> +    {
>> +            struct v4l2_dv_enum_preset *p = arg;
>> +
>> +            if (!ops->vidioc_enum_dv_presets)
>> +                    break;
>> +
>> +            ret = ops->vidioc_enum_dv_presets(file, fh, p);
>> +            if (!ret)
>> +                    dbgarg(cmd,
>> +                            "index=%d, preset=%d, name=%s, width=%d,"
>> +                            " height=%d ",
>> +                            p->index, p->preset, p->name, p->width,
>> +                            p->height);
>> +            break;
>> +    }
>> +    case VIDIOC_S_DV_PRESET:
>> +    {
>> +            struct v4l2_dv_preset *p = arg;
>> +
>> +            if (!ops->vidioc_s_dv_preset)
>> +                    break;
>> +
>> +            dbgarg(cmd, "preset=%d\n", p->preset);
>> +            ret = ops->vidioc_s_dv_preset(file, fh, p);
>> +            break;
>> +    }
>> +    case VIDIOC_G_DV_PRESET:
>> +    {
>> +            struct v4l2_dv_preset *p = arg;
>> +
>> +            if (!ops->vidioc_g_dv_preset)
>> +                    break;
>> +
>> +            ret = ops->vidioc_g_dv_preset(file, fh, p);
>> +            if (!ret)
>> +                    dbgarg(cmd, "preset=%d\n", p->preset);
>> +            break;
>> +    }
>> +    case VIDIOC_QUERY_DV_PRESET:
>> +    {
>> +            struct v4l2_dv_preset *p = arg;
>> +
>> +            if (!ops->vidioc_query_dv_preset)
>> +                    break;
>> +
>> +            ret = ops->vidioc_query_dv_preset(file, fh, p);
>> +            if (!ret)
>> +                    dbgarg(cmd, "preset=%d\n", p->preset);
>> +            break;
>> +    }
>> +    case VIDIOC_S_DV_TIMINGS:
>> +    {
>> +            struct v4l2_dv_timings *p = arg;
>> +
>> +            if (!ops->vidioc_s_dv_timings)
>> +                    break;
>> +
>> +            dbgarg(cmd, "type=%d", p->type);
>> +            switch (p->type) {
>> +            case V4L2_DV_BT_656_1120:
>> +                    dbgarg2("interlaced=%d, pixelclock=%lld,"
>> +                            " width=%d, height=%d, polarities=%x,"
>> +                            " hfrontporch=%d, hsync=%d, hbackporch=%d,"
>> +                            " vfrontporch=%d, vsync=%d, vbackporch=%d,"
>> +                            " il_vfrontporch=%d, il_vsync=%d,"
>> +                            " il_vbackporch=%d\n",
>> +                            p->bt.interlaced, p->bt.pixelclock,
>> +                            p->bt.width, p->bt.height, p->bt.polarities,
>> +                            p->bt.hfrontporch, p->bt.hsync,
>> +                            p->bt.hbackporch, p->bt.vfrontporch,
>> +                            p->bt.vsync, p->bt.vbackporch,
>> +                            p->bt.il_vfrontporch, p->bt.il_vsync,
>> +                            p->bt.il_vbackporch);
>> +                    ret = ops->vidioc_s_dv_timings(file, fh, p);
>> +                    break;
>> +            default:
>> +                    dbgarg2("- Unknown type!\n");
>> +                    break;
>> +            }
>> +            break;
>> +    }
>> +    case VIDIOC_G_DV_TIMINGS:
>> +    {
>> +            struct v4l2_dv_timings *p = arg;
>> +
>> +            if (!ops->vidioc_g_dv_timings)
>> +                    break;
>> +
>> +            dbgarg(cmd, "type=%d", p->type);
>> +            ret = ops->vidioc_g_dv_timings(file, fh, p);
>> +            if (!ret) {
>> +                    switch (p->type) {
>> +                    case V4L2_DV_BT_656_1120:
>> +                            dbgarg2("interlaced=%d, pixelclock=%lld,"
>> +                                    " width=%d, height=%d, polarities=%x,"
>> +                                    " hfrontporch=%d, hsync=%d,"
>> +                                    " hbackporch=%d, vfrontporch=%d,"
>> +                                    " vsync=%d, vbackporch=%d,"
>> +                                    " il_vfrontporch=%d, il_vsync=%d,"
>> +                                    " il_vbackporch=%d\n",
>> +                                    p->bt.interlaced, p->bt.pixelclock,
>> +                                    p->bt.width, p->bt.height,
>> +                                    p->bt.polarities, p->bt.hfrontporch,
>> +                                    p->bt.hsync, p->bt.hbackporch,
>> +                                    p->bt.vfrontporch, p->bt.vsync,
>> +                                    p->bt.vbackporch, p->bt.il_vfrontporch,
>> +                                    p->bt.il_vsync, p->bt.il_vbackporch);
>> +                            break;
>> +                    default:
>> +                            dbgarg2("- Unknown type!\n");
>> +                            break;
>> +                    }
>> +            }
>> +            break;
>> +    }
>>
>>      default:
>>      {
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index 469dbd0..3436d4a 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -730,6 +730,119 @@ struct v4l2_standard {
>>  };
>>
>>  /*
>> + *  V I D E O       T I M I N G S   D V     P R E S E T
>> + */
>> +struct v4l2_dv_preset {
>> +    __u32   preset;
>> +    __u32   reserved[4];
>> +};
>> +
>> +/*
>> + *  D V     P R E S E T S   E N U M E R A T I O N
>> + */
>> +struct v4l2_dv_enum_preset {
>> +    __u32   index;
>> +    __u32   preset;
>> +    __u8    name[32]; /* Name of the preset timing */
>> +    __u32   width;
>> +    __u32   height;
>> +    __u32   reserved[4];
>> +};
>> +
>> +/*
>> + *  D V     P R E S E T     V A L U E S
>> + */
>> +#define             V4L2_DV_PRESET_BASE     0x00000000
>> +#define             V4L2_DV_INVALID         (V4L2_DV_PRESET_BASE + 0)
>> +/* BT.1362 */
>> +#define             V4L2_DV_480P59_94       (V4L2_DV_PRESET_BASE + 1)
>> +/* BT.1362 */
>> +#define             V4L2_DV_576P50          (V4L2_DV_PRESET_BASE + 2)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_720P24          (V4L2_DV_PRESET_BASE + 3)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_720P25          (V4L2_DV_PRESET_BASE + 4)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_720P30          (V4L2_DV_PRESET_BASE + 5)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_720P50          (V4L2_DV_PRESET_BASE + 6)
>> +/* SMPTE 274M */
>> +#define             V4L2_DV_720P59_94       (V4L2_DV_PRESET_BASE + 7)
>> +/* SMPTE 274M/296M */
>> +#define             V4L2_DV_720P60          (V4L2_DV_PRESET_BASE + 8)
>> +/* BT.1120/ SMPTE 274M */
>> +#define             V4L2_DV_1080I29_97      (V4L2_DV_PRESET_BASE + 9)
>> +/* BT.1120/ SMPTE 274M */
>> +#define             V4L2_DV_1080I30         (V4L2_DV_PRESET_BASE + 10)
>> +/* BT.1120 */
>> +#define             V4L2_DV_1080I25         (V4L2_DV_PRESET_BASE + 11)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_1080I50         (V4L2_DV_PRESET_BASE + 12)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_1080I60         (V4L2_DV_PRESET_BASE + 13)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_1080P24         (V4L2_DV_PRESET_BASE + 14)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_1080P25         (V4L2_DV_PRESET_BASE + 15)
>> +/* SMPTE 296M */
>> +#define             V4L2_DV_1080P30         (V4L2_DV_PRESET_BASE + 16)
>> +/* BT.1120 */
>> +#define             V4L2_DV_1080P50         (V4L2_DV_PRESET_BASE + 17)
>> +/* BT.1120 */
>> +#define             V4L2_DV_1080P60         (V4L2_DV_PRESET_BASE + 18)
>> +
>> +/*
>> + *  D V     B T     T I M I N G S
>> + */
>> +
>> +/* BT.656/BT.1120 timing data */
>> +struct v4l2_bt_timings {
>> +    __u32   width;          /* width in pixels */
>> +    __u32   height;         /* height in lines */
>> +    __u32   interlaced;     /* Interlaced or progressive */
>> +    __u32   polarities;     /* Positive or negative polarity */
>> +    __u64   pixelclock;     /* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
>> +    __u32   hfrontporch;    /* Horizpontal front porch in pixels */
>> +    __u32   hsync;          /* Horizontal Sync length in pixels */
>> +    __u32   hbackporch;     /* Horizontal back porch in pixels */
>> +    __u32   vfrontporch;    /* Vertical front porch in pixels */
>> +    __u32   vsync;          /* Vertical Sync length in lines */
>> +    __u32   vbackporch;     /* Vertical back porch in lines */
>> +    __u32   il_vfrontporch; /* Vertical front porch for bottom field of
>> +                             * interlaced field formats
>> +                             */
>> +    __u32   il_vsync;       /* Vertical sync length for bottom field of
>> +                             * interlaced field formats
>> +                             */
>> +    __u32   il_vbackporch;  /* Vertical back porch for bottom field of
>> +                             * interlaced field formats
>> +                             */
>> +    __u32   reserved[16];
>> +};
>> +
>> +/* Interlaced or progressive format */
>> +#define     V4L2_DV_PROGRESSIVE     0
>> +#define     V4L2_DV_INTERLACED      1
>> +
>> +/* Polarities. If bit is not set, it is assumed to be negative polarity
>> */
>> +#define V4L2_DV_VSYNC_POS_POL       0x00000001
>> +#define V4L2_DV_HSYNC_POS_POL       0x00000002
>> +
>> +/* BT.656/1120 timing type */
>> +enum v4l2_dv_timings_type {
>> +    V4L2_DV_BT_656_1120,
>> +};
>> +
>> +/* DV timings */
>> +struct v4l2_dv_timings {
>> +    enum v4l2_dv_timings_type type;
>> +    union {
>> +            struct v4l2_bt_timings  bt;
>> +            __u32   reserved[32];
>> +    };
>> +};
>> +
>> +/*
>>   *  V I D E O   I N P U T S
>>   */
>>  struct v4l2_input {
>> @@ -740,7 +853,8 @@ struct v4l2_input {
>>      __u32        tuner;             /*  Associated tuner */
>>      v4l2_std_id  std;
>>      __u32        status;
>> -    __u32        reserved[4];
>> +    __u32        capabilities;
>> +    __u32        reserved[3];
>>  };
>>
>>  /*  Values for the 'type' field */
>> @@ -771,6 +885,11 @@ struct v4l2_input {
>>  #define V4L2_IN_ST_NO_ACCESS   0x02000000  /* Conditional access denied
>> */
>>  #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
>>
>> +/* capabilities flags */
>> +#define V4L2_IN_CAP_PRESETS         0x00000001 /* Supports DV_PRESETS
>*/
>> +#define V4L2_IN_CAP_CUSTOM_TIMINGS  0x00000002 /* Supports Custom
>timings
>> */
>> +#define V4L2_IN_CAP_STD                     0x00000004 /* Supports STD */
>> +
>>  /*
>>   *  V I D E O   O U T P U T S
>>   */
>> @@ -781,13 +900,19 @@ struct v4l2_output {
>>      __u32        audioset;          /*  Associated audios (bitfield) */
>>      __u32        modulator;         /*  Associated modulator */
>>      v4l2_std_id  std;
>> -    __u32        reserved[4];
>> +    __u32        capabilities;
>> +    __u32        reserved[3];
>>  };
>>  /*  Values for the 'type' field */
>>  #define V4L2_OUTPUT_TYPE_MODULATOR          1
>>  #define V4L2_OUTPUT_TYPE_ANALOG                     2
>>  #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY   3
>>
>> +/* capabilities flags */
>> +#define V4L2_OUT_CAP_PRESETS                0x00000001 /* Supports DV_PRESETS
>*/
>> +#define V4L2_OUT_CAP_CUSTOM_TIMINGS 0x00000002 /* Supports Custom
>timings
>> */
>> +#define V4L2_OUT_CAP_STD            0x00000004 /* Supports STD */
>> +
>>  /*
>>   *  C O N T R O L S
>>   */
>> @@ -1620,6 +1745,13 @@ struct v4l2_dbg_chip_ident {
>>  #endif
>>
>>  #define VIDIOC_S_HW_FREQ_SEEK        _IOW('V', 82, struct
>v4l2_hw_freq_seek)
>> +#define     VIDIOC_ENUM_DV_PRESETS  _IOWR('V', 83, struct
>v4l2_dv_enum_preset)
>> +#define     VIDIOC_S_DV_PRESET      _IOWR('V', 84, struct v4l2_dv_preset)
>> +#define     VIDIOC_G_DV_PRESET      _IOWR('V', 85, struct v4l2_dv_preset)
>> +#define     VIDIOC_QUERY_DV_PRESET  _IOR('V',  86, struct v4l2_dv_preset)
>> +#define     VIDIOC_S_DV_TIMINGS     _IOWR('V', 87, struct v4l2_dv_timings)
>> +#define     VIDIOC_G_DV_TIMINGS     _IOWR('V', 88, struct v4l2_dv_timings)
>> +
>>  /* Reminder: when adding new ioctls please add support for them to
>>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>>
>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>> index 7a4529d..e8ba0f2 100644
>> --- a/include/media/v4l2-ioctl.h
>> +++ b/include/media/v4l2-ioctl.h
>> @@ -239,6 +239,21 @@ struct v4l2_ioctl_ops {
>>      int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
>>                                         struct v4l2_frmivalenum *fival);
>>
>> +    /* DV Timings IOCTLs */
>> +    int (*vidioc_enum_dv_presets) (struct file *file, void *fh,
>> +                                   struct v4l2_dv_enum_preset *preset);
>> +
>> +    int (*vidioc_s_dv_preset) (struct file *file, void *fh,
>> +                               struct v4l2_dv_preset *preset);
>> +    int (*vidioc_g_dv_preset) (struct file *file, void *fh,
>> +                               struct v4l2_dv_preset *preset);
>> +    int (*vidioc_query_dv_preset) (struct file *file, void *fh,
>> +                                    struct v4l2_dv_preset *qpreset);
>> +    int (*vidioc_s_dv_timings) (struct file *file, void *fh,
>> +                                struct v4l2_dv_timings *timings);
>> +    int (*vidioc_g_dv_timings) (struct file *file, void *fh,
>> +                                struct v4l2_dv_timings *timings);
>> +
>>      /* For other private ioctls */
>>      long (*vidioc_default)         (struct file *file, void *fh,
>>                                      int cmd, void *arg);
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index d411345..cedcc72 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -206,6 +206,19 @@ struct v4l2_subdev_audio_ops {
>>
>>     s_routing: see s_routing in audio_ops, except this version is for
>> video
>>      devices.
>> +
>> +   s_dv_preset: set dv (Digital Video) preset in the sub device. Similar
>> to
>> +    s_std()
>> +
>> +   query_dv_preset: query dv preset in the sub device. This is similar
>to
>> +    querystd()
>> +
>> +   s_dv_timings(): Set custom dv timings in the sub device. This is used
>> +    when sub device is capable of setting detailed timing information
>> +    in the hardware to generate/detect the video signal.
>> +
>> +   g_dv_timings(): Get custom dv timings in the sub device.
>> +
>>   */
>>  struct v4l2_subdev_video_ops {
>>      int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
>> config);
>> @@ -229,6 +242,14 @@ struct v4l2_subdev_video_ops {
>>      int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>>      int (*enum_framesizes)(struct v4l2_subdev *sd, struct
>v4l2_frmsizeenum
>> *fsize);
>>      int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
>> v4l2_frmivalenum *fival);
>> +    int (*s_dv_preset)(struct v4l2_subdev *sd,
>> +                    struct v4l2_dv_preset *preset);
>> +    int (*query_dv_preset)(struct v4l2_subdev *sd,
>> +                    struct v4l2_dv_preset *preset);
>> +    int (*s_dv_timings)(struct v4l2_subdev *sd,
>> +                    struct v4l2_dv_timings *timings);
>> +    int (*g_dv_timings)(struct v4l2_subdev *sd,
>> +                    struct v4l2_dv_timings *timings);
>>  };
>>
>>  struct v4l2_subdev_ops {
>> --
>> 1.6.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

