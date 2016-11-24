Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39998 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934732AbcKXMUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 07:20:08 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH500LDKBLHY590@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2016 12:20:05 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 0/7] Add a plugin for Exynos4 camera
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, mchehab@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <c9f1ff2d-4155-fe56-d9ae-92ea30067161@samsung.com>
Date: Thu, 24 Nov 2016 13:20:01 +0100
MIME-version: 1.0
In-reply-to: <20161124071011.00794fb9@vento.lan>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <CGME20161103115131epcas1p390d36f98d52c001fdb1d1bc6e5451b32@epcas1p3.samsung.com>
 <a95cba78-c237-9982-97a2-1e80998e8e06@xs4all.nl>
 <4c4c34ae-5735-bb7c-d85d-c7bec6007216@samsung.com>
 <20161123195144.609d335d@vento.lan>
 <48866a8c-2b2a-d849-e401-c21703b20236@samsung.com>
 <20161124071011.00794fb9@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2016 10:10 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 24 Nov 2016 09:10:28 +0100
> Jacek Anaszewski <j.anaszewski@samsung.com> escreveu:
>
>> On 11/23/2016 10:51 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 03 Nov 2016 13:13:12 +0100
>>> Jacek Anaszewski <j.anaszewski@samsung.com> escreveu:
>>>
>>>> Hi Hans,
>>>>
>>>> On 11/03/2016 12:51 PM, Hans Verkuil wrote:
>>>>> Hi all,
>>>>>
>>>>> Is there anything that blocks me from merging this?
>>>>>
>>>>> This plugin work has been ongoing for years and unless there are serious
>>>>> objections I propose that this is merged.
>>>>>
>>>>> Jacek, is there anything missing that would prevent merging this?
>>>>
>>>> There were issues raised by Sakari during last review, related to
>>>> the way how v4l2 control bindings are defined. That discussion wasn't
>>>> finished, so I stayed by my approach.
>>>
>>> Are those things something that could be fixed later without
>>> breaking binary apps? If not, then perhaps it is time to merge
>>> this.
>>
>> They are related to the format of configuration file being introduced
>> by this patch set, so there are no binary apps depending on it.
>
> Ok. Yet, changing the configuration file format could be a pain
> for the users. The best would be to add a format that would be
> extensible enough to be able to add support for other needs in
> the future.
>
>> Few days ago I had a discussion with Sakari on IRC, and he pointed
>> me to his patch set adding an extended version of his mediatext
>> library RFC [0], the first version of which I included to my patch set,
>> and extended a bit. A decision should be made if I should adapt my
>> API to the mediatext RFC. RFC is not a stable ground though.
>>
>> [0] https://www.spinics.net/lists/linux-media/msg103242.html
>
> If I understood well, you're proposing to use this format for
> the configuration file:
>
> 	link-conf "s5p-mipi-csis.0":1 -> "FIMC.0":0 [1]
> 	ctrl-to-subdev-conf 0x0098091f -> "fimc.0.capture"
> 	ctrl-to-subdev-conf 0x00980902 -> "S5C73M3"
> 	ctrl-to-subdev-conf 0x00980922 -> "fimc.0.capture"
> 	ctrl-to-subdev-conf 0x009a0914 -> "S5C73M3"
>
> What if, instead, you use something like:
>
> [group]
> 	key = value
>
> type of configuration file?
>
> This way, if one wants to extend it, all it is needed is to add
> other groups or more key types.
>
> The users with an older configuration won't suffer if newer
> groups and newer key types were added.
>
> E. g something like:
>
> [link]
> 	source = "s5p-mipi-csis.0":1
> 	sink = "FIMC.0":0 [1]
>
> [ctrl-to-subdev]
> 	ctrl_id = 0x0098091f
> 	subdev= "fimc.0.capture"
>
> [ctrl-to-subdev]
> 	ctrl_id = 0x00980902
> 	subdev = "S5C73M3"
>
> ...
>
>
> This way, Sakari's patches could use the same format to add mediatext
> entries. E. g. something like (the actual content actually depends on
> what is here - I'm just wild guessing from the tree diagram at the
> RFC e-mail):
>
> [mediatext]
> 	shell_script = foo
> 	devnode = /dev/video*
> 	devnode = /dev/mediaX
> 	devnode = /dev/v4l-subdev*
>
> without needing to change the format of the file, and keeping it
> backward compatible.

First version of this patch set used similar configuration format
but Sakari asked me to switch to the format accepted by media-ctl,
which the first version of mediatext adhered to.

Sakari has pledged to review this patch set, so we will be able
to decide on how to proceed no sooner than that.

Best regards,
Jacek Anaszewski


> Regards,
> Mauro
>>
>>>> Other than that - I've tested it
>>>> and it works fine both with GStreamer and my test app.
>>>>
>>>> Best regards,
>>>> Jacek Anaszewski
>>>>
>>>>
>>>>> On 12/10/16 16:35, Jacek Anaszewski wrote:
>>>>>> This is a seventh version of the patch series adding a plugin for the
>>>>>> Exynos4 camera. Last version [0] of the patch set was posted in
>>>>>> January.
>>>>>>
>>>>>> The plugin doesn't link against libmediactl, but has its sources
>>>>>> compiled in. Currently utils are built after the plugins, but
>>>>>> libv4l-exynos4-camera plugin depends on the utils. In order to link
>>>>>> the plugin against libmediactl the build system would have to be
>>>>>> modified.
>>>>>>
>>>>>> ================
>>>>>> Changes from v6:
>>>>>> ================
>>>>>>
>>>>>> - close v4l2 sub-devices on media device release
>>>>>> - moved non-generic code from libmediactl to the plugin
>>>>>> - resigned from adding libmedia_ioctl library and moved all its
>>>>>>   code to the plugin, since it depended on pipeline representation,
>>>>>>   which was not generic for all possible media device topologies
>>>>>> - used media_get_info()->name instead of adding media_entity_get_name
>>>>>> - renamed media_get_backlinks_by_entity() to
>>>>>> media_entity_get_backlinks(()
>>>>>> - moved pipeline from struct media_device to the plugin
>>>>>> - changed the way of associating video device file descriptor with
>>>>>> media device
>>>>>> - switched to using auto-generated media-bus-format-names.h header file
>>>>>> - renamed v4l2-ctrl-redir config entry name to v4l2-ctrl-binding
>>>>>>
>>>>>> ================
>>>>>> Changes from v5:
>>>>>> ================
>>>>>>
>>>>>> - fixed and tested use cases with S5K6A3 sensor and FIMC-IS-ISP
>>>>>> - added conversion "colorspace id to string"
>>>>>>
>>>>>> ================
>>>>>> Changes from v4:
>>>>>> ================
>>>>>>
>>>>>> - removed some redundant functions for traversing media device graph
>>>>>>   and switched over to using existing ones
>>>>>> - avoided accessing struct v4l2_subdev from libmediactl
>>>>>> - applied various improvements
>>>>>>
>>>>>> ================
>>>>>> Changes from v3:
>>>>>> ================
>>>>>>
>>>>>> - added struct v4l2_subdev and put entity fd and
>>>>>>   information about supported controls to it
>>>>>> - improved functions for negotiating and setting
>>>>>>   pipeline format by using available libv4lsubdev API
>>>>>> - applied minor improvements and cleanups
>>>>>>
>>>>>> ================
>>>>>> Changes from v2:
>>>>>> ================
>>>>>>
>>>>>> - switched to using mediatext library for parsing
>>>>>>   the media device configuration
>>>>>> - extended libmediactl
>>>>>> - switched to using libmediactl
>>>>>>
>>>>>> ================
>>>>>> Changes from v1:
>>>>>> ================
>>>>>>
>>>>>> - removed redundant mbus code negotiation
>>>>>> - split the parser, media device helpers and ioctl wrappers
>>>>>>   to the separate modules
>>>>>> - added mechanism for querying extended controls
>>>>>> - applied various fixes and modifications
>>>>>>
>>>>>>
>>>>>>
>>>>>> The plugin was tested on v4.8-rc2 (exynos4-is driver doesn't proble
>>>>>> properly
>>>>>> with current master branch of linux-media.git) with patches fixing
>>>>>> several
>>>>>> issues for Exynos4 camera: [1], [2], [3].
>>>>>>
>>>>>> The plugin expects a configuration file:
>>>>>> /var/lib/libv4l/exynos4_capture_conf
>>>>>>
>>>>>> Exemplary configuration file for pipeline with sensor
>>>>>> S5C73M3 (rear camera):
>>>>>>
>>>>>> ==========================================
>>>>>>
>>>>>> link-conf "s5p-mipi-csis.0":1 -> "FIMC.0":0 [1]
>>>>>> v4l2-ctrl-binding 0x0098091f -> "fimc.0.capture"
>>>>>> v4l2-ctrl-binding 0x00980902 -> "S5C73M3"
>>>>>> v4l2-ctrl-binding 0x00980922 -> "fimc.0.capture"
>>>>>> v4l2-ctrl-binding 0x009a0914 -> "S5C73M3"
>>>>>>
>>>>>> ==========================================
>>>>>>
>>>>>> With this settings the plugin can be tested on the exynos4412-trats2
>>>>>> board
>>>>>> using following gstreamer pipeline:
>>>>>>
>>>>>> gst-launch-1.0 v4l2src device=/dev/video1
>>>>>> extra-controls="c,rotate=90,color_effects=2" !
>>>>>> video/x-raw,width=960,height=720 ! fbdevsink
>>>>>>
>>>>>> Exemplary configuration file for pipeline with sensor
>>>>>> S5K6A3 (front camera):
>>>>>>
>>>>>> ==========================================
>>>>>>
>>>>>> link-conf "s5p-mipi-csis.1":1 -> "FIMC-LITE.1":0 [1]
>>>>>> link-conf "FIMC-LITE.1":2 -> "FIMC-IS-ISP":0 [1]
>>>>>> link-conf "FIMC-IS-ISP":1 -> "FIMC.0":1 [1]
>>>>>>
>>>>>> ==========================================
>>>>>>
>>>>>> gst-launch-1.0 v4l2src device=/dev/video1
>>>>>> extra-controls="c,rotate=270,color_effects=2,horizontal_flip=1" !
>>>>>> video/x-raw,width=960,height=920 ! fbdevsink
>>>>>>
>>>>>> Best Regards,
>>>>>> Jacek Anaszewski
>>>>>>
>>>>>> [0] http://www.spinics.net/lists/linux-media/msg96510.html
>>>>>> [1] https://patchwork.kernel.org/patch/9335197/
>>>>>> [2] https://patchwork.kernel.org/patch/9270985/
>>>>>> [3] https://patchwork.kernel.org/patch/9308923/
>>>>>> [4] https://patchwork.kernel.org/patch/9335273/
>>>>>>
>>>>>>
>>>>>> Jacek Anaszewski (7):
>>>>>>   mediactl: Add support for v4l2-ctrl-binding config
>>>>>>   mediatext: Add library
>>>>>>   mediactl: Add media_entity_get_backlinks()
>>>>>>   mediactl: Add media_device creation helpers
>>>>>>   mediactl: libv4l2subdev: Add colorspace logging
>>>>>>   mediactl: libv4l2subdev: add support for comparing mbus formats
>>>>>>   Add a libv4l plugin for Exynos4 camera
>>>>>>
>>>>>>  configure.ac                                      |    1 +
>>>>>>  lib/Makefile.am                                   |    5 +
>>>>>>  lib/libv4l-exynos4-camera/Makefile.am             |   19 +
>>>>>>  lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c | 1325
>>>>>> +++++++++++++++++++++
>>>>>>  utils/media-ctl/Makefile.am                       |   10 +-
>>>>>>  utils/media-ctl/libmediactl.c                     |  152 ++-
>>>>>>  utils/media-ctl/libmediatext.pc.in                |   10 +
>>>>>>  utils/media-ctl/libv4l2subdev.c                   |  106 ++
>>>>>>  utils/media-ctl/mediactl.h                        |   42 +
>>>>>>  utils/media-ctl/mediatext-test.c                  |   64 +
>>>>>>  utils/media-ctl/mediatext.c                       |  312 +++++
>>>>>>  utils/media-ctl/mediatext.h                       |   52 +
>>>>>>  utils/media-ctl/v4l2subdev.h                      |   50 +
>>>>>>  13 files changed, 2144 insertions(+), 4 deletions(-)
>>>>>>  create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
>>>>>>  create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
>>>>>>  create mode 100644 utils/media-ctl/libmediatext.pc.in
>>>>>>  create mode 100644 utils/media-ctl/mediatext-test.c
>>>>>>  create mode 100644 utils/media-ctl/mediatext.c
>>>>>>  create mode 100644 utils/media-ctl/mediatext.h
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>> Thanks,
>>> Mauro
>>>
>>>
>>>
>>
>>
>
>
>
> Thanks,
> Mauro
>
>
>


