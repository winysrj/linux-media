Return-path: <linux-media-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50042 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbZINVHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:07:39 -0400
Date: Mon, 14 Sep 2009 23:07:41 +0200
From: Andreas Mohr <andi@lisas.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: V4L2 drivers: potentially dangerous and inefficient
	msecs_to_jiffies() calculation
Message-ID: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

./drivers/media/video/sn9c102/sn9c102_core.c
,
./drivers/media/video/et61x251/et61x251_core.c
and
./drivers/media/video/zc0301/zc0301_core.c
do
                            cam->module_param.frame_timeout *
                            1000 * msecs_to_jiffies(1) );
multiple times each.
What they should do instead is
frame_timeout * msecs_to_jiffies(1000), I'd think.
msecs_to_jiffies(1) is quite a bit too boldly assuming
that all of the msecs_to_jiffies(x) implementation branches
always round up.

Not to mention that the current implementation needs one additional
multiplication operation as opposed to constant-aggregating it into the
msecs_to_jiffies() argument and thus nicely evaporating it into nirvana.

HTH,

Andreas Mohr
