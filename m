Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:41738 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZBSP0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 10:26:12 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KFB00260K7LV8Z0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2009 10:26:11 -0500 (EST)
Date: Thu, 19 Feb 2009 10:26:08 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <499CBFCA.6040108@rogers.com>
To: CityK <cityk@rogers.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	David Engel <david@istwok.net>, linux-media@vger.kernel.org
Message-id: <499D7A10.8080709@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
 <499B1E19.80302@linuxtv.org> <20090217205629.GA9722@opus.istwok.net>
 <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
 <499B3A60.90306@linuxtv.org>
 <412bdbff0902171438u7c2ab531y62bb6c717647e917@mail.gmail.com>
 <499C265B.9010309@linuxtv.org> <499CBFCA.6040108@rogers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CityK wrote:
> Steven Toth wrote:
>> Agreed, probably a secondary issue - which probably needs some
>> attention regardless.
>>
>> I don't follow kworld products so I don't pretend to know which demod
>> they're using. I guess my question to the wider audience is, do people
>> with this same demod on other cards experience similar BER issues.
> 
> The KWorld 11x uses the Nxt2004 demod ... and "Zoinks!", upon checking,
> I find that my single 11x card is now exhibiting BER too !   This is
> something new to me, as previous femon output was always free of such
> errors.

The numbers are suspicious, (presumably) post-viterbi errors without UCB 
shouldn't happen, unless the driver isn't properly querying the demod stats. I'm 
not sure of the nxt2004's history so maybe this has always been an issue, maybe 
BER and UCB were never properly implemented? If I had a card I'd take a look. I 
don't so I can't help.

Clearly, I wouldn't trust that driver or its numbers right now.

- Steve
