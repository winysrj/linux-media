Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:50445 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbZAWCNr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 21:13:47 -0500
Date: Thu, 22 Jan 2009 20:58:15 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Tuning a pvrusb2 device.  Every attempt has failed.
Message-ID: <20090123015815.GA22113@shibaya.lonestar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Still trying to get the OnAir Creator to work.  It is properly recognized
by the pvrusb2 driver, but I can't seem to get any further.  I'm now
trying to scan the digital channels.

What I have already tried:

o Channel scan with mythtv completes, but when trying to view any of the
  supposedly found channels, I get a blank screen.  Mythtv says it can't
  get a signal lock.
o Channel scan withh kaffeine: as it progresses, I see the occasional green
  light, most often with a relatively low number (15-25% or so) of signal
  strength and an even lower number (1-3% or so) of SNR.  When the progress
  bar reaches about 80% the scan suddenly ends and there is nothing in the
  right column, where the found channels are supposed to go (right?).
  Usually the next operation I try crashes kaffeine.  I'm still trying to
  find gdb on this new lenny install.  Until I do I won't be able to get
  a trace-back.
o Scan with 'scan' from dvb-tools.  I used the us-ATSC-center-frequencies-8VSB
  file from kaffeine.  I get this:

scanning /tmp/us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 57028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 57028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
... [ exactly the same output for most channels but then I get a few
      channels like this ]
>>> tune to: 497028615:8VSB
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb
...
dumping lists (0 services)
Done.

o If I try to tune it (to one of the frequencies that gives a filter
  timeout, with dvbtune from dvb-tools) I get this:

> dvbtune -f 533028615
Using DVB card "LG Electronics LGDT3303 VSB/QAM Frontend"
Unknown FE type. Aborting

o scantv is for analog only, and it doesn't have NTSC norm, but in any
  case, it seems to put the device into analog mode (it has an analog tuner)
  and turns the red led off.  From observation, it seems that when the device
  is accessed in analog mode (via /dev/video0) the led goes off, when
  accessed through the /dev/dvb/adapter0, it comes back on.

o change-channel.sh that comes with the pvrusb2 driver.  The above frequency
  list (from kaffeine) is apparently the wrong format for this script.  I'll
  have to look further into the proper format.  Of course it would be quicker
  if someone can point me to a list of us channels in the proper format.
  The procedure described in the script to obtain the frequencies depends on
  frequency lists in /usr/share/doc/xawtv, but there is no file for us
  frequencies.

o femon returns this, which makes sense since the card is not tuned to
  anything:

FE: LG Electronics LGDT3303 VSB/QAM Frontend (ATSC)
status       | signal 0000 | snr 0000 | ber 00000000 | unc 0000fbdf |


Can anyone suggest other tools I might have missed?  Explain why I'm getting
the results above? Since both mythtv and kaffeine find some channels in the
scan, shouldn't I be able to watch them?  To narrow down the problem, I was
going to tune the card to one of the channels and then use mplayer to read
directly from the device, but I can't even change the channel.

Any suggestions would be welcome.  Thanks.

A.

