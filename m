Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:40755 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752949Ab2AaLjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 06:39:35 -0500
Message-ID: <1328009971.2853.9.camel@Zweitbox>
Subject: Current drivers for Hauppauge NOVA-S Plus broken (?)
From: =?ISO-8859-1?Q?J=FCrgen?= Hein <jurhein@gmx.de>
To: linux-media@vger.kernel.org
Date: Tue, 31 Jan 2012 12:39:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo,

with the current drivers from media_build_experimental for hauppauge
NOVA-S Plus (Conexant 2388x (bt878 successor) support (VIDEO_CX88)
cx8800...)does this here not more. Picture and sound with significant
dropouts.

Log:
Jan 16 12:00:28 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:28 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:31 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:31 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:34 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:34 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:37 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:37 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:40 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:40 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:43 debian vdr: [2497] frontend 2/0 lost lock on channel
580, tp 111758
Jan 16 12:00:43 debian vdr: [2497] frontend 2/0 regained lock on channel
580, tp 111758
Jan 16 12:00:49 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:00:49 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:00:52 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:00:52 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:00:55 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:00:55 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:00:58 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:00:58 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:01:01 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:01:01 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:01:04 debian vdr: [2497] frontend 2/0 lost lock on channel 2,
tp 111836
Jan 16 12:01:04 debian vdr: [2497] frontend 2/0 regained lock on channel
2, tp 111836
Jan 16 12:01:10 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:10 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
Jan 16 12:01:13 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:13 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
Jan 16 12:01:16 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:16 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
Jan 16 12:01:19 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:19 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
Jan 16 12:01:22 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:22 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
Jan 16 12:01:25 debian vdr: [2497] frontend 2/0 lost lock on channel
101, tp 112031
Jan 16 12:01:25 debian vdr: [2497] frontend 2/0 regained lock on channel
101, tp 112031
ff..

With the drivers of 11.2011 is working properly.


(Excuse me, but I am speaking no english)

THX


