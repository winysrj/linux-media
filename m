Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47777 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaKSJdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 04:33:20 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so4670912wiv.5
        for <linux-media@vger.kernel.org>; Wed, 19 Nov 2014 01:33:17 -0800 (PST)
Date: Wed, 19 Nov 2014 10:33:06 +0100
From: Francesco Marletta <fmarletta@movia.biz>
To: Carlos =?UTF-8?B?U2FubWFydMOtbg==?= Bustos <carsanbu@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Help required for TVP5151 on Overo
Message-ID: <20141119103306.07e52744@crow>
In-Reply-To: <CAPW4HR0RS3oPRLKRiD-h0e-xbK95ODFur1_VtD2aTFwZ6NEjBQ@mail.gmail.com>
References: <20141119094656.5459258b@crow>
	<CAPW4HR0RS3oPRLKRiD-h0e-xbK95ODFur1_VtD2aTFwZ6NEjBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Carlos,
thanks for your response.

I've read your message on permalink.

I'm not sure the ISP is broken, or at least it may be broken but it can
be fixed.

I'm trying to work the tvp5151 board described in [1], the author
states (and told me) that it was successfull in using that board, using
a patch that he also publish, but my board is not working (using the
same patch set). Maybe there is something different in my kernel, even
if the version is the same? 

I'm going to try applying the patch by hand, to check if there is
something different respect the source that the patch is made from.

It will be useful to me to have a kernel (with modules) that works with
that board, this way I could check if the problem is in the hw or in
the sw.

I'll continue to try.

Regards
Francesco

[1] http://www.sleepyrobot.com/?p=253


Il giorno Wed, 19 Nov 2014 10:15:36 +0100
Carlos Sanmartín Bustos <carsanbu@gmail.com> ha scritto:

> Hi Francesco,
> 
> Yesterday I sent a mail asking about similar behaviour in another
> OMAP3 board [1], I'm starting to think that OMAP3 ISP is broken in
> latest kernel versions.
> 
> I hope someone give us a solution.
> 
> Regards,
> 
> Carlos
> 
> [1]
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/84744
> 
> 2014-11-19 9:46 GMT+01:00 Francesco Marletta <fmarletta@movia.biz>:
> > Hello to everyone,
> > I'd like to know who have used the TVP5151 video decoder with the
> > OMAP3 Overo module.
> >
> > I'm trying to have the processor to capture the video from a TVP5151
> > boarda, but without success (both gstreamer and yavta wait forever
> > the data from the V4L2 subsystem).
> >
> > Thanks in advance!
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
