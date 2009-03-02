Return-path: <linux-media-owner@vger.kernel.org>
Received: from paja.nic.funet.fi ([193.166.3.10]:49956 "EHLO paja.nic.funet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZCBUDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 15:03:15 -0500
Received: (from localhost user: 'kouhia' uid#241 fake: STDIN
	(kouhia@paja.nic.funet.fi)) by nic.funet.fi id S81046AbZCBUDMO4HfA
	for <linux-media@vger.kernel.org>; Mon, 2 Mar 2009 22:03:12 +0200
From: Juhana Sadeharju <kouhia@nic.funet.fi>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: writing DVB recorder, questions
Message-Id: <S81046AbZCBUDMO4HfA/20090302200312Z+2644@nic.funet.fi>
Date: Mon, 2 Mar 2009 22:03:12 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Now I record by taking the complete TS (demuxing PID 8192)
and by skipping the video and audio packets of other TV channels
that are listed in channels.conf (only video and audio PIDs are
listed). That seems to work.

I hope the recordings are ok. There is no way to verify them now.

Xine is able to play the recordings more or less. Video may be
visible or not. Audio can be selected but by default I hear the
robovoice channel. For subtitles Xine gives the "fin" option but
it does not work (works as bad as with Me-TV recordings, perhaps
a bug in Xine?).

Xine people could check the issue and have Xine modified for channel
selection when the TS-file with multiple TV channels is played.
The complete unmodified DVB stream could be playable.

In any case, being able to record all necessary data for one
TV channel without 70% extra data of other channels (10 GB vs. 3 GB),
gives me more time to implement the proper recorder. If Xine
will not be modified to play fuller TS files, I also need to write
a post-recording filter for fixing the recordings.

Bad is that, even the DVB device allows read-only access, no
DVB application will display the TV channel while my recorder
is running. (dvbstream/mumudvb type applications are solution.)

About reliability:
I'm unwilling to use mumudvb and dvbstream type solutions which
use pipes. My dvbrec is based on shmrec which I wrote at 1998.
Standard audio recorders at 1998 in Pentium 90 MHz made dropouts
when Linux swapped or when I used other applications (as simple as
Emacs). With shmrec, having two processes and properly tuned
read-from-A/D and write-to-disk buffers, I achieved reliable
recordings even when I used other applications.

Because CPUs and disks are now faster, reliability issues are
easily skipped because problems seems to not appear. But perfect
recorder requires a reliable recorder part; other parts may be
less reliable and must not affect the reliability of the recorder.

Juhana
