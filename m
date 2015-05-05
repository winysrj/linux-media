Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40423 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993385AbbEEP1I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 11:27:08 -0400
Date: Tue, 5 May 2015 12:27:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: Re: DVBv5 qos/stats driver implementation
Message-ID: <20150505122702.44269b54@recife.lan>
In-Reply-To: <5548D2FF.3050100@gmail.com>
References: <5548D2FF.3050100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 05 May 2015 15:26:07 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> Mauro/Antti,
> 
> Myself and Patrick are currently in the process of bringing an old out 
> of tree frontend driver into shape for inclusion, and one of the issues 
> raised by Mauro was the requirement for the new DVBv5 stats method. I've 
> noticed there seems to be two different ways of going around this - one 
> is to run through the collection and cache filling process during the 
> calls to read_status (as in dib7000p/dib8000p), and the other is to poll 
> independently every couple of seconds via schedule_delayed_work (as in 
> af9033, rtl2830/2832).
> 
> Is there any reason for the two different ways - is it just a coding 
> preference or is there some specifics to how these frontends need to be 
> implemented?

Hi Jemma,

It is basically coding preference. 

The DVB has already a thread that calls the frontend driver on every
3 seconds, at most (or when an event occurs). So, I don't see any need
for the drivers to start another thread to update status, as 3 seconds
is generally good enough for status update, then the frontend is
already locked, and the events can make status to update earlier during
device lock phase. Also, if needed, it won't be hard to add core support
to adjust the kthread delay time.

The driver may also skip an update if needed. So, I don't see much
gain on having a per-driver thread.

Having a per-driver thread should work too, although it is an overkill
for me to have two status kthreads running (one provided by the core,
and another by the driver).

Regards,
Mauro
