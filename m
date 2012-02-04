Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2BDWhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 17:37:42 -0500
Received: by eaah12 with SMTP id h12so1971488eaa.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 14:37:40 -0800 (PST)
Message-ID: <4F2DB332.9020106@gmail.com>
Date: Sat, 04 Feb 2012 23:37:38 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v2 04/31] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-4-git-send-email-sakari.ailus@iki.fi> <4F2D80C1.2050808@gmail.com> <4F2D9581.1040809@iki.fi>
In-Reply-To: <4F2D9581.1040809@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/04/2012 09:30 PM, Sakari Ailus wrote:
>>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE			(1<<   0)
>>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1<<   1)
>>> +#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<   2)
>>> +
>>> +/* active cropping area */
>>> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0
>>> +/* cropping bounds */
>>> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			2
>>
>> You've dropped the DEFAULT targets but the target numbers stayed
>> unchanged. How about using hex numbers ? e.g.
>>
>> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
>> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0101
> 
> Fine for me. Changed for the next revision.
> 
> I wanted to keep the target numbers the same since we're still using
> exactly the same as the V4L2.

You're right, keeping the numbers same for subdevs and regular video
nodes may be important. I'm wondering whether we should use same
definitions for subdevs, rather than inventing new ones ? In case we 
associate the selection targets with controls some target identifiers
must not actually be different. Whether the control belongs directly 
to a video node control handler or is inherited from a sub-device the
selection target would have to be same. I'm referring here to an auto
focus rectangle selection target base for instance.
I guess including videodev2.h from v4l2-subdev.h is not an option, if
at all necessary ?

--

Thanks,
Sylwester
