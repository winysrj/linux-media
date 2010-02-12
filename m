Return-path: <linux-media-owner@vger.kernel.org>
Received: from asmtpout024.mac.com ([17.148.16.99]:64710 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0BLOpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 09:45:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from macpro.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213])
 by asmtp024.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0KXQ002DQE6OTH00@asmtp024.mac.com> for
 linux-media@vger.kernel.org; Fri, 12 Feb 2010 05:44:52 -0800 (PST)
Subject: Re: New Hauppauge HVR-2200 Revision?
From: Steven Toth <steven.toth@mac.com>
In-reply-to: <4B7412CC.6010003@barber-family.id.au>
Date: Fri, 12 Feb 2010 08:44:48 -0500
Cc: linux-media@vger.kernel.org
Message-id: <4B99D44B-A91C-4145-9317-EFA5AF9BD553@mac.com>
References: <4B5B0E12.3090706@barber-family.id.au>
 <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com>
 <4B5B837A.6020001@barber-family.id.au>
 <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com>
 <4B5B8E5B.4020600@barber-family.id.au>
 <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com>
 <4B5BF61A.4000605@barber-family.id.au> <4B73F6AC.5040803@barber-family.id.au>
 <4B7412CC.6010003@barber-family.id.au>
To: Francis Barber <fedora@barber-family.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Anyway, apart from the problems noted above it is fine.  I'm not sure what the criteria is for merging support for this card into the main repository, but I would view it as worthy of merging even with these problems outstanding.
>> 
>> Many thanks,
>> Frank.
>> 
> Interestingly, so far it only seems to affect the second adapter.  The first one is still working.
> 


Odd.

Francis,

I find the whole ber/unc values puzzling, essentially they shouldn't happen assuming a good clean DVB-T signal. I'm going to look into this very shortly, along with a broad locking feature I want to change in the demod.

I've had one or two other people comment on the -stable tree and in general they're pretty happy, including myself, which means that I'll be generating a pull request to have these changes merged very shortly (1-2 weeks).

Regards,

- Steve

--
Steven Toth - Kernel Labs
http://www.kernellabs.com


