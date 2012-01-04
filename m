Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41366 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2ADI4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 03:56:39 -0500
Date: Wed, 4 Jan 2012 10:56:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tuukkat76@gmail.com, dacohen@gmail.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, snjw23@gmail.com
Subject: [ANN] IRC meeting on new sensor control interface, 2012-01-09
 14:00 GMT+2
Message-ID: <20120104085633.GM3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'd like to announce that we'll have an IRC meeting on #v4l-meeting channel
on the new sensor control interface. The date is next Monday 2012-01-09
14:00 GMT + 2. Most important background information is this; it discusses
how image sensors should be controlled:

<URL:http://www.spinics.net/lists/linux-media/msg40861.html>

These changes currently depend on

- Integer menu controls [1],
- Selection IOCTL for subdevs [2] and
- validate_pipeline() V4L2 subdev pad op.

The full patchset, with all the latest patches for the above, is available
here. What also is there, is the SMIA++ driver which uses these interfaces.
It can be used on the Nokia N9.

<URL:http://www.spinics.net/lists/linux-media/msg41765.html>


Questions and comments are always very, very welcome by e-mail as usual. The
purpose of the meeting is to have a possibility for real-time discussion on
the topic.


[1] http://www.spinics.net/lists/linux-media/msg40796.html

[2] http://www.spinics.net/lists/linux-media/msg41503.html


Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
