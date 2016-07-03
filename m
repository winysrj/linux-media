Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60718 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbcGCJnP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2016 05:43:15 -0400
Subject: Re: [RFC PATCH] media: s5p-mfc - remove vidioc_g_crop
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
	Shuah Khan <shuahkh@osg.samsung.com>
References: <1467322502-11180-1-git-send-email-shuahkh@osg.samsung.com>
 <CAH_td2wtizPpD59h2shZoyuTvSNr=7YjR4mSmTO9FsWaJp8dfA@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
	linux-kernel@vger.kernel.org, k.debski@samsung.com,
	javier@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	jtp.park@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <772ecbb8-b1d2-b4cf-2be2-110f731b9a2b@xs4all.nl>
Date: Sun, 3 Jul 2016 11:43:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAH_td2wtizPpD59h2shZoyuTvSNr=7YjR4mSmTO9FsWaJp8dfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 07/02/2016 10:29 PM, Nicolas Dufresne wrote:
> 
> Le 30 juin 2016 5:35 PM, "Shuah Khan" <shuahkh@osg.samsung.com <mailto:shuahkh@osg.samsung.com>> a écrit :
>>
>> Remove vidioc_g_crop() from s5p-mfc decoder. Without its s_crop counterpart
>> g_crop is not useful. Delete it.
> 
> G_CROP tell the userspace which portion of the output is to be displayed. Example,  1920x1080 inside a buffer of 1920x1088. It can be
> implemented using G_SELECTION too, which emulate G_CROP. removing this without implementing G_SEKECTION will break certain software like
> GStreamer v4l2 based decoder.

Sorry, but this is not correct.

G_CROP for VIDEO_OUTPUT returns the output *compose* rectangle, not the output
crop rectangle.

Don't blame me, this is how it was defined in V4L2. The problem is that for video
output (esp. m2m devices) you usually want to set the crop rectangle, and that's
why the selection API was added so you can unambiguously set the crop and compose
rectangles for both capture and output.

Unfortunately, the exynos drivers were written before the G/S_SELECTION API was
created, and the crop ioctls in the video output drivers actually set the output
crop rectangle instead of the compose rectangle :-(

This is a known inconsistency.

You are right though that we can't remove g_crop here, I had forgotten about the
buffer padding.

What should happen here is that g_selection support is added to s5p-mfc, and
have that return the proper rectangles. The g_crop can be kept, and a comment
should be added that it returns the wrong thing, but that that is needed for
backwards compat.

The gstreamer code should use g/s_selection if available. It should check how it
is using g/s_crop for video output devices today and remember that for output
devices g/s_crop is really g/s_compose, except for the exynos drivers.

It's why I recommend the selection API since it doesn't have these problems.

I think I should do another push towards implementing the selection API in all
drivers. There aren't many left.

Regards,

	Hans
