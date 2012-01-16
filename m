Return-path: <linux-media-owner@vger.kernel.org>
Received: from vms173013pub.verizon.net ([206.46.173.13]:52732 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2APR4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 12:56:17 -0500
Received: from opus ([unknown] [71.170.160.242]) by vms173013.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0LXW0068AKH9HC84@vms173013.mailsrvcs.net> for
 linux-media@vger.kernel.org; Mon, 16 Jan 2012 11:55:57 -0600 (CST)
Date: Mon, 16 Jan 2012 11:55:56 -0600
From: David Engel <david@istwok.net>
To: Linux Media <linux-media@vger.kernel.org>
Subject: Strange problem, help needed
Message-id: <20120116175556.GB29539@opus.istwok.net>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a MythTV backend with a Hauppauge HVR-2250 (dual tuner,
ATSC?QAM, PCIe) and a Ceton InfiniTV4 (quad tuner, QAM/cable card,
PCIe).  Over the weekend, I started intermittently seeing corrupt
recordings that were painful to watch.

I eventually narrowed the problem down to when both tuners on the 2250
are active at the same time.  In this case, both recordings have
corruption (CRC errors, etc.).  The InfiniTV4 does not appear to be
affected by anything going on on the 2250.  Likewise, the 2250 does
not appear to be affected by anything going on on the InfiniTV4.

I noticed something strange while diagnosinig the problem.  When the
2250 is busy recording, top reports the CPU as being in wait for an
abnormally high amount of time (~30% for one tuner busy and ~50% for
both tuners busy).  I don't recall seeing that before.  I quickly
tried a KWorld ATSC 110 on a different system and it showed no, or
negligible wait time.

Thinking that the 2250 was going bad, I replaced it with two KWorld
ATSC 110s (single tuner, ATSC/QAM, PCI).  The two 110s had the same
problem as the 2250 -- corruption when both tuners are busy and
unusually high wait time when either is busy.

At this point, I'm suspecting a motherboard, memory or grounding
issue, but would like some feedback in case there's anything I'm
missing.  The high wait time seems extremely odd to me.  Perhaps it
means something to those of you who are much more familiar with the
cards and drivers.

Oh, the problem appear shortly after switching to the 3.1.9 kernel.  I
also tried the 3.1.8 and 3.0.14 kernels to rule out software and there
was no effect on the problem.

David
-- 
David Engel
david@istwok.net
