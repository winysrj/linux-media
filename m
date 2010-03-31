Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:56840 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0CaLAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 07:00:44 -0400
Date: Wed, 31 Mar 2010 13:00:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrzej Hajda <andrzej.hajda@wp.pl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: cx88 remote control event device
Message-ID: <20100331130042.276d7ef7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Last year, you submitted a fix for the cx88 remote control not behaving
properly on some cards. The fix works fine for me and lets me use my
remote control, and I am very grateful for this.

However, I have noticed (using powertop) that the cx88 driver is waking
up the kernel 1250 times per second to handle the remote control. I
understand that it is needed for proper operation when the remote
control is in use. What I do not understand is why it still happens
when nobody uses the remote control. Even when no application has the
event device node opened, polling still happens.

Can't we have the cx88 driver poll the remote control only when the
device node is opened? I believe this would save some power by allowing
the CPU to stay in higher C states.

Thanks,
-- 
Jean Delvare
