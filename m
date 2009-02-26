Return-path: <linux-media-owner@vger.kernel.org>
Received: from paja.nic.funet.fi ([193.166.3.10]:41473 "EHLO paja.nic.funet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZBZM2d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 07:28:33 -0500
Received: (from localhost user: 'kouhia' uid#241 fake: STDIN
	(kouhia@paja.nic.funet.fi)) by nic.funet.fi id S79054AbZBZM2acYeFs
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 14:28:30 +0200
From: Juhana Sadeharju <kouhia@nic.funet.fi>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: writing DVB recorder, questions
Message-Id: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
Date: Thu, 26 Feb 2009 14:28:30 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello. I started writing a simple DVB recorder, dvbrec. Perhaps
it later evolves to program such as Klear, which indeed is
clearest thing I have seen among DVB programs (but misses subtitles).

The complete stream has too much of data: 10 GB per hour.
As solution, existing recorders seems to pick only parts of the
whole stream (audio and video of one channel), missing many
features, including subtitles. The idea seems to be to drop
the parts that are unwanted and unknown (to author).

Perfect recording requires more. My idea is to pick all what comes
and drop the known parts: audio and video of the unwanted channels.
This leaves subtitles, alternative languages, robovoice, epg,
text-tv, etc. intact.

Xine plays poorly the output of "dvbstream -o 8192". I yet don't
know why. Xine people may take this early hint and think about
playing the complete DVB stream with a configurable way to play it.

Questions:

(1) In dvbstream, what happens when 8192 is only PID? I have stared
at the code but cannot figure out how the device is configured. I want
all data from the DVB device like "dvbstream -o 8192" does.
Then I may parse the stream on my own.

(2) Do I need to use demux? PES? Filters? I don't understand them.
Quick intro would be nice as well.

(3) What PID to use for subtitles? channels.conf lists numbers
512:650:17 as a last thing. They seem to be video PID (512) and
audio PID (650). Where is the subtitle PID (DMX_SUBTITLE)?

(4) I have followed Xine's way, but my program ends to
"Unable to read PAT filter". The polled and read FD is a demux FD.
How the demux should be used?

I will ask more questions later. Recording video and audio has
been easy, but subtitles, EPG, etc. are quite a different story.

PS. I'm now trying to read PAT/PTM but I get nothing from
demux FD. I'm following xine-lib, but apparently not enough well.

Juhana
