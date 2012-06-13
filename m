Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:20402 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2FMWj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:39:29 -0400
Message-ID: <4FD91697.9050100@iki.fi>
Date: Thu, 14 Jun 2012 01:39:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH v3 0/6] V4L2 and V4L2 subdev selection target and flag changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Compared to the previous version of the patchset, I've addressed
more comments from Sylwester. The fixes are simple but yet important,
plus I added back a missing reference from the selection API to the
target reference.

The resulting HTML documentation is available here (same location as
last time):

<URL:http://www.retiisi.org.uk/v4l2/tmp/media_api5/>

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

