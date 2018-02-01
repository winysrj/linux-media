Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36122 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbeBAErD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 23:47:03 -0500
Received: by mail-wr0-f169.google.com with SMTP id y3so7559174wrh.3
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 20:47:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83695d60-5052-14ba-4f7b-23f153a05a85@xs4all.nl>
References: <1514491789-8697-1-git-send-email-tharvey@gateworks.com>
 <1514491789-8697-5-git-send-email-tharvey@gateworks.com> <1e65ee61-f282-4b53-dd03-68a89a91da8e@xs4all.nl>
 <CAJ+vNU1ysHuzqOnL4sf3hFZrU5kyGnQ0dFkRObVjCa=NyLsJug@mail.gmail.com>
 <517f8b12-e10e-1e8d-6d98-26f5fefe62b8@xs4all.nl> <CAJ+vNU1xnnmNZW5zmT8+0HfT3Xfg6zfdrbC8vFNH4wuah5AVTA@mail.gmail.com>
 <fa8cc2d1-b7ea-343e-5b5a-ba5f60b9c5d9@xs4all.nl> <83695d60-5052-14ba-4f7b-23f153a05a85@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 31 Jan 2018 20:47:01 -0800
Message-ID: <CAJ+vNU3DJ2xNEKoi1-div80hKkzsm+pFYtzJDUn+seXAVq8jCQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim Harvey - Principal Software Engineer
Gateworks Corporation - http://www.gateworks.com/
3026 S. Higuera St. San Luis Obispo CA 93401
805-781-2000


On Wed, Jan 31, 2018 at 5:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 01/31/18 08:38, Hans Verkuil wrote:
>> On 01/31/2018 05:51 AM, Tim Harvey wrote:
>>> On Mon, Jan 29, 2018 at 4:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 01/25/2018 05:15 PM, Tim Harvey wrote:
>>> <snip>
>>>>>>
>>>>>> Hmm. This receiver supports multiple output formats, but you advertise only one.
>>>>>> That looks wrong. If nothing else, you should be able to switch between RGB and
>>>>>> YUV 4:4:4 since they use the same port config.
>>>>>>
>>>>>> It's a common use-case that you want to switch between RGB and YUV depending on
>>>>>> the source material (i.e. if you receive a desktop/graphics then RGB is best, if
>>>>>> you receive video then YUV 4:2:2 or 4:2:0 is best).
>>>>>>
>>>>>> Hardcoding just one format won't do.
>>>>>>
>>>>>
>>>>> I've been thinking about this a bit. I had hard-coded a single format
>>>>> for now because I haven't had any good ideas on how to deal with the
>>>>> fact that the port mappings would need to differ if you change from
>>>>> the RGB888/YUV444 (I think these are referred to as 'planar' formats?)
>>>>> to YUV422 (semi-planar) and BT656 formats. It is true though that the
>>>>> 36bit (TDA19973) RGB888/YUV444 and 24bit (TDA19971/2) formats can both
>>>>> be supported with the same port mappings / pinout.
>>>>
>>>> Regarding terminology:
>>>>
>>>> RGB and YUV are typically interleaved, i.e. the color components are
>>>> (for two pixels) either RGBRGB for RGB888, YUVYUV for YUV444 or YUYV
>>>> for YUV422.
>>>>
>>>> Planar formats are in practice only seen for YUV and will first output
>>>> all Y samples, and then the UV samples. This requires that the hardware
>>>> buffers the frame and that's not normally done by HDMI receivers.
>>>>
>>>> The DMA engine, however, is often able to split up the interleaved YUV
>>>> samples that it receives and DMA them to separate buffers, thus turning
>>>> an interleaved media bus format to a planar memory format.
>>>>
>>>> BT656 doesn't refer to how the samples are transferred, instead it
>>>> refers to how the hsync and vsync are reported. The enum v4l2_mbus_type
>>>> has various options, one of them being BT656.
>>>>
>>>> Which mbus type is used is board specific (and should come from the
>>>> device tree). Whether to transmit RGB888, YUV444 or YUV422 (or possibly
>>>> even YUV420) is dynamic and is up to userspace since it is use-case
>>>> dependent.
>>>>
>>>> So you'll never switch between BT656 and CSI, but you can switch between
>>>> BT656+RGB and BT656+YUV, or between CSI+RGB and CSI+YUV.
>>>>
>>>>>
>>>>> For example the GW5400 has a TDA19971 mapped to IMX6 CSI_DATA[19:4]
>>>>> (16bit) for YUV422. However if you want to use BT656 you have to shift
>>>>> the TDA19971 port mappings to get the YCbCr pins mapped to
>>>>> CSI_DATA[19:x] and those pin groups are at the bottom of the bus for
>>>>> the RGB888/YUV444 format.
>>>>
>>>> As mentioned above, you wouldn't switch between mbus types.
>>>>
>>>>>
>>>>> I suppose however that perhaps for the example above if I have a 16bit
>>>>> width required to support YUV422 there would never be a useful case
>>>>> for supporting 8-bit/10-bit/12-bit BT656 on the same board?
>>>>
>>>> You wouldn't switch between mbus types, but if the device tree configures
>>>> BT.656 with a bus width of 24 bits, then the application might very well
>>>> want to dynamically switch between 8, 10 and 12 bits per color component.
>>>>
>>>
>>> Hans,
>>>
>>> I just submitted a v7 with multiple format support. Your point about
>>> bus_type being specified by dt is exactly what I needed to help make
>>> sense of the formats.
>>
>> Ah, good. It took me some time as well before I realized that the confusion
>> was in mixing up bus types and formats.
>>
>>> That said, I'm unsure how to properly test the enum_mbus_code() pad op
>>> function. How do you obtain a list of valid formats on a subdev?
>>>
>>> I tried the following:
>>> root@ventana:~# media-ctl -e 'tda19971 2-0048'
>>> /dev/v4l-subdev1
>>> root@ventana:~# media-ctl --get-v4l2 '"tda19971 2-0048":0'
>>>                 [fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]
>>> ^^^^ calls get_format and returns the 1 and only format available for
>>> my tda19971 with 16bit parallel bus
>>> root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --get-fmt-video-out
>>> VIDIOC_G_FMT: failed: Inappropriate ioctl for device
>>> root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --list-formats-out
>>> ioctl: VIDIOC_ENUM_FMT
>>>
>>> I'm thinking perhaps enumerating the list of possible formats is a
>>> missing feature in media-ctl?
>>
>> Yeah, it is. Surprising, really. Ditto for the SUBDEV_ENUM_FRAME_SIZE/INTERVAL
>> ioctls.
>>
>> I wonder whether this should be added to v4l2-ctl, media-ctl or both. I always
>> felt that media-ctl is more about setting up the whole pipeline, whereas v4l2-ctl
>> is specific to a V4L2 device.
>>
>> Regards,
>>
>>       Hans
>>
>
> Here is a quick patch adding support for enumerating mbus codes to v4l2-ctl.
> You get some compile warnings, just ignore those.
>
> An example using vimc, listing the code for pad 1:
>
> $ ./v4l2-ctl -d /dev/v4l-subdev5 --list-subdev-mbus-codes=1
> ioctl: VIDIOC_SUBDEV_ENUM_MBUS_CODE
>         0x00001013: BGR888_1X24
>         0x0000100a: RGB888_1X24
>         0x0000100d: ARGB8888_1X32
>
> Regards,
>
>         Hans
>
> ---------------- cut here ------------------------
> diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
> index 83fa49a3..b3ccfc8b 100644
> --- a/utils/v4l2-ctl/Makefile.am
> +++ b/utils/v4l2-ctl/Makefile.am
> @@ -6,9 +6,16 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
>         v4l2-ctl-io.cpp v4l2-ctl-stds.cpp v4l2-ctl-vidcap.cpp v4l2-ctl-vidout.cpp \
>         v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
>         v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
> -       v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp
> +       v4l2-ctl-subdev.cpp v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c v4l2-ctl-meta.cpp
>  v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
>
> +media-bus-format-names.h: ../../include/linux/media-bus-format.h
> +       sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \
> +       < $< > $@
> +
> +BUILT_SOURCES = media-bus-format-names.h
> +CLEANFILES = $(BUILT_SOURCES)
> +
>  if WITH_V4L2_CTL_LIBV4L
>  v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
>  else
> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> index 46e621f7..2f521f5d 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> @@ -91,6 +91,8 @@ void common_usage(void)
>  #ifndef NO_LIBV4L2
>                "  -w, --wrapper      use the libv4l2 wrapper library.\n"
>  #endif
> +              "  --which-is-try     set the 'which' argument to V4L2_SUBDEV_FORMAT_TRY instead of\n"
> +              "                     V4L2_SUBDEV_FORMAT_ACTIVE (the default)\n"
>                "  --list-devices     list all v4l devices\n"
>                "  --log-status       log the board status in the kernel log [VIDIOC_LOG_STATUS]\n"
>                "  --get-priority     query the current access priority [VIDIOC_G_PRIORITY]\n"
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index e02dc756..9dced5b1 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -83,6 +83,7 @@ static struct option long_options[] = {
>         {"help-vbi", no_argument, 0, OptHelpVbi},
>         {"help-sdr", no_argument, 0, OptHelpSdr},
>         {"help-meta", no_argument, 0, OptHelpMeta},
> +       {"help-subdev", no_argument, 0, OptHelpSubDev},
>         {"help-selection", no_argument, 0, OptHelpSelection},
>         {"help-misc", no_argument, 0, OptHelpMisc},
>         {"help-streaming", no_argument, 0, OptHelpStreaming},
> @@ -91,6 +92,7 @@ static struct option long_options[] = {
>  #ifndef NO_LIBV4L2
>         {"wrapper", no_argument, 0, OptUseWrapper},
>  #endif
> +       {"which-is-try", no_argument, 0, OptWhichIsTry},
>         {"concise", no_argument, 0, OptConcise},
>         {"get-output", no_argument, 0, OptGetOutput},
>         {"set-output", required_argument, 0, OptSetOutput},
> @@ -115,6 +117,7 @@ static struct option long_options[] = {
>         {"list-formats-sdr-out", no_argument, 0, OptListSdrOutFormats},
>         {"list-formats-out", no_argument, 0, OptListOutFormats},
>         {"list-formats-meta", no_argument, 0, OptListMetaFormats},
> +       {"list-subdev-mbus-codes", optional_argument, 0, OptListSubDevMBusCodes},
>         {"list-fields-out", no_argument, 0, OptListOutFields},
>         {"clear-clips", no_argument, 0, OptClearClips},
>         {"clear-bitmap", no_argument, 0, OptClearBitmap},
> @@ -1212,6 +1215,7 @@ int main(int argc, char **argv)
>         const char *wait_event_id = NULL;
>         __u32 poll_for_event = 0;       /* poll for this event */
>         const char *poll_event_id = NULL;
> +       __u32 which = V4L2_SUBDEV_FORMAT_ACTIVE;
>         unsigned secs = 0;
>         char short_options[26 * 2 * 3 + 1];
>         int idx = 0;
> @@ -1274,6 +1278,9 @@ int main(int argc, char **argv)
>                 case OptHelpMeta:
>                         meta_usage();
>                         return 0;
> +               case OptHelpSubDev:
> +                       subdev_usage();
> +                       return 0;
>                 case OptHelpSelection:
>                         selection_usage();
>                         return 0;
> @@ -1317,6 +1324,9 @@ int main(int argc, char **argv)
>                         if (poll_for_event == 0)
>                                 return 1;
>                         break;
> +               case OptWhichIsTry:
> +                       which = V4L2_SUBDEV_FORMAT_TRY;
> +                       break;
>                 case OptSleep:
>                         secs = strtoul(optarg, 0L, 0);
>                         break;
> @@ -1341,6 +1351,7 @@ int main(int argc, char **argv)
>                         vbi_cmd(ch, optarg);
>                         sdr_cmd(ch, optarg);
>                         meta_cmd(ch, optarg);
> +                       subdev_cmd(ch, optarg);
>                         selection_cmd(ch, optarg);
>                         misc_cmd(ch, optarg);
>                         streaming_cmd(ch, optarg);
> @@ -1480,6 +1491,7 @@ int main(int argc, char **argv)
>         vbi_set(fd);
>         sdr_set(fd);
>         meta_set(fd);
> +       subdev_set(fd, which);
>         selection_set(fd);
>         streaming_set(fd, out_fd);
>         misc_set(fd);
> @@ -1497,6 +1509,7 @@ int main(int argc, char **argv)
>         vbi_get(fd);
>         sdr_get(fd);
>         meta_get(fd);
> +       subdev_get(fd, which);
>         selection_get(fd);
>         misc_get(fd);
>         edid_get(fd);
> @@ -1512,6 +1525,7 @@ int main(int argc, char **argv)
>         vbi_list(fd);
>         sdr_list(fd);
>         meta_list(fd);
> +       subdev_list(fd, which);
>         streaming_list(fd, out_fd);
>
>         if (options[OptWaitForEvent]) {
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 3b56d8a6..2ac29268 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -10,6 +10,7 @@
>  #include <string>
>
>  #include <linux/videodev2.h>
> +#include <linux/v4l2-subdev.h>
>
>  #ifndef NO_LIBV4L2
>  #include <libv4l2.h>
> @@ -58,6 +59,7 @@ enum Option {
>         OptGetVideoFormat = 'V',
>         OptSetVideoFormat = 'v',
>         OptUseWrapper = 'w',
> +       OptWhichIsTry = 'W',
>
>         OptGetSlicedVbiOutFormat = 128,
>         OptGetOverlayFormat,
> @@ -97,6 +99,7 @@ enum Option {
>         OptListSdrOutFormats,
>         OptListOutFormats,
>         OptListMetaFormats,
> +       OptListSubDevMBusCodes,
>         OptListOutFields,
>         OptClearClips,
>         OptClearBitmap,
> @@ -211,6 +214,7 @@ enum Option {
>         OptHelpVbi,
>         OptHelpSdr,
>         OptHelpMeta,
> +       OptHelpSubDev,
>         OptHelpSelection,
>         OptHelpMisc,
>         OptHelpStreaming,
> @@ -345,6 +349,13 @@ void meta_set(int fd);
>  void meta_get(int fd);
>  void meta_list(int fd);
>
> +// v4l2-ctl-subdev.cpp
> +void subdev_usage(void);
> +void subdev_cmd(int ch, char *optarg);
> +void subdev_set(int fd, __u32 which);
> +void subdev_get(int fd, __u32 which);
> +void subdev_list(int fd, __u32 which);
> +
>  // v4l2-ctl-selection.cpp
>  void selection_usage(void);
>  void selection_cmd(int ch, char *optarg);
>

Hans,

You forgot to include v4l2-ctl-selection.cpp in your patch.

Regards,

Tim
