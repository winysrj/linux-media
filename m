Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:51372 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab1EQGhv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 02:37:51 -0400
To: <linux-media@vger.kernel.org>
Subject: dvb: =?UTF-8?Q?DMX=5FOUT=5FTSDEMUX=5FTAP=20broken=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 17 May 2011 08:28:17 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <fenrir@videolan.org>
Message-ID: <e3172c94265819005a66a6f8e8fe2d3b@chewa.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

   Hello all,



I have been trying to get the newer DMX_OUT_TSDEMUX_TAP mode of the Linux

DVB demux device node to work in VLC, in favor of the older dvr method.

While VLC does get what looks like TS packets, the data seems to be

corrupted. Interestingly, if the magic PID 0x2000 is used to capture all

PIDs, then DMX_OUT_TSDEMUX_TAP seems to work just fine. This problem has

been observed by two different developers with different cards and

different delivery mechanisms (DVB-C and DVB-T).



Did anyone have any success with this?



(Code is there, but pre-compiled-out by not defining USE_DMX:

http://git.videolan.org/?p=vlc.git;a=blob;f=modules/access/dtv/linux.c;h=29426d21024f7f1c725dcac781719a0c0b15dcb9#l193

)



Thanks in advance,



-- 

Rémi Denis-Courmont

http://www.remlab.net/
