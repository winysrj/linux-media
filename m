Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31666 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1GGRwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 13:52:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNZ0009A5NO3530@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Jul 2011 18:52:36 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LNZ00HCU5NNHD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Jul 2011 18:52:35 +0100 (BST)
Date: Thu, 07 Jul 2011 19:52:32 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l:
 add macro for 1080p59_54 preset
In-reply-to: <4E15BA35.9090806@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Message-id: <4E15F260.2010004@samsung.com>
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
 <761c3894fa161d5e702cccf80443c7dd.squirrel@webmail.xs4all.nl>
 <4E14BA02.1010207@redhat.com> <201107071333.24501.hverkuil@xs4all.nl>
 <4E15BA35.9090806@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Mauro, Hans,

I am really surprised by the havoc caused by the little 2-line patch.

Let me sum up what I (don't) like in Hans' and Mauro's approaches:

Hans approach:
- extend v4l2_enum_dv_preset with fps and flags fields,
- allow enumerating presets by both index and preset code
- add standard to macro names for presets

Pros:
- backward compatible with existing api
- very simple and effective. Setting desired preset using only 2 lines 
of code
- easy to add unfortunate 1080p59_94
- easy to differentiate 1080p59_94 from 1080p60 using VIDIOC_ENUM_DV_PRESET

Cons:
- number of existing macros must increase extensionally with number of 
features. Height, progressiveness, frequency are already present. 
Standard family is added in Hans' RFC. Some presets involve width. 
Therefore multiple holes are expected making usage of macros very 
unreliable.
- it is not possible to use VIDIOC_S_DV_PRESET to handle case when 
application just wants a preset that has 720 height. The application has 
to enumerate all existing/possible presets  (number of possible 
combinations may be large) to find a preset that suits to the 
application's needs.
- unnecessary redundancy, preset is nothing more than a standardized index

Mauro's approach:
- enumerate all possible presets using VIDIOC_ENUM_DV_PRESETS2
- choose suitable preset using index field from

Pros:
- consistency: preset can only be addressed by index field,
- no preset macros

Cons:
- structure v4l2_dv_enum_preset2 contains BT.656/BT.1120 timing related 
data, the structure should be more general. Most application would not 
use timing fields, so maybe there is no need of adding them to the 
structure.
- applications still has to enumerate through all possible combinations 
to find a suitable preset
- not compatible with existing API, two way to configure DV hardware

I propose following requirements for DV preset api basing on pros and 
cons from overmentioned approaches.
- an application should be able to choose a preset with desired 
parameters using single ioctl call
- preset should be accessed using single key. I prefer to use index as a 
key because it gives more flexibility to a driver.
- compatible with existing api as much as possible

What do you think about approach similar to S_FMT?
Please look at the code below.

struct v4l2_dv_preset2 {
    u16 width;
    u16 height;
    v4l2_fract fps;
    u32 flags; /* progressiveness, standard hints, rounding constraints */
    u32 reserved[];
};

/* Values for the standard field */
#define V4L2_DV_BT_656_1120     0       /* BT.656/1120 timing type */

struct v4l2_enum_dv_preset2 {
    u32 index;
    char name[32];
    struct v4l2_dv_preset2 preset;
    struct v4l2_dv_timings timings; /* to be removed ? */
    u32 reserved[];
};

#define    VIDIOC_ENUM_DV_PRESETS2    _IOWR('V', 83, struct 
v4l2_dv_enum_preset2)
#define    VIDIOC_S_DV_PRESET2    _IOWR('V', 84, struct v4l2_dv_preset2)
#define    VIDIOC_G_DV_PRESET2    _IOWR('V', 85, struct v4l2_dv_preset2)
#define    VIDIOC_TRY_DV_PRESET2    _IOWR('V', 86, struct v4l2_dv_preset2)

To set a mode with height 720 lines the applications would execute code 
below:

struct v4l2_dv_preset2 preset = {    .height = 720 };
ioctl(fd, VIDIOC_S_DV_PRESET2, &preset);

The preset is selected using the most interesting features like 
width/height/frequency and progressiveness.
The driver would find the preset with vertical resolution as close as 
possible to 720.
The width and fps is zero so driver is free to choose suitable/default ones.
The field flags may contain hind about choosing preset that belong to 
specific DV standard family.

I do not feel competent in the field of DV standard. Could give me more 
ideas about flags?
The flags could contain  constraint  bits similar to ones presented in 
SELECTION api.
Maybe structures v4l2_dv_preset and v4l2_enum_dv_presets could be 
utilized for purpose of presented api.
Maybe using some union/structure align magic it would be possible to 
keep binary compatibility with existing programs.

For now, I have removed unfortunate 1080P59_94 format from S5P-TV driver.
I would be very happy if the driver was merged into 3.1.
I think that it would be not possible due to 1080p59_94 issue.
The driver did not lose much of its functionality because it still 
supports 1080p60.
Moreover, adding 1080p59_94 is relatively trivial.

I hope you find this information useful.

Regards,
Tomasz Stanislawski
