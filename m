Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail918.opentransfer.com ([98.130.1.193]:57824 "EHLO
	mail918.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2DBVCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:02:07 -0400
Subject: NTSC_443 problem in v4l and em28x
From: Colin Eby <colineby@isallthat.com>
Reply-To: colineby@isallthat.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Apr 2012 22:02:04 +0100
Message-ID: <1333400524.30070.83.camel@hp0>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All, 

Wondered if someone could advise... I'm from an NTSC and PAL capable
tape deck, in the UK. I believe that means the signal coming from the
deck will be NTSC_443 compliant. What is captured through VLC or XAWTV
is slightly grainy black and white (no green band). It kinda looks like
the there are no capture distinctions between NTSC_443 and NTSC. I'd try
tweaking the code around this, but I'm not clear where it's controlled
from. Can someone help guide me?  I have a mountain of these tapes to
capture for a museum.

Here's the setup:
U-matic Sony VO5630 VTR using BNC to RCA video out
V4L2 device Pinnacle Dazzle DVC 90/100/101/ using driver: em28xx
(version: 0.1.2) 
Fedora 14
VLC 1.1.12

I know about the issue with changing video standards in this VLC UI
version. That's not the problem, and I've confirmed it with a slightly
more up to date Ubuntu equivalent.  I get the same behaviour in XAWTV
and VLC. Here's some of what my experimentation has shown.

* On PAL tapes this gear works fine (with the deck switched to PAL and
VLC set to PAL)
* Direct to TV the gear works fine in NTSC mode (bless modern flat
panels)
* Using Windows and AmCap I get colour video on the NTSC tapes. __The
setting that work there is NTSC_443 with a YUYV colour space.__
* I've tried all the different standards available in VLC and XAWTV with
the deck set to NTSC and an NTSC tape. I see no visible difference
between NTSC, NTSC_M or NTSC_443 -- and based on work in Windows, I
believe I should.
* Debug from V4L/VLC shows NTSC_443 is supported in the driver.

There's clear evidence I can get some kind of tool chain to work in
Windows. But I wondered if there wasn't some fine tuning to the driver
that would get Linux rig to work.  And I wondered if there were known
issues around the NTSC_443 norm. Forgive me if I've missed any, but I
haven't found any so far.

-- Colin

