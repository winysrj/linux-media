Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:34665 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224AbaGEW0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 18:26:39 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@opensource.se, horms@verge.net.au,
	g.liakhovetski@gmx.de, linux-kernel@lists.codethink.co.uk
Subject: rcar-vin & soc-camera device tree updates
Date: Sat,  5 Jul 2014 23:26:19 +0100
Message-Id: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a new patch, with most of the issues from the previous
reviews now fixed. If there is anything that I have missed then
please let me know.

The only issues remaining is what to do about multiple subdevices
and/or multiple ports on drivers. I have yet to do either of erroring
out or supporting them. Feedback on this issue is welcome.

