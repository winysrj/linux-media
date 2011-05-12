Return-path: <mchehab@gaivota>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:39639 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab1ELFtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 01:49:23 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 12 May 2011 13:48:52 +0800
Subject: Audio Video synchronization for data received from a HDMI receiver
 chip
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Linux media folks,

We are considering putting an advanced HDMI receiver chip on our SoC,
to allow reception of HDMI audio and video. The chip receives HDMI data
from a host like a set-up box or DVD player. It provides a video data interface
and SPDIF/I2S audio data interface.

We plan to support the HDMI video using the V4L2 framework and the HDMI
audio using ALSA framework.

Now, what seems to be intriguing us is how the audio-video synchronization
will be maintained? Will a separate bridging entity required to ensure the same
or whether this can be left upon a user space application like mplayer or gstreamer.

Also is there a existing interface between the V4L2 and ALSA frameworks and the same
can be used in our design?

Regards,
Bhupesh
ST Microelectronics
