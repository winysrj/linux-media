Return-path: <mchehab@pedra>
Received: from out1.ip06ir2.opaltelecom.net ([62.24.128.242]:43963 "EHLO
	out1.ip06ir2.opaltelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab1CBRZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 12:25:36 -0500
Message-Id: <9ffr5a$elf5vr@out1.ip06ir2.opaltelecom.net>
Date: Wed, 02 Mar 2011 17:25:28 +0000
To: linux-media@vger.kernel.org
From: Nick Pelling <nickpelling@nanodome.com>
Subject: Missing /dev/video[N] devices...?
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,

Problem solved - the boot sequence didn't have a makedev, so the 
/dev/video[N] nodes weren't getting automatically created. A few 
"mknod c X  Y" commands later, all the /dev/video[N] items are in place. :-)

Cheers, ....Nick Pelling....

