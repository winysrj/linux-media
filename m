Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43696 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755147Ab3AWNzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 08:55:19 -0500
Date: Wed, 23 Jan 2013 15:55:14 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, arun.kk@samsung.com,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Message-ID: <20130123135514.GD18639@valkosipuli.retiisi.org.uk>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <20130122184442.GB18639@valkosipuli.retiisi.org.uk>
 <040701cdf946$3a18c060$ae4a4120$%debski@samsung.com>
 <201301231003.47396.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301231003.47396.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 23, 2013 at 10:03:47AM +0100, Hans Verkuil wrote:
...
> Right. And in my view there should be no default timestamp. Drivers should
> always select MONOTONIC or COPY, and never UNKNOWN. The vb2 code should
> check for that and issue a WARN_ON if no proper timestamp type was provided.
> 
> v4l2-compliance already checks for that as well.

I agree with that.

Speaking of non-vb2 drivers --- I guess there's no reason for a driver not
to use vb2 these days. There are actually already multple reasons to use it
instead.

So, vb2 drivers should choose the timestamps, and non-vb2 drivers... well,
we shouldn't have more, but in case we do, they _must_ set the timestamp
type, as there's no "default" since the relevant IOCTLs are handled by the
driver itself rather than the V4L2 framework.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
