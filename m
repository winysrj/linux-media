Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpi3.ngi.it ([88.149.128.33]:36760 "EHLO smtpi3.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab2BCK2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Feb 2012 05:28:15 -0500
Received: from [127.0.0.1] (unknown [81.174.56.138])
	by smtpi3.ngi.it (Postfix) with ESMTP id 151AA318CEE
	for <linux-media@vger.kernel.org>; Fri,  3 Feb 2012 11:20:58 +0100 (CET)
Message-ID: <4F2BB50A.8080104@robertoragusa.it>
Date: Fri, 03 Feb 2012 11:20:58 +0100
From: Roberto Ragusa <mail@robertoragusa.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DVB TS/PES filters
References: <20120126154015.01eb2c18@tiber>
In-Reply-To: <20120126154015.01eb2c18@tiber>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2012 04:40 PM, Tony Houghton wrote:
> I could do with a little more information about DMX_SET_PES_FILTER.
> Specifically I want to use an output type of DMX_OUT_TS_TAP. I believe
> there's a limit on how many filters can be set, but I don't know whether
> the kernel imposes such a limit or whether it depends on the hardware,
> If the latter, how can I read the limit?
> 
> I looked at the code for GStreamer's dvbsrc and that defines a limit of
> 32 filters. It also implies that using the "magic number" 8192 as the
> pid requests the entire stream.
> 
> I can't find information about these things in the API docs. Is there
> somewhere I can get more details.
> 
> If I ended up wanting enough pids to exceed the limit would it work to
> allow LIMIT - 1 individual pid filters to be set, then after that set
> one for 8192 instead and clear all the others?

It has been a long time since I touched this, anyway...

Yes 8192 is "all PIDs"; this has to be supported by the hardware, which
usually does. All the packets go to the userspace process.

If you ask filters, the kernel uses the HW filters if available/enough,
otherwise it switches to software filtering at the kernel level. Your application
sees only the packets it asked, but the kernel may be getting everything
and filtering itself; this can have some performance implication on slow
(USB) buses.

I suggest you to experiment a little to discover if I said something wrong
and if your hardware (driver) behaves as I said.


-- 
   Roberto Ragusa    mail at robertoragusa.it
