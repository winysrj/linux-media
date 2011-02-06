Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36410 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1BFWrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 17:47:01 -0500
Received: by wwa36 with SMTP id 36so4237626wwa.1
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 14:47:00 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 15:46:59 -0700
Message-ID: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
Subject: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Dave Johansen <davejohansen@gmail.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
Dual Express. I had previously had some issues with trying to get
channels working in MythTV (
http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
), but now it locks up with MythBuntu 10.10 when I scan for channels
in MythTV and also with the scan command line utility.

Here's the output from scan:

scan /usr/share/dvb/atsc/us-ATSC-
center-frequencies-8VSB
scanning us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 189028615:8VSB
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb

Any ideas/suggestions on how I can get this to work?

Thanks,
Dave
