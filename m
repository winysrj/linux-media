Return-path: <mchehab@pedra>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:49335 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab0KISmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 13:42:16 -0500
Message-ID: <4CD99605.8070405@comcast.net>
Date: Tue, 09 Nov 2010 10:42:13 -0800
From: Douglas Peale <Douglas_Peale@comcast.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Units error in v4l2-ctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I was playing around with V4l2-ctl, and noticed an error in the units displayed.

$ v4l2-ctl -d /dev/video1 --get-tuner
Tuner:
	Name                 : Television
	Capabilities         : 62.5 kHz stereo lang1 lang2
	Frequency range      : 0.0 MHz - 268435455.9 MHz
	Signal strength/AFC  : 0%/0
	Current audio mode   : mono
	Available subchannels: mono

Either the frequency range should be reported in Hz, not MHz, or the decimal place needs to be moved 6 places to the left.

For reference, more info on the specific device.
$ v4l2-ctl -d /dev/video1 --info
Driver Info:
	Driver name   : cx8800
	Card type     : ATI HDTV Wonder
	Bus info      : PCI:0000:07:01.0
	Driver version: 8
	Capabilities  : 0x05010011
		Video Capture
		VBI Capture
		Tuner
		Read/Write
		Streaming
