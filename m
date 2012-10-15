Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54649 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751302Ab2JOQFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 12:05:55 -0400
Date: Mon, 15 Oct 2012 19:05:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, remi@remlab.net, daniel-gl@gmx.net,
	sylwester.nawrocki@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Timestamps and V4L2
Message-ID: <20121015160549.GE21261@valkosipuli.retiisi.org.uk>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As a summar from the discussion, I think we have reached the following
conclusion. Please say if you agree or disagree with what's below. :-)

- The drivers will be moved to use monotonic timestamps for video buffers.
- The user space will learn about the type of the timestamp through buffer
flags.
- The timestamp source may be made selectable in the future, but buffer
flags won't be the means for this, primarily since they're not available on
subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
