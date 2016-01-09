Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46214 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756099AbcAIXED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 18:04:03 -0500
Date: Sun, 10 Jan 2016 01:03:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, Nikhil Devshatwar <nikhil.nd@ti.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] [media] Check v4l2_of_parse_endpoint() ret val in
 all drivers
Message-ID: <20160109230330.GG576@valkosipuli.retiisi.org.uk>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thu, Jan 07, 2016 at 03:27:14PM -0300, Javier Martinez Canillas wrote:
> Hello,
> 
> When discussing a patch [0] with Laurent Pinchart for another series I
> mentioned to him that most callers of v4l2_of_parse_endpoint() weren't
> checking the return value. This is likely due the function kernel-doc
> stating incorrectly that the return value is always 0 but can return a
> negative error code on failure.
> 
> This trivial patch series fixes the function kernel-doc and add proper
> error checking in all the drivers that are currently not doing so.

After fixing patches 5 and 6,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
