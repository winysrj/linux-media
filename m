Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:63024 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3H3NBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 09:01:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>
Subject: Agenda for the Edinburgh mini-summit
Date: Fri, 30 Aug 2013 15:01:25 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201308301501.25164.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I know, we don't even know yet when the mini-summit will be held but I thought
I'd just start this thread to collect input for the agenda.

I have these topics (and I *know* that I am forgetting a few):

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

Feel free to add suggestions to this list.

Note: my email availability will be limited in the next three weeks, especially
next week, as I am travelling a lot.

Regards,

	Hans
