Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36062 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaLBHv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 02:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <1429705.acTXlHE2TG@avalon>
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
 <1680188.7K1XCBdsCk@avalon> <CA+V-a8uaw2X_a3rfx0=avbuGnUdbqveMvJaU25hewzv9eAA8+Q@mail.gmail.com>
 <1429705.acTXlHE2TG@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 2 Dec 2014 07:51:27 +0000
Message-ID: <CA+V-a8tyOMA=k2dyJ83uM5SXav+5dTzt1pyTXVUg31L33kRCPw@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Dec 1, 2014 at 11:26 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Sunday 30 November 2014 21:30:35 Prabhakar Lad wrote:
>> On Sun, Nov 30, 2014 at 9:16 PM, Laurent Pinchart wrote:
>> > On Sunday 30 November 2014 21:05:50 Prabhakar Lad wrote:
>> >> On Sat, Nov 29, 2014 at 7:12 PM, Laurent Pinchart wrote:
>> >> > Hi Prabhakar,
>> >>
>> >> [Snip]
>> >>
>> >>>>> Sure. That's a better choice than removing the config option
>> >>>>> dependency of the fields struct v4l2_subdev.
>> >>>
>> >>> Decoupling CONFIG_VIDEO_V4L2_SUBDEV_API from the availability of the
>> >>> in-kernel pad format and selection rectangles helpers is definitely a
>> >>> good idea. I was thinking about decoupling the try format and
>> >>> rectangles from v4l2_subdev_fh by creating a kind of configuration store
>> >>> structure to store them, and embedding that structure in v4l2_subdev_fh.
>> >>> The pad-level operations would then take a pointer to the configuration
>> >>> store instead of the v4l2_subdev_fh. Bridge drivers that want to
>> >>> implement TRY_FMT based on pad-level operations would create a
>> >>> configuration store, use the pad-level operations, and destroy the
>> >>> configuration store. The userspace subdev API would use the
>> >>> configuration store from the file handle.
>> >>
>> >> are planning to work/post any time soon ? Or are you OK with suggestion
>> >> from Hans ?
>> >
>> > I have no plan to work on that myself now, I was hoping you could
>> > implement it ;-)
>>
>> OK will implement it.
>>
>> Can you please elaborate a more on this "The userspace subdev API would use
>> the configuration store from the file handle."
>
> Basically,
>
> 1. Create a subdev pad configuration store structure to store the formats and
> selection rectangles for each pad.
>
> 2. Embed an instance of that structure in v4l2_subdev_fh.
>
> 3. Modify the subdev pad ops to take a configuration store pointer instead of
> a file handle pointer.
>
> The userspace API implementation (v4l2-subdev.c) would then pass &fh->store to
> the pad operations instead of fh.
>
> Bridge drivers that need to implement TRY_FMT on top of pad ops would create a
> temporary store (or temporary stores when multiple subsdevs are involved),
> call the pad ops with a pointer to the temporary store to propagate TRY
> formats, destroy the store(s) and return the resulting format.
>
> Is that clear ?
>
Yes thank you, I'll soon shoot a RFC version.

Regards,
--Prabhakar Lad
