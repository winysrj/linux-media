Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:13935 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2JILAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 07:00:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Tue, 9 Oct 2012 13:00:24 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1210081126140.12203@axis700.grange> <5073FDC8.8090909@samsung.com>
In-Reply-To: <5073FDC8.8090909@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091300.24124.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 9 October 2012 12:34:48 Sylwester Nawrocki wrote:
> Hi Guennadi,
> 
> On 10/08/2012 11:40 AM, Guennadi Liakhovetski wrote:
> > On Fri, 5 Oct 2012, Sylwester Nawrocki wrote:
> >> I would really like to see more than one user until we add any core code.
> >> No that it couldn't be changed afterwards, but it would be nice to ensure 
> >> the concepts are right and proven in real life.
> > 
> > Unfortunately I don't have any more systems on which I could easily enough 
> > try this. I've got a beagleboard with a camera, but I don't think I'm a 
> > particularly good candidate for implementing DT support for OMAP3 camera 
> > drivers;-) Apart from that I've only got soc-camera based systems, of 
> > which none are _really_ DT-ready... At best I could try an i.MX31 based 
> > board, but that doesn't have a very well developed .dts and that would be 
> > soc-camera too anyway.
> 
> I certainly wouldn't expect you would do all the job. I mean it would be good
> to possibly have some other developers adding device tree support based on that 
> new bindings and new infrastructure related to them. 
> 
> There have been recently some progress in device tree support for Exynos SoCs,
> including common clock framework support and we hope to add FDT support to the 
> Samsung SoC camera devices during this kernel cycle, based on the newly designed 
> media bindings. This is going to be a second attempt, after our initial RFC from 
> May [1]. It would still be SoC specific implementation, but not soc-camera based.
>  
> I wasn't a big fan of this asynchronous sub-devices probing, but it now seems
> to be a most complete solution to me. I think it just need to be done right
> at the v4l2-core so individual drivers don't get complicated too much.

After investigating this some more I think I agree with that. There are some
things where we should probably ask for advice from the i2c subsystem devs,
I'm thinking of putting the driver back into the deferred-probe state in
particular.

Creating v4l2-core support for this is crucial as it is quite complex and
without core support this is going to be a nightmare for drivers.

Regards,

	Hans
