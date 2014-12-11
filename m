Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60956 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLKOmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 09:42:49 -0500
Message-ID: <1418308963.2320.14.camel@collabora.com>
Subject: Re: coda: not generating EOS event
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	frederic.sureau@vodalys.com
Date: Thu, 11 Dec 2014 09:42:43 -0500
In-Reply-To: <CAOMZO5BgYVQQY4_jJK0h1jMW-Tpb8DHqAkfi2MerhmndMSZr3w@mail.gmail.com>
References: <CAOMZO5BgYVQQY4_jJK0h1jMW-Tpb8DHqAkfi2MerhmndMSZr3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 11 décembre 2014 à 11:00 -0200, Fabio Estevam a écrit :
> Hi,
> 
> I am running Gstreamer 1.4.4 with on a imx6q-sabresd board and I am
> able to decode a video through the coda driver.
> 
> The pipeline I use is:
> gst-launch-1.0 filesrc
> location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
> h264parse ! v4l2video1dec ! videoconvert ! fbdevsink

This is a known issue. The handling of EOS and draining is ill defined
in V4L2 specification. We should be clarifying this soon. Currently
GStreamer implements what was originally done in Exynos MFC driver. This
consist of sending empty buffer to the V4L2 Output (the input), until we
get an empty buffer (bytesused = 0) on the V4L2 Capture (output).

The CODA driver uses the new method to initiate the drain, which is to
send V4L2_DEC_CMD_STOP, this was not implemented by any driver when GST
v4l2 support was added. This is the right thing to do. This is tracked
at (contribution welcome of course):

https://bugzilla.gnome.org/show_bug.cgi?id=733864

Finally, CODA indicate that all buffer has been sent through an event,
V4L2_EVENT_EOS. This event was designed for another use case, it should
in fact be sent when the decoder is done with the encoded buffers,
rather then when the last decoded buffer has been queued. When correctly
implemented, this event cannot be used to figure-out when the last
decoded buffer has been dequeued.

During last workshop, it has been proposed to introduce a flag on the
last decoded buffer, _LAST. This flag could also be put on an empty
buffer to accommodate driver like MFC that only know it's EOS after the
last buffer has been delivered. This all need to be SPECed and
implemented. If you need to get that to run now, the easiest might be to
hack CODA to mimic MFC behavior. Implement DEC_CMD_STOP in GStreamer
shall not be very hard though, it simply need someone to do it.

cheers,
Nicolas

