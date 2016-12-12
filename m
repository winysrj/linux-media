Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49501
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750991AbcLLJvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 04:51:31 -0500
Date: Mon, 12 Dec 2016 07:51:24 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
Message-ID: <20161212075124.4e1ba840@vento.lan>
In-Reply-To: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Em Fri,  9 Dec 2016 13:47:13 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> This patch series fixes a regression reported by Devin Heitmueller that
> affects a large number of em28xx. The problem was introduced by
> 
> commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date:   Tue Jan 26 06:59:39 2016 -0200
> 
>     [media] em28xx: fix implementation of s_stream
> 
> that started calling s_stream(1) in the em28xx driver when enabling the
> stream, resulting in the tvp5150 s_stream() operation writing several
> registers with values fit for other platforms (namely OMAP3, possibly others)
> but not for em28xx.
> 
> The series starts with two unrelated drive-by cleanups and an unrelated bug
> fix. It then continues with a patch to remove an unneeded and armful call to
> tvp5150_reset() when getting the format from the subdevice (4/6), an update of
> an invalid comment and the addition of macros for register bits in order to
> make the code more readable (5/6) and actually allow following the incorrect
> code flow, and finally a rework of the s_stream() operation to fix the
> problem.
> 
> Compared to v1,
> 
> - Patch 4/5 now calls tvp5150_reset() at probe time
> - Patch 5/6 is fixed with an extra ~ removed
> 
> I haven't been able to test this with an em28xx device as I don't own any that
> contains a tvp5150, but Mauro reported that the series fixes the issue with
> his device.
> 
> I also haven't been able to test anything on an OMAP3 platform, as the tvp5150
> driver go broken on DT-based systems by

I applied today patches 1 to 3, as I don't see any risk of regressions
there. Stable was c/c on patch 3.

I want to do more tests on patches 4-6, with both progressive video and RF. 
It would also be nice if someone could test it on OMAP3, to be sure that no
regressions happened there.

So, my goal is to send those patches for -rc2, assuming that we can do
such tests, as it is likely too late for -rc1, as we'll have a short merge
window this time.

Regards,
Mauro

> commit f7b4b54e63643b740c598e044874c4bffa0f04f2
> Author: Javier Martinez Canillas <javier@osg.samsung.com>
> Date:   Fri Feb 5 17:09:58 2016 -0200
> 
>     [media] tvp5150: add HW input connectors support
> 
> Fixing it will be the topic of another patch series.
> 
> Laurent Pinchart (6):
>   v4l: tvp5150: Compile tvp5150_link_setup out if
>     !CONFIG_MEDIA_CONTROLLER
>   v4l: tvp5150: Don't inline the tvp5150_selmux() function
>   v4l: tvp5150: Add missing break in set control handler
>   v4l: tvp5150: Reset device at probe time, not in get/set format
>     handlers
>   v4l: tvp5150: Fix comment regarding output pin muxing
>   v4l: tvp5150: Don't override output pinmuxing at stream on/off time
> 
>  drivers/media/i2c/tvp5150.c     | 63 +++++++++++++++++++++++++----------------
>  drivers/media/i2c/tvp5150_reg.h |  9 ++++++
>  2 files changed, 48 insertions(+), 24 deletions(-)
> 



Thanks,
Mauro
