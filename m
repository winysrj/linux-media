Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43696 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbbFHJOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 05:14:44 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPM00FRZCCHP970@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2015 10:14:41 +0100 (BST)
Message-id: <55755D00.1090902@samsung.com>
Date: Mon, 08 Jun 2015 11:14:40 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com, gjasny@googlemail.com,
	hdegoede@redhat.com, kyungmin.park@samsung.com
Subject: Re: [v4l-utils PATCH/RFC v5 00/14] Add a plugin for Exynos4 camera
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
 <557551D9.9090607@xs4all.nl>
In-reply-to: <557551D9.9090607@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

It got stuck on this version. I have some slight improvements locally
but haven't sent them as there hasn't been any comment to this so far.
AFAIR Sakari had some doubts about handling multiple pipelines within
one media controller. In this approach only one pipeline is allowed.
There has to be a new IOCTL added for locking pipelines, to handle this
IIRC.

Besides there are some v4l-utils build system dependency issues to
solve, I mentioned below in the cover letter.

On 06/08/2015 10:27 AM, Hans Verkuil wrote:
> Hi Jacek,
>
> What is the status of this? It would be really useful to have a working plugin
> as an example in v4l-utils.
>
> Regards,
>
> 	Hans
>
> On 02/26/2015 04:59 PM, Jacek Anaszewski wrote:
>> This is a fifth version of the patch series adding a plugin for the
>> Exynos4 camera.
>>
>> Temporarily the plugin doesn't link against libmediactl, but
>> has its sources compiled in. Currently utils are built after
>> the plugins, but libv4l-exynos4-camera plugin depends on the utils.
>> In order to link the plugin against libmediactl the build system
>> would have to be modified.
>>
>> ================
>> Changes from v4:
>> ================
>>
>> - removed some redundant functions for traversing media device graph
>>    and switched over to using existing ones
>> - avoided accessing struct v4l2_subdev from libmediactl
>> - applied various improvements
>>
>> ================
>> Changes from v3:
>> ================
>>
>> - added struct v4l2_subdev and put entity fd and
>>    information about supported controls to it
>> - improved functions for negotiating and setting
>>    pipeline format by using available libv4lsubdev API
>> - applied minor improvements and cleanups
>>
>> ================
>> Changes from v2:
>> ================
>>
>> - switched to using mediatext library for parsing
>>    the media device configuration
>> - extended libmediactl
>> - switched to using libmediactl
>>
>> ================
>> Changes from v1:
>> ================
>>
>> - removed redundant mbus code negotiation
>> - split the parser, media device helpers and ioctl wrappers
>>    to the separate modules
>> - added mechanism for querying extended controls
>> - applied various fixes and modifications
>>
>> The plugin was tested on linux-next_20150223 with patches for
>> exynos4-is that fix failing open ioctl when a sensor sub-device is not
>> linked [1] [2] [3].
>>
>> The plugin expects a configuration file:
>> /var/lib/libv4l/exynos4_capture_conf
>>
>> Exemplary configuration file:
>>
>> ==========================================
>>
>> link-conf "s5p-mipi-csis.0":1 -> "FIMC.0":0 [1]
>> ctrl-to-subdev-conf 0x0098091f -> "fimc.0.capture"
>> ctrl-to-subdev-conf 0x00980902 -> "S5C73M3"
>> ctrl-to-subdev-conf 0x00980922 -> "fimc.0.capture"
>> ctrl-to-subdev-conf 0x009a0914 -> "S5C73M3"
>>
>> ==========================================
>>
>> With this settings the plugin can be tested on the exynos4412-trats2 board
>> using following gstreamer pipeline:
>>
>> gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw,width=960,height=720 ! fbdevsink
>>
>> Thanks,
>> Jacek Anaszewski
>>
>> [1] https://patchwork.linuxtv.org/patch/26366/
>> [2] https://patchwork.linuxtv.org/patch/26367/
>> [3] https://patchwork.linuxtv.org/patch/26368/
>>
>> Jacek Anaszewski (13):
>>    mediactl: Introduce v4l2_subdev structure
>>    mediactl: Add support for v4l2-ctrl-redir config
>>    mediatext: Add library
>>    mediactl: Add media device graph helpers
>>    mediactl: Add media_device creation helpers
>>    mediactl: libv4l2subdev: add VYUY8_2X8 mbus code
>>    mediactl: Add support for media device pipelines
>>    mediactl: libv4l2subdev: add support for comparing mbus formats
>>    mediactl: libv4l2subdev: add support for setting pipeline format
>>    mediactl: libv4l2subdev: add get_pipeline_entity_by_cid function
>>    mediactl: Add media device ioctl API
>>    mediactl: libv4l2subdev: Enable opening/closing pipelines
>>    Add a libv4l plugin for Exynos4 camera
>>
>> Sakari Ailus (1):
>>    mediactl: Separate entity and pad parsing
>>
>>   configure.ac                                      |    1 +
>>   lib/Makefile.am                                   |    5 +
>>   lib/libv4l-exynos4-camera/Makefile.am             |    7 +
>>   lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  586 +++++++++++++++++++++
>>   utils/media-ctl/Makefile.am                       |   12 +-
>>   utils/media-ctl/libmediactl.c                     |  271 +++++++++-
>>   utils/media-ctl/libmediatext.pc.in                |   10 +
>>   utils/media-ctl/libv4l2media_ioctl.c              |  369 +++++++++++++
>>   utils/media-ctl/libv4l2media_ioctl.h              |   40 ++
>>   utils/media-ctl/libv4l2subdev.c                   |  301 ++++++++++-
>>   utils/media-ctl/mediactl-priv.h                   |   11 +-
>>   utils/media-ctl/mediactl.h                        |  151 ++++++
>>   utils/media-ctl/mediatext-test.c                  |   64 +++
>>   utils/media-ctl/mediatext.c                       |  311 +++++++++++
>>   utils/media-ctl/mediatext.h                       |   52 ++
>>   utils/media-ctl/v4l2subdev.h                      |  131 +++++
>>   16 files changed, 2292 insertions(+), 30 deletions(-)
>>   create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
>>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
>>   create mode 100644 utils/media-ctl/libmediatext.pc.in
>>   create mode 100644 utils/media-ctl/libv4l2media_ioctl.c
>>   create mode 100644 utils/media-ctl/libv4l2media_ioctl.h
>>   create mode 100644 utils/media-ctl/mediatext-test.c
>>   create mode 100644 utils/media-ctl/mediatext.c
>>   create mode 100644 utils/media-ctl/mediatext.h
>>
>
>


-- 
Best Regards,
Jacek Anaszewski
