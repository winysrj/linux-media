Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:12748 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab1AOAJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 19:09:50 -0500
Subject: VIDIOC_INT_RESET still needed in ivtv for the moment
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 19:09:34 -0500
Message-ID: <1295050174.2459.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

A few weeks ago you asked if VIDIOC_INT_RESET is still needed in ivtv.
I can now say for certain, that yes, it is still needed.

See this from 2008:

http://www.mail-archive.com/ivtv-users@ivtvdriver.org/msg08613.html

It will not be needed after I get two things done:

1. patch ivtv to issue a GPIO reset of the IR chip at module load.

2. add a way for the cx18, ivtv, and hdpvr bridge drivers to provide a
reset callback to lirc_zilog.  (I know ivtv and cx18 can provide one.)

After that, cx18 and ivtv will not need the VIDIOC_INT_RESET ioctl().

Regards,
Andy

