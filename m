Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:39582 "EHLO smtp3.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbcCIPva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 10:51:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp3.goneo.de (Postfix) with ESMTP id F0AC623F948
	for <linux-media@vger.kernel.org>; Wed,  9 Mar 2016 16:43:47 +0100 (CET)
Received: from smtp3.goneo.de ([127.0.0.1])
	by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m9RuVOHo5kdI for <linux-media@vger.kernel.org>;
	Wed,  9 Mar 2016 16:43:37 +0100 (CET)
Received: from sol.fritz.box (dyndsl-095-033-013-101.ewe-ip-backbone.de [95.33.13.101])
	by smtp3.goneo.de (Postfix) with ESMTPSA id 8A3C323F40A
	for <linux-media@vger.kernel.org>; Wed,  9 Mar 2016 16:43:37 +0100 (CET)
From: Markus Heiser <markus.heiser@darmarit.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: DVBv5 Tools: VDR support seems to be broken
Message-Id: <19129703-C076-47F7-BEFF-8A57D172132D@darmarit.de>
Date: Wed, 9 Mar 2016 16:43:36 +0100
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tested DVBv5 tools, creating vdr channel lists. My first attemp
was to convert a dvbv5 channel list:

<SNIP> -----------------------------
# file: test_convert_in.conf
#
# converted with: dvb-format-convert -I DVBV5 -O VDR  test_convert_in.conf test_convert_out.conf
#
[Das Erste HD]
	SERVICE_ID = 10301
	VIDEO_PID = 5101
	AUDIO_PID = 5102 5103 5106 5108
	PID_0b = 5172 2171
	PID_06 = 5105 5104
	PID_05 = 1170
	LNB = UNIVERSAL
	FREQUENCY = 11494000
	INVERSION = OFF
	SYMBOL_RATE = 22000488
	INNER_FEC = 2/3
	MODULATION = PSK/8
	PILOT = ON
	ROLLOFF = 35
	POLARIZATION = HORIZONTAL
	STREAM_ID = 0
	DELIVERY_SYSTEM = DVBS2
<SNAP> -----------------------------


this results in a strange VDR channel (test_convert_out.conf):


<SNIP> -----------------------------
Das Erste HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
<SNAP> -----------------------------


so I created an other (vdr) channel-file (test123.conf) to see how 
to fix the problem:


<SNIP> -----------------------------
# file test123.conf
#
# tested with: mpv -v --dvbin-file=test123.conf dvb://"Das Erste HD fixed"
#
Das Erste HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
#
# dropping "(null):" and delete last ":" fixed the problem for mpv
#
Das Erste HD fixed:11494:S1HC23I0M5N1O35:S:22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0
<SNAP> -----------------------------


refering to the VDR Wikis ...

* LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
* german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4

... there is no field at position [4] / in between "Source"
and "SRate" which might have a value ... I suppose the '(null):'
is the result of pointing to *nothing* ...

An other mistake is the ending colon (":") at the line. It is not
explicit specified but adding an collon to the end of an channel
entry will prevent players (like mpv or mplayer) from parsing the
line (they will ignore these lines).

At least: generating a channel list with

  dvbv5-scan --output-format=vdr ...

will result in the same defective channel entry, containing
"(null):" and the leading collon ":".

If I can help -- e.g. testing -- please contact me.

Regards

  --M