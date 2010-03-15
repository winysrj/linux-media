Return-path: <linux-media-owner@vger.kernel.org>
Received: from web53305.mail.re2.yahoo.com ([206.190.49.95]:27352 "HELO
	web53305.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753206Ab0COUof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 16:44:35 -0400
Message-ID: <591118.98811.qm@web53305.mail.re2.yahoo.com>
Date: Mon, 15 Mar 2010 13:37:53 -0700 (PDT)
From: Dr Wowe <drwowe@yahoo.com>
Subject: ATSC substreams
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have my channels.conf set up for use with my TV tuner, to receive over-the-air ATSC broadcasts in the USA.
Some of my local channels have multiple substreams, which are configured in channels.conf like this:
---
21.1:509028615:8VSB:49:52:3
21.2:509028615:8VSB:65:68:4
21.3:509028615:8VSB:81:84:5
---
I can record video from a channel using the command-line:
$ azap -r 21.1
$ dd if=/dev/dvb/adapter0/dvr0 of=video.ts

My question is this: How can I configure it so that I am recording all 3 substreams at the same time, multiplexed into a single MPEG TS?  I know this is physically possible, because the old pre-DVB V4L interface I used several years ago did that, recording the raw ATSC signal from channel 21, with all of the channels included as mpeg substreams.


      
