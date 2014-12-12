Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65336 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759609AbaLLPih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 10:38:37 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so9478114wgh.27
        for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 07:38:36 -0800 (PST)
Date: Fri, 12 Dec 2014 16:38:02 +0100
From: Francesco Marletta <fmarletta@movia.biz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Carlos =?UTF-8?B?U2FubWFydMOtbg==?= Bustos <carsanbu@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Help required for TVP5151 on Overo
Message-ID: <20141212163802.6efa5dd0@crow>
In-Reply-To: <5213550.zrY0P2Gc9u@avalon>
References: <20141119094656.5459258b@crow>
	<CAPW4HR0RS3oPRLKRiD-h0e-xbK95ODFur1_VtD2aTFwZ6NEjBQ@mail.gmail.com>
	<20141119103306.07e52744@crow>
	<5213550.zrY0P2Gc9u@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
I'll check the patches you indicated on 
	git://linuxtv.org/pinchartl/media.git omap3isp/tvp5151

Which version of the kernel are these patches for? 

Regards
Francesco



Il giorno Tue, 02 Dec 2014 01:41:23 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> ha scritto:

> Hi Francesco,
> 
> On Wednesday 19 November 2014 10:33:06 Francesco Marletta wrote:
> > Hi Carlos,
> > thanks for your response.
> > 
> > I've read your message on permalink.
> > 
> > I'm not sure the ISP is broken, or at least it may be broken but it
> > can be fixed.
> > 
> > I'm trying to work the tvp5151 board described in [1], the author
> > states (and told me) that it was successfull in using that board,
> > using a patch that he also publish, but my board is not working
> > (using the same patch set). Maybe there is something different in
> > my kernel, even if the version is the same?
> 
> For what it's worth, I've successfully used that tvp5151 board with a
> Gumstix Overo using the mainline kernel. Changes required to the
> OAMP3 ISP driver have been pushed to mainline. Some changes were
> required to the tvp5151 driver too, some have made it upstream, but I
> haven't had time to clean up and submit the rest of the tvp5151
> modifications.
> 
> I've pushed the patches to
> 
> 	git://linuxtv.org/pinchartl/media.git omap3isp/tvp5151
> 
> > I'm going to try applying the patch by hand, to check if there is
> > something different respect the source that the patch is made from.
> > 
> > It will be useful to me to have a kernel (with modules) that works
> > with that board, this way I could check if the problem is in the hw
> > or in the sw.
> > 
> > I'll continue to try.
> > 
> > [1] http://www.sleepyrobot.com/?p=253
> 
