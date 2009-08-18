Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:33990 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZHRMX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 08:23:29 -0400
Received: from mbpwifi.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KOK00LZZNQRXN80@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 18 Aug 2009 08:23:15 -0400 (EDT)
Date: Tue, 18 Aug 2009 08:23:15 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge 2250 - second tuner is only half working
In-reply-to: <35375.76.104.173.166.1250492844.squirrel@www.cyberseth.com>
To: seth@cyberseth.com
Cc: linux-media@vger.kernel.org
Message-id: <4A8A9D33.5050505@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <35375.76.104.173.166.1250492844.squirrel@www.cyberseth.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'd really appreciate any help or guidance on this problem as i'm fully
> perplexed by it.

Hey Seth,

I ran the same tests on my cable system (channel 103) on 669Mhz and had no 
issue, and my snr's reported as (0x172 and 0x17c).

One possibility is that you're overwhelming the frontend. Try adding a small 
mount of attenuation to the signal for test purposes.

Hard to believe but this is where I'd start looking.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
