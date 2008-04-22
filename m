Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JoNiA-0006Ga-6r
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 20:59:27 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 22 Apr 2008 20:57:30 +0200
References: <200804120312.00264@orion.escape-edv.de>
In-Reply-To: <200804120312.00264@orion.escape-edv.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804222057.30841@orion.escape-edv.de>
Subject: Re: [linux-dvb] [ALPS BSBE1] Improve tuning
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
> Hi,
> 
> I have reworked the BSBE1 tuner support in bsbe1.h to follow the ALPS-
> recommended parameters more closely.
> 
> Tests with BSBE1-based Activy cards showed reduced BER.
> 
> Cards affected:
> - driver dvb-ttpci(av7110): Hauppauge/TT Nexus-S rev 2.3
> - driver budget-ci: TT S-1500 PCI
> 
> Please test and report any problems. Thanks!

No problems were reported. Committed to HG.

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
