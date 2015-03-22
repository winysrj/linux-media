Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49682 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283AbbCVMD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 08:03:27 -0400
Date: Sun, 22 Mar 2015 14:03:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] v4l2-ioctl: fill in the description for
 VIDIOC_ENUM_FMT
Message-ID: <20150322120324.GM16613@valkosipuli.retiisi.org.uk>
References: <550C0FCF.4030302@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550C0FCF.4030302@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2015 at 01:17:19PM +0100, Hans Verkuil wrote:
> The descriptions used in drivers for the formats returned with ENUM_FMT
> are all over the place.
> 
> So instead allow the core to fill in the description and flags. This
> allows drivers to drop the description and flags.
> 
> If the format is not found in the list, and if the description field is
> filled in, then just return but call WARN_ONCE to let developers know
> that this list needs to be extended.
> 
> Based on an earlier patch from Philipp Zabel:
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/81411
> 
> But this patch moves the code into the core and away from drivers.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>

Nice patch!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
