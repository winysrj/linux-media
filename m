Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51937 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759325AbZKKVpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 16:45:13 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 11 Nov 2009 15:45:15 -0600
Subject: RE: [PATCH] V4L: adding digital video timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE40155936998@dlee06.ent.ti.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com>
 <76889a5297f775ff3e951ae3af801f96.squirrel@webmail.xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE4015568EF61@dlee06.ent.ti.com>
 <200911051356.29540.hverkuil@xs4all.nl>
In-Reply-To: <200911051356.29540.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

>> [MK] Could you explain this to me? In my prototype, I had tvp5146 that
>> implements S_STD and tvp7002 that implements S_PRESET. Since bridge
>driver
>> has all the knowledge about the sub devices and their capabilities, it
>can
>> set the flag for each of the input that it supports (currently I am
>> setting this flag in the board setup file that describes all the inputs
>using v4l2_input structure). So it is a matter of setting relevant cap flag
>in this file for each of the input based on what the sub device supports. I
>am not sure how core can figure this out?
>
>The problem is that we don't want to go through all drivers in order to set
>the input/output capability flags. However, v4l2_ioctl.c can easily check
>whether the v4l2_ioctl_ops struct has set vidioc_s_std, vidioc_s_dv_preset
>and/or vidioc_s_dv_timings and fill in the caps accordingly. If this is
>done
>before the vidioc_enum_input/output is called, then the driver can override
>what v4l2_ioctl.c did if that is needed.
>

Why do we need to do that? Why not leave it to the bridge driver to set that
flag since it knows all encoder/decoder connected to it and whether current encoder/decoder has support for S_STD or S_PRESET looking at the sub dev ops.
If we set them at the core, as you explained, then bridge driver needs to
override it. That is not clean IMO.

Murali

>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

