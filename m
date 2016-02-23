Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42164 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655AbcBWP6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 10:58:37 -0500
Date: Tue, 23 Feb 2016 17:58:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [v4l-utils PATCH 3/4] libv4l2subdev: Add a function to list
 library supported pixel codes
Message-ID: <20160223155803.GZ32612@valkosipuli.retiisi.org.uk>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456090187-1191-4-git-send-email-sakari.ailus@linux.intel.com>
 <56CC529C.8010908@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56CC529C.8010908@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2016 at 01:37:48PM +0100, Hans Verkuil wrote:
> On 02/21/16 22:29, Sakari Ailus wrote:
> > Also mark which format definitions are compat definitions for the
> > pre-existing codes. This way we don't end up listing the same formats
> > twice.
> 
> This new compat field doesn't seem to be used...

Good catch... that was an addition made in an earlier version of the patch;
the information is no longer needed once the table containing the formats is
available. I'll remove it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
