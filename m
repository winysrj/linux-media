Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KWwoR-0006zq-Gm
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 19:22:08 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Aug 2008 19:21:19 +0200
References: <48B00D6C.8080302@gmx.de>
	<alpine.LRH.1.10.0808231750550.26788@pub5.ifh.de>
	<200808231842.36465@orion.escape-edv.de>
In-Reply-To: <200808231842.36465@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808231921.20076@orion.escape-edv.de>
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
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
> As there is a flag I2C_M_NOSTART in the I2C subsystem in recent kernels,
> we could pass this flag to the I2C driver and add a workaround to the 
> i2c master_xfer function.

Correction. I2C_M_NOSTART cannot be used. It removes a *start*
condition, but we have to insert a *stop* condition...

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
