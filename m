Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:56590 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbcFQKDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 06:03:11 -0400
Date: Fri, 17 Jun 2016 03:03:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Janusz Krzysztofik <jmkrzyszt@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/3] media: an attempt to refresh omap1_camera
 driver
Message-ID: <20160617100307.GE22406@atomide.com>
References: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
 <5763A114.2080309@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5763A114.2080309@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Hans Verkuil <hverkuil@xs4all.nl> [160617 00:07]:
> Hi Janusz,
> 
> On 06/16/2016 07:21 PM, Janusz Krzysztofik wrote:
> > As requested by media subsystem maintainers, here is an attempt to 
> > convert the omap1_camera driver to the vb2 framework. Also, conversion 
> > to the dmaengine framework, long awaited by ARM/OMAP maintainers, is 
> > done.

Janusz, thanks for updating to the dmaengine :)

> > Next, I'm going to approach removal of soc-camera dependency. Please 
> > let me know how much time I have for that, i.e., when the soc-camera
> > framework is going to be depreciated.
> 
> Well, it is already deprecated (i.e. new drivers cannot use it), but it won't
> be removed any time soon. There are still drivers depending on it, and some
> aren't easy to rewrite.
> 
> I have to say that it is totally unexpected to see that this omap1 driver is still
> used. In fact, we've already merged a patch that removed it for the upcoming
> 4.8 kernel. Based on this new development I'll revert that for the omap1
> driver.
> 
> Out of curiosity: is supporting the Amstrad Delta something you do as a hobby
> or are there other reasons?

Hmm if that IP old phone works fine with mainline kernel, why not keep
using it? :)

> A final note: once you've managed to drop the soc-camera dependency you should
> run the v4l2-compliance test over the video node (https://git.linuxtv.org/v4l-utils.git/).
> 
> If that passes without failures, then this driver is in good shape and can be
> moved out of staging again.

Sounds good to me also, thanks guys.

Tony
