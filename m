Return-path: <linux-media-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0F3VLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 17:11:15 -0400
Subject: macbook webcam no longer works on .35-rc
From: Johannes Berg <johannes@sipsolutions.net>
To: "laurent.pinchart" <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 23:11:09 +0200
Message-ID: <1277932269.11050.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm pretty sure this was a regression in .34, but haven't checked right
now, can bisect when I find time but wanted to inquire first if somebody
had ideas. All I get is:

[57372.078968] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
-32 (exp. 1).

johannes

