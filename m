Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3JOIiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 04:38:07 -0400
Date: Tue, 15 Oct 2013 10:37:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
In-Reply-To: <Pine.LNX.4.64.1310150934050.5601@axis700.grange>
Message-ID: <Pine.LNX.4.64.1310151037150.5601@axis700.grange>
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost>
 <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com>
 <52543116.60509@googlemail.com> <Pine.LNX.4.64.1310081834030.31629@axis700.grange>
 <5256ACB9.6030800@googlemail.com> <Pine.LNX.4.64.1310101539500.20787@axis700.grange>
 <20131012064555.380f692e.m.chehab@samsung.com> <Pine.LNX.4.64.1310150934050.5601@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 Oct 2013, Guennadi Liakhovetski wrote:

> Well, yes, the idea is not bad, FWIW I could live with it. Doing this 
> wouldn't be very simple though, I guess. E.g. em28xx would have to do both 
> - call balanced .s_power() for camera sensors etc. and call .suspend() for 
> tuners or whatever... But please also see my other reply in this thread 
> (to be posted shortly).

Sorry, I posted it in a different thread:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/69003

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
