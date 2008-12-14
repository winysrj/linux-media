Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1LBpm4-0008JH-8z
	for linux-dvb@linuxtv.org; Sun, 14 Dec 2008 13:08:41 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mBEC8aP0019447
	for <linux-dvb@linuxtv.org>; Sun, 14 Dec 2008 13:08:36 +0100
Message-ID: <4944F744.5070201@cadsoft.de>
Date: Sun, 14 Dec 2008 13:08:36 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4943A606.5060502@cadsoft.de>
	<200812141302.47851@orion.escape-edv.de>
In-Reply-To: <200812141302.47851@orion.escape-edv.de>
Subject: Re: [linux-dvb] DiSEqC handling in S2API
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

On 14.12.2008 13:02, Oliver Endriss wrote:
> Klaus Schmidinger wrote:
>> While adapting VDR to the S2API driver, I saw that there are also
>> facilities to handle DiSEqC via the new API, like DTV_VOLTAGE and
>> DTV_TONE. However, I can't seem to find out how the "legacy"
>> FE_DISEQC_SEND_BURST and FE_DISEQC_SEND_MASTER_CMD could be handled
>> with S2API.
>> Is this not implemented?
> 
> LNB control works perfectly with the old api.
> Imho DTV_VOLTAGE and DTV_TONE should be removed.
> They duplicate existing functions and do not offer any advantage.

Thanks, so I'll leave this with the "old" API.

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
