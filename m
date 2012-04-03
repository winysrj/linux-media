Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53923 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab2DCDBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 23:01:51 -0400
References: <1333400524.30070.83.camel@hp0>
In-Reply-To: <1333400524.30070.83.camel@hp0>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: NTSC_443 problem in v4l and em28x
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 02 Apr 2012 23:01:56 -0400
To: colineby@isallthat.com, linux-media@vger.kernel.org
Message-ID: <1db8b250-88a6-413f-a365-62f2418a3ace@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Colin Eby <colineby@isallthat.com> wrote:

>All, 
>
>Wondered if someone could advise... I'm from an NTSC and PAL capable
>tape deck, in the UK. I believe that means the signal coming from the
>deck will be NTSC_443 compliant. What is captured through VLC or XAWTV
>is slightly grainy black and white (no green band). It kinda looks like
>the there are no capture distinctions between NTSC_443 and NTSC. I'd
>try
>tweaking the code around this, but I'm not clear where it's controlled
>from. Can someone help guide me?  I have a mountain of these tapes to
>capture for a museum.
>
>Here's the setup:
>U-matic Sony VO5630 VTR using BNC to RCA video out
>V4L2 device Pinnacle Dazzle DVC 90/100/101/ using driver: em28xx
>(version: 0.1.2) 
>Fedora 14
>VLC 1.1.12
>
>I know about the issue with changing video standards in this VLC UI
>version. That's not the problem, and I've confirmed it with a slightly
>more up to date Ubuntu equivalent.  I get the same behaviour in XAWTV
>and VLC. Here's some of what my experimentation has shown.
>
>* On PAL tapes this gear works fine (with the deck switched to PAL and
>VLC set to PAL)
>* Direct to TV the gear works fine in NTSC mode (bless modern flat
>panels)
>* Using Windows and AmCap I get colour video on the NTSC tapes. __The
>setting that work there is NTSC_443 with a YUYV colour space.__
>* I've tried all the different standards available in VLC and XAWTV
>with
>the deck set to NTSC and an NTSC tape. I see no visible difference
>between NTSC, NTSC_M or NTSC_443 -- and based on work in Windows, I
>believe I should.
>* Debug from V4L/VLC shows NTSC_443 is supported in the driver.
>
>There's clear evidence I can get some kind of tool chain to work in
>Windows. But I wondered if there wasn't some fine tuning to the driver
>that would get Linux rig to work.  And I wondered if there were known
>issues around the NTSC_443 norm. Forgive me if I've missed any, but I
>haven't found any so far.
>
>-- Colin
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Well the tape deck does output NTSC 4.43:
http://umatic.palsite.com/vo5630spec.shtml

The horizontal line count seems unusual.

Anyway, Devin is right, NTSC 4.43 is really rare.

My first bit of advice is to ensure the video input is set specifically to NTSC_443, and no other NTSC, PAL, or SECAM standard using v4l2-ctl on the /dev/videoN node.  No chip is likely ever going to autodetect NTSC 4.43 properly (under linux at least).

The CX2584x chips supposedly handle NTSC 4.43.  If you have a PVR-150 card lying around, maybe that will work better.

Regards,
Andy
