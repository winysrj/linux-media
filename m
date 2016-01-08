Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35955 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbcAHNga (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 08:36:30 -0500
Received: by mail-wm0-f51.google.com with SMTP id l65so135028705wmf.1
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2016 05:36:29 -0800 (PST)
Received: from [127.0.1.1] ([41.224.127.22])
        by smtp.gmail.com with ESMTPSA id a126sm18593276wmh.0.2016.01.08.05.36.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Jan 2016 05:36:27 -0800 (PST)
Message-ID: <568fbb5b.84e31c0a.56c09.2f3c@mx.google.com>
Date: Fri, 08 Jan 2016 05:36:27 -0800 (PST)
From: tabkaslim@gmail.com
Subject: scan single transponder and get its channels list
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I want  to scan a single transponder to get the channel list of that specific transponder I used the scan command with a file containing a single line:

S 11938000 V 27500000 3/4

the problem is after scanning that transponder it should give the channels list , but it continues to scan other transponder from the satellite.

Is there a way to force it , to only scan the needed transponder or is there any other tool that can perform this task.


Thanks for you time and any help is appreciated.
