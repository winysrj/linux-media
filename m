Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46425 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2JIKew (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 06:34:52 -0400
Message-id: <5073FDC8.8090909@samsung.com>
Date: Tue, 09 Oct 2012 12:34:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1210021142210.15778@axis700.grange>
 <506ABE40.9070504@samsung.com> <201210051241.52205.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
 <506F2763.6050808@gmail.com> <Pine.LNX.4.64.1210081126140.12203@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1210081126140.12203@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10/08/2012 11:40 AM, Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2012, Sylwester Nawrocki wrote:
>> I would really like to see more than one user until we add any core code.
>> No that it couldn't be changed afterwards, but it would be nice to ensure 
>> the concepts are right and proven in real life.
> 
> Unfortunately I don't have any more systems on which I could easily enough 
> try this. I've got a beagleboard with a camera, but I don't think I'm a 
> particularly good candidate for implementing DT support for OMAP3 camera 
> drivers;-) Apart from that I've only got soc-camera based systems, of 
> which none are _really_ DT-ready... At best I could try an i.MX31 based 
> board, but that doesn't have a very well developed .dts and that would be 
> soc-camera too anyway.

I certainly wouldn't expect you would do all the job. I mean it would be good
to possibly have some other developers adding device tree support based on that 
new bindings and new infrastructure related to them. 

There have been recently some progress in device tree support for Exynos SoCs,
including common clock framework support and we hope to add FDT support to the 
Samsung SoC camera devices during this kernel cycle, based on the newly designed 
media bindings. This is going to be a second attempt, after our initial RFC from 
May [1]. It would still be SoC specific implementation, but not soc-camera based.
 
I wasn't a big fan of this asynchronous sub-devices probing, but it now seems
to be a most complete solution to me. I think it just need to be done right
at the v4l2-core so individual drivers don't get complicated too much.

--

Regards,
Sylwester

[1] http://www.spinics.net/lists/linux-media/msg48341.html
