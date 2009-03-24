Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:35256 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZCXWIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 18:08:15 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KH100BI06TFKIM0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 24 Mar 2009 18:08:12 -0400 (EDT)
Date: Tue, 24 Mar 2009 18:08:03 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: The right way to interpret the content of SNR,
 signal strength and BER from HVR 4000 Lite
In-reply-to: <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
Message-id: <49C959C3.3060402@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49B9BC93.8060906@nav6.org>
 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
 <20090319101601.2eba0397@pedra.chehab.org>
 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
 <1237689919.3298.179.camel@palomino.walls.org>
 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
 <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Let me ask this rhetorical question: if we did nothing more than just
>> normalize the SNR to provide a consistent value in dB, and did nothing
>> more than normalize the existing strength field to be 0-100%, leaving
>> it up to the driver author to decide the actual heuristic, what
>> percentage of user's needs would be fulfilled?

We don't need a new API and more complexity and/or code confusion, just 
standardize on the unit values for the existing APIs.

1) SNR in either units of db or units of .1 db (I don't care which, although I 
prefer the later).

2) Strength as a percentage.

The approach Devin outlined above has my support.

- Steve
