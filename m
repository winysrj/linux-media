Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JcdNW-0005wg-L6
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 10:17:35 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Mar 2008 10:15:54 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<47E2CF49.8070302@t-online.de> <47E2D3C4.2050005@gmail.com>
In-Reply-To: <47E2D3C4.2050005@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803211015.54663@orion.escape-edv.de>
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
	transponder fails
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

Hi,

Manu Abraham wrote:
> Hi Hartmut,
> 
> Hartmut Hackmann wrote:
> 
> > This might be right! I could not get good information regarding the
> > transponder bandwidths. We might need to make this depend on the
> > symbol rate or a module parameter.
> 
> You can calculate the tuner bandwidth from the transponder symbol rate
> (in Mbaud) for DVB-S:
> 
> BW = (1 + RO) * SR/2 + 5) * 1.3

Apparently I need some lessons in signal theory. ;-)
What does R0 stand for?

Do we have to select a higher cut-off value to compensate for the LNB
drift and other stuff like that?

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
