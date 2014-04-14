Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaDNMuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 08:50:20 -0400
Date: Mon, 14 Apr 2014 14:50:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: OV7670: ENUM_FRAMESIZES seems buggy to me
Message-ID: <Pine.LNX.4.64.1404141439210.23631@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

This loop in ov7670_enum_framesizes():

	for (i = 0; i < n_win_sizes; i++) {
		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
		if (info->min_width && win->width < info->min_width)
			continue;
		if (info->min_height && win->height < info->min_height)
			continue;
		...

seems wrong to me. If any of the above "if" statements is true, it will 
stay true forever, until the loop terminates. If that's intended, you 
could at least use "break" immediately. If it's not - something else is 
wrong there. Maybe the "win" initialisation at the top of the loop should 
have "i" as an index? I.e.

-		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
+		struct ov7670_win_size *win = &info->devtype->win_sizes[i];

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
