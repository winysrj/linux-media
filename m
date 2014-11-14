Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47164 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754772AbaKNJl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 04:41:59 -0500
Date: Fri, 14 Nov 2014 11:32:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	David Cohen <dacohen@gmail.com>
Subject: Re: [PATCH 1/2] mach-omap2: remove deprecated VIDEO_OMAP2 support
Message-ID: <20141114093243.GB8907@valkosipuli.retiisi.org.uk>
References: <1415956994-5240-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415956994-5240-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 14, 2014 at 10:23:13AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The omap2 camera driver has been deprecated for a year and is now
> going to be removed. It is unmaintained and it uses an internal API
> that has long since been superseded by a much better API. Worse, that
> internal API has been abused by out-of-kernel trees (i.MX6).
> 
> In addition, Sakari stated that these drivers have never been in a
> usable state in the mainline kernel due to missing platform data.

For both:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
