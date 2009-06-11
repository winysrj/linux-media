Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:49861 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbZFKIQN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 04:16:13 -0400
Date: Thu, 11 Jun 2009 10:16:08 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Soeren.Moch@stud.uni-hannover.de
cc: linux-media@vger.kernel.org
Subject: Re: dib0700 Nova-TD-Stick problem
In-Reply-To: <20090603133631.159278y5l7uv8x0k@www.stud.uni-hannover.de>
Message-ID: <alpine.LRH.1.10.0906111013310.18712@pub1.ifh.de>
References: <20090603133631.159278y5l7uv8x0k@www.stud.uni-hannover.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soeren,

On Wed, 3 Jun 2009, Soeren.Moch@stud.uni-hannover.de wrote:

> Soeren.Moch wrote:
>> For a few weeks I use a Nova-TD-Stick and was annoyed with dvb stream
>> errors, although the demod bit-error-rate (BER/UNC) was zero.
>> 
>> I could track down this problem to dib0700_streaming_ctrl:
>> When one channel is streaming and the other channel is switched on, the
>> stream of the already running channel gets broken.
>> 
>> I think this is a firmware bug and should be fixed there, but I attach a
>> driver patch, which solved the problem for me. (Kernel 2.6.29.1, FW
>> 1.20, Nova-T-Stick + Nova-TD-Stick used together). Since I had to reduce
>> the urb count to 1, I consider this patch as quick hack, not a real
>> solution.
>> 
>> Probably the same problem exists with other dib0700 diversity/dual
>> devices, without a firmware fix a similar driver patch may be helpful.
>> 
>> Regards,
>> Soeren
>> 
>
> Hi Patrick,
>
> do you see any chance that somebody will fix the firmware?

:/ .

> If not, can you take into consideration to remove the 
> dib0700_streaming_ctrl callback as in the (again) attached patch so 
> solve the switch-on problem?

I'd rather fix the streaming-enable command, which might be not correctly 
implemented. Need to check. :(

> The patch runs flawlessly on my vdr system 
> for weeks now. There are no negative side effects from reducing the urb 
> count to 1.

Hmm, on fast systems certainly not, but once the system is loaded or old 
there might be data losses.

It would be nice to have other people trying this workaround on other 
cards so that we know that it really helps and not just solves the problem 
for you.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
