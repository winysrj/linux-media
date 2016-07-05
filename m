Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45849
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbcGETpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 15:45:09 -0400
Subject: Re: [RFC PATCH] media: s5p-mfc - remove vidioc_g_crop
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1467322502-11180-1-git-send-email-shuahkh@osg.samsung.com>
 <CAH_td2wtizPpD59h2shZoyuTvSNr=7YjR4mSmTO9FsWaJp8dfA@mail.gmail.com>
 <772ecbb8-b1d2-b4cf-2be2-110f731b9a2b@xs4all.nl>
 <1467595835.2577.2.camel@ndufresne.ca>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
	linux-kernel@vger.kernel.org, k.debski@samsung.com,
	javier@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	jtp.park@samsung.com, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <577C0E2F.1050804@osg.samsung.com>
Date: Tue, 5 Jul 2016 13:44:47 -0600
MIME-Version: 1.0
In-Reply-To: <1467595835.2577.2.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2016 07:30 PM, Nicolas Dufresne wrote:
> Le dimanche 03 juillet 2016 à 11:43 +0200, Hans Verkuil a écrit :
>> Hi Nicolas,
>>
>> On 07/02/2016 10:29 PM, Nicolas Dufresne wrote:
>>>
>>> Le 30 juin 2016 5:35 PM, "Shuah Khan" <shuahkh@osg.samsung.com
>>> <mailto:shuahkh@osg.samsung.com>> a écrit :
>>>>
>>>> Remove vidioc_g_crop() from s5p-mfc decoder. Without its s_crop
>>>> counterpart
>>>> g_crop is not useful. Delete it.
>>>
>>> G_CROP tell the userspace which portion of the output is to be
>>> displayed. Example,  1920x1080 inside a buffer of 1920x1088. It can
>>> be
>>> implemented using G_SELECTION too, which emulate G_CROP. removing
>>> this without implementing G_SEKECTION will break certain software
>>> like
>>> GStreamer v4l2 based decoder.
>>
>> Sorry, but this is not correct.
>>
>> G_CROP for VIDEO_OUTPUT returns the output *compose* rectangle, not
>> the output
>> crop rectangle.
>>
>> Don't blame me, this is how it was defined in V4L2. The problem is
>> that for video
>> output (esp. m2m devices) you usually want to set the crop rectangle,
>> and that's
>> why the selection API was added so you can unambiguously set the crop
>> and compose
>> rectangles for both capture and output.
>>
>> Unfortunately, the exynos drivers were written before the
>> G/S_SELECTION API was
>> created, and the crop ioctls in the video output drivers actually set
>> the output
>> crop rectangle instead of the compose rectangle :-(
>>
>> This is a known inconsistency.
>>
>> You are right though that we can't remove g_crop here, I had
>> forgotten about the
>> buffer padding.
>>
>> What should happen here is that g_selection support is added to s5p-
>> mfc, and
>> have that return the proper rectangles. The g_crop can be kept, and a
>> comment
>> should be added that it returns the wrong thing, but that that is
>> needed for
>> backwards compat.

Thank you both for the review and comments. I wasn't entirely sure
about removing g-crop, hence this RFC patch. I will add g_selection
and the comment to g_crop about returning incorrect info.

thanks,
-- Shuah

>>
>> The gstreamer code should use g/s_selection if available. It should
>> check how it
>> is using g/s_crop for video output devices today and remember that
>> for output
>> devices g/s_crop is really g/s_compose, except for the exynos
>> drivers.
> 
> This is already the case. There is other non-mainline driver that do
> like exynos (I have been told).
> 
> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/commit/sys?id=7
> 4f020fd2f1dc645efe35a7ba1f951f9c5ee7c4c
> 
>>
>> It's why I recommend the selection API since it doesn't have these
>> problems.
>>
>> I think I should do another push towards implementing the selection
>> API in all
>> drivers. There aren't many left.
>>
>> Regards,
>>
>> 	Hans

