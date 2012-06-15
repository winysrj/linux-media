Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:49988 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2FONo0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:44:26 -0400
Message-ID: <4FDB3C2E.9060502@iki.fi>
Date: Fri, 15 Jun 2012 16:44:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH v4 0/7] V4L2 and V4L2 subdev selection target and flag changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Compared to the previous version of the patchset, I've fixed a few
spelling errors, changed X/O to tell whether a target or a flag is valid
on an interface to more clear Yes/No. There's also a new patch to V4L2
subdev selection API documentation fixing conflicting definition of the
KEEP_CONFIG flag.

The resulting HTML documentation is available here (same location as
last time):

<URL:http://www.retiisi.org.uk/v4l2/tmp/media_api5/>

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
