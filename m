Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:48572 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3IJJfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 05:35:08 -0400
To: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: V2: Agenda for the Edinburgh mini-summit
From: Hans Verkuil <hansverk@cisco.com>
Date: Tue, 10 Sep 2013 11:34:32 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201309101134.32883.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have collected all the ideas up to now in a V2 of the agenda.

The items are grouped by the person(s) that suggested them. As done in the
past those who suggested a topic and who will attend the mini-summit are
expected to prepare for it, perhaps making a (very) small presentation if
necessary.

Hans Verkuil:

- Discuss ideas/use-cases for a property-based API. An initial discussion
  appeared in this thread:

  http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/65195

- What is needed to share i2c video transmitters between drm and v4l? Hopefully
  we will know more after the upcoming LPC.

- Decide on how v4l2 support libraries should be organized. There is code for
  handling raw-to-sliced VBI decoding, ALSA looping, finding associated
  video/alsa nodes and for TV frequency tables. We should decide how that should
  be organized into libraries and how they should be documented. The first two
  aren't libraries at the moment, but I think they should be. The last two are
  libraries but they aren't installed. Some work is also being done on an improved
  version of the 'associating nodes' library that uses the MC if available.

- Define the interaction between selection API, ENUM_FRAMESIZES and S_FMT. See
  this thread for all the nasty details:

  http://www.spinics.net/lists/linux-media/msg65137.html

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

Mauro Carvalho Chehab:

- Better integration between DVB and V4L2, including starting using the media
  controller API on DVB side too.

- Get the status about the media controller API usage on ALSA.

Oliver Schinagl, Benjamin Gaignard, Hugues Fruchet, Laurent Pinchart, Pawel Osciak:

- How to handle codecs where part of the processing is done in HW and part in
  SW?

Sakari Ailus:

- Multi-format frames and metadata. Support would be needed on video nodes
  and V4L2 subdev nodes. I'll prepare the RFC for the former; the latter has
  an RFC here: http://www.spinics.net/lists/linux-media/msg67295.html

Ricardo Ribalda Delgado, Sylwester Nawrocki:

- Support for multiple rectangle cropping
  See thread: http://www.spinics.net/lists/linux-media/msg67824.html

Feel free to add suggestions to this list.

As it stands I don't think it will be possible to handle it all in one day.
In particular the codec problem as mentioned by Oliver et al needs a lot of
time. Should we set aside a separate day for just this? October 21 or 22
would work for me. I would really like to get some feedback on this. If we
decide to go for a second day for this topic, then I can see if I can get
a room. It looks like there is a lot of interest in getting this sorted,
so brainstorming for a day might be quite useful.

Note: my email availability will be limited in the next two weeks, especially
next week, as I am abroad (LinuxCon and LPC).

Regards,

	Hans

_______________________________________________
media-workshop mailing list
media-workshop@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop
