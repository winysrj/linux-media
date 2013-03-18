Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3385 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3CROMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:12:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [REVIEWv2 PATCH 0/6] v4l2: constify _IOW ioctls
Date: Mon, 18 Mar 2013 15:11:59 +0100
Message-Id: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of this patch series.

Two changes:

- fixed the handling of a frequency of 0 in the radio-keene driver (thanks
  to Laurent for spotting that special case)
- added a sixth patch that prevents the v4l2 core from printing more than the
  size of the buffer containing the name. The data in that buffer may not be
  0 terminated, either because that's how userspace passed the data or because
  of driver bugs. So safe-guard against that.

If nothing else comes up, then I plan on posting a pull request on Friday.

Regards,

	Hans

>From the first patch series:

This is the second and last phase of ensuring that the arguments of write-only
ioctls in V4L2 are const. The first phase was 4-5 months ago and added const
to s_crop, s_modulator, s_audio, s_audout, (un)subscribe_event, s_freq_hw_seek,
s_jpegcomp and s_fbuf.

This second phase adds const to s_frequency, s_tuner, s_std and s_register.
Actually, for s_std it doesn't add const but changes it to pass the std by
value which is more consistent in that particular case.

As a result drivers will be aware when they are implementing write-only ioctls
(and I saw a few drivers attempting to return data back to the user), and the
v4l2 core will know that drivers won't change the argument of a write-only
ioctls which simplifies the core debug code.

The changes have been compile-tested with the linux-media daily build but
I may have missed some more exotic architectures.

Ideally I would like to have this merged fairly early on so we have enough
time to shake out any remaining compile problems.

Regards,

        Hans

