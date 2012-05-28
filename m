Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab2E1LUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:20:41 -0400
Message-ID: <4FC35F8F.7090703@redhat.com>
Date: Mon, 28 May 2012 13:20:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] Add hwseek caps and frequency bands
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, the entire series is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

I was thinking that it would be a good idea to add a:
#define V4L2_TUNER_CAP_BANDS_MASK 0x001f0000

to videodev2.h, which apps can then easily use to test
if the driver supports any bands other then the default,
and decide to show band selection elements of the UI or
not based on a test on the tuner-caps using that mask.

This can be done in a separate patch, or merged into
"PATCH 4/6 videodev2.h: add frequency band information"

Regards,

Hans



 >
 >


On 05/28/2012 12:46 PM, Hans Verkuil wrote:
> Changes since v1:
>
> - Fixed typo in second patch
> - Patch 5 now only contains the part about frequency bands
> - Patch 6 contains only (I hope) a non-controversial clarification
> regarding modulators (and a small change making a line more understandable).
>
> Regards,
>
> 	Hans
>
> This patch series adds improved hwseek support as discussed here:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45957.html
>
> and on irc:
>
> http://linuxtv.org/irc/v4l/index.php?date=2012-05-26
>
>  From the RFC I have implemented/documented items 1-4 and 6a. I decided
> not to go with option 6b. This may be added in the future if there is a
> clear need.
>
> The addition of the frequency band came out of this discussion:
>
> http://www.spinics.net/lists/linux-media/msg48272.html
>
> Regards,
>
>          Hans
>
