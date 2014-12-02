Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39489 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079AbaLBMJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 07:09:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, dri-devel@lists.freedesktop.org,
	thierry.reding@gmail.com
Subject: [PATCHv2 0/3] hdmi: add unpack and logging functions
Date: Tue,  2 Dec 2014 13:08:43 +0100
Message-Id: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
adds unpacking and logging functions to hdmi.c. It also uses those
in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
once this functionality is merged).

Patches 2 and 3 have been posted before by Martin Bugge. It stalled, but
I am taking over from Martin to try and get this is. I want to use this
in a bunch of v4l2 drivers, so I would really like to see this merged.

Changes since v1:

- rename HDMI_CONTENT_TYPE_NONE to HDMI_CONTENT_TYPE_GRAPHICS to conform
  to CEA-861-F.
- added missing HDMI_AUDIO_CODING_TYPE_CXT.
- Be explicit: out of range values are called "Invalid", reserved
  values are called "Reserved".
- Incorporated most of Thierry's suggestions. Exception: I didn't
  create ..._get_name(buffer, length, ...) functions. I think it makes
  the API awkward and I am not convinced that it is that useful.
  I also kept "No Data" since that's what CEA-861-F calls it. I also
  think that "No Data" is a better description than "None" since it
  really means that nobody bothered to fill this in.

Please let me know if there are more things that need to be addressed in
these patches before they can be merged.

Regards,

	Hans

