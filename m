Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4385 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3JVJrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Oct 2013 05:47:12 -0400
Message-ID: <52664996.1050206@xs4all.nl>
Date: Tue, 22 Oct 2013 09:47:02 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>
Subject: [ANN] Final agenda for the V4L/DVB mini-summit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is the final schedule. I moved a few topics around at the request of
Laurent and to make it a better fit for the break times.

Please note that the LED topic has moved to a slightly later timeslot.



We plan to start at 9:00 and we have the Glamis room until 18:00.

The schedule is as follows:

9:00 Welcome/Introduction

9:10 Mauro Carvalho Chehab

- Better integration between DVB and V4L2, including starting using the media
  controller API on DVB side too.

  30 min

9:40 Kieran Kunhya

- (3G/HD-)SDI multiplexed raw format

  This is a professional interface used in broadcasting and CCTV.
  The most serious issue is that many vendors provide Linux drivers with
  V4L2 and ALSA - which is not acceptable for maintaining lipsync, let
  alone maintaining the exact relationship between audio samples and
  video that SDI provides.

  Some other issues are mentioned here: https://wiki.videolan.org/SDI_API/
  The wiki page has a very loose proposal for an API, though perhaps the
  per-line idea is ambitious at this stage. Field or frame capture is
  more realistic.

10:00 Break

10:30 Ricardo Ribalda Delgado, Sylwester Nawrocki

- Support for multiple rectangle cropping
  See thread: http://www.spinics.net/lists/linux-media/msg67824.html

10:50 Sylwester Nawrocki

- LED flash support

11:10 Hans Verkuil

- Colorspace: limited/full range
Draft presentation for all these topics: http://hverkuil.home.xs4all.nl/presentations/summit2013.odp

11:20 Hans Verkuil

- VIDIOC_TRY_FMT shouldn't return -EINVAL when an unsupported pixelformat is provided,
  but in practice video capture board tend to do that, while webcam drivers tend to map
  it silently to a valid pixelformat. Some applications rely on the -EINVAL error code.

  We need to decide how to adjust the spec. I propose to just say that some drivers
  will map it silently and others will return -EINVAL and that you don't know what a
  driver will do. Also specify that an unsupported pixelformat is the only reason why
  TRY_FMT might return -EINVAL.

  Alternatively we might want to specify explicitly that EINVAL should be returned for
  video capture devices (i.e. devices supporting S_STD or S_DV_TIMINGS) and 0 for all
  others.

11:40 Hans Verkuil

- Decide on how v4l2 support libraries should be organized. There is code for
  handling raw-to-sliced VBI decoding, ALSA looping, finding associated
  video/alsa nodes and for TV frequency tables. We should decide how that should
  be organized into libraries and how they should be documented. The first two
  aren't libraries at the moment, but I think they should be. The last two are
  libraries but they aren't installed. Some work is also being done on an improved
  version of the 'associating nodes' library that uses the MC if available.

12:00 Lunch

13:00 Hans Verkuil

- Define the interaction between selection API, ENUM_FRAMESIZES and S_FMT. See
  this thread for all the nasty details:

  http://www.spinics.net/lists/linux-media/msg65137.html

  Also see my draft presentation (link above) for more info and proposals.

14:00 Laurent Pinchart

- Status update regarding the media controller API usage on ALSA (Mauro likes to
  know) and sharing i2c transmitters between V4L2 and DRM (Hans V. likes to know).

14:10 Sakari Ailus

- Multi-format frames and metadata. Support would be needed on video nodes
  and V4L2 subdev nodes. I'll prepare the RFC for the former; the latter has
  an RFC here: http://www.spinics.net/lists/linux-media/msg67295.html

15:00 Break

15:30 Hugues Fruchet

- How to handle codecs where part of the processing is done in HW and part in SW?

17:30 End


Note: these times are tentative. Some topics will take less time, some will take
more time.

Regards,

	Hans
