Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f62.mail.ru ([194.67.57.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JXaQ1-00073U-LP
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 12:07:17 +0100
From: Igor <goga777@bk.ru>
To: Vladimir Prudnikov <vpr@krastelcom.ru>
Mime-Version: 1.0
Date: Fri, 07 Mar 2008 14:06:43 +0300
References: <E723A8FD-137B-499A-8F6A-DC19E8AF919F@krastelcom.ru>
In-Reply-To: <E723A8FD-137B-499A-8F6A-DC19E8AF919F@krastelcom.ru>
Message-Id: <E1JXaPT-0008Gj-00.goga777-bk-ru@f62.mail.ru>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb]
	=?koi8-r?b?UmUgOiBUVCBTMi0zMjAwLiBObyBsb2NrIG9uIGhp?=
	=?koi8-r?b?Z2ggc3ltYm9sIHJhdGUgKDQ1TSl0cmFuc3BvbmRlcnM=?=
Reply-To: Igor <goga777@bk.ru>
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

may be the transponder with high SR has weak signal ?

Igor


-----Original Message-----
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Manu Abraham <abraham.manu@gmail.com>
Date: Fri, 7 Mar 2008 10:32:05 +0300
Subject: Re: [linux-dvb] Re : TT S2-3200. No lock on high symbol rate (45M)transponders

> 
> Reverted registers. No difference. Low SR - fine.
> High SR - no lock.
> 
> Regards,
> Vladimir
> 
> 
> On Mar 7, 2008, at 3:23 AM, Manu Abraham wrote:
> 
> > manu wrote:
> >> On 03/06/2008 06:34:28 AM, Vladimir Prudnikov wrote:
> >>> Can't get TT S2-3200 locked on high SR transponders. I have seen a
> >>> lot
> >>>
> >>> of suggestions regarding changing Frequency/Symbol rate on various
> >>> forums but no luck. Low SR are fine.
> >>> Does anyone have a "revision" of multiproto that was tested with  
> >>> high
> >>>
> >>> SR?
> >>>
> >>> I hope Manu can comment on that as well...
> >>>
> >> Just a "me too", well kind of: for me certain transponders do not  
> >> lock
> >> or lock but with corrupted streams whereas others are perfect (on the
> >> same sat with the same characteristics, SR is 30M).
> >
> >
> > Please try whether these register setup changes does help as  
> > applicable.
> >
> > http://jusst.de/hg/mantis/rev/72e81184fb9f
> >
> > Regards,
> > Manu
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
