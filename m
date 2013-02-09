Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1976 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3BIKBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com
Subject: [RFCv2 PATCH 00/26] cx231xx: v4l2-compliance fixes, big-endian fixes
Date: Sat,  9 Feb 2013 11:00:30 +0100
Message-Id: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series cleans up the cx231xx driver based on v4l2-compliance
reports.

I have tested this on various cx231xx devices. However, I have no hardware
that supports the radio tuner, so that's untested.

Also note that the MPEG encoder support does not seem to work. It didn't work
before these patches are applied, and it doesn't work afterwards. At best it
will stream for a bit and then hang the machine. While I did convert the 417
code to have it pass the compliance tests, I did disable 417 support in the
single card that supports it (gracefully provided by Conexant for which I
want to thank them!) until someone can find the time to dig into it and
figure out what is wrong. Note that that board is an evaluation board and not
a consumer product.

In addition the vbi support is flaky as well. It was flaky before this patch
series, and it is equally flaky afterwards. I have managed to get something
to work only on rare occasions and only for NTSC, never for PAL.

Finally I have tested this on a big-endian machine so there are a bunch of
patches fixing a lot of endianness problems.

A general note regarding this driver: I've found this to be a particularly
fragile driver. Things like changing formats/standards, unplugging at
unexpected times and vbi support all seem very prone to errors. I have
serious doubts about the disconnect handling: this code really should use the
core support for handling such events (in particular the v4l2_device release
callback).

New since v1:

- I reverted a bunch of bytesperline calculation changes: those aren't needed
  for this driver (patch 06/26)
- Some vbi fmt patches ended up in patch 07 instead of 08, moved them to the
  right patch. No actual code was changed.
- Patches 21-26 are new.

All other patches are unchanged.

If there are no comments, then I'll post a pull request for this series in a
week.

Regards,

        Hans

