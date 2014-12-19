Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41294 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbaLSMOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:14:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, marbugge@cisco.com
Subject: [PATCHv3 0/3] hdmi: add unpack and logging functions
Date: Fri, 19 Dec 2014 13:14:19 +0100
Message-Id: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
adds unpacking and logging functions to hdmi.c. It also uses those
in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
once this functionality is merged).

Changes since v2:
- Applied most comments from Thierry's review
- Renamed HDMI_AUDIO_CODING_TYPE_EXT_STREAM as per Thierry's suggestion.

Thierry, if this OK, then please give your Ack and I'll post a pull
request for 3.20 for the media git tree.

Regards,

	Hans

