Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jus87-0005Ql-O3
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 18:41:31 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 10 May 2008 18:39:58 +0200
References: <482560EB.2000306@gmail.com>
	<200805101727.55810@orion.escape-edv.de>
	<4825C724.1020001@gmail.com>
In-Reply-To: <4825C724.1020001@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805101839.58280@orion.escape-edv.de>
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

e9hack wrote:
> Oliver Endriss schrieb:
> > Argh, I just checked the API 1.0.0. spec:
> > | FE READ UNCORRECTED BLOCKS
> > | This ioctl call returns the number of uncorrected blocks detected by the device
> > | driver during its lifetime. For meaningful measurements, the increment
> > | in block count during a speci c time interval should be calculated. For this
> > | command, read-only access to the device is suf cient.
> > | Note that the counter will wrap to zero after its maximum count has been
> > | reached
> > 
> 
> First you read a very old spec, now you read an old spec. This description is no longer a 
> part of the spec. In the current spec 
> (http://linuxtv.org/downloads/linux-dvb-api-v4/linux-dvb-api-v4-0-3.pdf), many necessary 
> descriptions are missing.

No, the API V4 proposal does not apply to current drivers.
The current API is V3.

Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
