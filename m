Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JhZR9-0000Ui-2M
	for linux-dvb@linuxtv.org; Fri, 04 Apr 2008 02:05:43 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: Christoph Pfister <christophpfister@gmail.com>
Date: Fri, 4 Apr 2008 01:33:05 +0200
References: <200803212024.17198.christophpfister@gmail.com>
	<200803220732.06390@orion.escape-edv.de>
	<200803281820.54243.christophpfister@gmail.com>
In-Reply-To: <200803281820.54243.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804040133.05892@orion.escape-edv.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Christoph Pfister wrote:
> > > <<<fix-knc1-dvbs-ci.diff>>>
> > >        case SUBID_DVBS_KNC1:
> > >        case SUBID_DVBS_KNC1_PLUS:
> > >        case SUBID_DVBS_EASYWATCH_1:
> > >+               budget_av->reinitialise_demod = 1;
> > >
> > > Fix CI interface on (some) KNC1 DVBS cards
> > > Quoting the commit introducing reinitialise_demod (3984 / by adq):
> > > "These cards [KNC1 DVBT and DVBC] need special handling for CI -
> > > reinitialising the frontend device when the CI module is reset."
> > > Apparently my 1894:0010 also needs that fix, because once you initialise
> > > CI/CAM you lose lock. Signed-off-by: Christoph Pfister
> > > <pfister@linuxtv.org>
> >
> > Are you _sure_ that 'reinitialise_demod = 1' is required by all 3 card
> > types, and does not hurt for SUBID_DVBS_KNC1_PLUS (1131:0011, 1894:0011)
> > and SUBID_DVBS_EASYWATCH_1 (1894:001a)?
> 
> Do you want me to limit reinitialise_demod to the one type of card I'm using 
> or is it ok for you this way?

Yes, please. We should not add a quirk unless we have verified that it
is really required. It is easier to add a hack than to remove it. ;-)

> (I'll repost a modified version of the first patch removing the 0xff check 
> altogether later today ...)

OK. I'll commit your patches this weekend.

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
