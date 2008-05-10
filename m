Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jur08-0008Cm-CV
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 17:28:46 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 10 May 2008 17:27:55 +0200
References: <482560EB.2000306@gmail.com>
	<200805101717.23199@orion.escape-edv.de>
In-Reply-To: <200805101717.23199@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805101727.55810@orion.escape-edv.de>
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

Oliver Endriss wrote:
> e9hack wrote:
> > the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
> > makes the UNC value of the femon plugin useless.
> 
> Why? It does not make sense to accumulate the errors forever, i.e.
> nobody wants to know what happened last year...
> 
> Afaics it is ok to reset the counter after reading it.
> All drivers should behave this way.
> 
> If the femon plugin requires something else it might store the values
> and process them as desired.
> 
> Afaics the femon command line tool has no problems with that.

Argh, I just checked the API 1.0.0. spec:
| FE READ UNCORRECTED BLOCKS
| This ioctl call returns the number of uncorrected blocks detected by the device
| driver during its lifetime. For meaningful measurements, the increment
| in block count during a speci c time interval should be calculated. For this
| command, read-only access to the device is suf cient.
| Note that the counter will wrap to zero after its maximum count has been
| reached

So it seens you are right and the drivers should accumulate the errors
forever. Any opinions?

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
