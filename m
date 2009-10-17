Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64390 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZJQDU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 23:20:57 -0400
Subject: Re: Leadtek PVR2100 / DVR3100 Experience
From: Andy Walls <awalls@radix.net>
To: David Nicol <david@etvinteractive.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <C6FE3C20.1BB80%david@etvinteractive.com>
References: <C6FE3C20.1BB80%david@etvinteractive.com>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 23:23:22 -0400
Message-Id: <1255749802.5667.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-10-16 at 15:05 +0100, David Nicol wrote:
> Hi,
> 
> Could anyone give first hand experience of the stability of the Leadtek
> PVR2100 and/or the DVR3100 cards?
> 
> Does analog capture work well in both cards over a prolonged period of
> uptime?
> 
> Any known issues with either card?

Both cards are supported by the cx18 driver which is stable.

The card definition for the DVR 3100 H certainly has the digital side of
the cards working properly, thanks to Terry Wu.

The analog side of the 3100 or just the 2100 should work just fine, once
the card definition in cx18-cards.c are tweaked to actually match how
the cards are wired up.  (I made some guesses without any cards to test
or look at.)  Once that's done, analog should be comparable to an
HVR-1600.  You'll have to extract the XCeive tuner's firmware via
instructions that are somewhere on the V4L-DVB wiki. 


On shortcoming the cx18 driver has is a missing interlock between the
analog and digitial TV capture, if trying to capture analog video from
the tuner versus a baseband input (CVBS or S-Video).  The XCeive tuner
can either do analog tuning or digital tuning at any one time - not
both.  Do don't try both analog and digital OTA capture with a 3100 at
the same time. 

Also, I wouldn't expect FM radio to work.

Regards,
Andy

> Thanks in advance for any information.
> 
> David Nicol


