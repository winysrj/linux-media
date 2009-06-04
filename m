Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:46768 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZFDIFr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 04:05:47 -0400
Date: Thu, 4 Jun 2009 10:05:21 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Soeren.Moch@stud.uni-hannover.de
cc: linux-media@vger.kernel.org
Subject: Re: dib0700 Nova-TD-Stick problem
In-Reply-To: <20090603133631.159278y5l7uv8x0k@www.stud.uni-hannover.de>
Message-ID: <alpine.LRH.1.10.0906041003130.6294@pub3.ifh.de>
References: <20090603133631.159278y5l7uv8x0k@www.stud.uni-hannover.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

No. :(

> If not, can you take into consideration to remove the 
> dib0700_streaming_ctrl callback as in the (again) attached patch so 
> solve the switch-on problem? The patch runs flawlessly on my vdr system 
> for weeks now. There are no negative side effects from reducing the urb 
> count to 1.

There might be a real problem in the dib0700 for the streaming_ctrl 
function. I have to check that.

> If you prefer a patch that removes the callback for all dib0700 devices or
> only for all dual devices, I can prepare that. But I can test it only with
> Nova-T-Stick and Nova-TD-Stick.

I have some new devices here to test as well, I will try to do it during 
the week(end).

Sorry for not reacting in the first place. But I really couldn't do 
anything at that time.

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
