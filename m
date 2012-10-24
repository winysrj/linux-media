Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58279 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935380Ab2JXSQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 14:16:07 -0400
Date: Wed, 24 Oct 2012 21:16:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [RFC 0/4] Monotonic timestamps
Message-ID: <20121024181602.GD23933@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here's my first monotonic timestamps patch (RFC) series. It's quite
experimental, not even compile tested, which doesn't matter much at this
point anyway.

What the patches do is that they

1. Add new buffer flags for timestamp type, and a mask,
2. convert all the drivers to use monotonic timestamps and
3. tell that all drivers are using monotonic timestamps.

The assumption is that all drivers will use monotonic timestamps, especially
the timestamp type is set in videobuf(2) in drivers that use it. This could
be changed later on if we wish to make it selectable; in this case videobuf2
would need to be told, and the helper function v4l2_get_timestamp() would
need to be put to videobuf2 instead.

This depends on my previous patch "v4l: Correct definition of
v4l2_buffer.flags related to cache management".

Comments and questions are very welcome!

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
