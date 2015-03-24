Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37353 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbbCXHt0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 03:49:26 -0400
From: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "divneil@outlook.com" <divneil@outlook.com>
Date: Tue, 24 Mar 2015 15:49:14 +0800
Subject: Subdev notification for video device
Message-ID: <C17522D12DF21D4F9DC8833224F23A8705F96EEB@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a use case, where, I am using subdev configuration to setup video capture.
The pipeline is something like this:

Subdevs: sd_display, sd_capture
Vdev: vcapture

 (0)sd_display(1) -> (0)sd_capture(1)->(0)vcapture

sd_display informs sd_capture of video resolution change and vdev using sd_capture needs to be informed, so, that vdev capture can be stopped.

Here, subdev notification/subscription is missing to/from vdev, in my understanding.
subdev can send notification to v4l2-dev, but not vdev.
Can you help with that? Thanks.

Regards,
Divneil 
