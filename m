Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53662 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab0JQDXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 23:23:09 -0400
Subject: Bisected MSP34xx PVR-250/PVR-350 no audio in 2.6.36
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Cc: Shane Shrybman <shrybman@teksavvy.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 23:23:01 -0400
Message-ID: <1287285781.2267.5.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

Shane Shrybman reported that in the 2.6.36 kernel, after the first
capture on his PVR-250, TV audio from the RF input no longer works.

I verified that RF TV audio never works with a PVR-350.

I bisected the problem to this change to the msp3400 driver:

http://git.linuxtv.org/media_tree.git?a=commit;h=ebc3bba5833e7021336f09767347a52448a60bc5


$ git bisect bad
ebc3bba5833e7021336f09767347a52448a60bc5 is the first bad commit
commit ebc3bba5833e7021336f09767347a52448a60bc5
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Mon May 24 10:01:58 2010 -0300

    V4L/DVB: msp3400: convert to the new control framework
    
    Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 fabcfdd08fe2835d9a146666c891b274b6546428 2199dcba591213638336d254b3a57d38bd068de4 M	drivers


I don't have time to fix it this weekend, but there it is before I
forget.

Regards,
Andy

