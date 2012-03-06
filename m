Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmsout01.mbox.net ([165.212.64.31]:39626 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2CFVWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 16:22:02 -0500
Received: from cmsout01.mbox.net (cmsout01-lo [127.0.0.1])
	by cmsout01.mbox.net (Postfix) with ESMTP id CB7432ACD85
	for <linux-media@vger.kernel.org>; Tue,  6 Mar 2012 21:09:54 +0000 (GMT)
Date: Tue, 06 Mar 2012 22:09:52 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: IR mce remote
Mime-Version: 1.0
Message-ID: <187qcFVi15152S03.1331068192@web03.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm having this trouble with a MCE USB remote from SMK Manufacturing (USB ID
0609:0334). Kernel version is 3.1.9 on opensuse 12.1 32bit.
The remote itself is a Sony RM-MCE20E (RC6 compatible). But problems also
arise with the Hauppauge I've got.

Whenever I push the same button rapidly, it will trigger itself more than 2
times. Currently, this is happening with the arrows under xbmc (it will scroll
a lot more than what I pressed on the buttons). It also happens under the
small tool 'input-events' where I can get results like




21:51:55.631200: EV_MSC MSC_SCAN -2146499551
21:51:55.631205: EV_KEY KEY_RIGHT pressed
21:51:55.631205: EV_SYN code=0 value=0
^[[C21:51:55.738203: EV_MSC MSC_SCAN -2146499551
21:51:55.738204: EV_SYN code=0 value=0
21:51:55.844201: EV_MSC MSC_SCAN -2146499551
21:51:55.844202: EV_SYN code=0 value=0
21:51:55.951199: EV_MSC MSC_SCAN -2146499551
21:51:55.951201: EV_SYN code=0 value=0
21:51:56.057202: EV_MSC MSC_SCAN -2146499551
21:51:56.057203: EV_SYN code=0 value=0
^[[C21:51:56.163202: EV_MSC MSC_SCAN -2146499551
21:51:56.163203: EV_SYN code=0 value=0
^[[C^[[C^[[C^[[C21:51:56.270203: EV_MSC MSC_SCAN -2146499551
21:51:56.270205: EV_SYN code=0 value=0
^[[C^[[C^[[C21:51:56.376204: EV_MSC MSC_SCAN -2146499551
21:51:56.376206: EV_SYN code=0 value=0
^[[C^[[C^[[C^[[C21:51:56.482206: EV_MSC MSC_SCAN -2146499551
21:51:56.482207: EV_SYN code=0 value=0
^[[C^[[C^[[C^[[C21:51:56.615205: EV_MSC MSC_SCAN -2146499551
21:51:56.615207: EV_SYN code=0 value=0
^[[C^[[C^[[C^[[C^[[C^[[C^[[C^[[C21:51:56.864515: EV_KEY KEY_RIGHT released
21:51:56.864516: EV_SYN code=0 value=0




I tried increasing the delay/period value, but it does not help

ir-keytable output
...
Protocols changed to RC-6 
Repeat delay = 1000 ms, repeat period = 1000 ms
Changed Repeat delay to 2000 ms and repeat period to 5000 ms

It seems like the events are being queued somewhere and released at once and
in full (without any being discarded to respect the delay/period conditions).

Any help would be welcome.

Thx
--
Issa

