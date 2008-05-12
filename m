Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JvY76-0007ee-Nc
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 15:30:54 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 12 May 2008 15:29:20 +0200
References: <482560EB.2000306@gmail.com>
	<200805101727.55810@orion.escape-edv.de>
	<4825C3C4.8000702@linuxtv.org>
In-Reply-To: <4825C3C4.8000702@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805121529.20537@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
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

Michael Krufky wrote:
> Oliver Endriss wrote:
> > Oliver Endriss wrote:
> >> e9hack wrote:
> >>> the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
> >>> makes the UNC value of the femon plugin useless.
> >> Why? It does not make sense to accumulate the errors forever, i.e.
> >> nobody wants to know what happened last year...
> >>
> >> Afaics it is ok to reset the counter after reading it.
> >> All drivers should behave this way.
> >>
> >> If the femon plugin requires something else it might store the values
> >> and process them as desired.
> >>
> >> Afaics the femon command line tool has no problems with that.
> > 
> > Argh, I just checked the API 1.0.0. spec:
> > | FE READ UNCORRECTED BLOCKS
> > | This ioctl call returns the number of uncorrected blocks detected by the device
> > | driver during its lifetime. For meaningful measurements, the increment
> > | in block count during a speci c time interval should be calculated. For this
> > | command, read-only access to the device is suf cient.
> > | Note that the counter will wrap to zero after its maximum count has been
> > | reached
> > 
> > So it seens you are right and the drivers should accumulate the errors
> > forever. Any opinions?
> > 
> 
> There are some devices that automatically reset the unc counter registers
> as they are read, and other devices that wrap to zero after its maximum
> count has been reached, unless the driver explicitly clears it. *(see below)
> 
> There are other devices that dont give unc info directly, but instead
> report an average unc per time interval.

Anyway, the driver should do its best to follow the API spec.
If the hardware returns an error rate the driver might convert it to an
(estimated) absolute value.

> I think it's possible that at the time the 1.0.0 spec was written, most
> devices were known to exhibit the behavior as described in the blurb
> quoted from the API 1.0.0 spec, above.
> 
> I don't think that all of the drivers comply to this, exactly as described,
> and it might be difficult to correct this across the board :-(  In many
> cases, we might not know for sure how absolute the value is, read from these
> registers on a given device.
>
> I am not sure what we should do, but here is an argument that supports the
> API 1.0.0 spec:
> 
> *There are some demods whose firmware uses these counters to determine lock
> state.  If we explicitly clear the counter registers during a channel scan,
> we can potentially confuse the firmware into detecting false locks, and not
> detecting real locks.

Imho we should try to follow the API spec as close as possible.
If we cannot implement an ioctl due to lack of information, there is
little we can do...

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
