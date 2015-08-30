Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:32866 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbbH3O21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 10:28:27 -0400
Date: Sun, 30 Aug 2015 11:27:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v8 00/55] MC next generation patches
Message-ID: <20150830112753.65858fdd@recife.lan>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Aug 2015 00:06:11 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> That's the 8th version of the MC next generation patches.
> 
> Differences from version 7:
> 
> - Patches reworked to make the reviewers happy;
> - Bug fixes;
> - ALSA changes got their own separate patches;
> - Javier patches got integrated into this series;
> - media-entity.h structs are now properly documented;
> - Tested on both au0828 and omap3isp.
> 
> Due to the complexity of this change, other platform drivers may
> require some fixes. 
> 
> As the patch series sent before, this is not meant to be sent
> upstream yet. Its goal is to merge it for Kernel 4.4, in order to
> give people enough time to review and fix pending issues.

As on the previous series, the patches are available on my experimental
tree:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen

There's one additional patch there that removes the backlinks from G_TOPOLOGY
ioctl. I'll be posting it in separate at the ML.

I also added a new branch:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen_test

Based on the first one. It contains a hack for au0828 that exposes the tuner
also via subdev devnode, and reduces the number of output pads of the DVB
demux to just 5, as the default is too high to produce a .dot file that
would be useful. Of course, this patch should never leave my experimental
tree ;) 

There are a few other from Javier there meant to allow testing the omap3isp
on my Beaglebone (that doesn't have any sensor on it) and on his omap3
devices.

I added support at the mc_nextgen_test tool to produce Graphviz .dot
files. It is still experimental, but it is good enough to already produce
some useful graphs. The newest version is at:

	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen

I added some graphs produced by it at:
	https://mchehab.fedorapeople.org/mc-next-gen/

Regards,
Mauro
