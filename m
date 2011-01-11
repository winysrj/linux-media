Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753800Ab1AKCRs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 21:17:48 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: Interconnection of different DVB adapters (was: Re: [PATCH 07/16] ngene: CXD2099AR Common Interface driver)
Date: Tue, 11 Jan 2011 03:14:24 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Ralph Metzler <rjkm@metzlerbros.de>
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <201101101820.07907@orion.escape-edv.de> <4D2BB31E.4090308@linuxtv.org>
In-Reply-To: <4D2BB31E.4090308@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101110314.24988@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 11 January 2011 02:32:14 Andreas Oberritter wrote:
> On 01/10/2011 06:20 PM, Oliver Endriss wrote:
> > On Monday 10 January 2011 15:05:34 Andreas Oberritter wrote:
> >> On 01/10/2011 10:36 AM, Oliver Endriss wrote:
> >>> From: Ralph Metzler <rjkm@metzlerbros.de>
> >>>
> >>> Driver for the Common Interface Controller CXD2099AR.
> >>> Supports the CI of the cineS2 DVB-S2.
> >>>
> >>> For now, data is passed through '/dev/dvb/adapterX/sec0':
> >>> - Encrypted data must be written to 'sec0'.
> >>> - Decrypted data can be read from 'sec0'.
> >>> - Setup the CAM using device 'ca0'.
> >>
> >> Nack. In DVB API terms, "sec" stands for satellite equipment control,
> >> and if I remember correctly, sec0 already existed in the first versions
> >> of the API and that's why its leftovers can be abused by this driver.
> >>
> >> The interfaces for writing data are dvr0 and demux0. If they don't fit
> >> for decryption of recorded data, then they should be extended.
> >>
> >> For decryption of live data, no new user interface needs to be created.
> > 
> > There was an attempt to find a solution for the problem in thread
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
> > 
> > As that discussion did not come to a final solution, and the driver is
> > still experimental, I left the original patch 'as is'.
> 
> Thanks for the pointer. My impression from the quoted thread is that the
> most desired and viable solution was to create a ca device node which
> can be virtually connected on demand to a demux or dvr device of another
> adapter, but there was no intent to put the required amount of work into
> it.

Attaching a CI to a single frontend is easy. In this case we could
simply attach the CI to the first frontend of the card, and we are done.

The intention was to allow decryption of streams from more than one
frontend _at_the_same_time_. That might require multiplexing partial
TS streams into a new one, passing it to the CAM and demultiplexing the
decrypted stream again.

The idea was to perform these operations in userspace, while the kernel
provides a simple interface which
- accepts an encrypted stream and
- delivers the decrypted stream.

sec0 was chosen because it exists and it is currently unused.
It can be renamed anytime, if we reach an agreement.

> That's fair, but IMHO not suitable for submission to the mainline 
> kernel.
>
> This definitely needs more thought.

If this is the common opinion, I will simply strip the CI support from
the driver again. The stv0900x and ngene patches are too important to be
delayed.

> Maybe the adapter-based scheme currently in use needs to be revised
> thoroughly. The "budget" type of adapters are basically just frontends
> and we should be able to interconnect those (and also other) frontends
> with CIs, demuxes and decoders of different adapters, if the underlying
> buses allow it. Is this something the media controller and mem2mem APIs
> are trying to solve for V4L? If yes, this could become interesting for
> DVB, too.

Honestly, I have little motivation to work on things,  which I do not
use. I do not care about CAM stuff. I am just submitting the code
I received...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
