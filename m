Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49692 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422816Ab2JaNVf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 09:21:35 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2A659307
	for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 13:21:31 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas6.st.com [10.75.90.73])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B8FE64464
	for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 13:21:31 +0000 (GMT)
From: Alain VOLMAT <alain.volmat@st.com>
To: linux-media <linux-media@vger.kernel.org>
Date: Wed, 31 Oct 2012 14:21:30 +0100
Subject: Way to request a time discontinuity in a V4L2 encoder device
Message-ID: <E27519AE45311C49887BE8C438E68FAA01012DC87FE3@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We have developed a V4L2 mem2mem driver for an H264 encoder running on an IP of one of our SoC and would like to have one more v4l2_buffer flag value for that.

In the context of this driver, we discovered that the current V4L2 encode API is missing the feature to mention to the IP that a time discontinuity has to be created.
Time discontinuity must be triggered when there is a discontinuity in the stream to be encoded, which would for example happen when there is a seek in the data to be encoded. In such case, it means that the IP should reset its bitrate allocation algorithm.

Considering that this information should be triggered on a frame basis, the idea is to have it passed via the flags member of v4l2_buffer, with a new flag V4L2_BUF_FLAG_ENCODE_TIME_DISCONTINUITY.

The usage for this flag value are:
* Queuing a "to be encoded" v4l2_buffer with flags & V4L2_BUF_FLAG_ENCODE_TIME_DISCONTINUITY informs the driver/IP that a time discontinuity (reset in the bitrate allocation algorithm) should be performed before encoding this frame.
* The flags bit should be then propagated until the dequeue to let the application know when a buffer is the first one after a time discontinuity.

Few words about the driver itself, it is available in the following context.
1. STLinux kernel (www.stlinux.com) rather than vanilla kernel since the board support is only available there for now
2. Multicom (http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/USER_MANUAL/CD18182595.pdf) based V4L2 driver. Multicom is an ST layer to allow to send and serialize commands to our various IP.

Regards,

Alain
