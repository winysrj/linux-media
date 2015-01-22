Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbAVO6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:58:47 -0500
Message-ID: <1421938721.3084.35.camel@pengutronix.de>
Subject: Re: coda: not generating EOS event
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	frederic.sureau@vodalys.com
Date: Thu, 22 Jan 2015 15:58:41 +0100
In-Reply-To: <5489AE9A.8030204@xs4all.nl>
References: <CAOMZO5BgYVQQY4_jJK0h1jMW-Tpb8DHqAkfi2MerhmndMSZr3w@mail.gmail.com>
	 <1418308963.2320.14.camel@collabora.com> <5489AE9A.8030204@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 11.12.2014, 15:47 +0100 schrieb Hans Verkuil:
> Hi Pawel,
> 
> On 12/11/14 15:42, Nicolas Dufresne wrote:
> > Le jeudi 11 décembre 2014 à 11:00 -0200, Fabio Estevam a écrit :
> >> Hi,
> >>
> >> I am running Gstreamer 1.4.4 with on a imx6q-sabresd board and I am
> >> able to decode a video through the coda driver.
> >>
> >> The pipeline I use is:
> >> gst-launch-1.0 filesrc
> >> location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
> >> h264parse ! v4l2video1dec ! videoconvert ! fbdevsink
> > 
> > This is a known issue. The handling of EOS and draining is ill defined
> > in V4L2 specification. We should be clarifying this soon. Currently
> > GStreamer implements what was originally done in Exynos MFC driver. This
> > consist of sending empty buffer to the V4L2 Output (the input), until we
> > get an empty buffer (bytesused = 0) on the V4L2 Capture (output).
> > 
> > The CODA driver uses the new method to initiate the drain, which is to
> > send V4L2_DEC_CMD_STOP, this was not implemented by any driver when GST
> > v4l2 support was added. This is the right thing to do. This is tracked
> > at (contribution welcome of course):
> > 
> > https://bugzilla.gnome.org/show_bug.cgi?id=733864
> > 
> > Finally, CODA indicate that all buffer has been sent through an event,
> > V4L2_EVENT_EOS. This event was designed for another use case, it should
> > in fact be sent when the decoder is done with the encoded buffers,
> > rather then when the last decoded buffer has been queued. When correctly
> > implemented, this event cannot be used to figure-out when the last
> > decoded buffer has been dequeued.
> > 
> > During last workshop, it has been proposed to introduce a flag on the
> > last decoded buffer, _LAST. This flag could also be put on an empty
> 
> Are you planning to work on this? That was my assumption, but it's probably
> a good idea to check in case we are waiting for one another :-)

I had another look at the ELC-E 2014 V4L2 codec API document and have
tried to implement the proposed decoder draining flow in an RFC:
"Signalling last decoded frame by V4L2_BUF_FLAG_LAST and -EPIPE":

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/87152

Are you planning to pour the workshop's codec API document into a V4L2
documentation patch?

regards
Philipp

