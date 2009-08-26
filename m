Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:56166 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbZHZNN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 09:13:26 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KOZ005NOJECR9M0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 26 Aug 2009 09:13:26 -0400 (EDT)
Date: Wed, 26 Aug 2009 09:13:24 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge 2250 - second tuner is only half working
In-reply-to: <50410.76.104.173.166.1251253129.squirrel@www.cyberseth.com>
To: seth@cyberseth.com
Cc: Steve Harrington <steve@emel-harrington.net>,
	linux-media@vger.kernel.org
Message-id: <4A9534F4.8020503@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <283002305-1251239519-cardhu_decombobulator_blackberry.rim.net-845544064-@bxe1079.bisx.prod.on.blackberry>
 <4A946CB5.2010800@kernellabs.com> <4A947260.1040907@kernellabs.com>
 <4A947F89.3010705@kernellabs.com>
 <50410.76.104.173.166.1251253129.squirrel@www.cyberseth.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/25/09 10:18 PM, seth@cyberseth.com wrote:
> Well my card is out the door already.  So it'll be a week or so till i can
> try again. I'll give it a pretty thorough run down when i get the new
> card, maybe I can dig up a repro.
>
> This is probably just a red herring, but FWIW I had never cold booted the
> machine (except monday morning when i yanked the card).  I warm booted
> plenty, but i frequently would run full us-Cable scan's on both tuners.
> Some time last week when repo's pushed out 2.6.28-15, i had at least one
> warm boot in there where i had the modules/firmware missing.  I
> reinstalled (dist-clean, make, make install), rebooted, and tried again
> and found it was working (well, for a little while until that spontaneous
> reboot).

Fair enough.

Another user is preparing remote access so I can take a look at the problem 
first hand. With any look we'll see the issue and have a patch by the time your 
replacement board comes back.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
