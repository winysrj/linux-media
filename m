Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JvY77-0007ec-BG
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 15:30:53 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 12 May 2008 15:16:47 +0200
References: <482560EB.2000306@gmail.com> <48274A27.9050206@gmail.com>
	<1210541523.3197.34.camel@palomino.walls.org>
In-Reply-To: <1210541523.3197.34.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805121516.48002@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
	stv0297
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andy Walls wrote:
> On Sun, 2008-05-11 at 23:33 +0400, Manu Abraham wrote:
> 
> > I am talking about standard DVB demods:
> > Every demodulator provides a standard interface, whether you know it or not.
> > 
> > BER, Bit Error Rate (symbols per unit time)
> > Strength, usually a RMS value (Absolute)
> > SNR, Signal To Noise Ratio (Relative)
> > UNC, Uncorrectable symbols (Absolute)
> > 
> > These parameters have meanings for the users, not just Linux users but
> > general users on the whole. Most DVB stuff is quite standardized, most
> > of which you can find in ETSI specifications and or old DVB.org whitepapers.
> > 
> > All the resultant parameters that which an API provides, should be that
> > which is a standard definition, rather than defining something which is
> > bogus. You take anything standardized, you won't find any other
> > difference from the above, almost all demodulators follow the
> > specifications involved therein.
> 
> Manu,
> 
> I will agree with you then, drivers shouldn't compute a UNC block rate.
> 
> 
> Oliver,
> 
> However, the original spec that was quoted, implied that *applications*
> would/could do just that: compute a rate from UNC block counts:

Applications may do whatever they wish with the UNC counter:
- provide the raw error count
- present the number of UNC blocks over a sliding window (last minute,
  last hour, whatever)
- calculate an UNC rate [1]

[1] Imho not very useful. UNC should remain constant or increment very
    slowly. Otherwise the ts stream will be unusable.

> > Argh, I just checked the API 1.0.0. spec:
> > | FE READ UNCORRECTED BLOCKS
> > | This ioctl call returns the number of uncorrected blocks detected by the device
> > | driver during its lifetime. For meaningful measurements, the increment
> > | in block count during a speci c time interval should be calculated. For this
> > | command, read-only access to the device is suf cient.
> > | Note that the counter will wrap to zero after its maximum count has been
> > | reached
> 
> Putting aside whether such UNC block rates are useful or not, the
> specification as quoted facilitates the following use case:
> 
> Multiple applications, can compute UNC block rates over different,
> possibly overlapping intervals of different lengths, with the
> applications required to handle rollover gracefully.

This a a very important point: The frontend may be opened by multiple
readers, so a driver _must_ _not_ reset the UNC counter after reading.
I guess that's why UNC was defined this way.

Btw, this is a common concept: SNMP (Simple Network Management Protocol)
counters behave the same way.

> The specification as is, appears to be the easiest way to support this
> use case, and it works provided the hardware automatically performs
> rollover of the UNC block counter.
> 
> If this is a use case that needs to be supported, then to handle the
> case of hardware that doesn't automatically roll the UNC counter over to
> zero, the last sentence of the specification might be changed to
> something like this:
> 
> "Note that the counter will wrap to zero after its maximum count has
> been reached.  For devices where the hardware does not automatically
> roll over to zero, when the ioctl would return the maximum supported
> value, the driver will reset the hardware counter to zero."
> 
> 
> This isn't perfect as some UNC counts will be lost after the counter
> saturates, but aside from this exceptional circumstance, the use case
> would be correctly supported.

The driver should do its best to implement the API spec. It might:
- return the value of a counter provided by the hardware if it matches
  the API spec
- implement a counter in software (see proposed patch for an example)
- return -ENOSYS if it cannot support the UNC counter [2]

Btw, the spec refers to an error code ENOSIGNAL, which does not exist.
:-(

[2] Unfortunately some drivers return a bogus value if they cannot
    provide UNC. This is a bug and should be fixed!
    Returning 0 is wrong. I'll fix the stv0299.

It is unlikely that the 32 bit UNC error count wraps. If it does, the
'UNC rate' is very high, and it does not matter whether a few errors
are lost...

Anyway the application should handle the wrapping of the UNC counter
properly.


@all:
1. If nobody objects I will commit the patches.
2. Please check and fix the other frontend drivers to follow the spec.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
