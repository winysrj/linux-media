Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1JHKxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Oct 2011 06:53:08 -0400
Message-ID: <4E902B89.7030004@redhat.com>
Date: Sat, 08 Oct 2011 07:52:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Randy Dunlap <rdunlap@xenotime.net>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media: fix dependencies in video mt9t001/mt9p031
References: <4E83A02F.2020309@xenotime.net> <1317418491-26513-1-git-send-email-paul.gortmaker@windriver.com> <4E8644D5.6080307@xenotime.net> <20111006140214.b64b22b77f2f831442d59794@canb.auug.org.au>
In-Reply-To: <20111006140214.b64b22b77f2f831442d59794@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 00:02, Stephen Rothwell escreveu:
> Hi Mauro,
>
> On Fri, 30 Sep 2011 15:38:13 -0700 Randy Dunlap<rdunlap@xenotime.net>  wrote:
>>
>> On 09/30/11 14:34, Paul Gortmaker wrote:
>>> Both mt9t001.c and mt9p031.c have two identical issues, those
>>> being that they will need module.h inclusion for the upcoming
>>> cleanup going on there, and that their dependencies don't limit
>>> selection of configs that will fail to compile as follows:
>>>
>>> drivers/media/video/mt9p031.c:457: error: implicit declaration of function ‘v4l2_subdev_get_try_crop’
>>> drivers/media/video/mt9t001.c:787: error: ‘struct v4l2_subdev’ has no member named ‘entity’
>>>
>>> The related config options are CONFIG_MEDIA_CONTROLLER and
>>> CONFIG_VIDEO_V4L2_SUBDEV_API.  Looking at the code, it appears
>>> that the driver was never intended to work without these enabled,
>>> so add a dependency on CONFIG_VIDEO_V4L2_SUBDEV_API, which in
>>> turn already has a dependency on CONFIG_MEDIA_CONTROLLER.
>>>
>>> Reported-by: Randy Dunlap<rdunlap@xenotime.net>
>>> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>
>>
>> Acked-by: Randy Dunlap<rdunlap@xenotime.net>
>
> Ping?
>
Sorry, I was assuming that this patch would be going together with the
other module.h trees. I'll apply it on my tree.

Thanks,
Mauro
