Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4928 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3A2Qda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com
Subject: [RFCv1 PATCH 00/20] cx231xx: v4l2-compliance fixes
Date: Tue, 29 Jan 2013 17:32:53 +0100
Message-Id: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series cleans up the cx231xx driver based on v4l2-compliance
reports.

I have tested this on various cx231xx devices. However, I have no hardware
that supports the radio tuner, so that's untested.

Also note that vbi and the MPEG encoder support does not seem to work. It
didn't work before these patches are applied, and it doesn't work afterwards.

I'm not sure if I should try to spend time on the MPEG encoder, since to
my knowledge there are no actual consumer products that support it. I have
a dev board from Conexant (Thanks!) that allowed me to test it, but I haven't
seen anything commercially available.

One option is to eventually merge the 417 conversion, and remove it from the
driver with a final patch so that the work I've done is at least available
in git should someone be interested in getting it to work.

I will take a closer look at the vbi support, though.. It would be nice to get
that working.

Regards,

	Hans

