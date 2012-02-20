Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47177 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2BTCDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 21:03:08 -0500
Date: Mon, 20 Feb 2012 04:03:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com
Subject: Re: [PATCH v3 0/33] V4L2 subdev and sensor control changes, SMIA++
 driver and N9 camera board code
Message-ID: <20120220020304.GJ7784@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220015605.GI7784@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Feb 20, 2012 at 03:56:05AM +0200, Sakari Ailus wrote:
> Hi everyone,
> 
> This the third version of my patchset that contains:
> 
> - Integer menu controls [2],
> - Selection IOCTL for subdevs [3],
> - Sensor control changes [5,7],
> - link_validate() media entity and V4L2 subdev pad ops,
> - OMAP 3 ISP driver improvements [4],
> - SMIA++ sensor driver,
> - rm680/rm696 board code (a.k.a Nokia N9 and N950) and
> - Other V4L2 and media improvements (see individual patches)
> 
> The Docbook documentation in HTML format can be found in [11].

I forgot to mention the git tree is available here:

	http://linuxtv.org/git/sailus/media_tree.git media-for-3.4

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
