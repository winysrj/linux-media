Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbGNOHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 10:07:01 -0400
Message-ID: <55A51763.8010506@linux.intel.com>
Date: Tue, 14 Jul 2015 17:06:27 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Media Controller - graph_mutex
References: <55A432D1.9060008@osg.samsung.com>
In-Reply-To: <55A432D1.9060008@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

Shuah Khan wrote:
> All,
> 
> ALSA has to make media_entity_pipeline_start() call in irq
> path. I am seeing warnings that the graph_mutex is unsafe irq
> lock as expected. We have to update MC start/stop pipeline
> to be irq safe for ALSA. Maybe there are other MC interfaces
> that need to be irq safe, but I haven't seen any problems with
> my limited testing.
> 
> So as per options, graph_mutex could be changed to a spinlock.
> It looks like drivers hold this lock and it isn't abstracted to
> MC API. Unfortunate, this would require changes to drivers that
> directly hold the lock for graph walks if this mutex is changed
> to spinlock.
> 
> e.g: drivers/media/platform/exynos4-is/fimc-isp-video.c
> 
> Changes aren't complex, just that the scope isn't limited
> to MC API.
> 
> Other ideas??

Do you have (preliminary?) patches and / or more information? I'd like
to understand why would ALSA need this.

The graph_mutex is currently also taken when the link state is modified,
and the callbacks to the drivers may involve power state changes and
device initialisation. On some busses such as I2C these are blocking
operations.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
