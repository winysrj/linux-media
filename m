Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:46348
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905AbZHWVJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 17:09:46 -0400
Subject: bug in pwc_set_shutter_speed v2.6.30.5 and fix
From: Jef Treece <treecej@comcast.net>
Reply-To: treece@gsp.org
To: linux-media@vger.kernel.org, laurent.pinchart@skynet.be
Content-Type: text/plain
Date: Sun, 23 Aug 2009 14:04:00 -0700
Message-Id: <1251061440.7262.8.camel@stoppy.bicycle.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found in recent kernel versions, I think somewhere between 2.6.29.3
and 2.6.30.3, pwc_set_shutter_speed regressed.

I was able to fix it with this one-line change
(drivers/media/video/pwc/pwc-ctrl.c line 755 in 2.6.30.5 source):

	ret = send_control_msg(pdev,
		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));

change to

	ret = send_control_msg(pdev,
		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);

I hope you find this information useful.

Thank you
Jef Treece





