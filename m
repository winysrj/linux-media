Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:36029 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab1AKBcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 20:32:17 -0500
Message-ID: <4D2BB31E.4090308@linuxtv.org>
Date: Tue, 11 Jan 2011 02:32:14 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>, mchehab@redhat.com,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Interconnection of different DVB adapters (was: Re: [PATCH 07/16]
 ngene: CXD2099AR Common Interface driver)
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <1294652184-12843-8-git-send-email-o.endriss@gmx.de> <4D2B122E.3050803@linuxtv.org> <201101101820.07907@orion.escape-edv.de>
In-Reply-To: <201101101820.07907@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/10/2011 06:20 PM, Oliver Endriss wrote:
> On Monday 10 January 2011 15:05:34 Andreas Oberritter wrote:
>> On 01/10/2011 10:36 AM, Oliver Endriss wrote:
>>> From: Ralph Metzler <rjkm@metzlerbros.de>
>>>
>>> Driver for the Common Interface Controller CXD2099AR.
>>> Supports the CI of the cineS2 DVB-S2.
>>>
>>> For now, data is passed through '/dev/dvb/adapterX/sec0':
>>> - Encrypted data must be written to 'sec0'.
>>> - Decrypted data can be read from 'sec0'.
>>> - Setup the CAM using device 'ca0'.
>>
>> Nack. In DVB API terms, "sec" stands for satellite equipment control,
>> and if I remember correctly, sec0 already existed in the first versions
>> of the API and that's why its leftovers can be abused by this driver.
>>
>> The interfaces for writing data are dvr0 and demux0. If they don't fit
>> for decryption of recorded data, then they should be extended.
>>
>> For decryption of live data, no new user interface needs to be created.
> 
> There was an attempt to find a solution for the problem in thread
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
> 
> As that discussion did not come to a final solution, and the driver is
> still experimental, I left the original patch 'as is'.

Thanks for the pointer. My impression from the quoted thread is that the
most desired and viable solution was to create a ca device node which
can be virtually connected on demand to a demux or dvr device of another
adapter, but there was no intent to put the required amount of work into
it. That's fair, but IMHO not suitable for submission to the mainline
kernel.

This definitely needs more thought.

Maybe the adapter-based scheme currently in use needs to be revised
thoroughly. The "budget" type of adapters are basically just frontends
and we should be able to interconnect those (and also other) frontends
with CIs, demuxes and decoders of different adapters, if the underlying
buses allow it. Is this something the media controller and mem2mem APIs
are trying to solve for V4L? If yes, this could become interesting for
DVB, too.

Regards,
Andreas
