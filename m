Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2738 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3F1M2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 08:28:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: [RFC PATCH 0/5] Matrix and Motion Detection support
Date: Fri, 28 Jun 2013 14:27:29 +0200
Message-Id: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for matrices and motion detection and
converts the solo6x10 driver to use these new APIs.

See the RFCv2 for details on the motion detection API:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html

And this RFC for details on the matrix API (which superseeds the v4l2_md_blocks
in the RFC above):

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195

I have tested this with the solo card, both global motion detection and
regional motion detection, and it works well.

There is no documentation for the new APIs yet (other than the RFCs). I would
like to know what others think of this proposal before I start work on the
DocBook documentation.

My tentative goal is to get this in for 3.12. Once this is in place the solo
and go7007 drivers can be moved out of staging into the mainline since this is
the only thing holding them back.

Regards,

	Hans

