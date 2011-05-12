Return-path: <mchehab@gaivota>
Received: from gateway05.websitewelcome.com ([69.93.179.12]:59726 "HELO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758099Ab1ELRQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 13:16:15 -0400
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Bhupesh SHARMA'" <bhupesh.sharma@st.com>,
	<linux-media@vger.kernel.org>
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
References: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com>
Subject: RE: Audio Video synchronization for data received from a HDMI receiver chip
Date: Thu, 12 May 2011 09:59:33 -0700
Message-ID: <004b01cc10c5$f85bf6c0$e913e440$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Which HDMI receiver chip?

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bhupesh SHARMA
Sent: Wednesday, May 11, 2011 10:49 PM
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart; Guennadi Liakhovetski; Hans Verkuil
Subject: Audio Video synchronization for data received from a HDMI receiver
chip

Hi Linux media folks,

We are considering putting an advanced HDMI receiver chip on our SoC,
to allow reception of HDMI audio and video. The chip receives HDMI data
from a host like a set-up box or DVD player. It provides a video data
interface
and SPDIF/I2S audio data interface.

We plan to support the HDMI video using the V4L2 framework and the HDMI
audio using ALSA framework.

Now, what seems to be intriguing us is how the audio-video synchronization
will be maintained? Will a separate bridging entity required to ensure the
same
or whether this can be left upon a user space application like mplayer or
gstreamer.

Also is there a existing interface between the V4L2 and ALSA frameworks and
the same
can be used in our design?

Regards,
Bhupesh
ST Microelectronics
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

