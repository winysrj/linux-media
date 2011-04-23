Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:56364 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1DWNaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 09:30:15 -0400
Message-ID: <4DB2D449.1090605@usa.net>
Date: Sat, 23 Apr 2011 15:29:45 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Martin Vidovic <xtronom@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net> <4DB2BA0B.20906@gmail.com> <4DB2C20E.1050701@usa.net> <4DB2C88D.1040200@gmail.com>
In-Reply-To: <4DB2C88D.1040200@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/04/11 14:39, Martin Vidovic wrote:
> Hi,
>> Okay, but have you managed to decode any channel yet ?
>>   
> Yes, I managed to descramble programmes without any problem.
>> I find some code odd, maybe you can take a look as well...
>>
>> init_channel in ngene-core.c creates the device sec0/caio0 with the
>> struct ngene_dvbdev_ci. In ngene-dvb.c you can see that this struct
>> declares the methods ts_read/ts_write to handle r/w operations on the
>> device sec0/caio0.
>>
>> Now take a look at those methods (ts_read/ts_write). I don't see how
>> they 'connect' to the file cxd2099.c which contains the methods handling
>> the i/o to the cam
> They don't connect explicitly. Transfers are done implicitly
> through nGene ring-buffers. See demux_tasklet(). CXD code
> seems to be used only for CAM commands and setup (only) of
> data transfers.

I have taken a look into the ddbrigde module code from
<http://linuxtv.org/hg/~endriss/ngene-octopus-test/rev/6b400d63c481>

The ts_read/ts_write methods are different from the ngene module's. So I
guess were are having entirely different problems.
