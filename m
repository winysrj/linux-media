Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0D0IGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 04:06:25 -0400
Message-ID: <4BD69B66.1090904@redhat.com>
Date: Tue, 27 Apr 2010 10:08:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Doing a stable v4l-utils release
References: <4BD5423B.4040200@redhat.com> <201004260955.13792.hverkuil@xs4all.nl>
In-Reply-To: <201004260955.13792.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/26/2010 09:55 AM, Hans Verkuil wrote:
> On Monday 26 April 2010 09:35:23 Hans de Goede wrote:
>> Hi all,
>>
>> Currently v4l-utils is at version 0.7.91, which as the version
>> suggests is meant as a beta release.
>>
>> As this release seems to be working well I would like to do
>> a v4l-utils-0.8.0 release soon. This is a headsup, to give
>> people a chance to notify me of any bugs they would like to
>> see fixed first / any patches they would like to add first.
>
> This is a good opportunity to mention that I would like to run checkpatch
> over the libs and clean them up.
>
> I also know that there is a bug in the control handling code w.r.t.
> V4L2_CTRL_FLAG_NEXT_CTRL. I have a patch, but I'd like to do the clean up
> first.
>
> If no one else has major patch series that they need to apply, then I can
> start working on this. The clean up is just purely whitespace changes to
> improve readability, no functionality will be touched.
>

I've no big changes planned on the short term, so from my pov go ahead.

Regards,

Hans
