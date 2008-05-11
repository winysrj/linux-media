Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JvJA8-0000Lz-VP
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 23:32:58 +0200
From: Andy Walls <awalls@radix.net>
To: Manu Abraham <abraham.manu@gmail.com>, Oliver Endriss <o.endriss@gmx.de>
In-Reply-To: <48274A27.9050206@gmail.com>
References: <482560EB.2000306@gmail.com>
	<200805101717.23199@orion.escape-edv.de>
	<200805101727.55810@orion.escape-edv.de>
	<1210456421.7632.29.camel@palomino.walls.org>
	<48261EB5.2090604@gmail.com>
	<1210463068.7632.102.camel@palomino.walls.org>
	<48268EB9.6060000@gmail.com>
	<1210530916.3198.72.camel@palomino.walls.org>
	<48274A27.9050206@gmail.com>
Date: Sun, 11 May 2008 17:32:03 -0400
Message-Id: <1210541523.3197.34.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends
	tda10021	and	stv0297
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

On Sun, 2008-05-11 at 23:33 +0400, Manu Abraham wrote:

> I am talking about standard DVB demods:
> Every demodulator provides a standard interface, whether you know it or not.
> 
> BER, Bit Error Rate (symbols per unit time)
> Strength, usually a RMS value (Absolute)
> SNR, Signal To Noise Ratio (Relative)
> UNC, Uncorrectable symbols (Absolute)
> 
> These parameters have meanings for the users, not just Linux users but
> general users on the whole. Most DVB stuff is quite standardized, most
> of which you can find in ETSI specifications and or old DVB.org whitepapers.
> 
> All the resultant parameters that which an API provides, should be that
> which is a standard definition, rather than defining something which is
> bogus. You take anything standardized, you won't find any other
> difference from the above, almost all demodulators follow the
> specifications involved therein.

Manu,

I will agree with you then, drivers shouldn't compute a UNC block rate.


Oliver,

However, the original spec that was quoted, implied that *applications*
would/could do just that: compute a rate from UNC block counts:


> Argh, I just checked the API 1.0.0. spec:
> | FE READ UNCORRECTED BLOCKS
> | This ioctl call returns the number of uncorrected blocks detected by the device
> | driver during its lifetime. For meaningful measurements, the increment
> | in block count during a speci c time interval should be calculated. For this
> | command, read-only access to the device is suf cient.
> | Note that the counter will wrap to zero after its maximum count has been
> | reached

Putting aside whether such UNC block rates are useful or not, the
specification as quoted facilitates the following use case:

Multiple applications, can compute UNC block rates over different,
possibly overlapping intervals of different lengths, with the
applications required to handle rollover gracefully.

The specification as is, appears to be the easiest way to support this
use case, and it works provided the hardware automatically performs
rollover of the UNC block counter.

If this is a use case that needs to be supported, then to handle the
case of hardware that doesn't automatically roll the UNC counter over to
zero, the last sentence of the specification might be changed to
something like this:

"Note that the counter will wrap to zero after its maximum count has
been reached.  For devices where the hardware does not automatically
roll over to zero, when the ioctl would return the maximum supported
value, the driver will reset the hardware counter to zero."


This isn't perfect as some UNC counts will be lost after the counter
saturates, but aside from this exceptional circumstance, the use case
would be correctly supported.


Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
