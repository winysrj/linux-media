Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:10556 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZFPHNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 03:13:17 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1725252wfd.4
        for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 00:13:19 -0700 (PDT)
Subject: DViCO FusionHDTV DVB-T Hybrid Tuning Regression
From: David Coles <coles.david@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Jun 2009 17:13:13 +1000
Message-Id: <1245136393.4396.82.camel@krikkit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been trying to track down a driver regression in my DViCO
FusionHDTV DVB-T Hybrid card that makes it impossible to tune to DVB
stations. In recent kernels (anything in past year) the card is detected
and /dev/dvb tree is created but attempting to scan for channels only
results in a 'tuning failed!!!'.

Tuning works quite happily on the 2.6.17 kernel (very old) but appears
to have broken somewhere around 2.6.22. Bisecting the v4l-dvb tree has
the card turning at r4675, unable to compile r4676 and r4677, then
no /dev/dvb tree being created until r5333 where tuning no longer works.

I've had a look at these diffs and guess it's possible that it broke
during the refactor at r4676, but being unable to test the card between
r4676 and r5332 makes it quite hard to narrow down (I'm also unsure why
r5333, apparently a change to the saa7134 code would have fixed the
missing /dev/dvb tree).

I'm a bit stuck at this point, but I do have a test machine set up and
quite happy to put some time into helping fix this.

Regards,
David Coles

