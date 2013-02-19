Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45266 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932600Ab3BSRBe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 12:01:34 -0500
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>
Subject: omap3isp, omap3-isp-live, mt9p031: snapshot-mode causing picture
 corruption
Date: Tue, 19 Feb 2013 17:01:22 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546724596F85@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

I'm still modifying your omap3-isp-live application to fit our needs.
Now I have severe problems with the snapshot-mode.

When I let the "live"-app running, the picture is fine. Then I capture
a snapshot by clicking the right mouse-button. The snapshot is taken
(1-2 seconds) and displayed on the LCD. Now the picture is corrupted.
Only the lower part of the picture looks good (altough it has a
green cast):

https://www.dropbox.com/s/ijk1nq8nrhlobfd/bad-snapshot.jpg

When I now resume the viewfinder, then a moving picture is shown, but
also partially corrupted (not a lot - just about the last 50 lines).
If I do the switching (viewfinder<->snapshot) several times, the
hardware locks completely up.

My hardware is as usual ;)
beagleboard-xm
kernel 3.7
mt9p031 running at 96Mhz (instead of 48Mhz, problem?)
lcd 800x480
vrfb with rotate 3

Further testing:
It also happens with vrfb disabled.
If I manually load a picture from disk into the resizer-input 
(in the function snapshot_process) while in snapshot-mode, the picture
is displayed correctly. 
It seems that the picture taken from the snapshot-pipeline is "dirty".
The buffer-sizes are correct though. Furthermore the snapshot-pipeline
looks nearly the same as the viewfinder-pipeline...

streaming-pipeline: http://pastebin.com/7qXtqXNz
during-snapshot-pipeline: http://pastebin.com/L5XE0h30
display-snapshot-pipeline: http://pastebin.com/dZ0zzHyC

I really have to get this working... any workarounds, dirty hacks or
ideas (or even fixes ;)) are very welcome!

Regards,

Florian

