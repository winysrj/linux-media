Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:33022 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1HJKZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 06:25:11 -0400
Message-ID: <4E425C7D.8090208@maxwell.research.nokia.com>
Date: Wed, 10 Aug 2011 13:25:01 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: nitesh moundekar <niteshmoundekar@gmail.com>
CC: Subash Patel <subashrp@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108081750.07000.laurent.pinchart@ideasonboard.com> <4E410342.3010502@gmail.com> <CAF5T7d=h=BBhmFNs3EBPMGzKAJg_fciq=iB_GKQGDB+oiL+XAg@mail.gmail.com> <4E415961.501@maxwell.research.nokia.com> <CAF5T7dkXFBkD8CtKLR5UNOtmjMiOC3F6gfryMvM6=sfybQDDnA@mail.gmail.com>
In-Reply-To: <CAF5T7dkXFBkD8CtKLR5UNOtmjMiOC3F6gfryMvM6=sfybQDDnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nitesh moundekar wrote:
> Hi Sakari,

Hi Nitesh,

> So without touching these controls, drivers should be able to work with
> default or internal settings calculated from frame rate and resolution. And
> when application like DSLR wants more control it can access those controls.

The current interface is provided from V4L2 subdevs, so the application
using that can be expected to know something of the system already.

It may be up to drivers to decide what do they implement and what they
do not. We'll have to see how generic the new way of configuring the
sensors is; my hope is that practically all raw bayer sensors (not the
SoC ones!) could be configured this way. Lack of information from
manufacturer could limit the ability to write such drivers for sensors,
though.

With such a system, an user space algorithm library (a plugin for
libv4l) will be needed in any case to come up with a fully functional
system useful for generic applications, and it may well be that this
interface will be used from the plugins.

Alternatively the old interface could be implemented using a wrapper
library for all drivers providing the new sensor configuration
interface. There would be a list of default modes, some of which could
be more board dependent than others.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
