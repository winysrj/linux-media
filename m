Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2030 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1FYODA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2011 10:03:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC tuner-core: how to set vt->type in g_tuner?
Date: Sat, 25 Jun 2011 16:02:45 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106251602.45572.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

The tuner-core.c implementation does this at the start of g_tuner:

        if (check_mode(t, vt->type) == -EINVAL)
                return 0;
        vt->type = t->mode;

The idea is that the vt->type is set depending on whether the VIDIOC_G_TUNER
ioctl is called from a radio device node or a video device node. If we have a
tuner that can do both radio and TV, then the type is set to whatever the
current tuner mode is.

This seems reasonable, but it will actually run into problems when g_tuner
is called for audio demodulators like msp3400 or cx25840. These need to know
the correct vt->type in order to fill in the right fields.

The problem here is that the tuner subdevices are not necessarily called first.
In fact, the msp3400/cx25840 are actually called first by ivtv.

So the msp3400 will get called with type TV, and later the tuner may change that
to type RADIO. This causes inconsistencies. This has actually been observed when
testing with ivtv and a PVR-500.

There are two solutions:

1) Audit the drivers and ensure that the tuner subdevices are registered first.

2) Do not allow the tuner to switch the type.

The problem with 1 is that this will be hard to enforce in the long term. Another
problem with 1 is that I do think it is a bit unexpected from an application PoV
that the type is suddenly inconsistent with the node the ioctl is called from.

The problem with 2 is that some sensible defaults need to be filled in if the
a radio/TV tuner is called with vt->type set to a different mode than the current
mode.

I do not think that is very hard though: afc/signal can be 0, ditto for rxsubchans.
The audmode field should just report the value last set with s_tuner.

g_frequency has the same problem as g_tuner. I believe g_frequency shouldn't change
the type either. Since it already has the last set frequency for tv or radio it can
just report it.

I think the second solution is the easiest to implement and the most intuitive as
well.

Comments?

	Hans
