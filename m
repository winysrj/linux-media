Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42714 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1EXAez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:34:55 -0400
From: Jeongtae Park <jtp.park@samsung.com>
To: Jeongtae Park <jtp.park@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, jonghun.han@samsung.com,
	june.bae@samsung.com, janghyuck.kim@samsung.com,
	younglak1004.kim@samsung.com, m.szyprowski@samsung.com
Subject: Add support control framework in MFC decoder
Date: Tue, 24 May 2011 09:28:36 +0900
Message-Id: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
This patch series implements MFC contorl framework support in decoder.

I started with below branch (MFC v8)
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/mfc_v8
and apply control event patch series by Hans Verkuil to the branch.
After that add some minor changes to support per-buffer control in the framework.
Last, migrate MFC decoder to the control framework.

Any comments are welcome!

This patch series contains:
[PATCH 1/4] media: MFC: Remove usused variables & compile warnings
[PATCH 2/4] v4l2: Apply control events patch series
[PATCH 3/4] v4l2-ctrls: add support for per-buffer control
[PATCH 4/4] media: MFC: Add support control framework in decoder

Best regards,
Jeongtae Park
