Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48778 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1JIDj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 23:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <4E902B89.7030004@redhat.com>
References: <4E83A02F.2020309@xenotime.net>
	<1317418491-26513-1-git-send-email-paul.gortmaker@windriver.com>
	<4E8644D5.6080307@xenotime.net>
	<20111006140214.b64b22b77f2f831442d59794@canb.auug.org.au>
	<4E902B89.7030004@redhat.com>
Date: Sat, 8 Oct 2011 23:39:27 -0400
Message-ID: <CAP=VYLr-RYXL+WjHittjFXJ-GNwx_mqiKT34NKUvTOfrKbpZEQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/media: fix dependencies in video mt9t001/mt9p031
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-next@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 8, 2011 at 6:52 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 06-10-2011 00:02, Stephen Rothwell escreveu:
>>
>> Hi Mauro,
>>
>> On Fri, 30 Sep 2011 15:38:13 -0700 Randy Dunlap<rdunlap@xenotime.net>
>>  wrote:
>>>
>>> On 09/30/11 14:34, Paul Gortmaker wrote:
>>>>
>>>> Both mt9t001.c and mt9p031.c have two identical issues, those
>>>> being that they will need module.h inclusion for the upcoming
>>>> cleanup going on there, and that their dependencies don't limit
>>>> selection of configs that will fail to compile as follows:
>>>>
>>>> drivers/media/video/mt9p031.c:457: error: implicit declaration of
>>>> function ‘v4l2_subdev_get_try_crop’
>>>> drivers/media/video/mt9t001.c:787: error: ‘struct v4l2_subdev’ has no
>>>> member named ‘entity’
>>>>
>>>> The related config options are CONFIG_MEDIA_CONTROLLER and
>>>> CONFIG_VIDEO_V4L2_SUBDEV_API.  Looking at the code, it appears
>>>> that the driver was never intended to work without these enabled,
>>>> so add a dependency on CONFIG_VIDEO_V4L2_SUBDEV_API, which in
>>>> turn already has a dependency on CONFIG_MEDIA_CONTROLLER.
>>>>
>>>> Reported-by: Randy Dunlap<rdunlap@xenotime.net>
>>>> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>
>>>
>>> Acked-by: Randy Dunlap<rdunlap@xenotime.net>
>>
>> Ping?
>>
> Sorry, I was assuming that this patch would be going together with the
> other module.h trees. I'll apply it on my tree.

Thanks.  Since the files in question don't exist on mainline, there is no real
way I can have it directly on the module.h tree.  If your file(s) needed the
export.h file, (which my tree creates) then I'd have carried it as a post-merge
delta to get past the chicken-and-egg problem of who's new file comes 1st.

But since your file really just needs module.h -- you can add it to your tree
right away.  Plus the Kconfig change I made really should be SOB by the
folks who know the driver restrictions; I just made an educated guess.

Paul.

>
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
