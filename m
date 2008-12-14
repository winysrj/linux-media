Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1LBpk1-0007hw-K6
	for linux-dvb@linuxtv.org; Sun, 14 Dec 2008 13:06:36 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 14 Dec 2008 13:02:47 +0100
References: <4943A606.5060502@cadsoft.de>
In-Reply-To: <4943A606.5060502@cadsoft.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812141302.47851@orion.escape-edv.de>
Subject: Re: [linux-dvb] DiSEqC handling in S2API
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

Klaus Schmidinger wrote:
> While adapting VDR to the S2API driver, I saw that there are also
> facilities to handle DiSEqC via the new API, like DTV_VOLTAGE and
> DTV_TONE. However, I can't seem to find out how the "legacy"
> FE_DISEQC_SEND_BURST and FE_DISEQC_SEND_MASTER_CMD could be handled
> with S2API.
> Is this not implemented?

LNB control works perfectly with the old api.
Imho DTV_VOLTAGE and DTV_TONE should be removed.
They duplicate existing functions and do not offer any advantage.
Just my 2 cents.

Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
