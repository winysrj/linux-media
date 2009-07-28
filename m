Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:55630 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZG1KCB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 06:02:01 -0400
Received: by bwz21 with SMTP id 21so786224bwz.37
        for <linux-media@vger.kernel.org>; Tue, 28 Jul 2009 03:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8ec317d30907280257r487a0dceo9c1e4515f8ef8857@mail.gmail.com>
References: <8ec317d30907280257r487a0dceo9c1e4515f8ef8857@mail.gmail.com>
Date: Tue, 28 Jul 2009 11:02:00 +0100
Message-ID: <8ec317d30907280302v174668dbqa9a350556a87854c@mail.gmail.com>
Subject: Pinnacle 3010ix and SAA716x drivers
From: Nick Spooner <nickspoon0@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Pinnacle 3010ix which I am trying to get to work under Linux.
The chips it uses are the SAA7162 video decoder/analog
demodulator/PCI-E controller, TDA8265A TV tuner (x2) and TDA10046A
DVB-T demodulator (x2). So far I have managed to load the driver for
this card (vendor 1131, product 7162, subsystem vendor 11bd, subsystem
product 100), which is saa716x, compiled from
http://www.jusst.de/hg/saa716x/.

The current problem is that the TDA10046A driver (tda1004x) is
reporting "Invalid tda1004x ID = 0xff. Can't proceed", which seems to
indicate either a firmware problem (I am using the latest available
firmware from the get-dvb-firmware script), or some kind of driver
issue. The SAA7162 seems to be functional, and /dev/dvb shows adapter0
and adapter1, under which are demux0, dvr0 and net0, but notably not
frontend0, which suggests, as one might expect, that the frontend
failed to initialise.

Pertinent dmesg output as follows:
[ 3163.548084] SAA716x Hybrid 0000:01:00.0: PCI INT A -> GSI 16
(level, low) -> IRQ 16
[ 3163.548093] SAA716x Hybrid 0000:01:00.0: setting latency timer to 64
[ 3163.605331] DVB: registering new adapter (SAA716x dvb adapter)
[ 3163.713096] Invalid tda1004x ID = 0xff. Can't proceed
[ 3163.713104] DVB: registering new adapter (SAA716x dvb adapter)
[ 3163.824165] Invalid tda1004x ID = 0xff. Can't proceed

Any advice on getting the TDA1004A to work?

Regards,
Nick Spooner
