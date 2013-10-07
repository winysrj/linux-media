Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4120 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3JGNta (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 09:49:30 -0400
Message-ID: <5252BBDE.5000502@xs4all.nl>
Date: Mon, 07 Oct 2013 15:49:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: V3: Agenda for the Edinburgh mini-summit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have collected all the ideas up to now in a V3 of the agenda and
included time allocated for each topic. 

The items are grouped by the person(s) that suggested them. As done in the
past those who suggested a topic and who will attend the mini-summit are
*EXPECTED TO PREPARE FOR IT*. If you present a topic, then make a (small?) presentation
if applicable. Those attending should read at least those documents from the
presenters that are of special interest to them. We have a full schedule, so let's
not waste time. If you have a presentation ready before hand, then just post a link
to your presentation so people can read it before the summit.

Please check the time I have allocated for you and let me know if you think it
is too short or too long.

We plan to start at 9:00 and we have the room until 17:30 or 18:00 (to be decided).
There are breaks from 10:00-10:30, 12:00-13:00, 15:00-15:30. So we have realistically
at best around 6 1/2 hours for actual discussions. And that's filled up completely.

The order of the topics is still up in the air. For those marked with 'LP' I would
like to have Laurent Pinchart present, but since he is also attending the ARM summit
we do not yet know when he will be available. Once I know that I'll shuffle things
around to accommodate Laurent.

Laurent, please double check if I marked topics with LP where I shouldn't or vice
versa. I have one topic with a 'LP?' prefix where I wasn't really sure. 


Topics for the V4L2/DVB mini-summit:

Hans Verkuil:
Draft presentation for all these topics: http://hverkuil.home.xs4all.nl/presentations/summit2013.odp

- (LP) Decide on how v4l2 support libraries should be organized. There is code for
  handling raw-to-sliced VBI decoding, ALSA looping, finding associated
  video/alsa nodes and for TV frequency tables. We should decide how that should
  be organized into libraries and how they should be documented. The first two
  aren't libraries at the moment, but I think they should be. The last two are
  libraries but they aren't installed. Some work is also being done on an improved
  version of the 'associating nodes' library that uses the MC if available.

  30 min

- (LP?) Define the interaction between selection API, ENUM_FRAMESIZES and S_FMT. See
  this thread for all the nasty details:

  http://www.spinics.net/lists/linux-media/msg65137.html

  Also see my draft presentation (link above) for more info and proposals.

  60 min

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

  20 min

- Colorspace: limited/full range

  10 min



Mauro Carvalho Chehab:

- Better integration between DVB and V4L2, including starting using the media
  controller API on DVB side too.

  30 min

Laurent Pinchart:

- Status update regarding the media controller API usage on ALSA (Mauro likes to
  know) and sharing i2c transmitters between V4L2 and DRM (Hans V. likes to know).

  10 min


Hugues Fruchet:

- (LP) How to handle codecs where part of the processing is done in HW and part in
  SW?

  2 hours


Sakari Ailus:

- (LP) Multi-format frames and metadata. Support would be needed on video nodes
  and V4L2 subdev nodes. I'll prepare the RFC for the former; the latter has
  an RFC here: http://www.spinics.net/lists/linux-media/msg67295.html

  50 min


Ricardo Ribalda Delgado, Sylwester Nawrocki:

- Support for multiple rectangle cropping
  See thread: http://www.spinics.net/lists/linux-media/msg67824.html

  20 min


Sylwester Nawrocki

- LED flash support

  20 min


Kieran Kunhya

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

  20 min


In principle the agenda is now closed for new topics.

Regards,

	Hans
