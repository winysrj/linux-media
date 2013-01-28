Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33164 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab3A1MGb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 07:06:31 -0500
Received: from mail174-tx2 (localhost [127.0.0.1])	by
 mail174-tx2-R.bigfish.com (Postfix) with ESMTP id A7AB03201F8	for
 <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 12:06:29 +0000 (UTC)
Received: from TX2EHSMHS021.bigfish.com (unknown [10.9.14.252])	by
 mail174-tx2.bigfish.com (Postfix) with ESMTP id C3F99360059	for
 <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 12:06:19 +0000 (UTC)
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover after
 a blank/unblank (or overlay disables after resuming)
Date: Mon, 28 Jan 2013 12:06:10 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546724582368@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

The LCD-screen can't recover the picture from omap3isp after a blank/unblank
of the framebuffer.

I have seen the problem (?) since kernel 3.5, and want now try
to clarify if probably just I am the problem, or if there is really an issue
with the omapdss-driver (or the combination omapdss/omap3isp/omapfb).

For the tests I am using the following:
- Kernel 3.7 from tmlind:
  http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git
- Beagleboard-xm with Leopard Imaging LI-5M03 (mt9p031)
- omap3-isp-live streamer app from Laurent Pinchart:
  http://git.ideasonboard.org/omap3-isp-live.git
- own written LCD-driver based on panel-generic-dpi for the hx8369 controller
  and a Truly 480x800 LCD

I am running the streamer which gives me a stream from the mt9p031 with about
25fps. Then I let the console blank, and the panel suspends (while still running
the streamer app). If I try to resume the display (unblank the screen), the
overlay gfx and vid2 disable. 

To reproduce:
root@beagleboard:/voisee# fb0=/sys/class/graphics/fb0
root@beagleboard:/voisee# setterm -blank 1
root@beagleboard:/voisee# ./streamer &

Wait until the LCD blanks after a minute (goes black).

Now unblank the screen (resume the display):
root@beagleboard:/voisee# echo 0 > $fb0/blank

Will result in the following and the following (screen flickers and goes
black again):
[ 5293.617095] omapdss DISPC error: FIFO UNDERFLOW on gfx, disabling the overlay
[ 5293.678283] omapdss DISPC error: FIFO UNDERFLOW on vid2, disabling the 
overlay

Output of mediactl -p while streaming:
http://pastebin.com/d9zDfKXu

OMAPDSS-config:
http://pastebin.com/JjF0CcCS

Now my questions:
Is this behaviour expected?
Should I suspend/disable the ISP from my application whenever the screen "wants"
to blank? 
If so, do I get some sort of event when the screen blanks (the blanking event 
from the framebuffer seems to be private).
I have a long running viewfinder-app: Should I disable the blanking at all
(setterm -blank 0)?

Thank you very much for your help/suggestions!

Regards,
Florian

