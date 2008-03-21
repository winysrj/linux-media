Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JcdNW-0005wf-G7
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 10:17:36 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Mar 2008 09:56:02 +0100
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803200118.26462@orion.escape-edv.de>
	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
In-Reply-To: <Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210956.03053@orion.escape-edv.de>
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

ldvb@ns.bog.msu.ru wrote:
> 
> On Thu, 20 Mar 2008, Oliver Endriss wrote:
> 
> > Sorry, if you want to have your problem fixed, you have dig through the
> > register programming of the frontend driver. Use an i2c sniffer and
> > compare the register settings of the the windows driver with those of
> > the linux driver...
> > If you want to experiment with some parameters, you might have a look at
> > changeset
> >  http://linuxtv.org/hg/v4l-dvb/rev/8a19aa788239
> > Maybe you can find a better register setting which fixes your problem.
> 
> Increased baseband cut-off helps! (tda826*.c)
> so, making it
> buf[6] = 0xfe;
> solves the problem.
> Maybe, I'll check other values.

Hm - buf[6] is not the baseband cut-off.

I guess you changed buf[5] back to 0xff, correct?

Could you please find out the _minimum_ value required?
You might try 0xff, 0xf7, 0xef, 0xe7, 0xdf, 0xd7, 0xcf, 0xc7 and so on.

The symbol rate of the transponder is 44948000, right?

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
