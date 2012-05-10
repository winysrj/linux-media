Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57658 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976Ab2EJUSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 16:18:54 -0400
Date: Thu, 10 May 2012 23:18:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [ANN] Selection API naming meeting #v4l-meeting next Monday
Message-ID: <20120510201849.GC3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Let's have a quick meeting 14:00 Finnish time (GMT + 3) next Monday on
#v4l-meeting on two topics:

- Selection target naming. It has been proposed that the _ACTUAL / _ACTIVE
  be removed and e.g. the crop targets would be then called
  V4L2_SEL_TGT_CROP and V4L2_SUBDEV_SEL_TGT_CROP on V4L2 and subdve
  interfaces, respectively.

- Unifying selection targets on subdevs and V4L2 API. Currently the IDs of
  mostly equivalent targets are the same, but there are subtle differences
  between the targets in some cases. We still have documented everything
  twice, even if the differences are subtle. Would it make sese to unify the
  two, and just mention the differences?

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
