Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59903 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbcLLQgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 11:36:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
Date: Mon, 12 Dec 2016 18:37:01 +0200
Message-ID: <2038446.MEtJKT2hJE@avalon>
In-Reply-To: <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com> <20161212075124.4e1ba840@vento.lan> <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday 12 Dec 2016 13:22:50 Javier Martinez Canillas wrote:
> On 12/12/2016 06:51 AM, Mauro Carvalho Chehab wrote:
> > Em Fri,  9 Dec 2016 13:47:13 +0200 Laurent Pinchart escreveu:
> >> Hello,
> >> 
> >> This patch series fixes a regression reported by Devin Heitmueller that
> >> affects a large number of em28xx. The problem was introduced by
> >> 
> >> commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
> >> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> Date:   Tue Jan 26 06:59:39 2016 -0200
> >> 
> >>     [media] em28xx: fix implementation of s_stream
> >> 
> >> that started calling s_stream(1) in the em28xx driver when enabling the
> >> stream, resulting in the tvp5150 s_stream() operation writing several
> >> registers with values fit for other platforms (namely OMAP3, possibly
> >> others) but not for em28xx.
> >> 
> >> The series starts with two unrelated drive-by cleanups and an unrelated
> >> bug fix. It then continues with a patch to remove an unneeded and armful
> >> call to tvp5150_reset() when getting the format from the subdevice (4/6),
> >> an update of an invalid comment and the addition of macros for register
> >> bits in order to make the code more readable (5/6) and actually allow
> >> following the incorrect code flow, and finally a rework of the
> >> s_stream() operation to fix the problem.
> >> 
> >> Compared to v1,
> >> 
> >> - Patch 4/5 now calls tvp5150_reset() at probe time
> >> - Patch 5/6 is fixed with an extra ~ removed
> >> 
> >> I haven't been able to test this with an em28xx device as I don't own any
> >> that contains a tvp5150, but Mauro reported that the series fixes the
> >> issue with his device.
> >> 
> >> I also haven't been able to test anything on an OMAP3 platform, as the
> >> tvp5150 driver go broken on DT-based systems by
> > 
> > I applied today patches 1 to 3, as I don't see any risk of regressions
> > there. Stable was c/c on patch 3.
> > 
> > I want to do more tests on patches 4-6, with both progressive video and
> > RF. It would also be nice if someone could test it on OMAP3, to be sure
> > that no regressions happened there.
> 
> I've tested patches 4-6 on a IGEPv2 and video capture is still working for
> both composite input AIP1A (after changing the hardcoded selected input)
> and AIP1B.
> 
> The patches also look good to me, so please feel free to add my Reviewed-by
> and Tested-by tags on these.
> 
> I wasn't able to test S-Video since my S-Video source broke (an old DVD
> player) but this never worked for me anyways with this board.

I've tested the patches too, in composite mode only as my hardware has a 
single input. The image quality isn't very good, but I believe that's due to 
my source. It shouldn't be related to this patch series at least.

I tried both BT.656 and parallel bus modes. The latter didn't work properly, 
but it wasn't supported when I worked on TVP5151 + OMAP3 support in the first 
place anyway, so it's not a regression, just something to eventually fix (if I 
have too much free time).

-- 
Regards,

Laurent Pinchart

