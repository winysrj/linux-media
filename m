Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50903
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752280AbcLLQW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 11:22:57 -0500
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20161212075124.4e1ba840@vento.lan>
Cc: linux-media@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
Date: Mon, 12 Dec 2016 13:22:50 -0300
MIME-Version: 1.0
In-Reply-To: <20161212075124.4e1ba840@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/12/2016 06:51 AM, Mauro Carvalho Chehab wrote:
> Hi Laurent,
> 
> Em Fri,  9 Dec 2016 13:47:13 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
>> Hello,
>>
>> This patch series fixes a regression reported by Devin Heitmueller that
>> affects a large number of em28xx. The problem was introduced by
>>
>> commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
>> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Date:   Tue Jan 26 06:59:39 2016 -0200
>>
>>     [media] em28xx: fix implementation of s_stream
>>
>> that started calling s_stream(1) in the em28xx driver when enabling the
>> stream, resulting in the tvp5150 s_stream() operation writing several
>> registers with values fit for other platforms (namely OMAP3, possibly others)
>> but not for em28xx.
>>
>> The series starts with two unrelated drive-by cleanups and an unrelated bug
>> fix. It then continues with a patch to remove an unneeded and armful call to
>> tvp5150_reset() when getting the format from the subdevice (4/6), an update of
>> an invalid comment and the addition of macros for register bits in order to
>> make the code more readable (5/6) and actually allow following the incorrect
>> code flow, and finally a rework of the s_stream() operation to fix the
>> problem.
>>
>> Compared to v1,
>>
>> - Patch 4/5 now calls tvp5150_reset() at probe time
>> - Patch 5/6 is fixed with an extra ~ removed
>>
>> I haven't been able to test this with an em28xx device as I don't own any that
>> contains a tvp5150, but Mauro reported that the series fixes the issue with
>> his device.
>>
>> I also haven't been able to test anything on an OMAP3 platform, as the tvp5150
>> driver go broken on DT-based systems by
> 
> I applied today patches 1 to 3, as I don't see any risk of regressions
> there. Stable was c/c on patch 3.
> 
> I want to do more tests on patches 4-6, with both progressive video and RF. 
> It would also be nice if someone could test it on OMAP3, to be sure that no
> regressions happened there.
>

I've tested patches 4-6 on a IGEPv2 and video capture is still working for both
composite input AIP1A (after changing the hardcoded selected input) and AIP1B.

The patches also look good to me, so please feel free to add my Reviewed-by and
Tested-by tags on these.

I wasn't able to test S-Video since my S-Video source broke (an old DVD player)
but this never worked for me anyways with this board.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
