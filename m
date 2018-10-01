Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48675 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728921AbeJASop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 14:44:45 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] Draft Agenda (v2) for the media summit on Thursday Oct 25th in
 Edinburgh
Message-ID: <63afc814-8b77-0762-bd0f-4f533513f983@xs4all.nl>
Date: Mon, 1 Oct 2018 14:07:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We are organizing a media mini-summit on Thursday October 25th in
Edinburgh, Edinburgh International Conference Centre.

If you plan to attend, please register on the ELCE/OSS site since we're
using there tracking system:

https://events.linuxfoundation.org/events/elc-openiot-europe-2018/register/

Name of the room for the summit: Tinto, Level 0 of the EICC

We had 75 people sign up for the summit as of a week ago, which is quite
amazing. I'm not listing all of them here, just those that I know are active
media developers:

Sakari Ailus <sakari.ailus@linux.intel.com>
Neil Armstrong <narmstrong@baylibre.com>
Kieran Bingham <kieran.bingham@ideasonboard.com>
Mauro Carvalho Chehab <mchehab@s-opensource.com>
Nicolas Dufresne <nicolas@ndufresne.ca> (Collabora)
Ezequiel Garcia <ezequiel@collabora.com>
Helen Koike <helen.koike@collabora.com>
Michael Ira Krufky <mkrufky@linuxtv.org> (Vimeo/Livestream)
Brad Love <brad@nextdimension.cc>
Jacopo Mondi <jacopo+renesas@jmondi.org>
Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> (Qtechnology A/S)
Maxime Ripard <maxime.ripard@bootlin.com>
Niklas Söderlund <niklas.soderlund@ragnatech.se>
Hans Verkuil <hverkuil@xs4all.nl> (Cisco)
Sean Young <sean@mess.org> (Monax)

Agenda
======

General remarks: the given start/end times for the various topics are
approximate since it is always hard to predict how long a discussion will take.
If people are attending other summits and those conflict with specific topics
they want to be part of, then let me know and we can rearrange the schedule
to (hopefully) accomodate that.

Let me know asap if there are problems with this schedule, or if new topics
are requested.

9:00-9:20: Introduction (Hans Verkuil)
	Settling in, hooking everything up, getting wifi/projector/etc.
	to work, drinking coffee/tea/water and a short intro :-)

9:20-9:30: Status of the HDMI CEC kernel support (Hans Verkuil)
	Give a quick overview of the status: what has been merged, what is
	still pending, what is under development.

9:35-9:45: Status of the RC kernel support (Sean Young)
	A 10 minute status update on rc-core, present and future. I'll give a
	brief presentation and leave some time for discussion.

9:45-10:00: Save/restore controls from MTD (Ricardo Ribalda Delgado)
	Industrial/Scientific sensors usually come with very extensive
	calibration information such as: per column gain, list of dead
	pixels, temperature sensor offset... etc

	We are saving that information on an flash device that is located
	by the sensor.

	Show how we are integrating that calibration flash with v4l2-ctrl.
	And if this feature is useful for someone else and upstream it.

10:00-11:00: Complex Cameras (Mauro Carvalho Chehab)
	The idea is to discuss about the undergoing work with complex camera
	development is happening.

	As we're working to merge request API, another topic for discussion
	is how to add support for requests on it (or on a separate but related
	library).

11:00-11:15: Break

11:15-12:00: Automated Testing (Ezequiel Garcia)
	There is a lot of discussion going on around testing,
	so it's a good opportunity for us to talk about our
	current testing infrastructure.

	We are already doing a good job with v4l2-compliance.
	Can we do more?

Lunch

13:30-14:30: Stateless Codec userspace (Hans Verkuil)
	Support for stateless codecs and Request API should be merged for
	4.20, and the next step is to discuss how to organize the userspace
	support.

	Hopefully by the time the media summit starts we'll have some better
	ideas of what we want in this area.

14:30-15:15: Which ioctls should be replaced with better versions? (Hans Verkuil)
	Some parts of the V4L2 API are awkward to use and I think it would be
	a good idea to look at possible candidates for that.

	Examples are the ioctls that use struct v4l2_buffer: the multiplanar support is
	really horrible, and writing code to support both single and multiplanar is hard.
	We are also running out of fields and the timeval isn't y2038 compliant.

	A proof-of-concept is here:

	https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3

	It's a bit old, but it gives a good impression of what I have in mind.

	Another candidate is VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS:
	expressing frame intervals as a fraction is really awkward and so is the fact
	that the subdev and 'normal' ioctls are not the same.

	Discuss what possible other ioctls are candidates for a refresh.

15:15-15:30: Break

15:30-16:00: Fault tolerant V4L2 (Kieran Bingham)
	In other words, how should we handle complex devices which do not 'fully
	probe' since one or more subdevices (e.g. sensors) are broken (or break
	while in use!).

16:00-16:30: Discuss the media development process
	Since we are all here, discuss any issues there may be with the media
	subsystem development process. Anything to improve?

16:30-16:45: Wrap up
	Create action items (and who will take care of them) if needed.
	Summarize and conclude the day.

End of the day: Key Signing Party
