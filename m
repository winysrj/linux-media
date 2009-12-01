Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:64047 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZLAPoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 10:44:13 -0500
Received: by ewy7 with SMTP id 7so5950907ewy.28
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 07:44:18 -0800 (PST)
Date: Tue, 1 Dec 2009 16:44:13 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Replace Mercurial with GIT as SCM
Message-ID: <20091201154413.GA11696@raptus.dandreoli.com>
References: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 01, 2009 at 03:59:20PM +0100, Patrick Boettcher wrote:
> Hi all,

hi,

> I would like to start a discussion which ideally results in either
> changing the SCM of v4l-dvb to git _or_ leaving everything as it is
> today with mercurial.

i should not be stopped by a tool i'm not familiar with (that is hg)
but actually it is a barrier for me. i'd like to regularly follow v4l-dvb
and surely with git i'd not waste the time as with hg.

the result is that i have a separate git tree for "my" tw68xx driver
and the integration with v4l-dvb and hg is not my topomost priority
given also that everything needs to be ported back to git before kernel
inclusion.

while i accept that people doing real work should use the tool the
prefer i consider this fracture with the kernel SCM a mistake.

this is only my opinion, my intent is not to start any flamewar.

regards,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
