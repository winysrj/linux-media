Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53587 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1I2WoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 18:44:24 -0400
Received: by yxl31 with SMTP id 31so1068358yxl.19
        for <linux-media@vger.kernel.org>; Thu, 29 Sep 2011 15:44:23 -0700 (PDT)
Date: Thu, 29 Sep 2011 14:44:18 -0800
From: Roger <rogerx.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: dvbscan output Channel Number into final stdout?
Message-ID: <20110929224418.GD2824@localhost2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can we get dvbscan to output the Channel Number into the final stdout somehow?

A likely format would be something such as the following.

Current output:

KATN-DT:497028615:8VSB:49:52:3
KWFA-DT:497028615:8VSB:65:68:4
...


Suggested output:
2.1:497028615:8VSB:49:52:3
2.2:497028615:8VSB:65:68:4
...

The reason for this, the local ATSC broadcast over the air channels are not
assigning unique channel names.  However, channel numbers seem to be consistent
between the published TV Guide/TV Listings and are unique!  This seems to be
the norm for the past several years now.

There have been some minor changes with channel numbers within the past years,
but if channel numbers are used such as in the above example, mplayer should be
able to recognize mplayer dvb://2.1 or mplayer dvb://2.2, etc?

One should also be able to do something like 'dvbscan | sort' instead of trying
to test each channel to see which channel is really 2.1 or 2.2!


Currently, dvbscan outputs the channel number only when the channel is first
found and with a colon. (ie. 2:1, 2:2, ...)

1) Get/Keep Channel Number found
2) Convert/reassign the colon to a period (ie. 2:1 == 2.1, 2:2 == 2.2)
3) Print Channel Number instead of Channel Name on final stdout.


In the meantime, I should test whether mplayer has any issues with using
"mplayer dvb://2.1" instead of the channel name.  It would be really nice to be
able to schedule a cron job here with "dvbscan > .mplayer/channels.conf" to
keep channels updated and have a decent channels.conf I can use within
mplayer/mencoder scripts for playback/recording.  Currently, I have to go
through and manually run mplayer on each station frequency to figure out which
is 2.1 and which is 2.2, and so on.  Or am I barking up the wrong tree?


-- 
Roger
http://rogerx.freeshell.org/
