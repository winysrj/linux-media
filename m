Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JcS6H-0003Yc-Sl
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 22:15:02 +0100
Message-ID: <47E2D3C4.2050005@gmail.com>
Date: Fri, 21 Mar 2008 01:14:44 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>	<200803200118.26462@orion.escape-edv.de>	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
	<47E2CF49.8070302@t-online.de>
In-Reply-To: <47E2CF49.8070302@t-online.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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

Hi Hartmut,

Hartmut Hackmann wrote:

> This might be right! I could not get good information regarding the
> transponder bandwidths. We might need to make this depend on the
> symbol rate or a module parameter.


You can calculate the tuner bandwidth from the transponder symbol rate
(in Mbaud) for DVB-S:

BW = (1 + RO) * SR/2 + 5) * 1.3


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
