Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:49467 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1HIP7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 11:59:40 -0400
Message-ID: <4E415961.501@maxwell.research.nokia.com>
Date: Tue, 09 Aug 2011 18:59:29 +0300
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
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108081750.07000.laurent.pinchart@ideasonboard.com> <4E410342.3010502@gmail.com> <CAF5T7d=h=BBhmFNs3EBPMGzKAJg_fciq=iB_GKQGDB+oiL+XAg@mail.gmail.com>
In-Reply-To: <CAF5T7d=h=BBhmFNs3EBPMGzKAJg_fciq=iB_GKQGDB+oiL+XAg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nitesh moundekar wrote:
> Hi all,

Hi Nitesh,

> I am worried about direction v4l2 is taking. It looks against the basic
> principle of driver i.e. hardware abstraction. So i think giving out pixel
> clock, binning, skipping, bayer pattern, etc device varying features to user
> space questionable. We can try to remain generic and proprietary or internal
> device information can be exposed at subdev level or via sysfs.

Welcome to the world of embedded devices...

What this would provide you is a way to configure sensors in a generic
way at low level without enforcing policies or putting artificial
limitations in place while being able to better gain information on the
capabilities of the devices in user space.

This level of control is essential when implementing digital cameras, be
they high end or low end in terms of hardware. If you're not doing that,
then this interface might not be relevant to you.

Also, this is not meant by any means to replace existing interfaces used
by applications.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
