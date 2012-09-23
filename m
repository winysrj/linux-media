Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45528 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2IWL0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 07:26:42 -0400
Received: by oago6 with SMTP id o6so4623958oag.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 04:26:42 -0700 (PDT)
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 23 Sep 2012 16:56:21 +0530
Message-ID: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
Subject: Gain controls in v4l2-ctrl framework
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
B/Mg gain values.
Since these control can be re-usable I am planning to add the
following gain controls as part
of the framework:

1: V4L2_CID_GAIN_RED
2: V4L2_CID_GAIN_GREEN_RED
3: V4L2_CID_GAIN_GREEN_BLUE
4: V4L2_CID_GAIN_BLUE
5: V4L2_CID_GAIN_OFFSET

I need your opinion's to get moving to add them.

Thanks and Regards,
--Prabhakar Lad
