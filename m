Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59241
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754430AbcLUKln (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 05:41:43 -0500
Date: Wed, 21 Dec 2016 08:41:36 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
Message-ID: <20161221084136.0438edc3@vento.lan>
In-Reply-To: <2038446.MEtJKT2hJE@avalon>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
        <20161212075124.4e1ba840@vento.lan>
        <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
        <2038446.MEtJKT2hJE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 12 Dec 2016 18:37:01 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> On Monday 12 Dec 2016 13:22:50 Javier Martinez Canillas wrote:
> > On 12/12/2016 06:51 AM, Mauro Carvalho Chehab wrote:  
> > > Em Fri,  9 Dec 2016 13:47:13 +0200 Laurent Pinchart escreveu:  
> > >> Hello,
> > >> 
> > >> This patch series fixes a regression reported by Devin Heitmueller that
> > >> affects a large number of em28xx. The problem was introduced by
> > >> 
> > >> commit 13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d
> > >> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >> Date:   Tue Jan 26 06:59:39 2016 -0200
> > >> 
> > >>     [media] em28xx: fix implementation of s_stream
> > >> 
> > >> that started calling s_stream(1) in the em28xx driver when enabling the
> > >> stream, resulting in the tvp5150 s_stream() operation writing several
> > >> registers with values fit for other platforms (namely OMAP3, possibly
> > >> others) but not for em28xx.
> > >> 
> > >> The series starts with two unrelated drive-by cleanups and an unrelated
> > >> bug fix. It then continues with a patch to remove an unneeded and armful
> > >> call to tvp5150_reset() when getting the format from the subdevice (4/6),
> > >> an update of an invalid comment and the addition of macros for register
> > >> bits in order to make the code more readable (5/6) and actually allow
> > >> following the incorrect code flow, and finally a rework of the
> > >> s_stream() operation to fix the problem.
> > >> 
> > >> Compared to v1,
> > >> 
> > >> - Patch 4/5 now calls tvp5150_reset() at probe time
> > >> - Patch 5/6 is fixed with an extra ~ removed
> > >> 
> > >> I haven't been able to test this with an em28xx device as I don't own any
> > >> that contains a tvp5150, but Mauro reported that the series fixes the
> > >> issue with his device.
> > >> 
> > >> I also haven't been able to test anything on an OMAP3 platform, as the
> > >> tvp5150 driver go broken on DT-based systems by  
> > > 
> > > I applied today patches 1 to 3, as I don't see any risk of regressions
> > > there. Stable was c/c on patch 3.
> > > 
> > > I want to do more tests on patches 4-6, with both progressive video and
> > > RF. It would also be nice if someone could test it on OMAP3, to be sure
> > > that no regressions happened there.  
> > 
> > I've tested patches 4-6 on a IGEPv2 and video capture is still working for
> > both composite input AIP1A (after changing the hardcoded selected input)
> > and AIP1B.
> > 
> > The patches also look good to me, so please feel free to add my Reviewed-by
> > and Tested-by tags on these.
> > 
> > I wasn't able to test S-Video since my S-Video source broke (an old DVD
> > player) but this never worked for me anyways with this board.  
> 
> I've tested the patches too, in composite mode only as my hardware has a 
> single input. The image quality isn't very good, but I believe that's due to 
> my source. It shouldn't be related to this patch series at least.

Yesterday, I was able to make my device that generates 480p to work again,
and bought a RF modulator.

I used HVR-350 and Hauppauge MediaMVP as image sources producing NTSC output,
and Kernel 4.9 + media patches for 4.10 + tvp5150 v2 patch series.

With that, I completed the tests on HVR-950. My tests covered:
- S-Video, Composite, TV
- 480i and 480p
- Closed Captions (with HVR-350 - it seems that MediaMVP doesn't
  produce NTSC CC).

PS.: I did some tests with PAL output too, with HVR-350.

> I tried both BT.656 and parallel bus modes. The latter didn't work properly, 
> but it wasn't supported when I worked on TVP5151 + OMAP3 support in the first 
> place anyway, so it's not a regression, just something to eventually fix (if I 
> have too much free time).

With that, it seems that BT.656 is working fine. So, I'm merging the
patches and will send them on the next pull request.

Thanks,
Mauro
