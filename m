Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:43413 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZBSQpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 11:45:10 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KFB00642NUULK51@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2009 11:44:57 -0500 (EST)
Date: Thu, 19 Feb 2009 11:44:54 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <20090219162820.GA23759@opus.istwok.net>
To: David Engel <david@istwok.net>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Message-id: <499D8C86.4050501@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
 <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net>
 <499C218D.7050406@linuxtv.org> <20090218153422.GC15359@opus.istwok.net>
 <20090219162820.GA23759@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> FWIW, I used a different 115 with that same motherboard for several
> months up until about two weeks ago and with that same graphics card
> for most of that time.  Like I said above, I've got to be missing
> something very stupid here.  
> 
> BTW, during all of the testing without the active splitter, I had it
> unplugged to make sure it wasn't contributing any extra RF noise.  I
> won't have an opportunity to do any more testing until this weekend.

I think CityK confirmed that the nxt2004 driver statistics are probably bogus so 
I doubt you're going to get your 115's running with BER 0 regardless, which is 
unfortunate.

Assuming your original configuration was fine, the second part of the problem 
remains then.... is the DMA being screwed by the mix of boards.

I'm not sure I have an easy way for you to determine this, other than making 
sure everything is on it's own interrupt, going back to basics to a single 115 
and a single 250 and trying to isolate the changes step by step.

- Steve


