Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:47689 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2FMVaR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:30:17 -0400
Message-ID: <4FD9065B.2030703@iki.fi>
Date: Thu, 14 Jun 2012 00:30:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH v2 0/6] V4L2 and V4L2 subdev selection target and flag changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Compared to the previous version of the patchset, I've addressed
Sylwester's comments on the 3th patch, and made a few other changes:

- Selection flags have also been unified (patches 5 and 6),
- Documentation had references to old subdev targets (which are now
fixed) and
- The common selections section has now been moved under appendices (B).

The resulting HTML documentation is available here:

<URL:http://www.retiisi.org.uk/v4l2/tmp/media_api5/>

I'm planning to send a pull req to Mauro on this late tomorrow Finnish
time so if you wish to review it please be quick. :-) :-)

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

