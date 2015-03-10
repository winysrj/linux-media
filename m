Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51044 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395AbbCJBSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 21:18:47 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/3] Add link-frequencies to struct v4l2_of_endpoint
Date: Tue, 10 Mar 2015 03:17:59 +0200
Message-Id: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

While I was adding a link_frequencies array field to struct
v4l2_of_endpoint, I also realised that the smiapp driver was not reading the
link-frequencies property from the endpoint, but the i2c device node
instead. This is what the second patch addresses.

The third patch does add support for reading the link-frequencies property
to struct v4l2_of_endpoint. There were a few options to consider. I'm not
entirely happy with the solution, but it still appears the best option to
me, all being:

1. Let drivers parse the link-frequencies property. There are three samples
from three different developers (myself, Laurent and Prabhakar) and two of
them seemed to have issues.

2. Reading the contents of the link-frequencies property in
v4l2_of_parse_endpoint() addresses the above issue. It currently has no
cleanup function to release memory reserved for the variable-size
link_frequencies array.

2a. Use a constant size array for link-frequencies. This limits the number
of link-frequencies and wastes memory elsewhere.

2b. Use devm_*() functions to allocate the memory. v4l2_of_parse_endpoint()
would require a device pointer argument in order to read variable size
content from the endpoint. One major issue in this approach is that the
configuration struct is typically short-lived as drivers allocate it in
stack in their DT node parsing function.

2c. Add a function to release resources reserved by
v4l2_of_parse_endpoint(). This is what the third patch does.

Comments are welcome.

-- 
Kind regards,
Sakari

