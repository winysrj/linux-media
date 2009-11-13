Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46003 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbZKMSTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 13:19:05 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 13 Nov 2009 12:19:10 -0600
Subject: RE: [PATCH] V4L: adding digital video timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE40155937234@dlee06.ent.ti.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com>
 <A69FA2915331DC488A831521EAE36FE4015568EF61@dlee06.ent.ti.com>
 <200911051356.29540.hverkuil@xs4all.nl>
 <200911110821.10524.hverkuil@xs4all.nl>
In-Reply-To: <200911110821.10524.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have downloaded the tree for Documentation and Applications and started first building documentation.

make media-spec

It seems to build. What output it creates? Do I edit one of the xml file
to add the documentation? After adding the documentation, I guess I need
to build again and verify the document is added in proper format. I am
assuming that the build will create a html file which I can view for 
verification of content. Please reply so that I can save some time in this
process by not re-inventing the wheel.

Thanks.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Wednesday, November 11, 2009 2:21 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com
>Subject: Re: [PATCH] V4L: adding digital video timings APIs
>
>On Thursday 05 November 2009 13:56:29 Hans Verkuil wrote:
>> On Friday 23 October 2009 22:44:34 Karicheri, Muralidharan wrote:
>> > Hans,
>> >
>> > >> following IOCTLS :-
>> > >>
>> > >>  -  verify the new v4l2_input capabilities flag added
>> > >>  -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
>> > >>  -  Set one of the supported preset using VIDIOC_S_DV_PRESET
>> > >>  -  Get current preset using VIDIOC_G_DV_PRESET
>> > >>  -  Detect current preset using VIDIOC_QUERY_DV_PRESET
>> > >>  -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
>> > >>     and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device.
>> > >>
>> > >> TODOs :
>> > >>
>> > >>  - Test it on a 64bit platform - I need help here since I don't have
>the
>> > >> platform.
>> > >>  - Add documentation (Can someone tell me which file to modify in
>the
>> > >> kernel tree?).
>> > >
>> > >Use the spec in media-spec/v4l.
>> >
>> > [MK] Where can I access this? Is this part of kernel tree (I couldn't
>find
>> > it under Documentation/video4linux/ under the kernel tree? Is it just
>updating a text file or I need to have some tool installed to access
>> > this documentation and update it.
>>
>> This has been moved around quite a bit lately. It is now in
>> linux/Documentation/DocBook/v4l. You build it using 'make media-spec'.
>>
>> > >Please also add support to v4l2-ctl.cpp in v4l2-apps/util! That's
>handy
>> > >for testing.
>> > [MK] Are you referring to the following repository for this?
>> >
>> > http://linuxtv.org/hg/~dougsland/tool/file/5b884b36bbab
>> >
>> > Is there a way I can do a git clone for this?
>>
>> Both the doc and the v4l2-ctl.cpp utility are in the master hg repository
>> (linuxtv.org/hg/v4l-dvb). The utility can be found here: v4l2-apps/util.
>> Build it using 'make apps'. The patches of the timings API, docs and
>utils
>> should all be done against the master hg tree since that is that latest
>and
>> greatest tree.
>>
>> >
>> > >
>> > >Setting the input/output capabilities should be done in v4l2-ioctl.c
>> > >rather than in the drivers. All the info you need to set these bits is
>> > >available in the core after all.
>> > >
>> >
>> > [MK] Could you explain this to me? In my prototype, I had tvp5146 that
>> > implements S_STD and tvp7002 that implements S_PRESET. Since bridge
>driver
>> > has all the knowledge about the sub devices and their capabilities, it
>can
>> > set the flag for each of the input that it supports (currently I am
>> > setting this flag in the board setup file that describes all the inputs
>using v4l2_input structure). So it is a matter of setting relevant cap flag
>in this file for each of the input based on what the sub device supports. I
>am not sure how core can figure this out?
>>
>> The problem is that we don't want to go through all drivers in order to
>set
>> the input/output capability flags. However, v4l2_ioctl.c can easily check
>> whether the v4l2_ioctl_ops struct has set vidioc_s_std,
>vidioc_s_dv_preset
>> and/or vidioc_s_dv_timings and fill in the caps accordingly. If this is
>done
>> before the vidioc_enum_input/output is called, then the driver can
>override
>> what v4l2_ioctl.c did if that is needed.
>>
>> >
>> > >I also noticed that not all new ioctls are part of video_ops. Aren't
>they
>> > >all required?
>> > >
>> > [MK] All new ioctls are supported in video_ops. I am not sure what you
>are
>> > referring to. For sub device ops, only few are required since bridge
>device
>> > can handle the rest.
>>
>> OK.
>>
>> Regards,
>>
>> 	Hans
>>
>
>Hi Murali,
>
>What is the status of this? It would be great if we can get this in for
>2.6.33.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

