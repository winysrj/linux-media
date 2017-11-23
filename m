Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:47551 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbdKWRDQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 12:03:16 -0500
Received: from classic (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
        (Authenticated sender: hadess@hadess.net)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 91399C5A73
        for <linux-media@vger.kernel.org>; Thu, 23 Nov 2017 18:03:15 +0100 (CET)
Message-ID: <1511456594.11411.3.camel@hadess.net>
Subject: Tons of input devices for USB camera in monitor
From: Bastien Nocera <hadess@hadess.net>
To: linux-media@vger.kernel.org
Date: Thu, 23 Nov 2017 18:03:14 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

My monitor, a Dell S2340T, has a builtin webcam. There's no camera
button for it, though that wasn't a problem up until recently.

This is a trimmed output of evtest:
/dev/input/event14:	DELL S2340T Webcam: DELL S2340T
/dev/input/event15:	DELL S2340T Webcam: DELL S2340T
/dev/input/event16:	DELL S2340T Webcam: DELL S2340T
<snip>
/dev/input/event31:	DELL S2340T Webcam: DELL S2340T
/dev/input/event256:	DELL S2340T Webcam: DELL S2340T
<snip>
/dev/input/event365:	DELL S2340T Webcam: DELL S2340T
/dev/input/event366:	DELL S2340T Webcam: DELL S2340T

More than a hundred device nodes registered. Only one of them shows up
in the output of "udevadm info --export-db".

Current tip of my tree is commit 37cb8e1f8e10.

Did I miss a fix going in for this problem? Do I need to try and bisect
it?

Cheers
