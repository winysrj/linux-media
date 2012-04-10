Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42487 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab2DJU0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 16:26:51 -0400
Received: by bkcik5 with SMTP id ik5so151993bkc.19
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 13:26:50 -0700 (PDT)
Message-ID: <4F849787.6000503@gmail.com>
Date: Tue, 10 Apr 2012 22:26:47 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com,
	pradeep.sawlani@gmail.com
Subject: Re: [GIT PULL FOR v3.5] V4L2 subdev and sensor control changes and
 SMIA++ driver
References: <20120402162649.GE922@valkosipuli.localdomain> <4F8479E3.3040007@redhat.com>
In-Reply-To: <4F8479E3.3040007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 04/10/2012 08:20 PM, Mauro Carvalho Chehab wrote:
...
>> The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:
>>
>>    [media] pwc: poll(): Check that the device has not beem claimed for streaming already (2012-03-27 11:42:04 -0300)
>>
>> are available in the git repository at:
>>    ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5
>>
>> Jesper Juhl (1):
>>        adp1653: Remove unneeded include of version.h
>>
>> Laurent Pinchart (2):
>>        omap3isp: Prevent pipelines that contain a crashed entity from starting
>>        omap3isp: Fix frame number propagation
>>
>> Sakari Ailus (37):
>>        v4l: Introduce integer menu controls
>>        v4l: Document integer menu controls
>>        vivi: Add an integer menu test control
>>        v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
>>        v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
>>        v4l: Check pad number in get try pointer functions
>>        v4l: Support s_crop and g_crop through s/g_selection
>>        v4l: Add subdev selections documentation: svg and dia files
>>        v4l: Add subdev selections documentation
> 
> There's something wrong here:
> 
> Warning: multiple "IDs" for constraint linkend: vidioc-subdev-g-selection.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-targets.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-targets.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-flags.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection.
> No template for "/book/part/chapter/section/section/section/para" (or any of its leaves) exists in the context named "title" in the "en" localization.
> No template for "/book/part/chapter/section/section/section/para" (or any of its leaves) exists in the context named "title" in the "en" localization.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-flags.
> Warning: multiple "IDs" for constraint linkend: vidioc-subdev-g-selection.
> Warning: multiple "IDs" for constraint linkend: vidioc-subdev-g-selection.
> Warning: multiple "IDs" for constraint linkend: vidioc-subdev-g-selection.
> Warning: multiple "IDs" for constraint linkend: vidioc-subdev-g-selection.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-targets.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection-flags.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection.
> Error: no ID for constraint linkend: v4l2-jpeg-chroma-subsampling.
> Error: no ID for constraint linkend: v4l2-jpeg-chroma-subsampling.
> Warning: multiple "IDs" for constraint linkend: v4l2-subdev-selection.
> 
> The index will break if there are two places with the same ID's.
> 
> Sylvester,
> 
> Btw, you also did a similar mistake: you've added a symbol at the API called
> v4l2_jpeg_chroma_subsampling, but you didn't create any reference for v4l2-jpeg-chroma-subsampling
> at the DocBook. Instead, you've created a jpeg-chroma-subsampling-control ID,
> not sure if it is for the same structure.

Yeah, it's for same structure. 
I remember having some issues with using IDs in the Docbook directly derived 
from the enum names, and then trying to dereference a particular control 
description in other Docbook chapter. 
But that was due to using &foo-id; rather than <link linkend="foo-id">foo_name</link>
and then I missed somehow to restore the required names.

> Sakari/Sylvester,
> 
> The building system adds a link for each structure at the media header files
> to the corresponding structures inside the DocBook. It also adds it to the
> index.
> 
> You need to take care that they'll point to the right things when sending us
> a DocBook patch.

Yes, I noticed that already, a bit too late though, sorry about that. Here is 
a patch that fixes the issue: http://patchwork.linuxtv.org/patch/10512

However I'll shortly send an updated version, replacing 
the jpeg-chroma-subsampling-control symbol directly with v4l2-jpeg-chroma-subsampling.

--

Regards
Sylwester
