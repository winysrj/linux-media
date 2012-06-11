Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx194.callplus.net.nz ([202.180.66.194]:34049 "EHLO
	mxi2.callplus.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751391Ab2FKVSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 17:18:54 -0400
Received: from [192.168.1.252] (www [192.168.1.252])
	by cs.componic (Postfix) with ESMTP id 03D0BE6198
	for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 09:09:12 +1200 (NZST)
Message-ID: <4FD65E78.9060305@componic.co.nz>
Date: Tue, 12 Jun 2012 09:09:12 +1200
From: Glenn Ramsey <gr@componic.co.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Troubleshooting inputlirc and TeVii s480
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need some advice regarding setting up a remote on a DVB card. I apologise if
this is not the correct list, but I couldn't find an lirc specific one.

I have a TeVii s480 installed in a Mythbuntu 12.04 machine, which apart from the
remote seems to be working fine. I have set up inputlirc using:

#/etc/defaults/inputlirc
EVENTS="/dev/input/ira"
OPTIONS="-g -c -m0"

/dev/input/ira and /dev/input/irb are set as symlinks to their corresponding
/dev/input/event* nodes by a udev rule. To get inputlirc to work at all I need
to restart it in /etc/rc.local because the relevant /dev/input/event* nodes are
not present when the default inutputlirc startup script runs.

The problem is that some of the keys are received twice. These keys are 0-9, and
the 4 arrow keys. It appears that the remote is being seen as a keyboard because
the 0-9 keys appear in a terminal and the arrow keys on the remote act like the
keyboard arrow keys. But if I press the back key on the remote while the
terminal has the focus then the extra keypresses stop and it appears to work
properly.

How do I disable the extra keypresses that are coming from remote?

Glenn


