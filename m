Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4413 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZIORTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 13:19:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: LPC v4l-dvb mini-summit agenda
Date: Tue, 15 Sep 2009 19:19:53 +0200
Cc: Andy Walls <awalls@radix.net>, Steven Toth <stoth@hauppauge.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	"Iovescu, Magdalena" <m-iovescu1@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Brandon Philips <brandon@ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909151919.53930.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I've tried to put together an initial agenda of points to discuss during
the mini-summit.

We have a room available all three days, so that makes life easier for us.

I assume that most people will want to attend at least the keynote speeches,
so I'm scheduling around that.

So Wednesday we start at 10:00 after the keynote (except for those attending
the audio track) and go on until 15:00 (yes, you are allowed to have lunch :-) ).

Thursday we can start at 9:00 until 16:00.

Friday starts with a V4L2 BoF followed by two v4l presentations, so we will
only have a session from 13:30 - 16:00. I suggest we use that to wrap up.

Of course, if someone is not directly involved in a particular topic, then
it's no problem to go to another session. But there is a lot to cover, so we
should try to stay focused. It is of course possible to continue in smaller
groups afterwards. As I said, we have the room to ourselves.

The main discussion points are these RFCs:

- V2.1 Media Controller RFC:
http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09636.html

- Bus and data format negotiation (addresses open issue #3 of the MC RFC):
http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09644.html

- Support for video timings at the input/output interface (aka support for HDTV):
http://www.mail-archive.com/davinci-linux-open-source%40linux.davincidsp.com/msg14814.html

- Allow bridge drivers to have better control over DVB frontend operations:
http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09183.html

We have some other topics as well (in no particular order):

- mercurial vs git, how important is backwards compatibility to us?
- how to do events in V4L?
- is it possible to create a pool of buffers that we can pass around to
  various video nodes?
- others?

My plan is to use the Wednesday to start with the media controller, make sure
that everyone understands what it is and what it is not and perhaps look at
one embedded device to see how well it would work. The afternoon we can look
at some of the other topics.

I hope that on Thursday we can go over the media controller in more detail,
esp. with regards to other embedded devices, current and (if possible)
upcoming. Depending on the time we might look at some other topics in the
afternoon.

Friday is mostly wrap up and a discussion of any remaining topics.

I'm pretty sure that this plan will not survive reality, but at least it is
a start.

I have the following people on my list for this mini-summit.

Sergio Alberto Aguirre Rodriguez
Sakari Ailus
Hans de Goede
Devin Heitmueller
Vaibhav Hiremath
Magdalena Iovescu
Muralidharan Karicheri
Mike Krufky
Brandon Philips
Laurent Pinchart
Steven Toth
Andy Walls

Let me know if I missed someone, or if you are on the list, but won't be
attending this mini-summit.

Note that no final decisions will be taken during this summit. That can only
happen on the list. The main purpose is to look at these RFCs and try to
shoot holes in them. Are they generic enough? Powerful enough? Will they
support the hardware that I know of? What if anything is missed? Etc, etc.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
