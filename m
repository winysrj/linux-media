Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56643 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbcE0Syt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 14:54:49 -0400
Received: from jgebben-mac.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jgebben@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id D8D0661388
	for <linux-media@vger.kernel.org>; Fri, 27 May 2016 18:54:47 +0000 (UTC)
From: Jeremy Gebben <jgebben@codeaurora.org>
Subject: multi-sensor media controller
To: linux-media@vger.kernel.org
Message-ID: <21de7cb7-69b1-94bd-584a-e5494bfb7dc8@codeaurora.org>
Date: Fri, 27 May 2016 12:54:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can someone give me a quick sanity check on a media controller set up?

We have have devices (well, phones) that can have 2 or more sensors and 
2 or more 'front end' ISPs.  The ISPs take CSI input from a sensor, and 
can produce Bayer and YUV output to memory. There is a bridge between 
the sensors and ISPs which allow any ISP to receive input from any 
sensor. We would (eventually) like to use the request API to ensure that 
sensor and ISP settings match for every frame.

We use this hardware in several different ways, some of the interesting 
ones are described below:

1. 2 sensors running independently, and possibly at different frame 
rates. For example in video chat you might want a "Picture in Picture" 
setup where you send output from both a front and back sensor.
(note: 'B' is the bridge)

SENSOR_A --> B --> ISP_X --> BUFFERS
              B
SENSOR_B --> B --> ISP_Y --> BUFFERS

2. Single sensor, dual ISP. High resolution use of a single sensor may
require both ISPs to work on different regions of the image. For 
example, ISP_X might process the left half of the image while ISP_Y 
processes the right.

SENSOR_A --> B --> ISP_X ----> BUFFERS
              B --> ISP_Y --/
              B

3. 2 different types of sensors working together to produce a single set 
of images. Processing must be synchronized, and eventually the buffers 
from SENSOR_A and SENSOR_C will be combined by other processing not 
shown here.

SENSOR_A --> B --> ISP_X --> BUFFERS
SENSOR_C --> B --> ISP_Y --> BUFFERS
              B

It seems to me that the way to do handle all these cases would be to put 
all of the hardware in a single media_device:

  +----------------------+
  |  SENSOR_A  B  ISP_X  |
  |  SENSOR_C  B         |
  |  SENSOR_B  B  ISP_Y  |
  +----------------------+

This makes cases #2 and #3 above easy to configure. But the topology can 
get rather large if the number of sensors and ISPs goes up. Also, case 
#1 could be a little strange because there would be 2 independent sets 
of requests coming to the same media_device at the same time.

Am I on the right track here?

I did find Guennadi's presentation about multi-stream:
https://linuxtv.org/downloads/presentations/media_summit_2016_san_diego/v4l2-multistream.pdf

...but I'm not sure I follow all of it from the slides alone, and
we don't have the mux/demux hardware that was the focus of his presentation.

Thanks,

Jeremy

-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  a Linux Foundation Collaborative Project
